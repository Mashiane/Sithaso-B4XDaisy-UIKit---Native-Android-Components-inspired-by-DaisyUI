B4A=true
Group=Default Group\DaisuyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Event: Click (Tag As Object)

#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: 10, Description: Tailwind size token or CSS size (eg 12, 80px, 4em, 5rem)
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: 6, Description: Tailwind size token or CSS size (eg 6, 24px, 1.5rem)
#DesignerProperty: Key: Text, DisplayName: Text, FieldType: String, DefaultValue: , Description: Label text.
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0xFF334155, Description: Text color.
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00000000, Description: Background color.
#DesignerProperty: Key: TextSize, DisplayName: Text Size, FieldType: String, DefaultValue: 12, Description: Number in dip or Tailwind token (eg 12, text-sm, text-lg).
#DesignerProperty: Key: FontBold, DisplayName: Font Bold, FieldType: Boolean, DefaultValue: False, Description: Use bold font.
#DesignerProperty: Key: SingleLine, DisplayName: Single Line, FieldType: Boolean, DefaultValue: True, Description: Single line text.
#DesignerProperty: Key: HAlign, DisplayName: Horizontal Align, FieldType: String, DefaultValue: LEFT, List: LEFT|CENTER|RIGHT, Description: Text horizontal alignment.
#DesignerProperty: Key: VAlign, DisplayName: Vertical Align, FieldType: String, DefaultValue: CENTER, List: TOP|CENTER|BOTTOM, Description: Text vertical alignment.
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: Int, DefaultValue: 0, Description: Inner padding in dip.
#DesignerProperty: Key: Margin, DisplayName: Margin, FieldType: String, DefaultValue:, Description: Tailwind/spacing margin utilities (eg m-2, mx-1.5, 1)
#DesignerProperty: Key: RoundedBox, DisplayName: Rounded Box, FieldType: Boolean, DefaultValue: False, Description: Use rounded-box radius.
#DesignerProperty: Key: BorderWidth, DisplayName: Border Width, FieldType: Int, DefaultValue: 0, Description: Border width in dip.
#DesignerProperty: Key: BorderColor, DisplayName: Border Color, FieldType: Color, DefaultValue: 0x00000000, Description: Border color.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Visible state.
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Enabled state.

Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mCallBack As Object
	Private mEventName As String
	Private mTag As Object
	Private CustProps As Map

	Private mWidth As Float = 40dip
	Private mHeight As Float = 24dip
	Private mWidthExplicit As Boolean = False
	Private mHeightExplicit As Boolean = False
	Private mText As String = ""
	Private mTextColor As Int = 0xFF334155
	Private mBackgroundColor As Int = xui.Color_Transparent
	Private mTextSize As Float = 12
	Private mFontBold As Boolean = False
	Private mSingleLine As Boolean = True
	Private mHAlign As String = "LEFT"
	Private mVAlign As String = "CENTER"
	Private mPadding As Float = 0dip
	Private mMargin As String = ""
	Private mRoundedBox As Boolean = False
	Private mBorderWidth As Float = 0dip
	Private mBorderColor As Int = xui.Color_Transparent
	Private mVisible As Boolean = True
	Private mEnabled As Boolean = True

	Private lblContent As B4XView
End Sub

Public Sub Initialize(Callback As Object, EventName As String)
	mCallBack = Callback
	mEventName = EventName
	SetDefaults
End Sub

'Public Sub CreateView(Width As Int, Height As Int) As B4XView
'	Dim p As Panel
'	p.Initialize("base")
'	Dim b As B4XView = p
'	b.Color = xui.Color_Transparent
'	b.SetLayoutAnimated(0, 0, 0, Width, Height)
'	Dim dummy As Label
'	DesignerCreateView(b, dummy, CreateMap())
'	mWidth = Width
'	mHeight = Height
'	Return mBase
'End Sub

Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
	mBase = Base
	mTag = mBase.Tag
	mBase.Tag = Me

	Dim l As Label
	l.Initialize("lblContent")
	l.SingleLine = True
	lblContent = l
	mBase.AddView(lblContent, 0, 0, mBase.Width, mBase.Height)

	ApplyDesignerProps(Props)
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Private Sub ApplyDesignerProps(Props As Map)
	If CustProps.IsInitialized = False Then SetDefaults
	SetProperties(Props)

	mWidth = Max(1dip, GetPropSizeDip(Props, "Width", mWidth))
	mHeight = Max(1dip, GetPropSizeDip(Props, "Height", mHeight))
	mWidthExplicit = Props.IsInitialized And Props.ContainsKey("Width")
	mHeightExplicit = Props.IsInitialized And Props.ContainsKey("Height")
	mText = GetPropString(Props, "Text", mText)
	mTextColor = GetPropColor(Props, "TextColor", mTextColor)
	mBackgroundColor = GetPropColor(Props, "BackgroundColor", mBackgroundColor)
	mTextSize = ResolveTextSize(GetPropObject(Props, "TextSize", mTextSize), mTextSize)
	mFontBold = GetPropBool(Props, "FontBold", mFontBold)
	mSingleLine = GetPropBool(Props, "SingleLine", mSingleLine)
	mHAlign = NormalizeHAlign(GetPropString(Props, "HAlign", mHAlign))
	mVAlign = NormalizeVAlign(GetPropString(Props, "VAlign", mVAlign))
	mPadding = Max(0, GetPropFloat(Props, "Padding", mPadding / 1dip) * 1dip)
	mMargin = GetPropString(Props, "Margin", mMargin)
	mRoundedBox = GetPropBool(Props, "RoundedBox", mRoundedBox)
	mBorderWidth = Max(0, GetPropFloat(Props, "BorderWidth", mBorderWidth / 1dip) * 1dip)
	mBorderColor = GetPropColor(Props, "BorderColor", mBorderColor)
	mVisible = GetPropBool(Props, "Visible", mVisible)
	mEnabled = GetPropBool(Props, "Enabled", mEnabled)
End Sub

Public Sub Base_Resize(Width As Double, Height As Double)
	If mBase.IsInitialized = False Or lblContent.IsInitialized = False Then Return
	Dim w As Int = Max(1dip, Width)
	Dim h As Int = Max(1dip, Height)
	mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, w, h)
	ApplyVisual
End Sub

Private Sub ApplyVisual
	If mBase.IsInitialized = False Or lblContent.IsInitialized = False Then Return
	Dim radius As Float = IIf(mRoundedBox, B4XDaisyVariants.GetRadiusBoxDip(8dip), 0)
	mBase.SetColorAndBorder(mBackgroundColor, mBorderWidth, mBorderColor, radius)

	Dim host As B4XRect
	host.Initialize(0, 0, Max(1dip, mBase.Width), Max(1dip, mBase.Height))
	Dim box As Map = BuildBoxModel
	Dim outerRect As B4XRect = B4XDaisyBoxModel.ResolveOuterRect(host, box)
	Dim contentRect As B4XRect = B4XDaisyBoxModel.ResolveContentRect(outerRect, box)
	lblContent.SetLayoutAnimated(0, contentRect.Left, contentRect.Top, contentRect.Width, contentRect.Height)
	lblContent.Text = mText
	lblContent.TextColor = mTextColor
	lblContent.TextSize = mTextSize
	lblContent.SetTextAlignment(mVAlign, mHAlign)
	Dim l As Label = lblContent
	l.SingleLine = mSingleLine
	If mFontBold Then
		lblContent.Font = xui.CreateDefaultBoldFont(mTextSize)
	Else
		lblContent.Font = xui.CreateDefaultFont(mTextSize)
	End If
	mBase.Visible = mVisible
	lblContent.Enabled = mEnabled
End Sub

Private Sub BuildBoxModel As Map
	Dim box As Map = B4XDaisyBoxModel.CreateDefaultModel
	box.Put("padding_left", mPadding)
	box.Put("padding_right", mPadding)
	box.Put("padding_top", mPadding)
	box.Put("padding_bottom", mPadding)
	ApplyMarginSpecToBox(box, mMargin)
	Return box
End Sub

Private Sub ApplyMarginSpecToBox(Box As Map, MarginSpec As String)
	Dim m As String = IIf(MarginSpec = Null, "", MarginSpec.Trim)
	If m.Length = 0 Then Return
	Dim rtl As Boolean = False
	If B4XDaisyVariants.ContainsAny(m, Array As String("m-", "mx-", "my-", "mt-", "mr-", "mb-", "ml-", "ms-", "me-", "-m-", "-mx-", "-my-", "-mt-", "-mr-", "-mb-", "-ml-", "-ms-", "-me-")) Then
		B4XDaisyBoxModel.ApplyMarginUtilities(Box, m, rtl)
	Else
		Dim mv As Float = B4XDaisyBoxModel.TailwindSpacingToDip(m, 0dip)
		Box.Put("margin_left", mv)
		Box.Put("margin_right", mv)
		Box.Put("margin_top", mv)
		Box.Put("margin_bottom", mv)
	End If
End Sub

Public Sub SetDefaults
	CustProps.Initialize
	CustProps.Put("Width", mWidth)
	CustProps.Put("Height", mHeight)
	CustProps.Put("Text", mText)
	CustProps.Put("TextColor", mTextColor)
	CustProps.Put("BackgroundColor", mBackgroundColor)
	CustProps.Put("TextSize", mTextSize)
	CustProps.Put("FontBold", mFontBold)
	CustProps.Put("SingleLine", mSingleLine)
	CustProps.Put("HAlign", mHAlign)
	CustProps.Put("VAlign", mVAlign)
	CustProps.Put("Padding", mPadding)
	CustProps.Put("Margin", mMargin)
	CustProps.Put("RoundedBox", mRoundedBox)
	CustProps.Put("BorderWidth", mBorderWidth)
	CustProps.Put("BorderColor", mBorderColor)
	CustProps.Put("Visible", mVisible)
	CustProps.Put("Enabled", mEnabled)
End Sub

Public Sub SetProperties(Props As Map)
	If Props.IsInitialized = False Then Return
	CustProps.Initialize
	For Each k As String In Props.Keys
		CustProps.Put(k, Props.Get(k))
	Next
End Sub

Public Sub GetProperties As Map
	CustProps.Initialize
	CustProps.Put("Width", mWidth)
	CustProps.Put("Height", mHeight)
	CustProps.Put("Text", mText)
	CustProps.Put("TextColor", mTextColor)
	CustProps.Put("BackgroundColor", mBackgroundColor)
	CustProps.Put("TextSize", mTextSize)
	CustProps.Put("FontBold", mFontBold)
	CustProps.Put("SingleLine", mSingleLine)
	CustProps.Put("HAlign", mHAlign)
	CustProps.Put("VAlign", mVAlign)
	CustProps.Put("Padding", mPadding)
	CustProps.Put("Margin", mMargin)
	CustProps.Put("RoundedBox", mRoundedBox)
	CustProps.Put("BorderWidth", mBorderWidth)
	CustProps.Put("BorderColor", mBorderColor)
	CustProps.Put("Visible", mVisible)
	CustProps.Put("Enabled", mEnabled)
	CustProps.Put("Tag", mTag)
	Return CustProps
End Sub

Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
	Dim empty As B4XView
	If Parent.IsInitialized = False Then Return empty
	Dim w As Int = Max(1dip, Width)
	Dim h As Int = Max(1dip, Height)
	Dim p As Panel
	p.Initialize("base")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, w, h)
	Dim snap As Map = GetProperties
	Dim props As Map
	props.Initialize
	For Each k As String In snap.Keys
		props.Put(k, snap.Get(k))
	Next
	If mWidthExplicit = False Then props.Put("Width", Max(1, Round(w / 1dip)) & "px")
	If mHeightExplicit = False Then props.Put("Height", Max(1, Round(h / 1dip)) & "px")
	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	Parent.AddView(mBase, Left, Top, w, h)
	Return mBase
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub

Public Sub IsReady As Boolean
	Return mBase.IsInitialized And lblContent.IsInitialized
End Sub

Private Sub lblContent_Click
	RaiseClick
End Sub

Private Sub base_Click
	RaiseClick
End Sub

Private Sub RaiseClick
	If xui.SubExists(mCallBack, mEventName & "_Click", 1) Then
		CallSub2(mCallBack, mEventName & "_Click", mTag)
	Else If xui.SubExists(mCallBack, mEventName & "_Click", 0) Then
		CallSub(mCallBack, mEventName & "_Click")
	End If
End Sub

Private Sub NormalizeHAlign(Value As String) As String
	Dim s As String = Value.ToUpperCase.Trim
	Select Case s
		Case "LEFT", "CENTER", "RIGHT"
			Return s
		Case Else
			Return "LEFT"
	End Select
End Sub

Private Sub NormalizeVAlign(Value As String) As String
	Dim s As String = Value.ToUpperCase.Trim
	Select Case s
		Case "TOP", "CENTER", "BOTTOM"
			Return s
		Case Else
			Return "CENTER"
	End Select
End Sub

Private Sub ResolveTextSize(Value As Object, DefaultSize As Float) As Float
	If Value = Null Then Return DefaultSize
	If IsNumber(Value) Then Return Max(1, Value)
	Dim s As String = Value
	s = s.Trim
	If s.Length = 0 Then Return DefaultSize
	If IsNumber(s) Then Return Max(1, s)
	Dim tm As Map = B4XDaisyVariants.TailwindTextMetrics(s, DefaultSize, DefaultSize * 1.4)
	Return Max(1, tm.GetDefault("font_size", DefaultSize))
End Sub

Private Sub GetPropSizeDip(Props As Map, Key As String, DefaultDipValue As Float) As Float
	If Props.IsInitialized = False Then Return DefaultDipValue
	If Props.ContainsKey(Key) = False Then Return DefaultDipValue
	Return B4XDaisyVariants.TailwindSizeToDip(Props.Get(Key), DefaultDipValue)
End Sub

Private Sub GetPropString(Props As Map, Key As String, DefaultValue As String) As String
	If Props.IsInitialized = False Then Return DefaultValue
	Return B4XDaisyVariants.GetPropString(Props, Key, DefaultValue)
End Sub

Private Sub GetPropBool(Props As Map, Key As String, DefaultValue As Boolean) As Boolean
	If Props.IsInitialized = False Then Return DefaultValue
	Return B4XDaisyVariants.GetPropBool(Props, Key, DefaultValue)
End Sub

Private Sub GetPropColor(Props As Map, Key As String, DefaultValue As Int) As Int
	If Props.IsInitialized = False Then Return DefaultValue
	Return B4XDaisyVariants.GetPropInt(Props, Key, DefaultValue)
End Sub

Private Sub GetPropInt(Props As Map, Key As String, DefaultValue As Int) As Int
	If Props.IsInitialized = False Then Return DefaultValue
	Return B4XDaisyVariants.GetPropInt(Props, Key, DefaultValue)
End Sub

Private Sub GetPropFloat(Props As Map, Key As String, DefaultValue As Float) As Float
	If Props.IsInitialized = False Then Return DefaultValue
	Return B4XDaisyVariants.GetPropFloat(Props, Key, DefaultValue)
End Sub

Private Sub GetPropObject(Props As Map, Key As String, DefaultValue As Object) As Object
	If Props.IsInitialized = False Then Return DefaultValue
	If Props.ContainsKey(Key) = False Then Return DefaultValue
	Return Props.Get(Key)
End Sub

Public Sub setText(Value As String)
	mText = Value
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getText As String
	Return mText
End Sub

Public Sub setWidth(Value As Object)
	mWidth = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(Value, mWidth))
	mWidthExplicit = True
	If mBase.IsInitialized = False Then Return
	Base_Resize(mWidth, mBase.Height)
End Sub

Public Sub getWidth As Float
	Return mWidth
End Sub

Public Sub setHeight(Value As Object)
	mHeight = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(Value, mHeight))
	mHeightExplicit = True
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mHeight)
End Sub

Public Sub getHeight As Float
	Return mHeight
End Sub

Public Sub setTextColor(Value As Int)
	mTextColor = Value
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getTextColor As Int
	Return mTextColor
End Sub

Public Sub setBackgroundColor(Value As Int)
	mBackgroundColor = Value
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getBackgroundColor As Int
	Return mBackgroundColor
End Sub

Public Sub setTextColorVariant(VariantName As String)
	Dim c As Int = B4XDaisyVariants.ResolveVariantColor(B4XDaisyVariants.DefaultPalette, VariantName, "text", mTextColor)
	setTextColor(c)
End Sub

Public Sub setTextSize(Value As Object)
	mTextSize = ResolveTextSize(Value, mTextSize)
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getTextSize As Float
	Return mTextSize
End Sub

Public Sub setFontBold(Value As Boolean)
	mFontBold = Value
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getFontBold As Boolean
	Return mFontBold
End Sub

Public Sub setSingleLine(Value As Boolean)
	mSingleLine = Value
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getSingleLine As Boolean
	Return mSingleLine
End Sub

Public Sub setHAlign(Value As String)
	mHAlign = NormalizeHAlign(Value)
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getHAlign As String
	Return mHAlign
End Sub

Public Sub setVAlign(Value As String)
	mVAlign = NormalizeVAlign(Value)
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getVAlign As String
	Return mVAlign
End Sub

Public Sub setPadding(Value As Float)
	mPadding = Max(0, Value)
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getPadding As Float
	Return mPadding
End Sub

Public Sub setMargin(Value As String)
	mMargin = IIf(Value = Null, "", Value)
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getMargin As String
	Return mMargin
End Sub

Public Sub setRoundedBox(Value As Boolean)
	mRoundedBox = Value
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getRoundedBox As Boolean
	Return mRoundedBox
End Sub

Public Sub setBorderWidth(Value As Float)
	mBorderWidth = Max(0, Value)
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getBorderWidth As Float
	Return mBorderWidth
End Sub

Public Sub setBorderColor(Value As Int)
	mBorderColor = Value
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getBorderColor As Int
	Return mBorderColor
End Sub

Public Sub setVisible(Value As Boolean)
	mVisible = Value
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getVisible As Boolean
	Return mVisible
End Sub

Public Sub setEnabled(Value As Boolean)
	mEnabled = Value
	If mBase.IsInitialized = False Then Return
	ApplyVisual
End Sub

Public Sub getEnabled As Boolean
	Return mEnabled
End Sub

Public Sub setTag(Value As Object)
	mTag = Value
End Sub

Public Sub getTag As Object
	Return mTag
End Sub
