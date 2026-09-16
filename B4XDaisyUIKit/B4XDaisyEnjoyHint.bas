B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.5
@EndOfDesignText@
#IgnoreWarnings:12,9
Sub Class_Globals
	Private xui As XUI
	Private mRoot As B4XView
	Private mCallBack As Object
	Private mEventName As String
		' UI Elements
	Private pnlOverlay As B4XView
	Private cvsOverlay As B4XCanvas
	Private lblMessage As B4XView
		' 100% Parity Action Buttons
	Private btnNext As B4XView
	Private btnSkip As B4XView
	Private btnPrev As B4XView
	Private btnClose As B4XDaisySvgIcon ' Using your framework's SVG icon for the top-right X
		' Configurable Options (EnjoyHint Parity)
	Public BtnNextText As String = "Next"
	Public BtnSkipText As String = "Skip"
	Public BtnPrevText As String = "Previous"
	Public BtnFinishText As String = "Finish"
	' Corner radius (dip) for the rectangular spotlight cut-out. 0 = sharp corners.
	Public RectCornerRadius As Int = 12dip
		' Scenario & State Management
	Type EnjoyHintStep (TargetView As B4XView, Message As String, Shape As String, Margin As Int, TimeoutMs As Int, ShowNext As Boolean, ShowSkip As Boolean, ShowPrev As Boolean, CloseOnOverlay As Boolean, ExplicitLeft As Int, ExplicitTop As Int, ExplicitRight As Int, ExplicitBottom As Int, PositionMode As String, ShadowColor As Int, Opacity As Float, ArrowPosition As String)
	Private mSteps As List
	Private mCurrentIndex As Int = 0
	Private mFirstStep As Boolean
		' Animations & Colors
	Private Anim As B4XDaisyAnimation
	Private OverlayColor As Int = xui.Color_ARGB(180, 0, 0, 0)
	Private ThemeColor As Int = xui.Color_RGB(30, 205, 151) ' Extracted from jquery.enjoyhint.css
		Private mFont As B4XFont
	' Auto-advance timer
	Private Timer1 As Timer
End Sub
Public Sub Initialize (oCallback As Object, sEventName As String, vRoot As B4XView)
	mCallBack = oCallback
	mEventName = sEventName
	mRoot = vRoot
	mSteps.Initialize
	mCurrentIndex = 0
	Anim.Initialize
	Timer1.Initialize("Timer1", 0)
	RectCornerRadius = B4XDaisyVariants.GetRadiusFieldDip(6dip)
		Try
		#If B4A
		mFont = xui.CreateFont(Typeface.LoadFromAssets("Casino_Hand.ttf"), 24)
		#Else If B4i
		mFont = xui.CreateFont(Font.CreateNew2("Casino Hand", 24), 24)
		#End If
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyEnjoyHint.Initialize: " & LastException.Message)
		mFont = xui.CreateDefaultBoldFont(24)
	End Try
		Try
		CreateUI
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyEnjoyHint.Initialize: " & LastException.Message)
	End Try
End Sub
Private Sub CreateUI
	Try
		Dim p As Panel
		p.Initialize("OverlayClick")
		pnlOverlay = p
		pnlOverlay.Color = xui.Color_Transparent
		pnlOverlay.SetLayoutAnimated(0, 0, 0, mRoot.Width, mRoot.Height)
		cvsOverlay.Initialize(pnlOverlay)
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyEnjoyHint.CreateUI: " & LastException.Message)
		Return
	End Try
		Try
		Dim l As Label
		l.Initialize("")
		lblMessage = l
		lblMessage.Font = mFont
		lblMessage.TextColor = xui.Color_White
		lblMessage.SetTextAlignment("CENTER", "CENTER")
		lblMessage.As(Label).SingleLine = False
		pnlOverlay.AddView(lblMessage, 0, 0, 0, 0)
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyEnjoyHint.CreateUI: " & LastException.Message)
	End Try
		Try
		' Create all 4 buttons required by jquery.enjoyhint.css
		btnNext = CreateActionBtn("Next")
		btnSkip = CreateActionBtn("Skip")
		btnPrev = CreateActionBtn("Previous")
		pnlOverlay.AddView(btnNext, 0, 0, 100dip, 40dip)
		pnlOverlay.AddView(btnSkip, 0, 0, 100dip, 40dip)
		pnlOverlay.AddView(btnPrev, 0, 0, 100dip, 40dip)
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyEnjoyHint.CreateUI: " & LastException.Message)
	End Try
		Try
		' Use B4XDaisySvgIcon for the Close Button (.enjoyhint_close_btn parity)
		btnClose.Initialize(Me, "closebtn")
		Dim closeView As B4XView = btnClose.AddToParent(pnlOverlay, 0, 0, 30dip, 30dip)
		btnClose.setSvgAsset("xmark-solid.svg")
		btnClose.setColor(xui.Color_White)
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyEnjoyHint.CreateUI: " & LastException.Message)
	End Try
End Sub
Private Sub CreateActionBtn(sEventPrefix As String) As B4XView
	Dim l As Label
	l.Initialize(sEventPrefix.ToLowerCase & "btn")
	Dim btn As B4XView = l
	btn.Font = xui.CreateDefaultBoldFont(17)
	btn.TextColor = ThemeColor
	btn.SetTextAlignment("CENTER", "CENTER")
	btn.SetColorAndBorder(xui.Color_Transparent, 2dip, ThemeColor, 40dip)
	Dim jo As JavaObject = l
	jo.RunMethod("setPadding", Array(10dip, 4dip, 10dip, 4dip))
	Return btn
End Sub
Private Sub MeasureTextWidth(sText As String) As Int
	Dim fnt As B4XFont = xui.CreateDefaultBoldFont(17)
	Return B4XDaisyVariants.MeasureTextWidthSafe(sText, fnt.Size, fnt.ToNativeFont, 4dip)
End Sub
Public Sub AddStep(vTarget As B4XView, sMessage As String, sShape As String, iMargin As Int, iTimeoutMs As Int, sArrowPosition As String)
	Dim stepObj As EnjoyHintStep
	stepObj.Initialize
	stepObj.TargetView = vTarget
	stepObj.Message = sMessage
	stepObj.Shape = sShape ' "rect" or "circle"
	stepObj.Margin = iMargin
	stepObj.TimeoutMs = iTimeoutMs
	stepObj.ShowNext = True
	stepObj.ShowSkip = True
	stepObj.ShowPrev = True
	stepObj.CloseOnOverlay = False
	stepObj.ExplicitLeft = -1
	stepObj.ExplicitTop = -1
	stepObj.ExplicitRight = -1
	stepObj.ExplicitBottom = -1
	stepObj.PositionMode = "auto"
	stepObj.ShadowColor = xui.Color_ARGB(180, 0, 0, 0)
	stepObj.Opacity = 0.7
	stepObj.ArrowPosition = sArrowPosition
	mSteps.Add(stepObj)
End Sub
Public Sub AddStep2(vTarget As B4XView, sMessage As String, sShape As String, iMargin As Int, iTimeoutMs As Int, bShowNext As Boolean, bShowSkip As Boolean, bShowPrev As Boolean, bCloseOnOverlay As Boolean, iExplicitLeft As Int, iExplicitTop As Int, iExplicitRight As Int, iExplicitBottom As Int, sPositionMode As String, iShadowColor As Int, fOpacity As Float, sArrowPosition As String)
	Dim stepObj As EnjoyHintStep
	stepObj.Initialize
	stepObj.TargetView = vTarget
	stepObj.Message = sMessage
	stepObj.Shape = sShape
	stepObj.Margin = iMargin
	stepObj.TimeoutMs = iTimeoutMs
	stepObj.ShowNext = bShowNext
	stepObj.ShowSkip = bShowSkip
	stepObj.ShowPrev = bShowPrev
	stepObj.CloseOnOverlay = bCloseOnOverlay
	stepObj.ExplicitLeft = iExplicitLeft
	stepObj.ExplicitTop = iExplicitTop
	stepObj.ExplicitRight = iExplicitRight
	stepObj.ExplicitBottom = iExplicitBottom
	stepObj.PositionMode = sPositionMode
	stepObj.ShadowColor = iShadowColor
	stepObj.Opacity = fOpacity
	stepObj.ArrowPosition = sArrowPosition
	mSteps.Add(stepObj)
End Sub
Public Sub RunWithResume
	If File.Exists(File.DirInternal, "enjoyhint_state.txt") Then
		Dim savedIndex As String = File.ReadString(File.DirInternal, "enjoyhint_state.txt")
		If IsNumber(savedIndex) Then mCurrentIndex = savedIndex
	Else
		mCurrentIndex = 0
	End If
	If mCurrentIndex >= mSteps.Size Then mCurrentIndex = 0
	RunStep(mCurrentIndex)
End Sub
Private Sub RunStep(iIndex As Int)
	Timer1.Enabled = False
	If iIndex >= mSteps.Size Then
		EndTour
		Return
	End If
	mCurrentIndex = iIndex
	Dim currentStep As EnjoyHintStep = mSteps.Get(iIndex)
	' Remember whether this is the first step of the tour (overlay just added).
	Dim wasJustAdded As Boolean = (pnlOverlay.Parent.IsInitialized = False)
	If wasJustAdded Then
		Try
			mRoot.AddView(pnlOverlay, 0, 0, mRoot.Width, mRoot.Height)
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisyEnjoyHint.RunStep: " & LastException.Message)
		End Try
	End If
	mFirstStep = wasJustAdded
	' Keep the dark overlay visible during the transition (NO transparent flash).
	' Fill the old spotlight hole so we don't see a stale hole while the content scrolls.
	Try
		cvsOverlay.ClearRect(cvsOverlay.TargetRect)
		cvsOverlay.DrawRect(cvsOverlay.TargetRect, currentStep.ShadowColor, True, 0)
		cvsOverlay.Invalidate
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyEnjoyHint.RunStep: " & LastException.Message)
	End Try
	' Hide labels/buttons only on the very first step (they start at default
	' positions). On later steps keep them visible and update them in place.
	If wasJustAdded Then
		lblMessage.Visible = False
		btnNext.Visible = False
		btnSkip.Visible = False
		btnPrev.Visible = False
		btnClose.View.Visible = False
	End If
	Try
		ScrollToView(currentStep.TargetView)
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyEnjoyHint.RunStep: " & LastException.Message)
	End Try
	Sleep(100)
	Recalc
	pnlOverlay.Visible = True
	Try
		DrawSpotlightAndArrow(currentStep)
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyEnjoyHint.RunStep: " & LastException.Message)
	End Try
	If currentStep.TimeoutMs > 0 Then
		Timer1.Interval = currentStep.TimeoutMs
		Timer1.Enabled = True
	End If
	File.WriteString(File.DirInternal, "enjoyhint_state.txt", iIndex)
End Sub
Private Sub DrawSpotlightAndArrow(StepObj As EnjoyHintStep)
	Dim tRect As B4XRect
	Try
		tRect = GetAbsoluteRect(StepObj.TargetView)
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyEnjoyHint.DrawSpotlightAndArrow: " & LastException.Message)
		Return
	End Try
	Dim m As Int = StepObj.Margin
	' Clear + redraw the dark overlay in ONE pass (no Invalidate here) so the
	' transparent state is never shown. The final Invalidate shows the new frame.
	Try
		cvsOverlay.ClearRect(cvsOverlay.TargetRect)
		cvsOverlay.DrawRect(cvsOverlay.TargetRect, StepObj.ShadowColor, True, 0)
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyEnjoyHint.DrawSpotlightAndArrow: " & LastException.Message)
	End Try
	Dim spotRect As B4XRect
	spotRect.Initialize(tRect.Left - m, tRect.Top - m, tRect.Right + m, tRect.Bottom + m)
	If StepObj.Shape.ToLowerCase = "circle" Then
		Dim radius As Float = Max(spotRect.Width, spotRect.Height) / 2
		Dim cx As Float = spotRect.Left + spotRect.Width / 2
		Dim cy As Float = spotRect.Top + spotRect.Height / 2
		#If B4A
		Try
			Dim jo As JavaObject = cvsOverlay
			Dim cvsObj As JavaObject = jo.GetField("cvs")
			Dim canvas As JavaObject = cvsObj.GetField("canvas")
			Dim paint As JavaObject = cvsObj.GetField("paint")
			paint.RunMethod("setAntiAlias", Array(True))
			Dim dstOut As JavaObject
			dstOut.InitializeStatic("android.graphics.PorterDuff.Mode")
			dstOut = dstOut.GetField("DST_OUT")
			Dim xfer As JavaObject
			xfer.InitializeNewInstance("android.graphics.PorterDuffXfermode", Array(dstOut))
			paint.RunMethod("setXfermode", Array(xfer))
			paint.RunMethod("setColor", Array(xui.Color_RGB(0, 0, 0)))
			canvas.RunMethod("drawCircle", Array(cx, cy, radius, paint))
			paint.RunMethod("setXfermode", Array(Null))
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisyEnjoyHint.DrawSpotlightAndArrow: " & LastException.Message)
		End Try
		#Else If B4i
		cvsOverlay.ClearRect(spotRect)
		#End If
	Else
		' Rectangular spotlight with rounded corners (cut out via DST_OUT).
		#If B4A
		Try
			Dim joR As JavaObject = cvsOverlay
			Dim cvsObjR As JavaObject = joR.GetField("cvs")
			Dim canvasR As JavaObject = cvsObjR.GetField("canvas")
			Dim paintR As JavaObject = cvsObjR.GetField("paint")
			paintR.RunMethod("setAntiAlias", Array(True))
			Dim dstOutR As JavaObject
			dstOutR.InitializeStatic("android.graphics.PorterDuff.Mode")
			dstOutR = dstOutR.GetField("DST_OUT")
			Dim xferR As JavaObject
			xferR.InitializeNewInstance("android.graphics.PorterDuffXfermode", Array(dstOutR))
			paintR.RunMethod("setXfermode", Array(xferR))
			Dim rectF As JavaObject
			rectF.InitializeNewInstance("android.graphics.RectF", Array(spotRect.Left, spotRect.Top, spotRect.Right, spotRect.Bottom))
			Dim radF As Float = RectCornerRadius
			paintR.RunMethod("setColor", Array(xui.Color_RGB(0, 0, 0)))
			canvasR.RunMethod("drawRoundRect", Array(rectF, radF, radF, paintR))
			paintR.RunMethod("setXfermode", Array(Null))
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisyEnjoyHint.DrawSpotlightAndArrow: " & LastException.Message)
			cvsOverlay.ClearRect(spotRect)
		End Try
		#Else
		cvsOverlay.ClearRect(spotRect)
		#End If
	End If
	Try
		LayoutInteractiveHints(spotRect, StepObj)
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyEnjoyHint.DrawSpotlightAndArrow: " & LastException.Message)
	End Try
	Try
		DrawKineticArrow(spotRect, StepObj.ArrowPosition)
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyEnjoyHint.DrawSpotlightAndArrow: " & LastException.Message)
	End Try
	Try
		cvsOverlay.Invalidate
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyEnjoyHint.DrawSpotlightAndArrow: " & LastException.Message)
	End Try
	lblMessage.Visible = True
	btnClose.View.Visible = True
	' Fade the label in only on the first step; on later steps it stays visible
	' (no hide/show), so a fade-in would be redundant / cause a re-fade flicker.
	If mFirstStep Then
		Try
			Anim.AnimateFadeDirectional(lblMessage, "in", "up", 20dip, 400)
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisyEnjoyHint.DrawSpotlightAndArrow: " & LastException.Message)
		End Try
	End If
	Try
		Anim.AnimatePulse(StepObj.TargetView, 800)
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyEnjoyHint.DrawSpotlightAndArrow: " & LastException.Message)
	End Try
End Sub
Private Sub LayoutInteractiveHints(rcSpot As B4XRect, StepObj As EnjoyHintStep)
	Dim screenW As Int = pnlOverlay.Width
	Dim screenH As Int = pnlOverlay.Height
		lblMessage.Text = StepObj.Message
	Dim maxLabelW As Int = screenW * 0.80
	Dim lblTop, lblLeft As Int
		If StepObj.PositionMode = "explicit" And StepObj.ExplicitLeft >= 0 And StepObj.ExplicitTop >= 0 Then
		lblLeft = StepObj.ExplicitLeft
		lblTop = StepObj.ExplicitTop
		If StepObj.ExplicitRight >= 0 Then maxLabelW = StepObj.ExplicitRight - StepObj.ExplicitLeft
		If StepObj.ExplicitBottom >= 0 Then
			' use explicit bounds
		End If
	Else
		If rcSpot.Top > screenH / 2 Then
			lblTop = rcSpot.Top - 150dip
		Else
			lblTop = rcSpot.Bottom + 50dip
		End If
		lblLeft = (screenW - maxLabelW) / 2
	End If
	lblMessage.SetLayoutAnimated(0, lblLeft, lblTop, maxLabelW, 80dip)
		' Detect a down-pointing arrow (label above the spotlight) so we can place
	' the button row ABOVE the label: Buttons -> Hint Label -> Component.
	Dim downArrow As Boolean = lblTop < rcSpot.Top
		' Position navigation buttons relative to hint text
	Dim btnHW As Int = 35dip
	Dim btnRowTop As Int
	If downArrow Then
		' Down arrow: buttons sit above the label (10dip gap above label top).
		btnRowTop = lblTop - btnHW - 10dip
	Else
		' Up arrow: keep buttons below the label (current behaviour).
		btnRowTop = lblTop + 90dip
		If btnRowTop > screenH - 50dip Then btnRowTop = lblTop - 50dip
	End If
	btnRowTop = Max(10dip, btnRowTop)
		Dim gap As Int = 8dip
	Dim btnCenter As Int = lblLeft + maxLabelW / 2
		Dim skipW As Int = 0
	Dim prevW As Int = 0
	Dim nextW As Int = 0
	If StepObj.ShowSkip Then skipW = MeasureTextWidth(BtnSkipText) + 20dip
	If mCurrentIndex > 0 And StepObj.ShowPrev Then prevW = MeasureTextWidth(BtnPrevText) + 20dip
	If StepObj.ShowNext Then nextW = MeasureTextWidth(IIf(mCurrentIndex = mSteps.Size - 1, BtnFinishText, BtnNextText)) + 20dip
		Dim totalW As Int = skipW + prevW + nextW
	Dim vc As Int = 0
	If skipW > 0 Then vc = vc + 1
	If prevW > 0 Then vc = vc + 1
	If nextW > 0 Then vc = vc + 1
	If vc > 1 Then totalW = totalW + gap * (vc - 1)
		Dim bx As Int = btnCenter - totalW / 2
		btnSkip.Visible = StepObj.ShowSkip
	If btnSkip.Visible Then
		btnSkip.Text = BtnSkipText
		btnSkip.SetLayoutAnimated(0, bx, btnRowTop, skipW, btnHW)
		bx = bx + skipW + gap
	End If
	If mCurrentIndex > 0 And StepObj.ShowPrev Then
		btnPrev.Visible = True
		btnPrev.Text = BtnPrevText
		btnPrev.SetLayoutAnimated(0, bx, btnRowTop, prevW, btnHW)
		bx = bx + prevW + gap
	Else
		btnPrev.Visible = False
	End If
	btnNext.Visible = StepObj.ShowNext
	If btnNext.Visible Then
		btnNext.Text = IIf(mCurrentIndex = mSteps.Size - 1, BtnFinishText, BtnNextText)
		btnNext.SetLayoutAnimated(0, bx, btnRowTop, nextW, btnHW)
	End If
		If StepObj.PositionMode = "explicit" And StepObj.ExplicitRight >= 0 And StepObj.ExplicitBottom >= 0 Then
		btnClose.View.SetLayoutAnimated(0, StepObj.ExplicitRight - 30dip, StepObj.ExplicitTop, 30dip, 30dip)
	Else
		btnClose.View.SetLayoutAnimated(0, screenW - 40dip, 20dip, 30dip, 30dip)
	End If
End Sub
Private Sub DrawKineticArrow(rcSpot As B4XRect, sArrowPosition As String)
	' Shaft starts at the horizontal center of the hint label, on the vertical
	' edge that faces the spotlight.
	Dim above As Boolean = lblMessage.Top < rcSpot.Top
	Dim startX As Float = lblMessage.Left + (lblMessage.Width / 2)
	Dim startY As Float = IIf(above, lblMessage.Top + lblMessage.Height, lblMessage.Top)
		' Target point along the component edge, chosen by the indicated placement:
	' "center" -> middle (straight shaft); "left"/"right" -> off-centre (curvy shaft).
	Dim arrowSize As Float = 12dip
	Dim arrowHalf As Float = 7dip
	Dim maxOff As Float = Max(0, rcSpot.Width / 2 - arrowHalf - 2dip)
	Dim placeOff As Float = 0
	Dim ap As String = sArrowPosition.ToLowerCase
	If ap = "left" Then placeOff = -Min(rcSpot.Width / 10, maxOff)
	If ap = "right" Then placeOff = Min(rcSpot.Width / 10, maxOff)
	Dim tipX As Float = rcSpot.Left + (rcSpot.Width / 2) + placeOff
	Dim tipY As Float = IIf(above, rcSpot.Top - 10dip, rcSpot.Bottom + 10dip)
		' Natural flow direction: from the label toward the apex. It points UP for an
	' up arrow / DOWN for a down arrow, but is allowed to tilt toward the label's
	' side so the arrow flows naturally instead of being rigid. The tilt is capped
	' (horizontal <= maxTilt * vertical) so it never goes sideways - it always
	' reads as pointing up or down, just with a natural lean.
	Dim rawX As Float = tipX - startX
	Dim rawY As Float = tipY - startY
	Dim maxTilt As Float = 0.6
	If Abs(rawY) < 1 Then rawY = IIf(above, -1, 1)
	If Abs(rawX) > maxTilt * Abs(rawY) Then rawX = IIf(rawX >= 0, 1, -1) * maxTilt * Abs(rawY)
	Dim bLen As Float = Sqrt(rawX * rawX + rawY * rawY)
	Dim bdx As Float = rawX / bLen
	Dim bdy As Float = rawY / bLen
		' Hands flare BACK from the apex along the bisector; perpendicular for the sides.
	Dim baseX As Float = tipX - bdx * arrowSize
	Dim baseY As Float = tipY - bdy * arrowSize
	Dim perpX As Float = -bdy
	Dim perpY As Float = bdx
	Dim leftX As Float = baseX - perpX * arrowHalf
	Dim leftY As Float = baseY - perpY * arrowHalf
	Dim rightX As Float = baseX + perpX * arrowHalf
	Dim rightY As Float = baseY + perpY * arrowHalf
		' Shaft S-curve: starts vertical at the label, ends flowing ALONG the bisector
	' into the apex - so the shaft and chevron align as one natural, tilting arrow.
	Dim span As Float = tipY - startY
	Dim cp1x As Float = startX
	Dim cp1y As Float = startY + 0.2 * span
	Dim cp2x As Float = tipX - bdx * 0.3 * Abs(span)
	Dim cp2y As Float = tipY - bdy * 0.3 * Abs(span)
		Dim p As B4XPath
	p.Initialize(startX, startY)
	Dim t As Float
	For t = 0.1 To 1.0 Step 0.05
		Dim t1 As Float = 1 - t
		Dim x As Float = t1 * t1 * t1 * startX + 3 * t1 * t1 * t * cp1x + 3 * t1 * t * t * cp2x + t * t * t * tipX
		Dim y As Float = t1 * t1 * t1 * startY + 3 * t1 * t1 * t * cp1y + 3 * t1 * t * t * cp2y + t * t * t * tipY
		p.LineTo(x, y)
	Next
	p.LineTo(tipX, tipY)
		' Open chevron V, vertex at the apex, tilted along the bisector (open V, not a triangle).
	Dim ah As B4XPath
	ah.Initialize(leftX, leftY)
	ah.LineTo(tipX, tipY)
	ah.LineTo(rightX, rightY)
		#If B4A
	' Shaft: BUTT cap so it stops flush at the apex. V: MITER join for a sharp apex, ROUND hands.
	Dim jo As JavaObject = cvsOverlay
	Dim cvsObj As JavaObject = jo.GetField("cvs")
	Dim paint As JavaObject = cvsObj.GetField("paint")
	Dim capStatic As JavaObject
	capStatic.InitializeStatic("android.graphics.Paint.Cap")
	Dim joinStatic As JavaObject
	joinStatic.InitializeStatic("android.graphics.Paint.Join")
	paint.RunMethod("setStrokeCap", Array(capStatic.GetField("BUTT")))
	cvsOverlay.DrawPath(p, xui.Color_White, False, 3dip)
	paint.RunMethod("setStrokeCap", Array(capStatic.GetField("ROUND")))
	paint.RunMethod("setStrokeJoin", Array(joinStatic.GetField("MITER")))
	cvsOverlay.DrawPath(ah, xui.Color_White, False, 3dip)
	paint.RunMethod("setStrokeJoin", Array(joinStatic.GetField("ROUND")))
	#Else
	cvsOverlay.DrawPath(p, xui.Color_White, False, 3dip)
	cvsOverlay.DrawPath(ah, xui.Color_White, False, 3dip)
	#End If
End Sub
Private Sub OverlayClick_Click
	Timer1.Enabled = False
	If mCurrentIndex < mSteps.Size Then
		Dim currentStep As EnjoyHintStep = mSteps.Get(mCurrentIndex)
		If currentStep.CloseOnOverlay Then
			mCurrentIndex = mCurrentIndex + 1
			RunStep(mCurrentIndex)
		End If
	End If
	If xui.SubExists(mCallBack, mEventName & "_OnOverlayClick", 0) Then CallSub(mCallBack, mEventName & "_OnOverlayClick")
End Sub
Private Sub Timer1_Tick
	Timer1.Enabled = False
	If mCurrentIndex < mSteps.Size - 1 Then
		mCurrentIndex = mCurrentIndex + 1
		RunStep(mCurrentIndex)
	Else
		EndTour
	End If
End Sub' 100% Callback Parity
Private Sub nextbtn_Click
	Timer1.Enabled = False
	mCurrentIndex = mCurrentIndex + 1
	RunStep(mCurrentIndex)
	If xui.SubExists(mCallBack, mEventName & "_OnNextClick", 0) Then CallSub(mCallBack, mEventName & "_OnNextClick")
End Sub
Private Sub previousbtn_Click
	Timer1.Enabled = False
	If mCurrentIndex > 0 Then mCurrentIndex = mCurrentIndex - 1
	RunStep(mCurrentIndex)
	If xui.SubExists(mCallBack, mEventName & "_OnPrevClick", 0) Then CallSub(mCallBack, mEventName & "_OnPrevClick")
End Sub
Private Sub skipbtn_Click
	Timer1.Enabled = False
	EndTour
	If xui.SubExists(mCallBack, mEventName & "_OnSkipClick", 0) Then CallSub(mCallBack, mEventName & "_OnSkipClick")
End Sub
Private Sub closebtn_Click (oTag As Object)
	Timer1.Enabled = False
	Try
		EndTour
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyEnjoyHint.closebtn_Click: " & LastException.Message)
	End Try
	If xui.SubExists(mCallBack, mEventName & "_OnCloseClick", 0) Then CallSub(mCallBack, mEventName & "_OnCloseClick")
End Sub
Public Sub EndTour
	Timer1.Enabled = False
	If pnlOverlay.Parent.IsInitialized Then
		Anim.AnimateFadeDirectional(pnlOverlay, "out", "none", 0, 300)
		Sleep(300)
		pnlOverlay.RemoveViewFromParent
	End If
	File.Delete(File.DirInternal, "enjoyhint_state.txt")
	If xui.SubExists(mCallBack, mEventName & "_OnFinished", 0) Then CallSub(mCallBack, mEventName & "_OnFinished")
End Sub
Public Sub Recalc
	If mCurrentIndex >= 0 And mCurrentIndex < mSteps.Size Then
		Dim currentStep As EnjoyHintStep = mSteps.Get(mCurrentIndex)
		cvsOverlay.ClearRect(cvsOverlay.TargetRect)
		cvsOverlay.Invalidate
		DrawSpotlightAndArrow(currentStep)
	End If
End Sub
Private Sub ScrollToView(vView As B4XView)
	#If B4A
	Try
		Dim p As B4XView = vView.Parent
		Dim topY As Int = 0
		Try
			topY = vView.Top
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisyEnjoyHint.ScrollToView: " & LastException.Message)
			topY = 0
		End Try
		Do While p.IsInitialized And p <> mRoot
			If GetType(p) = "anywheresoftware.b4a.objects.ScrollViewWrapper$MyScrollView" Then
				Dim sv As ScrollView = p
				sv.ScrollPosition = Max(0, topY - (sv.Height / 3))
				Exit
			End If
			Try
				topY = topY + p.Top
			Catch
				If B4XDaisyApp.DebugLogs Then Log("B4XDaisyEnjoyHint.ScrollToView: " & LastException.Message)
				' skip if cannot access parent Top
			End Try
			p = p.Parent
		Loop
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyEnjoyHint.ScrollToView: " & LastException.Message)
	End Try
	#End If
End Sub
Private Sub GetAbsoluteRect(vView As B4XView) As B4XRect
    Dim r As B4XRect
    If vView.IsInitialized = False Then
        r.Initialize(0, 0, 0, 0)
        Return r
    End If
    #If B4A
    Try
        Dim joTarget As JavaObject = vView
        Dim joRoot As JavaObject = mRoot
        Dim locTarget(2), locRoot(2) As Int
        joTarget.RunMethod("getLocationOnScreen", Array(locTarget))
        joRoot.RunMethod("getLocationOnScreen", Array(locRoot))
        Dim left As Int = locTarget(0) - locRoot(0)
        Dim top As Int = locTarget(1) - locRoot(1)
        r.Initialize(left, top, left + vView.Width, top + vView.Height)
        Return r
    Catch
        If B4XDaisyApp.DebugLogs Then Log("B4XDaisyEnjoyHint.GetAbsoluteRect: " & LastException.Message)
    End Try
    #End If
    ' Fallback (B4i/others): walk hierarchy up to mRoot
    Try
        Dim left As Int = vView.Left
        Dim top As Int = vView.Top
        Dim p As B4XView = vView.Parent
        Do While p.IsInitialized And p <> mRoot
            left = left + p.Left
            top = top + p.Top
            #If B4A
            If GetType(p) = "anywheresoftware.b4a.objects.ScrollViewWrapper$MyScrollView" Then
                Dim sv As ScrollView = p
                top = top - sv.ScrollPosition
            End If
            #End If
            p = p.Parent
        Loop
        r.Initialize(left, top, left + vView.Width, top + vView.Height)
    Catch
        If B4XDaisyApp.DebugLogs Then Log("B4XDaisyEnjoyHint.GetAbsoluteRect: " & LastException.Message)
        r.Initialize(0, 0, 0, 0)
    End Try
    Return r
End Sub
