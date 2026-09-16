B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: w-10, Description: Tailwind size token or CSS size (eg w-12, 80px, 4em, 5rem)
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: h-10, Description: Tailwind size token or CSS size (eg h-12, 80px, 4em, 5rem)
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: String, DefaultValue:, Description: Tailwind/spacing padding utilities (eg p-2, px-3, 2)
#DesignerProperty: Key: Margin, DisplayName: Margin, FieldType: String, DefaultValue:, Description: Tailwind/spacing margin utilities (eg m-2, mx-1.5, 1)
#DesignerProperty: Key: Direction, DisplayName: Direction, FieldType: String, DefaultValue: bottom, List: bottom|top|start|end, Description: Daisy stack direction.
#DesignerProperty: Key: StepPrimary, DisplayName: Primary Step, FieldType: Int, DefaultValue: 7, Description: Primary offset in dip used for the deepest layer.
#DesignerProperty: Key: StepSecondary, DisplayName: Secondary Step, FieldType: Int, DefaultValue: 3, Description: Secondary offset in dip used for the middle layer.
#DesignerProperty: Key: AutoFillLayers, DisplayName: Auto Fill Layers, FieldType: Boolean, DefaultValue: True, Description: Resize each child to fill its layer frame.
#DesignerProperty: Key: LayoutAnimationMs, DisplayName: Layout Animation, FieldType: Int, DefaultValue: 0, Description: Animation duration in milliseconds when relayout runs.
#DesignerProperty: Key: Rounded, DisplayName: Rounded, FieldType: String, DefaultValue: rounded-box, List: theme|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full|rounded-box|rounded-field|rounded-selector, Description: Corner radius token.
#DesignerProperty: Key: StrictDaisyParity, DisplayName: Strict Daisy Parity, FieldType: Boolean, DefaultValue: True, Description: Use DaisyUI stack geometry and per-layer opacity (1.0, 0.9, 0.7).

'B4XDaisyStack
'Native B4X stack container inspired by DaisyUI stack component.

#IgnoreWarnings:12,9
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
	Private mRounded As String = "rounded-box"
	Private mStrictDaisyParity As Boolean = True
	Private inResize As Boolean = False
End Sub

Public Sub Initialize(oCallback As Object, sEventName As String)
	mCallBack = oCallback
	mEventName = sEventName
	Layers.Initialize
End Sub

Public Sub CreateView(iWidth As Int, iHeight As Int) As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, iWidth, iHeight)
	Dim props As Map = BuildRuntimeProps(iWidth, iHeight)
	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	Return mBase
End Sub

Private Sub ResolvePxSizeSpec(fSizeDip As Float) As String
	Dim px As Int = Max(1, Round(fSizeDip / 1dip))
	Return px & "px"
End Sub

Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
	mBase = oBase
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent
	If Layers.IsInitialized = False Then Layers.Initialize
	AttachAllLayersToBase
	ApplyDesignerProps(mProps)
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub Base_Resize(dWidth As Double, dHeight As Double)
	If mBase.IsInitialized = False Then Return
	If inResize Then Return
	inResize = True
	RelayoutLayersForBounds(dWidth, dHeight, mLayoutAnimationMs)
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

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
Public Sub AddViewToContent(vChildView As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If mBase.IsInitialized = False Then Return
	mBase.AddView(vChildView, iLeft, iTop, iWidth, iHeight)
End Sub

Sub IsReady As Boolean
	Return mBase.IsInitialized And mBase.Width > 0 And mBase.Height > 0
End Sub

Public Sub AddLayer(vChildView As B4XView) As Int
	Return AddLayerInternal(vChildView, Null, True)
End Sub

Public Sub AddLayerWithTag(vChildView As B4XView, oTag As Object) As Int
	Return AddLayerInternal(vChildView, oTag, True)
End Sub

Public Sub SetLayers(lstViews As List)
	Clear
	If lstViews.IsInitialized = False Then Return
	For Each v As B4XView In lstViews
		AddLayerInternal(v, Null, False)
	Next
	RelayoutLayers
End Sub

Public Sub RemoveLayerAt(iIndex As Int) As Boolean
	If IsValidLayerIndex(iIndex) = False Then Return False
	Dim item As Map = Layers.Get(iIndex)
	Dim v As B4XView = item.Get("view")
	If v.IsInitialized Then v.RemoveViewFromParent
	Layers.RemoveAt(iIndex)
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

Public Sub getLayer(iIndex As Int) As B4XView
	Dim empty As B4XView
	If IsValidLayerIndex(iIndex) = False Then Return empty
	Dim item As Map = Layers.Get(iIndex)
	Return item.Get("view")
End Sub

Public Sub getLayerCount As Int
	If Layers.IsInitialized = False Then Return 0
	Return Layers.Size
End Sub

Public Sub setLayerTag(iIndex As Int, oTag As Object)
	If IsValidLayerIndex(iIndex) = False Then Return
	Dim item As Map = Layers.Get(iIndex)
	item.Put("tag", oTag)
	Layers.Set(iIndex, item)
End Sub

Public Sub getLayerTag(iIndex As Int) As Object
	If IsValidLayerIndex(iIndex) = False Then Return Null
	Dim item As Map = Layers.Get(iIndex)
	Return item.Get("tag")
End Sub

Public Sub setDirection(sValue As String)
	mDirection = NormalizeDirection(sValue)
	If mBase.IsInitialized = False Then Return
	RelayoutLayers
End Sub

Public Sub getDirection As String
	Return mDirection
End Sub

Public Sub setWidth(oValue As Object)
	mWidth = Max(16dip, B4XDaisyVariants.TailwindSizeToDip(oValue, B4XDaisyVariants.ResolveWidthBase(mBase, mWidth)))
	mWidthExplicit = True
	If mBase.IsInitialized = False Then Return
	Dim targetH As Float = Max(1dip, mBase.Height)
	mBase.SetLayoutAnimated(mLayoutAnimationMs, mBase.Left, mBase.Top, mWidth, targetH)
	RelayoutLayersForBounds(mWidth, targetH, mLayoutAnimationMs)
End Sub

Public Sub getWidth As Float
	Return mWidth
End Sub

Public Sub setHeight(oValue As Object)
	mHeight = Max(16dip, B4XDaisyVariants.TailwindSizeToDip(oValue, B4XDaisyVariants.ResolveHeightBase(mBase, mHeight)))
	mHeightExplicit = True
	If mBase.IsInitialized = False Then Return
	Dim targetW As Float = Max(1dip, mBase.Width)
	mBase.SetLayoutAnimated(mLayoutAnimationMs, mBase.Left, mBase.Top, targetW, mHeight)
	RelayoutLayersForBounds(targetW, mHeight, mLayoutAnimationMs)
End Sub

Public Sub getHeight As Float
	Return mHeight
End Sub

Public Sub setSize(iWidth As Int, iHeight As Int)
	mWidth = Max(16dip, iWidth)
	mHeight = Max(16dip, iHeight)
	mWidthExplicit = True
	mHeightExplicit = True
	If mBase.IsInitialized Then
		mBase.SetLayoutAnimated(mLayoutAnimationMs, mBase.Left, mBase.Top, mWidth, mHeight)
		RelayoutLayersForBounds(mWidth, mHeight, mLayoutAnimationMs)
	End If
End Sub

Public Sub setStepPrimary(oValue As Object)
	mStepPrimary = Max(0, ParseSizeSpec(oValue, mStepPrimary))
	If mStepSecondary > mStepPrimary Then mStepSecondary = mStepPrimary
	If mBase.IsInitialized = False Then Return
	RelayoutLayers
End Sub

Public Sub getStepPrimary As Float
	Return mStepPrimary
End Sub

Public Sub setStepSecondary(oValue As Object)
	mStepSecondary = Max(0, ParseSizeSpec(oValue, mStepSecondary))
	If mStepSecondary > mStepPrimary Then mStepSecondary = mStepPrimary
	If mBase.IsInitialized = False Then Return
	RelayoutLayers
End Sub

Public Sub getStepSecondary As Float
	Return mStepSecondary
End Sub

Public Sub setAutoFillLayers(bValue As Boolean)
	mAutoFillLayers = bValue
	If mBase.IsInitialized = False Then Return
	RelayoutLayers
End Sub

Public Sub getAutoFillLayers As Boolean
	Return mAutoFillLayers
End Sub

Public Sub setLayoutAnimationMs(iValue As Int)
	mLayoutAnimationMs = Max(0, iValue)
	If mBase.IsInitialized = False Then Return
	RelayoutLayers
End Sub

Public Sub getLayoutAnimationMs As Int
	Return mLayoutAnimationMs
End Sub

Public Sub setRounded(sValue As String)
	mRounded = IIf(sValue = Null, "rounded-box", sValue.ToLowerCase.Trim)
	If mBase.IsInitialized Then ApplyRoundedBox
End Sub

Public Sub getRounded As String
	Return mRounded
End Sub

Public Sub setRoundedBox(bValue As Boolean)
	If bValue Then
	    setRounded("rounded-box")
	Else
	    setRounded("rounded-none")
	End If
End Sub

Public Sub getRoundedBox As Boolean
	Return (mRounded = "rounded-box" Or mRounded = "theme")
End Sub

Public Sub setStrictDaisyParity(bValue As Boolean)
	mStrictDaisyParity = bValue
	If mBase.IsInitialized = False Then Return
	RelayoutLayers
End Sub

Public Sub getStrictDaisyParity As Boolean
	Return mStrictDaisyParity
End Sub

Public Sub setPadding(sValue As String)
	mPadding = IIf(sValue = Null, "", sValue)
	If mBase.IsInitialized = False Then Return
	RelayoutLayers
End Sub

Public Sub getPadding As String
	Return mPadding
End Sub

Public Sub setMargin(sValue As String)
	mMargin = IIf(sValue = Null, "", sValue)
	If mBase.IsInitialized = False Then Return
	RelayoutLayers
End Sub

Public Sub getMargin As String
	Return mMargin
End Sub

Private Sub ApplyRoundedBox
	If mBase.IsInitialized = False Then Return
	If mRounded = "rounded-box" Or mRounded = "theme" Then
		mBase.SetColorAndBorder(mBase.Color, 0, xui.Color_Transparent, 8dip)
	Else
		mBase.SetColorAndBorder(mBase.Color, 0, xui.Color_Transparent, 0)
	End If
End Sub

'Convenience helper to quickly create and add plain card-like layers.
Public Sub AddColorLayer(iBackColor As Int, sText As String, iTextColor As Int, fCornerRadius As Float) As B4XView
	Dim p As B4XView = xui.CreatePanel("")
	p.SetColorAndBorder(iBackColor, 0, xui.Color_Transparent, Max(0, fCornerRadius))
	If sText.Length > 0 Then
		Dim lbl As Label
		lbl.Initialize("")
		Dim xlbl As B4XView = lbl
		xlbl.Text = sText
		xlbl.TextColor = iTextColor
		xlbl.TextSize = 20
		xlbl.SetTextAlignment("CENTER", "CENTER")
		p.AddView(xlbl, 0, 0, 10dip, 10dip)
	End If
	AddLayer(p)
	Return p
End Sub

Private Sub AddLayerInternal(vChildView As B4XView, oTag As Object, bTriggerLayout As Boolean) As Int
	If vChildView.IsInitialized = False Then Return -1
	If Layers.IsInitialized = False Then Layers.Initialize
	Dim existingIndex As Int = FindLayerIndexByView(vChildView)
	If existingIndex >= 0 Then
		Dim existingItem As Map = Layers.Get(existingIndex)
		existingItem.Put("tag", oTag)
		Layers.Set(existingIndex, existingItem)
		If mBase.IsInitialized Then
			vChildView.RemoveViewFromParent
			mBase.AddView(vChildView, 0, 0, 1dip, 1dip)
		End If
		If bTriggerLayout Then RelayoutLayers
		Return existingIndex
	End If
	vChildView.RemoveViewFromParent
	If mBase.IsInitialized Then mBase.AddView(vChildView, 0, 0, 1dip, 1dip)
	Dim item As Map = CreateMap("view": vChildView, "tag": oTag)
	Layers.Add(item)
	If bTriggerLayout Then RelayoutLayers
	Return Layers.Size - 1
End Sub

Private Sub RelayoutLayers
	RelayoutLayersForBounds(mBase.Width, mBase.Height, mLayoutAnimationMs)
End Sub

Private Sub RelayoutLayersForBounds(fWidth As Float, fHeight As Float, iAnimationMs As Int)
	If mBase.IsInitialized = False Then Return
	If Layers.IsInitialized = False Then Return

	Dim w As Float = Max(1dip, fWidth)
	Dim h As Float = Max(1dip, fHeight)
	Dim anim As Int = Max(0, iAnimationMs)
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

Private Sub FindLayerIndexByView(vChildView As B4XView) As Int
	If Layers.IsInitialized = False Then Return -1
	For i = 0 To Layers.Size - 1
		Dim item As Map = Layers.Get(i)
		Dim existing As B4XView = item.Get("view")
		If existing.IsInitialized And existing = vChildView Then Return i
	Next
	Return -1
End Sub

Private Sub ResolveTier(iIndex As Int) As Int
	If iIndex <= 0 Then Return 1
	If iIndex = 1 Then Return 2
	Return 3
End Sub

Private Sub ResolveLayerRect(sDir As String, iTier As Int, fP1 As Float, fP2 As Float, fParentW As Float, fParentH As Float) As B4XRect
	If mStrictDaisyParity Then
		Dim e As Float = 3dip
		Dim i As Float = 4dip
		Dim x0 As Float = 0
		Dim y0 As Float = 0
		Dim w0 As Float = fParentW
		Dim h0 As Float = fParentH
		Select Case sDir
			Case "top"
				Select Case iTier
					Case 1
						x0 = 0 : y0 = e + i : w0 = fParentW : h0 = fParentH - (e + i)
					Case 2
						x0 = e : y0 = e : w0 = fParentW - (e * 2) : h0 = fParentH - (e * 2)
					Case Else
						x0 = e + i : y0 = 0 : w0 = fParentW - ((e + i) * 2) : h0 = fParentH - (e + i)
				End Select
			Case "start"
				Select Case iTier
					Case 1
						x0 = e + i : y0 = 0 : w0 = fParentW - (e + i) : h0 = fParentH
					Case 2
						x0 = e : y0 = e : w0 = fParentW - (e * 2) : h0 = fParentH - (e * 2)
					Case Else
						x0 = 0 : y0 = e + i : w0 = fParentW - (e + i) : h0 = fParentH - ((e + i) * 2)
				End Select
			Case "end"
				Select Case iTier
					Case 1
						x0 = 0 : y0 = 0 : w0 = fParentW - (e + i) : h0 = fParentH
					Case 2
						x0 = e : y0 = e : w0 = fParentW - (e * 2) : h0 = fParentH - (e * 2)
					Case Else
						x0 = e + i : y0 = e + i : w0 = fParentW - (e + i) : h0 = fParentH - ((e + i) * 2)
				End Select
			Case Else 'bottom
				Select Case iTier
					Case 1
						x0 = 0 : y0 = 0 : w0 = fParentW : h0 = fParentH - (e + i)
					Case 2
						x0 = e : y0 = e : w0 = fParentW - (e * 2) : h0 = fParentH - (e * 2)
					Case Else
						x0 = e + i : y0 = e + i : w0 = fParentW - ((e + i) * 2) : h0 = fParentH - (e + i)
				End Select
		End Select
		Return SafeRect(x0, y0, w0, h0, fParentW, fParentH)
	End If

	Dim x As Float
	Dim y As Float
	Dim w As Float
	Dim h As Float

	Select Case sDir
		Case "top"
			Select Case iTier
				Case 1
					x = 0 : y = fP1 : w = fParentW : h = fParentH - fP1
				Case 2
					x = fP2 : y = fP2 : w = fParentW - fP2 * 2 : h = fParentH - fP2 * 2
				Case Else
					x = fP1 : y = 0 : w = fParentW - fP1 * 2 : h = fParentH - fP1
			End Select
		Case "start"
			Select Case iTier
				Case 1
					x = fP1 : y = 0 : w = fParentW - fP1 : h = fParentH
				Case 2
					x = fP2 : y = fP2 : w = fParentW - fP2 * 2 : h = fParentH - fP2 * 2
				Case Else
					x = 0 : y = fP1 : w = fParentW - fP1 : h = fParentH - fP1 * 2
			End Select
		Case "end"
			Select Case iTier
				Case 1
					x = 0 : y = 0 : w = fParentW - fP1 : h = fParentH
				Case 2
					x = fP2 : y = fP2 : w = fParentW - fP2 * 2 : h = fParentH - fP2 * 2
				Case Else
					x = fP1 : y = fP1 : w = fParentW - fP1 : h = fParentH - fP1 * 2
			End Select
		Case Else 'bottom
			Select Case iTier
				Case 1
					x = 0 : y = 0 : w = fParentW : h = fParentH - fP1
				Case 2
					x = fP2 : y = fP2 : w = fParentW - fP2 * 2 : h = fParentH - fP2 * 2
				Case Else
					x = fP1 : y = fP1 : w = fParentW - fP1 * 2 : h = fParentH - fP1
			End Select
	End Select

	Return SafeRect(x, y, w, h, fParentW, fParentH)
End Sub

Private Sub ApplyLayerOpacity(vLayer As B4XView, iIndex As Int)
	Dim a As Float = 1
	If mStrictDaisyParity Then
		If iIndex = 0 Then
			a = 1
		Else If iIndex = 1 Then
			a = 0.9
		Else
			a = 0.7
		End If
	End If
	#If B4A
	Try
		Dim jo As JavaObject = vLayer
		jo.RunMethod("setAlpha", Array(a))
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyStack.ApplyLayerOpacity: " & LastException.Message)
	End Try 'ignore
	#End If
End Sub

Private Sub SafeRect(fX As Float, fY As Float, fW As Float, fH As Float, fMaxW As Float, fMaxH As Float) As B4XRect
	Dim left As Float = Max(0, fX)
	Dim top As Float = Max(0, fY)
	Dim width As Float = Max(1dip, fW)
	Dim height As Float = Max(1dip, fH)

	If left > fMaxW - 1dip Then left = Max(0, fMaxW - 1dip)
	If top > fMaxH - 1dip Then top = Max(0, fMaxH - 1dip)
	If left + width > fMaxW Then width = Max(1dip, fMaxW - left)
	If top + height > fMaxH Then height = Max(1dip, fMaxH - top)

	Dim r As B4XRect
	r.Initialize(left, top, left + width, top + height)
	Return r
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
	mWidth = Max(16dip, B4XDaisyVariants.GetPropSizeDip(mProps, "Width", "w-10"))
	mHeight = Max(16dip, B4XDaisyVariants.GetPropSizeDip(mProps, "Height", "h-10"))
	mPadding = B4XDaisyVariants.GetPropString(mProps, "Padding", mPadding)
	mMargin = B4XDaisyVariants.GetPropString(mProps, "Margin", mMargin)
	mDirection = NormalizeDirection(B4XDaisyVariants.GetPropString(mProps, "Direction", mDirection))
	mStepPrimary = Max(0, B4XDaisyVariants.GetPropFloat(mProps, "StepPrimary", 7) * 1dip)
	mStepSecondary = Max(0, B4XDaisyVariants.GetPropFloat(mProps, "StepSecondary", 3) * 1dip)
	If mStepSecondary > mStepPrimary Then mStepSecondary = mStepPrimary
	mAutoFillLayers = B4XDaisyVariants.GetPropBool(mProps, "AutoFillLayers", mAutoFillLayers)
	mLayoutAnimationMs = Max(0, B4XDaisyVariants.GetPropInt(mProps, "LayoutAnimationMs", mLayoutAnimationMs))
	mRounded = B4XDaisyVariants.GetPropString(mProps, "Rounded", mRounded)

	' Backward compatibility: migrate legacy RoundedBox=True
	If mProps.ContainsKey("RoundedBox") Then
	    Dim bLegacyBox As Boolean = B4XDaisyVariants.GetPropBool(mProps, "RoundedBox", False)
	    If bLegacyBox And (mRounded = "theme" Or mRounded = "") Then
	        mRounded = "rounded-box"
	    End If
	End If
	mStrictDaisyParity = B4XDaisyVariants.GetPropBool(mProps, "StrictDaisyParity", mStrictDaisyParity)
	ApplyRoundedBox
End Sub

Private Sub BuildRuntimeProps(iWidth As Int, iHeight As Int) As Map
	Dim props As Map
	props.Initialize
	props.Put("Width", B4XDaisyVariants.ResolvePxSizeSpec(iWidth))
	props.Put("Height", B4XDaisyVariants.ResolvePxSizeSpec(iHeight))
	props.Put("Padding", mPadding)
	props.Put("Margin", mMargin)
	props.Put("Direction", mDirection)
	props.Put("StepPrimary", mStepPrimary)
	props.Put("StepSecondary", mStepSecondary)
	props.Put("AutoFillLayers", mAutoFillLayers)
	props.Put("LayoutAnimationMs", mLayoutAnimationMs)
	props.Put("Rounded", mRounded)
	props.Put("StrictDaisyParity", mStrictDaisyParity)
	Return props
End Sub







Public Sub setTag(oValue As Object)
	mTag = oValue
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

Private Sub ApplySpacingSpecToBox(mBox As Map, sPaddingSpec As String, sMarginSpec As String)
	Dim rtl As Boolean = False
	Dim p As String = IIf(sPaddingSpec = Null, "", sPaddingSpec.Trim)
	Dim m As String = IIf(sMarginSpec = Null, "", sMarginSpec.Trim)
	If p.Length > 0 Then
		If B4XDaisyVariants.ContainsAny(p, Array As String("p-", "px-", "py-", "pt-", "pr-", "pb-", "pl-", "ps-", "pe-")) Then
			B4XDaisyBoxModel.ApplyPaddingUtilities(mBox, p, rtl)
		Else
			Dim pv As Float = B4XDaisyBoxModel.TailwindSpacingToDip(p, 0dip)
			mBox.Put("padding_left", pv)
			mBox.Put("padding_right", pv)
			mBox.Put("padding_top", pv)
			mBox.Put("padding_bottom", pv)
		End If
	End If
	If m.Length > 0 Then
		If B4XDaisyVariants.ContainsAny(m, Array As String("m-", "mx-", "my-", "mt-", "mr-", "mb-", "ml-", "ms-", "me-", "-m-", "-mx-", "-my-", "-mt-", "-mr-", "-mb-", "-ml-", "-ms-", "-me-")) Then
			B4XDaisyBoxModel.ApplyMarginUtilities(mBox, m, rtl)
		Else
			Dim mv As Float = B4XDaisyBoxModel.TailwindSpacingToDip(m, 0dip)
			mBox.Put("margin_left", mv)
			mBox.Put("margin_right", mv)
			mBox.Put("margin_top", mv)
			mBox.Put("margin_bottom", mv)
		End If
	End If
End Sub

Private Sub NormalizeDirection(sValue As String) As String
	If sValue = Null Then Return "bottom"
	Dim v As String = sValue.ToLowerCase.Trim
	If v.StartsWith("stack-") Then v = v.SubString(6)
	Select Case v
		Case "top", "bottom", "start", "end"
			Return v
		Case Else
			Return "bottom"
	End Select
End Sub

Private Sub ParseSizeSpec(oValue As Object, fDefaultValue As Float) As Float
	If oValue = Null Then Return fDefaultValue
	If IsNumber(oValue) Then Return oValue * 1dip
	Dim s As String = oValue
	s = s.Trim
	If s.Length = 0 Then Return fDefaultValue
	If IsNumber(s) Then Return s * 1dip
	If s.EndsWith("dip") Then
		Dim n1 As String = s.SubString2(0, s.Length - 3).Trim
		If IsNumber(n1) Then Return n1 * 1dip
	End If
	Return B4XDaisyVariants.TailwindSizeToDip(s, fDefaultValue)
End Sub

Private Sub IsValidLayerIndex(iIndex As Int) As Boolean
	If Layers.IsInitialized = False Then Return False
	Return iIndex >= 0 And iIndex < Layers.Size
End Sub





' removed simple GetPropString helper; use variant call directly

' removed simple GetPropBool helper; use variant call directly

Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub

#Region B4XView Layout Wrapper Methods
Public Sub SetLayoutAnimated(iDuration As Int, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int)
	If mBase.IsInitialized Then mBase.SetLayoutAnimated(iDuration, iLeft, iTop, iWidth, iHeight)
End Sub

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

#End Region

#Region B4XView Z-Order and Visibility Methods
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