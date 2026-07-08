B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9

#Region Variables
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private svHost As ScrollView
	Private pnlHost As B4XView
	Private PAGE_PAD As Int = 12dip
End Sub
#End Region

#Region Initialization
''' <summary>
''' Initializes the demo page.
''' </summary>
Public Sub Initialize As Object
	Return Me
End Sub

''' <summary>
''' B4XPage Created event. Sets up the scrollable content area.
''' </summary>
Private Sub B4XPage_Created(Root1 As B4XView)
	Root = Root1

	svHost.Initialize(Max(1dip, Root.Height))
	Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
	pnlHost = svHost.Panel
	pnlHost.Color = xui.Color_Transparent

	RenderExamples(Root.Width, Root.Height)
End Sub
#End Region

#Region Rendering
''' <summary>
''' Renders all DaisyUI Rating examples in a linear vertical layout.
''' Parity: covers all 8 documented examples from the DaisyUI Rating page.
''' </summary>
Private Sub RenderExamples(Width As Int, Height As Int)
	If pnlHost.IsInitialized = False Then Return
	pnlHost.RemoveAllViews

	Dim maxW As Int = Max(220dip, Width - (PAGE_PAD * 2))
	Dim y As Int = PAGE_PAD

	' #region Example 1: Basic Rating (mask-star)
	''' Basic Rating with default mask-star icons.
	y = AddSectionTitle("Rating", y, maxW)
	Dim c1 As B4XDaisyRating
	c1.Initialize(Me, "rating1")
	c1.AddToParent(pnlHost, PAGE_PAD, y, maxW, 48dip)
	c1.Value = 2
	c1.IconStyle = "star"
	c1.Tag = "basic-star"
	y = y + 64dip
	' #endregion

	' #region Example 2: Read-only Rating
	''' Read-only Rating using div elements (aria-current for active state).
	y = AddSectionTitle("Read-only Rating", y, maxW)
	Dim c2 As B4XDaisyRating
	c2.Initialize(Me, "rating2")
	c2.AddToParent(pnlHost, PAGE_PAD, y, maxW, 48dip)
	c2.Value = 3
	c2.ReadOnly = True
	c2.Tag = "readonly"
	y = y + 64dip
	' #endregion

	' #region Example 3: mask-star-2 with warning color (bg-orange-400)
	''' mask-star-2 with orange-400 warning color.
	y = AddSectionTitle("mask-star-2 with warning color", y, maxW)
	Dim c3 As B4XDaisyRating
	c3.Initialize(Me, "rating3")
	c3.AddToParent(pnlHost, PAGE_PAD, y, maxW, 48dip)
	c3.Value = 2
	c3.IconStyle = "star-2"
	c3.Variant = "warning"
	c3.Tag = "star2-orange"
	y = y + 64dip
	' #endregion

	' #region Example 4: mask-heart with multiple colors
	''' mask-heart with per-item colors (bg-red-400, bg-orange-400, bg-yellow-400, bg-lime-400, bg-green-400).
	y = AddSectionTitle("mask-heart with multiple colors", y, maxW)
	Dim c4 As B4XDaisyRating
	c4.Initialize(Me, "rating4")
	c4.AddToParent(pnlHost, PAGE_PAD, y, maxW, 48dip)
	c4.Value = 2
	c4.IconStyle = "heart"
	c4.Gap = 4
	Dim heartColors As List
	heartColors.Initialize
	heartColors.Add(xui.Color_RGB(248, 113, 113))   ' bg-red-400
	heartColors.Add(xui.Color_RGB(251, 146, 60))     ' bg-orange-400
	heartColors.Add(xui.Color_RGB(250, 204, 21))     ' bg-yellow-400
	heartColors.Add(xui.Color_RGB(163, 230, 53))     ' bg-lime-400
	heartColors.Add(xui.Color_RGB(74, 222, 128))     ' bg-green-400
	c4.SetItemColors(heartColors)
	c4.Tag = "heart-multicolor"
	y = y + 64dip
	' #endregion

	' #region Example 5: mask-star-2 with green-500 color
	''' mask-star-2 with green-500 success color.
	y = AddSectionTitle("mask-star-2 with green-500 color", y, maxW)
	Dim c5 As B4XDaisyRating
	c5.Initialize(Me, "rating5")
	c5.AddToParent(pnlHost, PAGE_PAD, y, maxW, 48dip)
	c5.Value = 2
	c5.IconStyle = "star-2"
	c5.Variant = "success"
	c5.Tag = "star2-green"
	y = y + 64dip
	' #endregion

	' #region Example 6: Sizes (xs, sm, md, lg, xl)
	''' All five size variants: rating-xs, rating-sm, rating-md, rating-lg, rating-xl.
	y = AddSectionTitle("Sizes", y, maxW)

	' xs
	Dim c6a As B4XDaisyRating
	c6a.Initialize(Me, "rating6a")
	c6a.AddToParent(pnlHost, PAGE_PAD, y, maxW, 28dip)
	c6a.Value = 2
	c6a.Size = "xs"
	c6a.IconStyle = "star-2"
	c6a.ActiveColor = xui.Color_RGB(251, 146, 60)
	c6a.Tag = "size-xs"
	y = y + 36dip

	' sm
	Dim c6b As B4XDaisyRating
	c6b.Initialize(Me, "rating6b")
	c6b.AddToParent(pnlHost, PAGE_PAD, y, maxW, 32dip)
	c6b.Value = 2
	c6b.Size = "sm"
	c6b.IconStyle = "star-2"
	c6b.ActiveColor = xui.Color_RGB(251, 146, 60)
	c6b.Tag = "size-sm"
	y = y + 40dip

	' md
	Dim c6c As B4XDaisyRating
	c6c.Initialize(Me, "rating6c")
	c6c.AddToParent(pnlHost, PAGE_PAD, y, maxW, 36dip)
	c6c.Value = 2
	c6c.Size = "md"
	c6c.IconStyle = "star-2"
	c6c.ActiveColor = xui.Color_RGB(251, 146, 60)
	c6c.Tag = "size-md"
	y = y + 44dip

	' lg
	Dim c6d As B4XDaisyRating
	c6d.Initialize(Me, "rating6d")
	c6d.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
	c6d.Value = 2
	c6d.Size = "lg"
	c6d.IconStyle = "star-2"
	c6d.ActiveColor = xui.Color_RGB(251, 146, 60)
	c6d.Tag = "size-lg"
	y = y + 48dip

	' xl
	Dim c6e As B4XDaisyRating
	c6e.Initialize(Me, "rating6e")
	c6e.AddToParent(pnlHost, PAGE_PAD, y, maxW, 48dip)
	c6e.Value = 2
	c6e.Size = "xl"
	c6e.IconStyle = "star-2"
	c6e.ActiveColor = xui.Color_RGB(251, 146, 60)
	c6e.Tag = "size-xl"
	y = y + 56dip
	' #endregion

	' #region Example 7: with AllowClear (rating-hidden)
	''' Rating with AllowClear enabled — tapping the same value resets to 0 (rating-hidden parity).
	y = AddSectionTitle("With AllowClear (rating-hidden)", y, maxW)
	Dim c7 As B4XDaisyRating
	c7.Initialize(Me, "rating7")
	c7.AddToParent(pnlHost, PAGE_PAD, y, maxW, 48dip)
	c7.Value = 2
	c7.Size = "lg"
	c7.IconStyle = "star-2"
	c7.AllowClear = True
	c7.Tag = "allow-clear"
	y = y + 64dip
	' #endregion

	' #region Example 8: Half stars (rating-half)
	''' Half-star rating (rating-lg rating-half with mask-half-1 / mask-half-2).
	y = AddSectionTitle("Half Stars (rating-half)", y, maxW)
	Dim c8 As B4XDaisyRating
	c8.Initialize(Me, "rating8")
	c8.AddToParent(pnlHost, PAGE_PAD, y, maxW, 48dip)
	c8.Value = 1.5
	c8.Size = "lg"
	c8.Half = True
	c8.IconStyle = "star-2"
	c8.Variant = "success"
	c8.Tag = "half-stars"
	y = y + 64dip
	' #endregion

	' #region Example 9: Interactive feedback
	''' Interactive rating that reports value changes via toast.
	y = AddSectionTitle("Interactive (tap to rate)", y, maxW)
	Dim c9 As B4XDaisyRating
	c9.Initialize(Me, "rating9")
	c9.AddToParent(pnlHost, PAGE_PAD, y, maxW, 48dip)
	c9.Value = 0
	c9.Size = "lg"
	c9.IconStyle = "star-2"
	c9.ActiveColor = xui.Color_RGB(251, 146, 60)
	c9.Tag = "interactive"
	y = y + 64dip
	' #region Example 10: mask-squircle Rating
	''' squircle mask shape rating items.
	y = AddSectionTitle("mask-squircle Rating", y, maxW)
	Dim c10 As B4XDaisyRating
	c10.Initialize(Me, "rating10")
	c10.AddToParent(pnlHost, PAGE_PAD, y, maxW, 48dip)
	c10.Value = 4
	c10.IconStyle = "squircle"
	c10.ActiveColor = xui.Color_RGB(59, 130, 246)
	c10.Tag = "squircle-stars"
	y = y + 64dip
	' #endregion

	' #region Example 11: Variant Colors
	''' Showcase of all DaisyUI theme variant colors.
	y = AddSectionTitle("Variant Colors", y, maxW)
	
	' Neutral
	Dim vNeutral As B4XDaisyRating
	vNeutral.Initialize(Me, "ratingVariant")
	vNeutral.AddToParent(pnlHost, PAGE_PAD, y, maxW, 36dip)
	vNeutral.Value = 1
	vNeutral.Variant = "neutral"
	vNeutral.Tag = "var-neutral"
	y = y + 42dip
	
	' Primary
	Dim vPrimary As B4XDaisyRating
	vPrimary.Initialize(Me, "ratingVariant")
	vPrimary.AddToParent(pnlHost, PAGE_PAD, y, maxW, 36dip)
	vPrimary.Value = 2
	vPrimary.Variant = "primary"
	vPrimary.Tag = "var-primary"
	y = y + 42dip
	
	' Secondary
	Dim vSecondary As B4XDaisyRating
	vSecondary.Initialize(Me, "ratingVariant")
	vSecondary.AddToParent(pnlHost, PAGE_PAD, y, maxW, 36dip)
	vSecondary.Value = 3
	vSecondary.Variant = "secondary"
	vSecondary.Tag = "var-secondary"
	y = y + 42dip
	
	' Accent
	Dim vAccent As B4XDaisyRating
	vAccent.Initialize(Me, "ratingVariant")
	vAccent.AddToParent(pnlHost, PAGE_PAD, y, maxW, 36dip)
	vAccent.Value = 4
	vAccent.Variant = "accent"
	vAccent.Tag = "var-accent"
	y = y + 42dip
	
	' Info
	Dim vInfo As B4XDaisyRating
	vInfo.Initialize(Me, "ratingVariant")
	vInfo.AddToParent(pnlHost, PAGE_PAD, y, maxW, 36dip)
	vInfo.Value = 5
	vInfo.Variant = "info"
	vInfo.Tag = "var-info"
	y = y + 42dip
	
	' Success
	Dim vSuccess As B4XDaisyRating
	vSuccess.Initialize(Me, "ratingVariant")
	vSuccess.AddToParent(pnlHost, PAGE_PAD, y, maxW, 36dip)
	vSuccess.Value = 4
	vSuccess.Variant = "success"
	vSuccess.Tag = "var-success"
	y = y + 42dip
	
	' Warning
	Dim vWarning As B4XDaisyRating
	vWarning.Initialize(Me, "ratingVariant")
	vWarning.AddToParent(pnlHost, PAGE_PAD, y, maxW, 36dip)
	vWarning.Value = 3
	vWarning.Variant = "warning"
	vWarning.Tag = "var-warning"
	y = y + 42dip
	
	' Error
	Dim vError As B4XDaisyRating
	vError.Initialize(Me, "ratingVariant")
	vError.AddToParent(pnlHost, PAGE_PAD, y, maxW, 36dip)
	vError.Value = 2
	vError.Variant = "error"
	vError.Tag = "var-error"
	y = y + 42dip
	' #endregion

	pnlHost.Height = Max(Height, y + PAGE_PAD)
End Sub

''' <summary>
''' Adds a styled section header using B4XDaisyText.
''' </summary>
Private Sub AddSectionTitle(Text As String, Y As Int, Width As Int) As Int
	Dim title As B4XDaisyText
	title.Initialize(Me, "")
	title.AddToParent(pnlHost, PAGE_PAD, Y, Width, 28dip)
	title.Text = Text
	title.TextColor = xui.Color_RGB(30, 41, 59)
	title.TextSize = 16
	title.FontBold = True
	Return Y + 30dip
End Sub
#End Region

#Region Base Events

Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
	If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
	RenderExamples(Width, Height)
End Sub

''' <summary>
''' Handles Changed events from all rating components.
''' </summary>
Private Sub rating1_Changed(Value As Float)
	#If B4A
	ToastMessageShow("Rating: " & Value, False)
	#End If
End Sub

Private Sub rating2_Changed(Value As Float)
	' Read-only — no interaction expected
End Sub

Private Sub rating3_Changed(Value As Float)
	#If B4A
	ToastMessageShow("Star-2 Orange: " & Value, False)
	#End If
End Sub

Private Sub rating4_Changed(Value As Float)
	#If B4A
	ToastMessageShow("Heart Multi: " & Value, False)
	#End If
End Sub

Private Sub rating5_Changed(Value As Float)
	#If B4A
	ToastMessageShow("Star-2 Green: " & Value, False)
	#End If
End Sub

Private Sub rating6a_Changed(Value As Float)
	#If B4A
	ToastMessageShow("Size XS: " & Value, False)
	#End If
End Sub

Private Sub rating6b_Changed(Value As Float)
	#If B4A
	ToastMessageShow("Size SM: " & Value, False)
	#End If
End Sub

Private Sub rating6c_Changed(Value As Float)
	#If B4A
	ToastMessageShow("Size MD: " & Value, False)
	#End If
End Sub

Private Sub rating6d_Changed(Value As Float)
	#If B4A
	ToastMessageShow("Size LG: " & Value, False)
	#End If
End Sub

Private Sub rating6e_Changed(Value As Float)
	#If B4A
	ToastMessageShow("Size XL: " & Value, False)
	#End If
End Sub

Private Sub rating7_Changed(Value As Float)
	#If B4A
	ToastMessageShow("AllowClear: " & Value, False)
	#End If
End Sub

Private Sub rating8_Changed(Value As Float)
	#If B4A
	ToastMessageShow("Half: " & Value, False)
	#End If
End Sub

Private Sub rating9_Changed(Value As Float)
	#If B4A
	ToastMessageShow("Interactive: " & Value, False)
	#End If
End Sub

Private Sub rating10_Changed(Value As Float)
	#If B4A
	ToastMessageShow("Squircle: " & Value, False)
	#End If
End Sub

Private Sub ratingVariant_Changed(Value As Float)
	#If B4A
	ToastMessageShow("Variant Rating: " & Value, False)
	#End If
End Sub
#End Region