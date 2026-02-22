B4A=true
Group=Default Group\DaisuyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: 10, Description: Tailwind size token or CSS size (eg 12, 80px, 4em, 5rem)
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: 10, Description: Tailwind size token or CSS size (eg 12, 80px, 4em, 5rem)
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: String, DefaultValue:, Description: Tailwind/spacing padding utilities (eg p-2, px-3, 2)
#DesignerProperty: Key: Margin, DisplayName: Margin, FieldType: String, DefaultValue:, Description: Tailwind/spacing margin utilities (eg m-2, mx-1.5, 1)
#DesignerProperty: Key: Direction, DisplayName: Direction, FieldType: String, DefaultValue: bottom, List: bottom|top|start|end, Description: Daisy stack direction.
#DesignerProperty: Key: StepPrimary, DisplayName: Primary Step, FieldType: Int, DefaultValue: 7, Description: Primary offset in dip used for the deepest layer.
#DesignerProperty: Key: StepSecondary, DisplayName: Secondary Step, FieldType: Int, DefaultValue: 3, Description: Secondary offset in dip used for the middle layer.
#DesignerProperty: Key: AutoFillLayers, DisplayName: Auto Fill Layers, FieldType: Boolean, DefaultValue: True, Description: Resize each child to fill its layer frame.
#DesignerProperty: Key: LayoutAnimationMs, DisplayName: Layout Animation, FieldType: Int, DefaultValue: 0, Description: Animation duration in milliseconds when relayout runs.
#DesignerProperty: Key: RoundedBox, DisplayName: Rounded Box, FieldType: Boolean, DefaultValue: False, Description: Apply 16px rounded corners to the base view.
#DesignerProperty: Key: StrictDaisyParity, DisplayName: Strict Daisy Parity, FieldType: Boolean, DefaultValue: True, Description: Use DaisyUI stack geometry and per-layer opacity (1.0, 0.9, 0.7).

'B4XDaisyStack
'Native B4X stack container inspired by DaisyUI stack component.

Sub Class_Globals
	Private xui As XUI
	Public mBase As B4XView
	Private mEventName As String 'ignore
	Private mCallBack As Object 'ignore
	Private mTag As Object
	'Each item is a Map with keys: view, tag
	Private Layers As List

	Private mWidth As Float = 40dip
	Private mHeight As Float = 40dip
	Private mWidthExplicit As Boolean = False
	Private mHeightExplicit As Boolean = False
	Private mPadding As String = ""
	Private mMargin As String = ""
	Private mDirection As String = "bottom"
	Private mStepPrimary As Float = 7dip
	Private mStepSecondary As Float = 3dip
	Private mAutoFillLayers As Boolean = True
	Private mLayoutAnimationMs As Int = 0
	Private mRoundedBox As Boolean = False
	Private mStrictDaisyParity As Boolean = True
End Sub

Public Sub Initialize(Callback As Object, EventName As String)
	mCallBack = Callback
	mEventName = EventName
	Layers.Initialize
End Sub

Public Sub CreateView(Width As Int, Height As Int) As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, Width, Height)
	Dim props As Map
	props.Initialize
	props.Put("Width", ResolvePxSizeSpec(Width))
	props.Put("Height", ResolvePxSizeSpec(Height))
	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	Return mBase
End Sub

Private Sub ResolvePxSizeSpec(SizeDip As Float) As String
	Dim px As Int = Max(1, Round(SizeDip / 1dip))
	Return px & "px"
End Sub

Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
	mBase = Base
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent
	If Layers.IsInitialized = False Then Layers.Initialize
	AttachAllLayersToBase
	ApplyDesignerProps(Props)
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub Base_Resize(Width As Double, Height As Double)
	If mBase.IsInitialized = False Then Return
	RelayoutLayersForBounds(Width, Height, mLayoutAnimationMs)
End Sub

Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
	Dim empty As B4XView
	If Parent.IsInitialized = False Then Return empty
	Dim w As Int = Max(1dip, Width)
	Dim h As Int = Max(1dip, Height)
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, w, h)
	Dim props As Map
	props.Initialize
	props.Put("Width", ResolvePxSizeSpec(w))
	props.Put("Height", ResolvePxSizeSpec(h))
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

Public Sub AddViewToContent(ChildView As B4XView, Left As Int, Top As Int, Width As Int, Height As Int)
	If mBase.IsInitialized = False Then Return
	mBase.AddView(ChildView, Left, Top, Width, Height)
End Sub

Sub IsReady As Boolean
	Return mBase.IsInitialized And mBase.Width > 0 And mBase.Height > 0
End Sub

Public Sub AddLayer(ChildView As B4XView) As Int
	Return AddLayerInternal(ChildView, Null, True)
End Sub

Public Sub AddLayerWithTag(ChildView As B4XView, Tag As Object) As Int
	Return AddLayerInternal(ChildView, Tag, True)
End Sub

Public Sub SetLayers(Views As List)
	Clear
	If Views.IsInitialized = False Then Return
	For Each v As B4XView In Views
		AddLayerInternal(v, Null, False)
	Next
	RelayoutLayers
End Sub

Public Sub RemoveLayerAt(Index As Int) As Boolean
	If IsValidLayerIndex(Index) = False Then Return False
	Dim item As Map = Layers.Get(Index)
	Dim v As B4XView = item.Get("view")
	If v.IsInitialized Then v.RemoveViewFromParent
	Layers.RemoveAt(Index)
	RelayoutLayers
	Return True
End Sub

Public Sub Clear
	If Layers.IsInitialized = False Then Layers.Initialize
	For i = 0 To Layers.Size - 1
		Dim item As Map = Layers.Get(i)
		Dim v As B4XView = item.Get("view")
		If v.IsInitialized Then v.RemoveViewFromParent
	Next
	Layers.Clear
End Sub

Public Sub getLayer(Index As Int) As B4XView
	Dim empty As B4XView
	If IsValidLayerIndex(Index) = False Then Return empty
	Dim item As Map = Layers.Get(Index)
	Return item.Get("view")
End Sub

Public Sub getLayerCount As Int
	If Layers.IsInitialized = False Then Return 0
	Return Layers.Size
End Sub

Public Sub setLayerTag(Index As Int, Tag As Object)
	If IsValidLayerIndex(Index) = False Then Return
	Dim item As Map = Layers.Get(Index)
	item.Put("tag", Tag)
	Layers.Set(Index, item)
End Sub

Public Sub getLayerTag(Index As Int) As Object
	If IsValidLayerIndex(Index) = False Then Return Null
	Dim item As Map = Layers.Get(Index)
	Return item.Get("tag")
End Sub

Public Sub setDirection(Value As String)
	mDirection = NormalizeDirection(Value)
	If mBase.IsInitialized = False Then Return
	RelayoutLayers
End Sub

Public Sub getDirection As String
	Return mDirection
End Sub

Public Sub setWidth(Value As Object)
	mWidth = Max(16dip, B4XDaisyVariants.TailwindSizeToDip(Value, ResolveWidthBase(mWidth)))
	mWidthExplicit = True
	If mBase.IsInitialized = False Then Return
	Dim targetH As Float = Max(1dip, mBase.Height)
	mBase.SetLayoutAnimated(mLayoutAnimationMs, mBase.Left, mBase.Top, mWidth, targetH)
	RelayoutLayersForBounds(mWidth, targetH, mLayoutAnimationMs)
End Sub

Public Sub getWidth As Float
	Return mWidth
End Sub

Public Sub setHeight(Value As Object)
	mHeight = Max(16dip, B4XDaisyVariants.TailwindSizeToDip(Value, ResolveHeightBase(mHeight)))
	mHeightExplicit = True
	If mBase.IsInitialized = False Then Return
	Dim targetW As Float = Max(1dip, mBase.Width)
	mBase.SetLayoutAnimated(mLayoutAnimationMs, mBase.Left, mBase.Top, targetW, mHeight)
	RelayoutLayersForBounds(targetW, mHeight, mLayoutAnimationMs)
End Sub

Public Sub getHeight As Float
	Return mHeight
End Sub

Public Sub setSize(Width As Int, Height As Int)
	mWidth = Max(16dip, Width)
	mHeight = Max(16dip, Height)
	mWidthExplicit = True
	mHeightExplicit = True
	If mBase.IsInitialized Then
		mBase.SetLayoutAnimated(mLayoutAnimationMs, mBase.Left, mBase.Top, mWidth, mHeight)
		RelayoutLayersForBounds(mWidth, mHeight, mLayoutAnimationMs)
	End If
End Sub

Public Sub setStepPrimary(Value As Object)
	mStepPrimary = Max(0, ParseSizeSpec(Value, mStepPrimary))
	If mStepSecondary > mStepPrimary Then mStepSecondary = mStepPrimary
	If mBase.IsInitialized = False Then Return
	RelayoutLayers
End Sub

Public Sub getStepPrimary As Float
	Return mStepPrimary
End Sub

Public Sub setStepSecondary(Value As Object)
	mStepSecondary = Max(0, ParseSizeSpec(Value, mStepSecondary))
	If mStepSecondary > mStepPrimary Then mStepSecondary = mStepPrimary
	If mBase.IsInitialized = False Then Return
	RelayoutLayers
End Sub

Public Sub getStepSecondary As Float
	Return mStepSecondary
End Sub

Public Sub setAutoFillLayers(Value As Boolean)
	mAutoFillLayers = Value
	If mBase.IsInitialized = False Then Return
	RelayoutLayers
End Sub

Public Sub getAutoFillLayers As Boolean
	Return mAutoFillLayers
End Sub

Public Sub setLayoutAnimationMs(Value As Int)
	mLayoutAnimationMs = Max(0, Value)
	If mBase.IsInitialized = False Then Return
	RelayoutLayers
End Sub

Public Sub getLayoutAnimationMs As Int
	Return mLayoutAnimationMs
End Sub

Public Sub setRoundedBox(Value As Boolean)
	mRoundedBox = Value
	If mBase.IsInitialized = False Then Return
	ApplyRoundedBox
End Sub

Public Sub getRoundedBox As Boolean
	Return mRoundedBox
End Sub

Public Sub setStrictDaisyParity(Value As Boolean)
	mStrictDaisyParity = Value
	If mBase.IsInitialized = False Then Return
	RelayoutLayers
End Sub

Public Sub getStrictDaisyParity As Boolean
	Return mStrictDaisyParity
End Sub

Public Sub setPadding(Value As String)
	mPadding = IIf(Value = Null, "", Value)
	If mBase.IsInitialized = False Then Return
	RelayoutLayers
End Sub

Public Sub getPadding As String
	Return mPadding
End Sub

Public Sub setMargin(Value As String)
	mMargin = IIf(Value = Null, "", Value)
	If mBase.IsInitialized = False Then Return
	RelayoutLayers
End Sub

Public Sub getMargin As String
	Return mMargin
End Sub

Private Sub ApplyRoundedBox
	If mBase.IsInitialized = False Then Return
	If mRoundedBox Then
		mBase.SetColorAndBorder(mBase.Color, 0, xui.Color_Transparent, 8dip)
	Else
		mBase.SetColorAndBorder(mBase.Color, 0, xui.Color_Transparent, 0)
	End If
End Sub

'Convenience helper to quickly create and add plain card-like layers.
Public Sub AddColorLayer(BackColor As Int, Text As String, TextColor As Int, CornerRadius As Float) As B4XView
	Dim p As B4XView = xui.CreatePanel("")
	p.SetColorAndBorder(BackColor, 0, xui.Color_Transparent, Max(0, CornerRadius))
	If Text.Length > 0 Then
		Dim lbl As Label
		lbl.Initialize("")
		Dim xlbl As B4XView = lbl
		xlbl.Text = Text
		xlbl.TextColor = TextColor
		xlbl.TextSize = 20
		xlbl.SetTextAlignment("CENTER", "CENTER")
		p.AddView(xlbl, 0, 0, 10dip, 10dip)
	End If
	AddLayer(p)
	Return p
End Sub

Private Sub AddLayerInternal(ChildView As B4XView, Tag As Object, TriggerLayout As Boolean) As Int
	If ChildView.IsInitialized = False Then Return -1
	If Layers.IsInitialized = False Then Layers.Initialize
	Dim existingIndex As Int = FindLayerIndexByView(ChildView)
	If existingIndex >= 0 Then
		Dim existingItem As Map = Layers.Get(existingIndex)
		existingItem.Put("tag", Tag)
		Layers.Set(existingIndex, existingItem)
		If mBase.IsInitialized Then
			ChildView.RemoveViewFromParent
			mBase.AddView(ChildView, 0, 0, 1dip, 1dip)
		End If
		If TriggerLayout Then RelayoutLayers
		Return existingIndex
	End If
	ChildView.RemoveViewFromParent
	If mBase.IsInitialized Then mBase.AddView(ChildView, 0, 0, 1dip, 1dip)
	Dim item As Map = CreateMap("view": ChildView, "tag": Tag)
	Layers.Add(item)
	If TriggerLayout Then RelayoutLayers
	Return Layers.Size - 1
End Sub

Private Sub RelayoutLayers
	RelayoutLayersForBounds(mBase.Width, mBase.Height, mLayoutAnimationMs)
End Sub

Private Sub RelayoutLayersForBounds(Width As Float, Height As Float, AnimationMs As Int)
	If mBase.IsInitialized = False Then Return
	If Layers.IsInitialized = False Then Return

	Dim w As Float = Max(1dip, Width)
	Dim h As Float = Max(1dip, Height)
	Dim anim As Int = Max(0, AnimationMs)
	Dim count As Int = Layers.Size
	If count = 0 Then Return
	Dim hostRect As B4XRect
	hostRect.Initialize(0, 0, w, h)
	Dim box As Map = BuildBoxModel
	Dim outerRect As B4XRect = B4XDaisyBoxModel.ResolveOuterRect(hostRect, box)
	Dim contentRect As B4XRect = B4XDaisyBoxModel.ResolveContentRect(outerRect, box)
	w = Max(1dip, contentRect.Width)
	h = Max(1dip, contentRect.Height)
	Dim offX As Float = contentRect.Left
	Dim offY As Float = contentRect.Top
	
	Dim dir As String = NormalizeDirection(mDirection)
	Dim p1 As Float = Max(0, mStepPrimary)
	Dim p2 As Float = Max(0, mStepSecondary)
	If p2 > p1 Then p2 = p1
	Dim fillChildren As Boolean = mAutoFillLayers Or mStrictDaisyParity

	For i = 0 To count - 1
		Dim item As Map = Layers.Get(i)
		Dim layer As B4XView = item.Get("view")
		If layer.IsInitialized = False Then Continue

		Dim tier As Int = ResolveTier(i)
		Dim r As B4XRect = ResolveLayerRect(dir, tier, p1, p2, w, h)
		layer.SetLayoutAnimated(anim, offX + r.Left, offY + r.Top, r.Width, r.Height)
		ApplyLayerOpacity(layer, i)
		
		' Explicitly resize custom views added as layers
		If layer.Tag <> Null And xui.SubExists(layer.Tag, "Base_Resize", 2) Then
			CallSub3(layer.Tag, "Base_Resize", r.Width, r.Height)
		End If
		
		If fillChildren And layer.NumberOfViews > 0 Then
			For vi = 0 To layer.NumberOfViews - 1
				Dim child As B4XView = layer.GetView(vi)
				child.SetLayoutAnimated(anim, 0, 0, r.Width, r.Height)
			Next
		End If
	Next

	'Like Daisy stack: first item is frontmost.
	For i = count - 1 To 0 Step -1
		Dim item2 As Map = Layers.Get(i)
		Dim layer2 As B4XView = item2.Get("view")
		If layer2.IsInitialized Then layer2.BringToFront
	Next
End Sub

Private Sub AttachAllLayersToBase
	If mBase.IsInitialized = False Then Return
	If Layers.IsInitialized = False Then Return
	For i = 0 To Layers.Size - 1
		Dim item As Map = Layers.Get(i)
		Dim layer As B4XView = item.Get("view")
		If layer.IsInitialized = False Then Continue
		layer.RemoveViewFromParent
		mBase.AddView(layer, 0, 0, 1dip, 1dip)
	Next
End Sub

Private Sub FindLayerIndexByView(ChildView As B4XView) As Int
	If Layers.IsInitialized = False Then Return -1
	For i = 0 To Layers.Size - 1
		Dim item As Map = Layers.Get(i)
		Dim existing As B4XView = item.Get("view")
		If existing.IsInitialized And existing = ChildView Then Return i
	Next
	Return -1
End Sub

Private Sub ResolveTier(Index As Int) As Int
	If Index <= 0 Then Return 1
	If Index = 1 Then Return 2
	Return 3
End Sub

Private Sub ResolveLayerRect(dir As String, Tier As Int, p1 As Float, p2 As Float, ParentW As Float, ParentH As Float) As B4XRect
	If mStrictDaisyParity Then
		Dim e As Float = 3dip
		Dim i As Float = 4dip
		Dim x0 As Float = 0
		Dim y0 As Float = 0
		Dim w0 As Float = ParentW
		Dim h0 As Float = ParentH
		Select Case dir
			Case "top"
				Select Case Tier
					Case 1
						x0 = 0 : y0 = e + i : w0 = ParentW : h0 = ParentH - (e + i)
					Case 2
						x0 = e : y0 = e : w0 = ParentW - (e * 2) : h0 = ParentH - (e * 2)
					Case Else
						x0 = e + i : y0 = 0 : w0 = ParentW - ((e + i) * 2) : h0 = ParentH - (e + i)
				End Select
			Case "start"
				Select Case Tier
					Case 1
						x0 = e + i : y0 = 0 : w0 = ParentW - (e + i) : h0 = ParentH
					Case 2
						x0 = e : y0 = e : w0 = ParentW - (e * 2) : h0 = ParentH - (e * 2)
					Case Else
						x0 = 0 : y0 = e + i : w0 = ParentW - (e + i) : h0 = ParentH - ((e + i) * 2)
				End Select
			Case "end"
				Select Case Tier
					Case 1
						x0 = 0 : y0 = 0 : w0 = ParentW - (e + i) : h0 = ParentH
					Case 2
						x0 = e : y0 = e : w0 = ParentW - (e * 2) : h0 = ParentH - (e * 2)
					Case Else
						x0 = e + i : y0 = e + i : w0 = ParentW - (e + i) : h0 = ParentH - ((e + i) * 2)
				End Select
			Case Else 'bottom
				Select Case Tier
					Case 1
						x0 = 0 : y0 = 0 : w0 = ParentW : h0 = ParentH - (e + i)
					Case 2
						x0 = e : y0 = e : w0 = ParentW - (e * 2) : h0 = ParentH - (e * 2)
					Case Else
						x0 = e + i : y0 = e + i : w0 = ParentW - ((e + i) * 2) : h0 = ParentH - (e + i)
				End Select
		End Select
		Return SafeRect(x0, y0, w0, h0, ParentW, ParentH)
	End If

	Dim x As Float
	Dim y As Float
	Dim w As Float
	Dim h As Float

	Select Case dir
		Case "top"
			Select Case Tier
				Case 1
					x = 0 : y = p1 : w = ParentW : h = ParentH - p1
				Case 2
					x = p2 : y = p2 : w = ParentW - p2 * 2 : h = ParentH - p2 * 2
				Case Else
					x = p1 : y = 0 : w = ParentW - p1 * 2 : h = ParentH - p1
			End Select
		Case "start"
			Select Case Tier
				Case 1
					x = p1 : y = 0 : w = ParentW - p1 : h = ParentH
				Case 2
					x = p2 : y = p2 : w = ParentW - p2 * 2 : h = ParentH - p2 * 2
				Case Else
					x = 0 : y = p1 : w = ParentW - p1 : h = ParentH - p1 * 2
			End Select
		Case "end"
			Select Case Tier
				Case 1
					x = 0 : y = 0 : w = ParentW - p1 : h = ParentH
				Case 2
					x = p2 : y = p2 : w = ParentW - p2 * 2 : h = ParentH - p2 * 2
				Case Else
					x = p1 : y = p1 : w = ParentW - p1 : h = ParentH - p1 * 2
			End Select
		Case Else 'bottom
			Select Case Tier
				Case 1
					x = 0 : y = 0 : w = ParentW : h = ParentH - p1
				Case 2
					x = p2 : y = p2 : w = ParentW - p2 * 2 : h = ParentH - p2 * 2
				Case Else
					x = p1 : y = p1 : w = ParentW - p1 * 2 : h = ParentH - p1
			End Select
	End Select

	Return SafeRect(x, y, w, h, ParentW, ParentH)
End Sub

Private Sub ApplyLayerOpacity(Layer As B4XView, Index As Int)
	Dim a As Float = 1
	If mStrictDaisyParity Then
		If Index = 0 Then
			a = 1
		Else If Index = 1 Then
			a = 0.9
		Else
			a = 0.7
		End If
	End If
	#If B4A
	Try
		Dim jo As JavaObject = Layer
		jo.RunMethod("setAlpha", Array(a))
	Catch
	End Try
	#End If
End Sub

Private Sub SafeRect(X As Float, Y As Float, W As Float, H As Float, MaxW As Float, MaxH As Float) As B4XRect
	Dim left As Float = Max(0, X)
	Dim top As Float = Max(0, Y)
	Dim width As Float = Max(1dip, W)
	Dim height As Float = Max(1dip, H)

	If left > MaxW - 1dip Then left = Max(0, MaxW - 1dip)
	If top > MaxH - 1dip Then top = Max(0, MaxH - 1dip)
	If left + width > MaxW Then width = Max(1dip, MaxW - left)
	If top + height > MaxH Then height = Max(1dip, MaxH - top)

	Dim r As B4XRect
	r.Initialize(left, top, left + width, top + height)
	Return r
End Sub

Private Sub ApplyDesignerProps(Props As Map)
	mWidth = Max(16dip, GetPropSizeDip(Props, "Width", mWidth))
	mHeight = Max(16dip, GetPropSizeDip(Props, "Height", mHeight))
	mPadding = GetPropString(Props, "Padding", mPadding)
	mMargin = GetPropString(Props, "Margin", mMargin)
	mDirection = NormalizeDirection(GetPropString(Props, "Direction", mDirection))
	mStepPrimary = Max(0, GetPropDip(Props, "StepPrimary", mStepPrimary))
	mStepSecondary = Max(0, GetPropDip(Props, "StepSecondary", mStepSecondary))
	If mStepSecondary > mStepPrimary Then mStepSecondary = mStepPrimary
	mAutoFillLayers = GetPropBool(Props, "AutoFillLayers", mAutoFillLayers)
	mLayoutAnimationMs = Max(0, GetPropInt(Props, "LayoutAnimationMs", mLayoutAnimationMs))
	mRoundedBox = GetPropBool(Props, "RoundedBox", mRoundedBox)
	mStrictDaisyParity = GetPropBool(Props, "StrictDaisyParity", mStrictDaisyParity)
	ApplyRoundedBox
End Sub







Public Sub setTag(Value As Object)
	mTag = Value
	If mBase.IsInitialized = False Then Return
End Sub

Public Sub getTag As Object
	Return mTag
End Sub

Private Sub BuildBoxModel As Map
	Dim box As Map = B4XDaisyBoxModel.CreateDefaultModel
	ApplySpacingSpecToBox(box, mPadding, mMargin)
	Return box
End Sub

Private Sub ApplySpacingSpecToBox(Box As Map, PaddingSpec As String, MarginSpec As String)
	Dim rtl As Boolean = False
	Dim p As String = IIf(PaddingSpec = Null, "", PaddingSpec.Trim)
	Dim m As String = IIf(MarginSpec = Null, "", MarginSpec.Trim)
	If p.Length > 0 Then
		If B4XDaisyVariants.ContainsAny(p, Array As String("p-", "px-", "py-", "pt-", "pr-", "pb-", "pl-", "ps-", "pe-")) Then
			B4XDaisyBoxModel.ApplyPaddingUtilities(Box, p, rtl)
		Else
			Dim pv As Float = B4XDaisyBoxModel.TailwindSpacingToDip(p, 0dip)
			Box.Put("padding_left", pv)
			Box.Put("padding_right", pv)
			Box.Put("padding_top", pv)
			Box.Put("padding_bottom", pv)
		End If
	End If
	If m.Length > 0 Then
		If B4XDaisyVariants.ContainsAny(m, Array As String("m-", "mx-", "my-", "mt-", "mr-", "mb-", "ml-", "ms-", "me-", "-m-", "-mx-", "-my-", "-mt-", "-mr-", "-mb-", "-ml-", "-ms-", "-me-")) Then
			B4XDaisyBoxModel.ApplyMarginUtilities(Box, m, rtl)
		Else
			Dim mv As Float = B4XDaisyBoxModel.TailwindSpacingToDip(m, 0dip)
			Box.Put("margin_left", mv)
			Box.Put("margin_right", mv)
			Box.Put("margin_top", mv)
			Box.Put("margin_bottom", mv)
		End If
	End If
End Sub

Private Sub NormalizeDirection(Value As String) As String
	If Value = Null Then Return "bottom"
	Dim v As String = Value.ToLowerCase.Trim
	If v.StartsWith("stack-") Then v = v.SubString(6)
	Select Case v
		Case "top", "bottom", "start", "end"
			Return v
		Case Else
			Return "bottom"
	End Select
End Sub

Private Sub ParseSizeSpec(Value As Object, DefaultValue As Float) As Float
	If Value = Null Then Return DefaultValue
	If IsNumber(Value) Then Return Value * 1dip
	Dim s As String = Value
	s = s.Trim
	If s.Length = 0 Then Return DefaultValue
	If IsNumber(s) Then Return s * 1dip
	If s.EndsWith("dip") Then
		Dim n1 As String = s.SubString2(0, s.Length - 3).Trim
		If IsNumber(n1) Then Return n1 * 1dip
	End If
	Return B4XDaisyVariants.TailwindSizeToDip(s, DefaultValue)
End Sub

Private Sub IsValidLayerIndex(Index As Int) As Boolean
	If Layers.IsInitialized = False Then Return False
	Return Index >= 0 And Index < Layers.Size
End Sub

Private Sub ResolveWidthBase(DefaultValue As Float) As Float
	If mBase.IsInitialized Then
		Dim parent As B4XView = mBase.Parent
		If parent.IsInitialized And parent.Width > 0 Then Return parent.Width
		If mBase.Width > 0 Then Return mBase.Width
	End If
	Return DefaultValue
End Sub

Private Sub ResolveHeightBase(DefaultValue As Float) As Float
	If mBase.IsInitialized Then
		Dim parent As B4XView = mBase.Parent
		If parent.IsInitialized And parent.Height > 0 Then Return parent.Height
		If mBase.Height > 0 Then Return mBase.Height
	End If
	Return DefaultValue
End Sub

Private Sub GetPropDip(Props As Map, Key As String, DefaultDipValue As Float) As Float
	If Props.ContainsKey(Key) = False Then Return DefaultDipValue
	Return B4XDaisyVariants.GetPropFloat(Props, Key, 0) * 1dip
End Sub

Private Sub GetPropSizeDip(Props As Map, Key As String, DefaultDipValue As Float) As Float
	If Props.ContainsKey(Key) = False Then Return DefaultDipValue
	Dim o As Object = Props.Get(Key)
	Return B4XDaisyVariants.TailwindSizeToDip(o, DefaultDipValue)
End Sub

Private Sub GetPropString(Props As Map, Key As String, DefaultValue As String) As String
	Return B4XDaisyVariants.GetPropString(Props, Key, DefaultValue)
End Sub

Private Sub GetPropFloat(Props As Map, Key As String, DefaultValue As Float) As Float
	Return B4XDaisyVariants.GetPropFloat(Props, Key, DefaultValue)
End Sub

Private Sub GetPropInt(Props As Map, Key As String, DefaultValue As Int) As Int
	Return B4XDaisyVariants.GetPropInt(Props, Key, DefaultValue)
End Sub

Private Sub GetPropBool(Props As Map, Key As String, DefaultValue As Boolean) As Boolean
	Return B4XDaisyVariants.GetPropBool(Props, Key, DefaultValue)
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub
