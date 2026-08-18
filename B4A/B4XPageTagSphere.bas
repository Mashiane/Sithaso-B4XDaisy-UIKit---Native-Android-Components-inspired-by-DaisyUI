B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.5
@EndOfDesignText@
#IgnoreWarnings:12, 9

Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private pageScroll As B4XDaisyPageScroll
	Private pnlHost As B4XView

	Private sphere1 As B4XDaisyTagSphere
	Private sphere2 As B4XDaisyTagSphere
	Private sphere3 As B4XDaisyTagSphere
	Private sphere4 As B4XDaisyTagSphere
	Private sphere5 As B4XDaisyTagSphere

	Private sbRadius As B4XDaisyRange
	Private sbSensitivity As B4XDaisyRange
	Private cbRotateOnTouch As B4XDaisyToggle
	Private cbAutoRotate As B4XDaisyToggle
	Private segEasing As B4XDaisySegment
	Private lblEvent As B4XDaisyText
	Private lblRadius As B4XDaisyText
	Private lblSensitivity As B4XDaisyText
	Private btnEmoji As B4XDaisyButton
	Private btnReset As B4XDaisyButton
	Private btnShuffle As B4XDaisyButton
	Private toast As B4XDaisyToast
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
	Root = Root1
	Root.Color = B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(245, 247, 250))
	pageScroll.Initialize(Me, "pageScroll")
	pageScroll.AddToParent(Root, 0, 0, Root.Width, Root.Height)
	pnlHost = pageScroll.Panel
	toast.Initialize(Me, "toast")
	toast.setVerticalAlignment("top")
	toast.setHorizontalAlignment("center")
	Dim y As Int = pageScroll.PagePadding
	y = BuildPlayground(y)
	y = BuildShowcase1(y)
	y = BuildShowcase2(y)
	y = BuildShowcase3(y)
	y = BuildShowcase4(y)
	pageScroll.AutoFit
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
	If Width <= 0 Or Height <= 0 Then Return
	If pageScroll.IsInitialized Then pageScroll.Base_Resize(Width, Height)
End Sub

Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

#Region 1 - Playground
Private Sub BuildPlayground(YStart As Int) As Int
	Dim maxW As Int = pageScroll.UsableWidth
	Dim pad As Int = pageScroll.PagePadding
	Dim gap As Int = pageScroll.YGap
	Dim y As Int = YStart

	y = pageScroll.AddSectionTitle("1. Playground - 24 emoji, sliders, easings", y, False)

	sphere1.Initialize(Me, "sphere1")
	sphere1.AddToParent(pnlHost, pad, y, maxW, 340dip)
	sphere1.setRadius(1.5)
	sphere1.setSensitivity(11)
	sphere1.setAutoRotate(True)
	sphere1.setAutoSpeed(0.3)
	sphere1.setEasing("easeout")
	sphere1.setTextSize(18)
	sphere1.setItems(EmojiList(24))
	y = y + 340dip + gap

	Dim labelW As Int = 110dip
	Dim sliderW As Int = maxW - labelW - gap

	lblRadius.Initialize(Me, "lblRadius")
	lblRadius.AddToParent(pnlHost, pad, y, labelW, 32dip)
	lblRadius.setText("Radius: 1.5")
	lblRadius.setTextColor(0xFF374151)
	lblRadius.setHAlign("left")
	lblRadius.setVAlign("middle")
	sbRadius.Initialize(Me, "sbRadius")
	sbRadius.AddToParent(pnlHost, pad + labelW + gap, y, sliderW, 32dip)
	sbRadius.setMinValue(10)
	sbRadius.setMaxValue(100)
	sbRadius.setValue(15)
	y = y + 32dip + 4dip

	lblSensitivity.Initialize(Me, "lblSensitivity")
	lblSensitivity.AddToParent(pnlHost, pad, y, labelW, 32dip)
	lblSensitivity.setText("Sensitivity: 11")
	lblSensitivity.setTextColor(0xFF374151)
	lblSensitivity.setHAlign("left")
	lblSensitivity.setVAlign("middle")
	sbSensitivity.Initialize(Me, "sbSensitivity")
	sbSensitivity.AddToParent(pnlHost, pad + labelW + gap, y, sliderW, 32dip)
	sbSensitivity.setMinValue(1)
	sbSensitivity.setMaxValue(100)
	sbSensitivity.setValue(11)
	y = y + 32dip + 4dip

	Dim halfW As Int = (maxW - gap) / 2
	cbRotateOnTouch.Initialize(Me, "cbRotateOnTouch")
	cbRotateOnTouch.AddToParent(pnlHost, pad, y, halfW, 32dip)
	cbRotateOnTouch.setText("Rotate on touch")
	cbRotateOnTouch.setChecked(True)
	cbAutoRotate.Initialize(Me, "cbAutoRotate")
	cbAutoRotate.AddToParent(pnlHost, pad + halfW + gap, y, halfW, 32dip)
	cbAutoRotate.setText("Auto rotate")
	cbAutoRotate.setChecked(True)
	y = y + 32dip + 8dip

	segEasing.Initialize(Me, "segEasing")
	segEasing.AddToParent(pnlHost, pad, y, maxW, 36dip)
	segEasing.AddButton("none", "None", "")
	segEasing.AddButton("easeoutexpo", "OutExpo", "")
	segEasing.AddButton("easeinexpo", "InExpo", "")
	segEasing.AddButton("reversequint", "RevQuint", "")
	y = y + 36dip + 4dip

	lblEvent.Initialize(Me, "lblEvent")
	lblEvent.AddToParent(pnlHost, pad, y, maxW, 24dip)
	lblEvent.setText("Tap a tag. Long-press a tag to delete it.")
	y = y + 24dip + gap

	Dim btnW As Int = (maxW - 2 * gap) / 3
	btnEmoji.Initialize(Me, "btnEmoji")
	btnEmoji.AddToParent(pnlHost, pad, y, btnW, 36dip)
	btnEmoji.setText("New emoji")
	btnEmoji.setVariant("primary")

	btnShuffle.Initialize(Me, "btnShuffle")
	btnShuffle.AddToParent(pnlHost, pad + btnW + gap, y, btnW, 36dip)
	btnShuffle.setText("Shuffle")
	btnShuffle.setVariant("secondary")

	btnReset.Initialize(Me, "btnReset")
	btnReset.AddToParent(pnlHost, pad + 2 * (btnW + gap), y, btnW, 36dip)
	btnReset.setText("Reset")
	btnReset.setVariant("ghost")
	Return y + 36dip + gap
End Sub
#End Region

#Region 2 - Showcase1 (20 Tech Tags - Original Demo)
Private Sub BuildShowcase1(YStart As Int) As Int
	Dim maxW As Int = pageScroll.UsableWidth
	Dim pad As Int = pageScroll.PagePadding
	Dim gap As Int = pageScroll.YGap
	Dim y As Int = YStart
	y = pageScroll.AddSectionTitle("2. Showcase1 - 20 Tech Tags (Original Demo)", y, False)
	sphere2.Initialize(Me, "sphere2")
	sphere2.AddToParent(pnlHost, pad, y, maxW, 320dip)
	sphere2.setRadius(1.5)
	sphere2.setSensitivity(11)
	sphere2.setAutoRotate(True)
	sphere2.setAutoSpeed(0.3)
	sphere2.setTextSize(15)
	sphere2.setTextColor(0xFF374151)
	sphere2.setItems(TechTagsList)
	Return y + 320dip + gap
End Sub
#End Region

#Region 3 - Showcase2 (250 dots, custom draw)
Private Sub BuildShowcase2(YStart As Int) As Int
	Dim maxW As Int = pageScroll.UsableWidth
	Dim pad As Int = pageScroll.PagePadding
	Dim gap As Int = pageScroll.YGap
	Dim y As Int = YStart
	y = pageScroll.AddSectionTitle("3. Showcase2 - 250 custom dots (DrawTag)", y, False)
	sphere3.Initialize(Me, "sphere3")
	sphere3.AddToParent(pnlHost, pad, y, maxW, 320dip)
	sphere3.setRadius(1.5)
	sphere3.setSensitivity(11)
	sphere3.setAutoRotate(True)
	sphere3.setAutoSpeed(-0.4)
	sphere3.setEasing("easeout")
	sphere3.setTextSize(2)
	Dim lst As List
	lst.Initialize
	For i = 0 To 249
		lst.Add(IIf(i Mod 2 = 0, ".", "o"))
	Next
	sphere3.setItems(lst)
	Return y + 320dip + gap
End Sub
#End Region

#Region 4 - Showcase3 (25 icons, custom draw)
Private Sub BuildShowcase3(YStart As Int) As Int
	Dim maxW As Int = pageScroll.UsableWidth
	Dim pad As Int = pageScroll.PagePadding
	Dim gap As Int = pageScroll.YGap
	Dim y As Int = YStart
	y = pageScroll.AddSectionTitle("4. Showcase3 - 25 icons (DrawTag)", y, False)
	sphere4.Initialize(Me, "sphere4")
	sphere4.AddToParent(pnlHost, pad, y, maxW, 320dip)
	sphere4.setRadius(1.5)
	sphere4.setSensitivity(11)
	sphere4.setAutoRotate(True)
	sphere4.setAutoSpeed(0.25)
	sphere4.setEasing("easeout")
	sphere4.setTextSize(2)
	Dim lst As List
	lst.Initialize
	Dim icons As List = Array("🌀", "🌁", "🌃", "🌄", "🌅", "🌆", "🌇", "🌈", "🌉", "🌊", "🌋", "🌌", "🌍", "🌎", "🌏", "🌐", "🌑", "🌒", "🌓", "🌔", "🌕", "🌖", "🌗", "🌘", "🌙")
	For i = 0 To icons.Size - 1
		lst.Add(icons.Get(i))
	Next
	sphere4.setItems(lst)
	Return y + 320dip + gap
End Sub
#End Region

#Region 5 - Showcase4 (17 Avatar Images)
Private Sub BuildShowcase4(YStart As Int) As Int
	Dim maxW As Int = pageScroll.UsableWidth
	Dim pad As Int = pageScroll.PagePadding
	Dim gap As Int = pageScroll.YGap
	Dim y As Int = YStart
	y = pageScroll.AddSectionTitle("5. Showcase4 - 17 Avatar Images (Custom Sizes)", y, False)
	sphere5.Initialize(Me, "sphere5")
	sphere5.AddToParent(pnlHost, pad, y, maxW, 320dip)
	sphere5.setRadius(1.5)
	sphere5.setSensitivity(11)
	sphere5.setAutoRotate(True)
	sphere5.setAutoSpeed(0.3)
	sphere5.setEasing("easeout")
	sphere5.setImageSize(44dip, 44dip)
	sphere5.setCircularAvatars(True)
	sphere5.setAvatarBorderWidth(2dip)
	sphere5.setAvatarBorderColor(0xFFFFFFFF)
	
	Dim files As List = Array("face_1.jpg", "face_2.jpg", "face_3.jpg", "face_8.jpg", "face11.jpg", "face12.jpg", "face14.jpg", "face16.jpg", "face17.jpg", "face18.jpg", "face19.jpg", "face21.jpg", "face22.jpg", "face24.jpg", "face27.jpg", "face_anna.jpg", "face_marcus.jpg")
	Dim bmps As List
	bmps.Initialize
	For Each fname As String In files
		Try
			Dim b As B4XBitmap = xui.LoadBitmapResize(File.DirAssets, fname, 88dip, 88dip, True)
			bmps.Add(b)
		Catch
		End Try
	Next
	sphere5.setBitmaps(bmps)
	Return y + 320dip + gap
End Sub
#End Region

#Region Data
Private Sub EmojiList(Count As Int) As List
	Dim base As List
	base.Initialize
	base.AddAll(Array("😀", "😃", "😄", "😁", "😆", "😅", "😂", "🤣", "😊", "😇", _
		"🙂", "🙃", "😉", "😌", "😍", "🥰", "😘", "😗", "😙", "😚", _
		"😋", "😛", "😝", "😜", "🤪", "🤨", "🧐", "🤓", "😎", "🤩", _
		"🥳", "😏", "😒", "😞", "😔", "😟", "😕", "🙁", "😣", "😖", _
		"😫", "😩", "🥺", "😢", "😭", "😤", "😠", "😡", "🤬", "🤯", _
		"😳", "🥵", "🥶", "😱", "😨", "😰", "😥", "😓", "🤗", "🤔", _
		"🤭", "🤫", "🤥", "😶", "😐", "😑", "😬", "🙄", "😯", "😦", _
		"😧", "😮", "😲", "🥱", "😴", "🤤", "😪", "😵", "🤐", "🥴", _
		"🤢", "🤮", "🤧", "😷", "🤒", "🤕", "🤑", "🤠", "😈", "👿", _
		"👹", "👺", "🤡", "💩", "👻", "💀", "☠", "👽", "👾", "🤖"))
	Dim out As List
	out.Initialize
	For i = 0 To Count - 1
		out.Add(base.Get(Rnd(0, base.Size - 1)))
	Next
	Return out
End Sub

Private Sub LoremList(Count As Int) As List
	Dim s As String = "Lorem ipsum dolor sit amet consectetur adipiscing elit Aenean rutrum mollis interdum Donec imperdiet condimentum faucibus Aliquam vel ex pulvinar consectetur mi ac scelerisque lorem Suspendisse sit amet bibendum orci In quis nisl dapibus faucibus tellus sit amet venenatis lorem Donec luctus luctus ultrices In tellus diam gravida vitae pellentesque et tristique eu nisl Donec pretium erat sed augue lobortis consectetur Quisque et eleifend tortor Ut blandit fermentum cursus Aliquam at rhoncus nisi et consectetur est Quisque malesuada est leo in cursus magna consectetur at Cras et volutpat justo Vestibulum condimentum dictum molestie Phasellus aliquam diam sed interdum commodo diam purus egestas massa in dictum tortor erat quis dolor Donec dapibus dolor quis mi commodo finibus Vivamus fermentum tellus nulla iaculis pharetra urna elementum in"
	Dim words() As String = Regex.Split(" ", s)
	Dim out As List
	out.Initialize
	For i = 0 To Count - 1
		out.Add(words(Rnd(0, words.Length - 1)))
	Next
	Return out
End Sub

Private Sub TechTagsList As List
	Dim out As List
	out.Initialize
	out.AddAll(Array("HTML", "CSS", "JavaScript", "Java", "Python", "C++", "React", "Vue", "Node", "Express", "MongoDB", "SQL", "Git", "GitHub", "Flutter", "Dart", "Swift", "Kotlin", "Rust", "Go"))
	Return out
End Sub
#End Region

#Region Events
Private Sub sbRadius_Changed(Value As Int)
	sphere1.setRadius(Value / 10.0)
	lblRadius.setText("Radius: " & NumberFormat2(Value / 10.0, 1, 1, 1, False))
End Sub

Private Sub sbSensitivity_Changed(Value As Int)
	sphere1.setSensitivity(Value)
	lblSensitivity.setText("Sensitivity: " & Value)
End Sub

Private Sub cbRotateOnTouch_Checked(Checked As Boolean)
	sphere1.setRotateOnTouch(Checked)
	If Checked And sphere1.getAutoRotate Then
		cbAutoRotate.setChecked(False)
	End If
End Sub

Private Sub cbAutoRotate_Checked(Checked As Boolean)
	sphere1.setAutoRotate(Checked)
	If Checked Then
		cbRotateOnTouch.setChecked(False)
	End If
End Sub

Private Sub segEasing_Changed(Value As String)
	sphere1.setEasing(Value)
End Sub

Private Sub btnEmoji_Click(Tag As Object)
	sphere1.setItems(EmojiList(24))
	lblEvent.setText("New emoji set.")
End Sub

Private Sub btnShuffle_Click(Tag As Object)
	sphere1.AddRotation(Rnd(-15, 15), Rnd(-15, 15))
End Sub

Private Sub btnReset_Click(Tag As Object)
	sphere1.setRadius(1.5)
	sphere1.setSensitivity(11)
	sphere1.setAutoRotate(True)
	sphere1.setRotateOnTouch(True)
	sphere1.setEasing("easeout")
	sbRadius.setValue(15)
	sbSensitivity.setValue(11)
	cbRotateOnTouch.setChecked(True)
	cbAutoRotate.setChecked(True)
End Sub

Private Sub sphere1_TagTap(Tag As String)
	lblEvent.setText("Tap: " & Tag)
End Sub

Private Sub sphere1_TagLongPress(Tag As String)
	sphere1.removeTag(Tag)
	lblEvent.setText("Deleted: " & Tag)
End Sub

Private Sub sphere2_TagTap(Tag As String)
	ShowToast("Lorem: " & Tag)
End Sub

Private Sub sphere2_TagLongPress(Tag As String)
	ShowToast("LongPress: " & Tag)
End Sub

Private Sub sphere3_TagTap(Tag As String)
	ShowToast("Dot tap: " & Tag)
End Sub

Private Sub sphere3_TagLongPress(Tag As String)
	ShowToast("Dot long: " & Tag)
End Sub

Private Sub sphere4_TagTap(Tag As String)
	ShowToast("Icon tap: " & Tag)
End Sub

Private Sub sphere4_TagLongPress(Tag As String)
	ShowToast("Icon long: " & Tag)
End Sub

Private Sub sphere5_TagTap(Tag As String)
	ShowToast("Avatar tapped!")
End Sub

Private Sub sphere5_TagLongPress(Tag As String)
	ShowToast("Avatar long press!")
End Sub
#End Region

#Region Custom DrawTag handlers
Private Sub sphere3_DrawTag(Info As Map)
	Dim Canvas As B4XCanvas = Info.Get("Canvas")
	Dim X As Float = Info.Get("X")
	Dim Y As Float = Info.Get("Y")
	Dim Alpha As Int = Info.Get("Alpha")
	Dim Index As Int = Info.Get("Index")
	Dim col As Int
	If Index Mod 2 = 0 Then
		col = xui.Color_ARGB(Alpha, 99, 102, 241)
	Else
		col = xui.Color_ARGB(Alpha, 236, 72, 153)
	End If
	Dim r As Float = 4dip + (Alpha / 255.0) * 6dip
	Canvas.DrawCircle(X, Y, r, col, True, 0)
End Sub

Private Sub sphere4_DrawTag(Info As Map)
	Dim Canvas As B4XCanvas = Info.Get("Canvas")
	Dim X As Float = Info.Get("X")
	Dim Y As Float = Info.Get("Y")
	Dim Alpha As Int = Info.Get("Alpha")
	Dim Index As Int = Info.Get("Index")
	Dim hue As Int = (Index * 14) Mod 360
	Dim col As Int = B4XDaisyVariants.HSLToInt(hue, 0.65, 0.5, Alpha)
	Canvas.DrawCircle(X, Y, 10dip, col, False, 2dip)
	Dim inner As Int = B4XDaisyVariants.HSLToInt(hue, 0.8, 0.7, Alpha)
	Canvas.DrawCircle(X, Y, 4dip, inner, True, 0)
End Sub
#End Region

#Region Toast
Private Sub ShowToast(Msg As String)
	toast.Info(Msg)
End Sub

Private Sub toast_NotificationClosed(View As B4XView)
End Sub
#End Region
