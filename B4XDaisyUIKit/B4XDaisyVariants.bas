B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=StaticCode
Version=13.4
@EndOfDesignText@
'Shared Daisy variant helpers for B4X components.
#IgnoreWarnings:12,9
Sub Process_Globals
	Private xui As XUI
	Private Const TW_SPACE_STEP_PX As Float = 4
	Private Const CSS_BASE_FONT_PX As Float = 16
	Public Const FLATPICKR_UNIX_PLACEHOLDER As String = "__fp_unix__"
	Private Themes As Map
	Private ActiveThemeName As String = "light"
	'
	Public FLEX_DEBUG As Boolean = False
    Public FLEX_SPACE_UNIT_DIP As Float = 4
	Type NullableInt (Success As Boolean, Value As Int)
	Type NullableFloat (Success As Boolean, Value As Float)
	Type B4XDaisySweetAlertResult (IsConfirmed As Boolean, IsDenied As Boolean, IsDismissed As Boolean, Dismiss As String, Value As Object)
	
	Public Const LINE_HEIGHT_DEFAULT As Float = 1.5
	Private argCache As Map
End Sub

' Converts HSL (Hue 0..360, Saturation 0..1, Lightness 0..1, Alpha 0..255) to ARGB Color Int
Public Sub HSLToInt(iH As Int, dS As Double, dL As Double, iA As Int) As Int
	Dim c As Double = (1 - Abs(2 * dL - 1)) * dS
	Dim hp As Double = iH / 60.0
	Dim x As Double = c * (1 - Abs((hp Mod 2) - 1))
	Dim r1 As Double = 0, g1 As Double = 0, b1 As Double = 0
	If hp < 1 Then
		r1 = c : g1 = x : b1 = 0
	Else If hp < 2 Then
		r1 = x : g1 = c : b1 = 0
	Else If hp < 3 Then
		r1 = 0 : g1 = c : b1 = x
	Else If hp < 4 Then
		r1 = 0 : g1 = x : b1 = c
	Else If hp < 5 Then
		r1 = x : g1 = 0 : b1 = c
	Else
		r1 = c : g1 = 0 : b1 = x
	End If
	Dim m As Double = dL - c / 2
	Return xui.Color_ARGB(iA, Round((r1 + m) * 255), Round((g1 + m) * 255), Round((b1 + m) * 255))
End Sub

public Sub AreSystemAnimationsEnabled As Boolean
    #If B4A
	Try
		Dim jo As JavaObject
		jo.InitializeStatic("android.animation.ValueAnimator")
		Return jo.RunMethod("areAnimatorsEnabled", Null)
	Catch
		Return True ' pre-API 26 fallback: assume enabled
	End Try
    #Else
    Return True
    #End If
End Sub

public Sub ForceAnimatorDurationScale(fScale As Float) As Boolean
    #If B4A
	Try
		Dim jo As JavaObject
		jo.InitializeStatic("android.animation.ValueAnimator")
		jo.RunMethod("setDurationScale", Array As Object(fScale))
		Return True
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyVariants.ForceAnimatorDurationScale: " & LastException.Message)
		Return False
	End Try
    #Else
    Return False
    #End If
End Sub

'Sub SetBorderColorAnimated(lblview As Label, duration As Long, toColor As Int)
'	Dim jo As JavaObject = lblview
'
'	' Create a Drawable with a border
'	Dim initialColor As Int = xui.Color_Transparent ' Default starting color
'  
'	borderDrawable.InitializeNewInstance("android.graphics.drawable.GradientDrawable", Null)
'	borderDrawable.RunMethod("setShape", Array(0)) ' 0 = RECTANGLE
'	borderDrawable.RunMethod("setStroke", Array(5dip, initialColor)) ' 5dip border width, initial color
'	jo.RunMethod("setBackground", Array(borderDrawable))
'
'	' Use JavaObject to call the static ValueAnimator.ofArgb method
'	Dim clrs(2) As Int
'	clrs(0) = initialColor
'	clrs(1) = toColor
'	Dim animator As JavaObject
'	animator.InitializeStatic("android.animation.ValueAnimator")
'	animator = animator.RunMethod("ofArgb", Array As Object(clrs))
'	animator.RunMethod("setDuration", Array As Object(duration))
'
'	' Use CreateEvent to define the AnimatorUpdateListener
'	' Pass the `borderDrawable` JavaObject directly as the "Tag"
'	Dim wrapper As JavaObject
'	wrapper = animator.CreateEvent("android.animation.ValueAnimator.AnimatorUpdateListener", "AnimationUpdate", borderDrawable)
'	animator.RunMethod("addUpdateListener", Array(wrapper))
'
'	' Start the animation
'	animator.RunMethod("start", Null)
'End Sub
'
'' Handle the animation update in the Sub below
'Sub AnimationUpdate_Event (Tag As Object, Args() As Object) As Object
'	Dim valueAnimator As JavaObject = Args(0) ' Get the ValueAnimator object
'	Dim animValue As Int = valueAnimator.RunMethod("getAnimatedValue", Null) ' Extract the animated value
'
'	' Update the border color
'	borderDrawable.RunMethod("setStroke", Array(5dip, animValue))
'End Sub


Sub isBase64(sText As String) As Boolean
	If Regex.IsMatch("^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)$", sText) And sText.Length > 3  Then
		Return True
	Else
		Return False
	End If
End Sub

Sub ConvertStringToBase64(sText As String) As String
	Private su As StringUtils
	Private b() As Byte = sText.GetBytes("UTF8")
	Return su.EncodeBase64(b)
End Sub

Sub ConvertBase64ToString(sText As String) As String
	Private su As StringUtils
	Dim b() As Byte = su.DecodeBase64(sText)
	Return BytesToString(b, 0, b.Length, "UTF8")
End Sub

'Sets text or CSBuilder to a label.
Public Sub SetTextOrCSBuilderToLabel(vXlbl As B4XView, oText As Object)
	#if B4A or B4J
	vXlbl.Text = oText
	#else if B4i
	Try
		If oText Is CSBuilder And vXlbl Is Label Then
			Dim lbl As Label = vXlbl
			lbl.AttributedText = oText
		Else 
			If GetType(oText) = "__NSCFNumber" Then oText = "" & Chr(oText)
			vXlbl.Text = oText
		End If
	Catch
		vXlbl.Text = oText
	End Try
	#end if
End Sub

'Sets a bitmap and sets the gravity to Fill.
Public Sub SetBitmapAndFill (vImageView As B4XView, bmpBmp As B4XBitmap)
	vImageView.SetBitmap(bmpBmp)
	Dim iiv As ImageView = vImageView
	#if B4A
	iiv.Gravity = Gravity.FILL
	#Else If B4J
	iiv.PreserveRatio = False
	#else if B4i
	iiv.ContentMode = iiv.MODE_FILL
	#End If
End Sub

'Create a Label.
Public Sub CreateLabel As B4XView
	Dim lbl As Label
	lbl.Initialize("")
	Return lbl
End Sub

'Creates a B4XImageView. You need to add B4XImageView.mBase to the layout tree.
Public Sub CreateB4XImageView As B4XImageView
	Dim iv As B4XImageView
	iv.Initialize(Null, "")
	Dim base As B4XView = xui.CreatePanel("")
	base.SetLayoutAnimated(0, 0, 0, 100dip, 100dip)
	iv.DesignerCreateView(base, Null, CreateMap("Round": False, "ResizeMode": "FIT", "BackgroundColor": 0xFFAAAAAA, "CornersRadius": 0))
	Return iv
End Sub

Sub CreateHaloEffect (vParent As B4XView, iX As Int, iY As Int, iClr As Int)
	Dim cvs As B4XCanvas
	Dim p As B4XView = xui.CreatePanel("")
	Dim radius As Int = 150dip
	p.SetLayoutAnimated(0, 0, 0, radius * 2, radius * 2)
	cvs.Initialize(p)
	cvs.DrawCircle(cvs.TargetRect.CenterX, cvs.TargetRect.CenterY, cvs.TargetRect.Width / 2, iClr, True, 0)
	Dim bmp As B4XBitmap = cvs.CreateBitmap
	For i = 1 To 5
		CreateHaloEffectHelper(vParent,bmp, iX, iY, iClr, radius)
		Sleep(800)
	Next
End Sub

Sub CreateHaloEffectHelper (vParent As B4XView, bmpBmp As B4XBitmap, iX As Int, iY As Int, iClr As Int, iRadius As Int)
	Dim iv As ImageView
	iv.Initialize("")
	Dim p As B4XView = iv
	p.SetBitmap(bmpBmp)
	vParent.AddView(p, iX, iY, 0, 0)
	Dim duration As Int = 3000
	p.SetLayoutAnimated(duration, iX - iRadius, iY - iRadius, 2 * iRadius, 2 * iRadius)
	p.SetVisibleAnimated(duration, False)
	Sleep(duration)
	p.RemoveViewFromParent
End Sub


#Region Radio Group Helpers
''' <summary>
''' Returns the currently checked B4XDaisyRadio in the given group within
''' the specified parent panel.  Searches direct children only (same pattern
''' as B4XRadioButton).  Returns Null if none is checked or the group is
''' not found.
''' </summary>
Public Sub GetCheckedRadio(vParent As B4XView, sGroupName As String) As B4XDaisyRadio
	If vParent.IsInitialized = False Then Return Null
	If sGroupName = "" Then Return Null
	Try
		Dim count As Int = vParent.NumberOfViews
		For i = 0 To count - 1
			Dim v As B4XView = vParent.GetView(i)
			If v.Tag Is B4XDaisyRadio Then
				Dim rb As B4XDaisyRadio = v.Tag
				If rb.GroupName = sGroupName And rb.Checked Then
					Return rb
				End If
			End If
		Next
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyVariants.GetCheckedRadio: " & LastException.Message)
	End Try
	Return Null
End Sub

' Adds a perfectly clipped ripple effect to any B4XView
' Parent: The mBase of the B4XDaisy component
' TouchX, TouchY: The coordinates from the _Touch event
' RippleColor: Best passed as a semi-transparent color (e.g., xui.Color_ARGB(80, 255, 255, 255))
' DurationMs: Animation length in milliseconds (e.g., 300 to 500)
' CornerRadius: The exact border radius of the component to constrain the ripple
Public Sub CreateRipple(vParent As B4XView, fTouchX As Float, fTouchY As Float, iRippleColor As Int, iDurationMs As Int, iCornerRadius As Int)
	Dim xui As XUI
    
	' 1. Create a temporary transparent overlay panel
	Dim Overlay As B4XView = xui.CreatePanel("")
	vParent.AddView(Overlay, 0, 0, vParent.Width, vParent.Height)

	' 2. Initialize Canvas and the target boundary rectangle
	Dim cvs As B4XCanvas
	cvs.Initialize(Overlay)
    
	Dim TargetRect As B4XRect
	TargetRect.Initialize(0, 0, vParent.Width, vParent.Height)

	' 3. Create the clipping path based on the component's corner radius [1]
	Dim ClipPth As B4XPath
	ClipPth.InitializeRoundedRect(TargetRect, iCornerRadius)

	' 4. Calculate max radius needed to cover the entire view from the exact touch point
	Dim DistTL As Float = Sqrt(Power(fTouchX, 2) + Power(fTouchY, 2))
	Dim DistTR As Float = Sqrt(Power(fTouchX - vParent.Width, 2) + Power(fTouchY, 2))
	Dim DistBL As Float = Sqrt(Power(fTouchX, 2) + Power(fTouchY - vParent.Height, 2))
	Dim DistBR As Float = Sqrt(Power(fTouchX - vParent.Width, 2) + Power(fTouchY - vParent.Height, 2))
	Dim MaxRadius As Float = Max(Max(DistTL, DistTR), Max(DistBL, DistBR))

	' 5. Animation setup (Approx 60 FPS)
	Dim Frames As Int = iDurationMs / 16
	Dim RadiusStep As Float = MaxRadius / Frames

	' Extract ARGB components from the provided RippleColor to safely fade the Alpha
	Dim r As Int = Bit.UnsignedShiftRight(Bit.And(iRippleColor, 0x00FF0000), 16)
	Dim g As Int = Bit.UnsignedShiftRight(Bit.And(iRippleColor, 0x0000FF00), 8)
	Dim b As Int = Bit.And(iRippleColor, 0x000000FF)
	Dim StartAlpha As Int = Bit.UnsignedShiftRight(Bit.And(iRippleColor, 0xFF000000), 24)

	' 6. Draw Loop
	For i = 1 To Frames
		cvs.ClearRect(TargetRect)
        
		' Apply clip path so the ripple never spills over the rounded corners [1]
		cvs.ClipPath(ClipPth)
        
		' Calculate fading alpha as the circle expands
		Dim CurrentAlpha As Int = StartAlpha - (StartAlpha * i / Frames)
		Dim CurrentColor As Int = xui.Color_ARGB(CurrentAlpha, r, g, b)
        
		' Draw the expanding ripple frame
		cvs.DrawCircle(fTouchX, fTouchY, i * RadiusStep, CurrentColor, True, 0)
        
		' Remove clip to prevent memory/drawing glitches on next frame
		cvs.RemoveClip
		cvs.Invalidate
        
		Sleep(16) ' Yield to the UI thread
	Next

	' 7. Cleanup overlay when the animation finishes
	Overlay.RemoveViewFromParent
End Sub

''' <summary>
''' Returns the Value property of the currently checked radio in the given
''' group within the specified parent panel.  Returns "" if none is checked.
''' </summary>
Public Sub GetCheckedValue(vParent As B4XView, sGroupName As String) As String
	Dim rb As B4XDaisyRadio = GetCheckedRadio(vParent, sGroupName)
	If rb <> Null Then Return rb.Value
	Return ""
End Sub

''' <summary>
''' Checks the radio with the given Value in the given group within the
''' specified parent panel, and unchecks any previously checked radio in
''' that group.  Returns True if a matching radio was found, False otherwise.
''' </summary>
Public Sub SetCheckedByValue(vParent As B4XView, sGroupName As String, sValue As String) As Boolean
	If vParent.IsInitialized = False Then Return False
	If sGroupName = "" Then Return False
	Dim found As Boolean = False
	Try
		Dim count As Int = vParent.NumberOfViews
		For i = 0 To count - 1
			Dim v As B4XView = vParent.GetView(i)
			If v.Tag Is B4XDaisyRadio Then
				Dim rb As B4XDaisyRadio = v.Tag
				If rb.GroupName = sGroupName Then
					If rb.Value = sValue Then
						rb.Checked = True
						found = True
					End If
				End If
			End If
		Next
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyVariants.SetCheckedByValue: " & LastException.Message)
	End Try
	Return found
End Sub
#End Region


Public Sub SetActiveTheme(sThemeName As String)
	EnsureThemeInitialized
	Dim key As String = NormalizeThemeName(sThemeName)
	If Themes.ContainsKey(key) = False Then key = "light"
	ActiveThemeName = key
End Sub

Public Sub GetActiveTheme As String
	EnsureThemeInitialized
	Return ActiveThemeName
End Sub

Public Sub HasTheme(sThemeName As String) As Boolean
	EnsureThemeInitialized
	Return Themes.ContainsKey(NormalizeThemeName(sThemeName))
End Sub

Public Sub RegisterTheme(sThemeName As String, mTokens As Map)
	EnsureThemeInitialized
	If mTokens.IsInitialized = False Then Return
	Dim key As String = NormalizeThemeName(sThemeName)
	Dim t As Map
	t.Initialize
	For Each mk As Object In mTokens.Keys
		Dim sk As String = mk
		If sk.StartsWith("--") Then
			t.Put(sk.ToLowerCase, mTokens.Get(mk))
		Else
			t.Put(sk, mTokens.Get(mk))
		End If
	Next
	t.Put("--theme-name", key)
	Themes.Put(key, t)
End Sub

Public Sub ResolveAssetImage(sFileName As String, sDefaultImage As String) As String
	If sFileName = Null Or sFileName.Trim.Length = 0 Then Return sDefaultImage
	Dim f As String = sFileName.Trim
	If f.StartsWith("<svg") Or f.StartsWith("<?xml") Then Return f
	If File.Exists(File.DirAssets, f) Then Return f
	If f.ToLowerCase.EndsWith(".svg") = False And File.Exists(File.DirAssets, f & ".svg") Then Return f & ".svg"
	Dim slash1 As Int = f.LastIndexOf("/")
	Dim slash2 As Int = f.LastIndexOf("\")
	Dim slash As Int = Max(slash1, slash2)
	If slash >= 0 Then
		Dim fn As String = f.SubString(slash + 1)
		If fn.Length > 0 Then
			If File.Exists(File.DirAssets, fn) Then Return fn
			If fn.ToLowerCase.EndsWith(".svg") = False And File.Exists(File.DirAssets, fn & ".svg") Then Return fn & ".svg"
		End If
	End If
	Return f
End Sub

Public Sub ResolveAssetSVG(sFileName As String, sDefaultText As String) As String
	If sFileName = Null Or sFileName.Trim.Length = 0 Then Return sDefaultText
	Dim f As String = sFileName.Trim
	If File.Exists(File.DirAssets, f) Then 
		Return File.ReadString(File.DirAssets, f)
	End If
	Return sDefaultText
End Sub

Public Sub GetThemeTokens(sThemeName As String) As Map
	EnsureThemeInitialized
	Dim key As String = NormalizeThemeName(sThemeName)
	If Themes.ContainsKey(key) Then Return Themes.Get(key)
	Return Themes.Get("light")
End Sub

Public Sub GetActiveTokens As Map
	Return GetThemeTokens(ActiveThemeName)
End Sub

' Set overflow hidden on a view
Public Sub SetOverflowHidden(vView As B4XView)
	' Clip to outline (requires background/outline)
	Dim jo As JavaObject = vView
	jo.RunMethod("setClipToOutline", Array(True))
	' Also clip children for ViewGroup (Panel, etc.) - works without background
	Try
		jo.RunMethod("setClipChildren", Array(True))
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyVariants.SetOverflowHidden: " & LastException.Message)
		' Not a ViewGroup, ignore
	End Try
End Sub

' Set a CSS/Style variable on a view (B4A only for now)
Public Sub SetStyleVariable(vView As B4XView, sName As String, oValue As Object)
    #If B4A
    Try
        Dim jo As JavaObject = vView
        ' In SNH (SithasoNewHeights) and DaisyUIKit, we often store these in the view's tag 
        ' or a dedicated map if it's a composite component. 
        ' For simple CSS variables that the underlying engine (like a WebView or custom renderer) 
        ' might need, we can use setTag or a custom property.
        ' However, for Daisy rotation, these are actually used by the B4X Transition or 
        ' the component's Refresh logic.
        ' We'll store it in a Map in the Tag if the Tag is a Map, otherwise we'll just 
        ' ensure it's available for the component.
        If vView.Tag <> Null And vView.Tag Is Map Then
            Dim m As Map = vView.Tag
            m.Put(sName, oValue)
        End If
    Catch
        If B4XDaisyApp.DebugLogs Then Log("B4XDaisyVariants.SetStyleVariable: " & LastException.Message)
    End Try
    #End If
End Sub


' Check if an object is of a specific class name
Public Sub IsClass(oObj As Object, sClassName As String) As Boolean
    If oObj = Null Then Return False
    Dim sType As String = GetType(oObj).ToLowerCase
    Return sType.Contains(sClassName.ToLowerCase)
End Sub

Public Sub GetTokenColor(sToken As String, iDefaultColor As Int) As Int
	Dim m As Map = GetActiveTokens
	Dim k As String = NormalizeTokenKey(sToken)
	If m.ContainsKey(k) = False Then Return iDefaultColor
	Dim o As Object = m.Get(k)
	If o Is Int Then Return o
	If o Is Float Or o Is Double Then Return o
	Return iDefaultColor
End Sub

Public Sub ResolveThemeColorTokenName(sName As String) As String
	If sName = Null Then Return ""
	Dim key As String = NormalizeUtilityToken(sName.ToLowerCase.Trim)
	If key.Length = 0 Then Return ""
	Dim slashPos As Int = key.IndexOf("/")
	If slashPos > 0 Then key = key.SubString2(0, slashPos).Trim
	If key.StartsWith("[") And key.EndsWith("]") And key.Length > 2 Then
		key = key.SubString2(1, key.Length - 1).Trim
	End If
	If key.StartsWith("(") And key.EndsWith(")") And key.Length > 2 Then
		key = key.SubString2(1, key.Length - 1).Trim
	End If
	If key.StartsWith("var(") And key.EndsWith(")") Then
		Dim pVar As Int = key.IndexOf("--")
		If pVar >= 0 Then key = key.SubString2(pVar, key.Length - 1).Trim
	End If
	Dim direct As String = MapKnownThemeColorNameToToken(key)
	If direct.Length > 0 Then Return direct
	key = StripColorUtilityPrefix(key)
	If key.StartsWith("--") Then Return NormalizeTokenKey(key)
	Return MapKnownThemeColorNameToToken(key)
End Sub

Public Sub NormalizeOrientation(sValue As String) As String
    If sValue = Null Then Return "horizontal"
    Dim s As String = sValue.ToLowerCase.Trim
    If s = "vertical" Then Return "vertical"
    Return "horizontal"
End Sub

Public Sub NormalizeHorizontalPlacement(sValue As String) As String
	If sValue = Null Then Return "end"
	Dim s As String = sValue.ToLowerCase.Trim
	Select Case s
		Case "start", "center", "end"
			Return s
		Case Else
			Return "end"
	End Select
End Sub

Public Sub NormalizeVerticalPlacement(sValue As String) As String
	If sValue = Null Then Return "top"
	Dim s As String = sValue.ToLowerCase.Trim
	Select Case s
		Case "top", "middle", "bottom"
			Return s
		Case Else
			Return "top"
	End Select
End Sub

Public Sub NormalizeAlertVariant(sValue As String) As String
	If sValue = Null Then Return "none"
	Dim s As String = sValue.ToLowerCase.Trim
	If s.StartsWith("alert-") Then s = s.SubString(6)
	Select Case s
		Case "none", "info", "success", "warning", "error", "neutral", "primary", "secondary", "accent"
			Return s
		Case Else
			Return "none"
	End Select
End Sub

Public Sub NormalizeSize(sValue As String) As String
	If sValue = Null Then Return "md"
	Dim s As String = sValue.ToLowerCase.Trim
	Select Case s
		Case "xs", "sm", "md", "lg", "xl"
			Return s
		Case Else
			Return "md"
	End Select
End Sub

Public Sub NormalizeBadgeStyle(sValue As String) As String
	If sValue = Null Then Return "solid"
	Dim s As String = sValue.ToLowerCase.Trim
	Select Case s
		Case "solid", "soft", "outline", "dash", "ghost"
			Return s
		Case Else
			Return "solid"
	End Select
End Sub

Public Sub NormalizeStyle(sValue As String) As String
	If sValue = Null Then Return "solid"
	Dim s As String = sValue.ToLowerCase.Trim
	Select Case s
		Case "solid", "soft", "outline", "dash", "ghost", "link"
			Return s
		Case Else
			Return "solid"
	End Select
End Sub

Public Sub NormalizeSelectionMode(sValue As String) As String
	If sValue = Null Then Return "multi"
	Dim s As String = sValue.ToLowerCase.Trim
	Select Case s
		Case "single", "multi"
			Return s
		Case Else
			Return "multi"
	End Select
End Sub

Public Sub NormalizeFieldsetBorderStyle(sValue As String) As String
	If sValue = Null Then Return "outlined"
	Dim s As String = sValue.ToLowerCase.Trim
	Select Case s
		Case "outlined", "ghost", "inset"
			Return s
		Case Else
			Return "outlined"
	End Select
End Sub

Public Sub NormalizeLegendSize(sValue As String) As String
	If sValue = Null Then Return "text-sm"
	Dim s As String = sValue.ToLowerCase.Trim
	Select Case s
		Case "text-xs", "text-sm", "text-base", "text-lg", "text-xl"
			Return s
		Case Else
			Return "text-sm"
	End Select
End Sub

Public Sub NormalizeSizeSpec(oValue As Object, sDefaultValue As String) As String
	Dim s As String = ""
	If oValue <> Null Then s = oValue
	s = s.Trim
	If s.Length = 0 Then Return sDefaultValue
	Return s
End Sub

Public Sub GetPropObject(mProps As Map, sKey As String, oDefaultValue As Object) As Object
	If mProps.IsInitialized = False Then Return oDefaultValue
	If mProps.ContainsKey(sKey) = False Then Return oDefaultValue
	Dim o As Object = mProps.Get(sKey)
	If o = Null Then Return oDefaultValue
	Return o
End Sub

Public Sub ResolveSizeSpec(sValue As String, iParentSize As Int, iFallback As Int) As Int
	Dim s As String = IIf(sValue = Null, "", sValue.Trim)
	If s.Length = 0 Then Return Max(1dip, iFallback)
	' Strip Tailwind bracket prefix so w-[80%], h-[80%], and [80%] resolve as % of ParentSize.
	Dim lower As String = s.ToLowerCase
	If lower.StartsWith("w-[") And lower.EndsWith("]") Then
		s = s.SubString2(3, s.Length - 1)
	Else If lower.StartsWith("h-[") And lower.EndsWith("]") Then
		s = s.SubString2(3, s.Length - 1)
	Else If lower.StartsWith("[") And lower.EndsWith("]") And lower.Length > 2 Then
		s = s.SubString2(1, s.Length - 1)
	End If
	If s.EndsWith("%") Then
		Dim n As Float = s.SubString2(0, s.Length - 1)
		If IsNumber(n) Then
			Dim ref As Int = Max(1dip, iParentSize)
			Return Max(1dip, Round(ref * (n / 100)))
		End If
	End If
	Return Max(1dip, TailwindSizeToDip(s, iFallback))
End Sub

Public Sub NormalizeAvatarPosition(sValue As String) As String
	If sValue = Null Then Return "left"
	Dim s As String = sValue.ToLowerCase.Trim
	If s = "right" Then Return "right"
	Return "left"
End Sub

Public Sub NormalizeDirection(sValue As String) As String
	If sValue = Null Then Return "horizontal"
	Dim s As String = sValue.ToLowerCase.Trim
	Select Case s
		Case "horizontal", "vertical"
			Return s
		Case Else
			Return "horizontal"
	End Select
End Sub	

Public Sub NormalizeAnimation(sValue As String) As String
	If sValue = Null Then Return "none"
	Dim s As String = sValue.ToLowerCase.Trim
	Select Case s
		Case "none", "pulse", "bounce"
			Return s
		Case Else
			Return "none"
	End Select
End Sub

Public Sub NormalizeSingleLineText(sValue As String) As String
	If sValue = Null Then Return ""
	Return sValue.Replace(CRLF, " ").Replace(Chr(10), " ").Replace(Chr(13), " ").Trim
End Sub

Private Sub StripColorUtilityPrefix(sValue As String) As String
	Dim s As String = sValue
	Dim prefixes() As String = Array As String( _
		"ring-offset-", "placeholder-", "decoration-", "divide-", "outline-", "shadow-", _
		"stroke-", "fill-", "caret-", "ring-", "from-", "via-", "to-", "border-", "text-", "bg-", "accent-", "color-" _
	)
	For Each pref As String In prefixes
		If s.StartsWith(pref) And s.Length > pref.Length Then
			Return s.SubString(pref.Length).Trim
		End If
	Next
	Return s
End Sub

Private Sub MapKnownThemeColorNameToToken(sKey As String) As String
	Select Case sKey
		Case "primary", "secondary", "accent", "neutral", "info", "success", "warning", "error", _
			"base-100", "base-200", "base-300", "base-content", _
			"primary-content", "secondary-content", "accent-content", "neutral-content", _
			"info-content", "success-content", "warning-content", "error-content"
			Return "--color-" & sKey
		Case Else
			Return ""
	End Select
End Sub

Public Sub GetTokenString(sToken As String, sDefaultValue As String) As String
	Dim m As Map = GetActiveTokens
	Dim k As String = NormalizeTokenKey(sToken)
	If m.ContainsKey(k) = False Then Return sDefaultValue
	Dim o As Object = m.Get(k)
	If o = Null Then Return sDefaultValue
	Return o
End Sub

Public Sub GetTokenNumber(sToken As String, fDefaultValue As Float) As Float
	Dim m As Map = GetActiveTokens
	Dim k As String = NormalizeTokenKey(sToken)
	If m.ContainsKey(k) = False Then Return fDefaultValue
	Dim o As Object = m.Get(k)
	If o = Null Then Return fDefaultValue
	If IsNumber(o) Then Return o
	Dim s As String = o
	If IsNumber(s) Then Return s
	Return fDefaultValue
End Sub

' helper used by demo pages
Public Sub GetThemeColor(sToken As String, iDefaultColor As Int) As Int
	' try to get the numeric value of the token; fall back to the provided default
	Return GetTokenNumber(sToken, iDefaultColor)
End Sub

Public Sub GetTokenDip(sToken As String, fDefaultDipValue As Float) As Float
	Dim raw As String = GetTokenString(sToken, "")
	If raw.Length = 0 Then Return fDefaultDipValue
	Return ParseThemeLengthToDip(raw, fDefaultDipValue)
End Sub

Public Sub GetBorderDip(fDefaultDip As Float) As Float
	Return GetTokenDip("--border", fDefaultDip)
End Sub

Public Sub GetRadiusBoxDip(fDefaultDip As Float) As Float
	Return GetTokenDip("--radius-box", fDefaultDip)
End Sub

Public Sub GetRadiusFieldDip(fDefaultDip As Float) As Float
	Return GetTokenDip("--radius-field", fDefaultDip)
End Sub

Public Sub GetRadiusSelectorDip(fDefaultDip As Float) As Float
	Return GetTokenDip("--radius-selector", fDefaultDip)
End Sub

Public Sub GetVariantPalette As Map
	Return BuildVariantPalette(ActiveThemeName)
End Sub

Public Sub BuildVariantPalette(sThemeName As String) As Map
	Dim t As Map = GetThemeTokens(sThemeName)
	Dim palette As Map
	palette.Initialize
	palette.Put("neutral", BuildVariantMap(t.GetDefault("--color-neutral", xui.Color_RGB(63, 64, 77)), t.GetDefault("--color-neutral-content", xui.Color_RGB(248, 248, 249))))
	palette.Put("primary", BuildVariantMap(t.GetDefault("--color-primary", xui.Color_RGB(121, 77, 255)), t.GetDefault("--color-primary-content", xui.Color_RGB(243, 242, 255))))
	palette.Put("secondary", BuildVariantMap(t.GetDefault("--color-secondary", xui.Color_RGB(118, 113, 127)), t.GetDefault("--color-secondary-content", xui.Color_RGB(247, 247, 248))))
	palette.Put("accent", BuildVariantMap(t.GetDefault("--color-accent", xui.Color_RGB(59, 130, 246)), t.GetDefault("--color-accent-content", xui.Color_RGB(239, 246, 255))))
	palette.Put("info", BuildVariantMap(t.GetDefault("--color-info", xui.Color_RGB(4, 182, 212)), t.GetDefault("--color-info-content", xui.Color_RGB(236, 254, 255))))
	palette.Put("success", BuildVariantMap(t.GetDefault("--color-success", xui.Color_RGB(0, 202, 75)), t.GetDefault("--color-success-content", xui.Color_RGB(240, 252, 248))))
	palette.Put("warning", BuildVariantMap(t.GetDefault("--color-warning", xui.Color_RGB(252, 170, 30)), t.GetDefault("--color-warning-content", xui.Color_RGB(255, 253, 245))))
	palette.Put("error", BuildVariantMap(t.GetDefault("--color-error", xui.Color_RGB(251, 65, 65)), t.GetDefault("--color-error-content", xui.Color_RGB(255, 250, 245))))
	Return palette
End Sub

Private Sub EnsureThemeInitialized
	If Themes.IsInitialized Then Return
	Themes.Initialize
	RegisterLightTheme
	If Themes.ContainsKey(ActiveThemeName) = False Then ActiveThemeName = "light"
End Sub

Private Sub RegisterLightTheme
	Dim light As Map
	light.Initialize
	light.Put("--theme-name", "light")
	light.Put("--color-base-100", 0xFFFFFFFF)
	light.Put("--color-base-200", 0xFFF8F7FB)
	light.Put("--color-base-300", 0xFFDEDBEB)
	light.Put("--color-base-content", 0xFF3F404D)
	light.Put("--color-primary", 0xFF794DFF)
	light.Put("--color-primary-content", 0xFFF3F2FF)
	light.Put("--color-secondary", 0xFF76717F)
	light.Put("--color-secondary-content", 0xFFF7F7F8)
	light.Put("--color-accent", 0xFF3B82F6)
	light.Put("--color-accent-content", 0xFFEFF6FF)
	light.Put("--color-neutral", 0xFF3F404D)
	light.Put("--color-neutral-content", 0xFFF8F8F9)
	light.Put("--color-info", 0xFF04B6D4)
	light.Put("--color-info-content", 0xFFECFEFF)
	light.Put("--color-success", 0xFF00CA4B)
	light.Put("--color-success-content", 0xFFF0FCF8)
	light.Put("--color-warning", 0xFFFCAA1E)
	light.Put("--color-warning-content", 0xFFFFFDF5)
	light.Put("--color-error", 0xFFFB4141)
	light.Put("--color-error-content", 0xFFFFFAF5)
	light.Put("--radius-selector", "0.25rem")
	light.Put("--radius-field", "0.375rem")
	light.Put("--radius-box", "0.5rem")
	light.Put("--size-selector", "0.25rem")
	light.Put("--size-field", "0.25rem")
	light.Put("--spacing", "0.25rem")
	light.Put("--border", "1px")
	light.Put("--depth", 0)
	light.Put("--noise", 0)
	' Glass utility defaults (daisyui-inspired).
	light.Put("--glass-blur", "40px")
	light.Put("--glass-opacity", "30%")
	light.Put("--glass-reflect-degree", "100")
	light.Put("--glass-reflect-opacity", "5%")
	light.Put("--glass-border-opacity", "20%")
	light.Put("--glass-text-shadow-opacity", "5%")
	Themes.Put("light", light)
End Sub

Private Sub NormalizeThemeName(sValue As String) As String
	If sValue = Null Then Return "light"
	Dim s As String = sValue.ToLowerCase.Trim
	If s.Length = 0 Then Return "light"
	Return s
End Sub

Private Sub NormalizeTokenKey(sToken As String) As String
	If sToken = Null Then Return ""
	Dim s As String = sToken.Trim
	If s.StartsWith("--") = False Then s = "--" & s
	Return s.ToLowerCase
End Sub

Private Sub ParseThemeLengthToDip(sValue As String, fDefaultDipValue As Float) As Float
	Dim s As String = sValue.ToLowerCase.Trim
	If s.Length = 0 Then Return fDefaultDipValue
	If s.EndsWith("px") Then
		Dim npx As String = s.SubString2(0, s.Length - 2).Trim
		If IsNumber(npx) Then Return npx * 1dip
		Return fDefaultDipValue
	End If
	If s.EndsWith("rem") Then
		Dim nrem As String = s.SubString2(0, s.Length - 3).Trim
		If IsNumber(nrem) Then Return nrem * 16 * 1dip
		Return fDefaultDipValue
	End If
	If s.EndsWith("em") Then
		Dim nem As String = s.SubString2(0, s.Length - 2).Trim
		If IsNumber(nem) Then Return nem * 16 * 1dip
		Return fDefaultDipValue
	End If
	If IsNumber(s) Then Return s * 1dip
	Return fDefaultDipValue
End Sub

Public Sub VariantList As String
	Return "none|neutral|primary|secondary|accent|info|success|warning|error"
End Sub

Public Sub NormalizeVariant(sName As String) As String
	If sName = Null Then Return "none"
	Dim v As String = sName.ToLowerCase.Trim
	If v.StartsWith("variant-") Then v = v.SubString(8)
	If v.StartsWith("badge-") Then v = v.SubString(6)
	If v = "" Then v = "none"
	Select Case v
		Case "none", "neutral", "primary", "secondary", "accent", "info", "success", "warning", "error"
			Return v
		Case Else
			Return "none"
	End Select
End Sub

Public Sub BuildVariantMap(iBackColor As Int, iTextColor As Int) As Map
	Dim vm As Map
	vm.Initialize
	vm.Put("back", iBackColor)
	vm.Put("text", iTextColor)
	vm.Put("muted", Blend(iTextColor, xui.Color_Gray, 0.35))
	Return vm
End Sub

Public Sub DefaultPalette As Map
	Return GetVariantPalette
End Sub

Public Sub ResolveVariantMap(mPalette As Map, sVariantName As String) As Map
	Dim pal As Map = IIf(mPalette.IsInitialized, mPalette, DefaultPalette)
	Dim key As String = NormalizeVariant(sVariantName)
	If pal.ContainsKey(key) Then Return pal.Get(key)
	If pal.ContainsKey("neutral") Then Return pal.Get("neutral")
	Return BuildVariantMap(0xFFE5E7EB, 0xFF111827)
End Sub

Public Sub ResolveVariantColor(mPalette As Map, sVariantName As String, sKey As String, iDefaultColor As Int) As Int
	Dim keyVariant As String = NormalizeVariant(sVariantName)
	'The explicit "none" variant means "don't apply a semantic palette color".
	If keyVariant = "none" Then Return iDefaultColor
	Dim vm As Map = ResolveVariantMap(mPalette, keyVariant)
	If vm.ContainsKey(sKey) Then
		Dim o As Object = vm.Get(sKey)
		If o <> Null Then Return o
	End If
	Return iDefaultColor
End Sub

' Resolves background color from either:
' 1) Daisy/Tailwind-like token strings (for example: bg-base-100, bg-base-content), or
' 2) semantic variant names (primary, success, etc).
' Token lookups are read from the active theme.
Public Sub ResolveBackgroundColorVariantFromPalette(mPalette As Map, sVariantOrToken As String, iDefaultColor As Int) As Int
	Return ResolveColorVariantFromPalette(mPalette, sVariantOrToken, "back", iDefaultColor)
End Sub

Public Sub ResolveTextColorVariantFromPalette(mPalette As Map, sVariantOrToken As String, iDefaultColor As Int) As Int
	Return ResolveColorVariantFromPalette(mPalette, sVariantOrToken, "text", iDefaultColor)
End Sub

Public Sub ResolveBorderColorVariantFromPalette(mPalette As Map, sVariantOrToken As String, iDefaultColor As Int) As Int
	Return ResolveColorVariantFromPalette(mPalette, sVariantOrToken, "border", iDefaultColor)
End Sub

Public Sub ResolveBackgroundColorVariant(sVariantOrToken As String, iDefaultColor As Int) As Int
	Return ResolveBackgroundColorVariantFromPalette(DefaultPalette, sVariantOrToken, iDefaultColor)
End Sub

Public Sub ResolveTextColorVariant(sVariantOrToken As String, iDefaultColor As Int) As Int
	Return ResolveTextColorVariantFromPalette(DefaultPalette, sVariantOrToken, iDefaultColor)
End Sub

''' Resolves a variant name to its text-[variant] color.
''' "primary" ? "text-primary" ? --color-primary (the variant hue itself, not -content).
''' Use this when the variant color is applied AS text color (e.g. ValueColor, FigureVariant).
Public Sub ResolveTextColor(sVariantName As String, iDefaultColor As Int) As Int
	If sVariantName = Null Then Return iDefaultColor
	Dim name As String = sVariantName.Trim
	If name.Length = 0 Or name = "none" Then Return iDefaultColor
	Dim token As String = ResolveThemeColorTokenName("text-" & name)
	If token.Length > 0 Then Return GetTokenColor(token, iDefaultColor)
	Return iDefaultColor
End Sub

Public Sub ResolveBorderColorVariant(sVariantOrToken As String, iDefaultColor As Int) As Int
	Return ResolveBorderColorVariantFromPalette(DefaultPalette, sVariantOrToken, iDefaultColor)
End Sub

Public Sub ResolveColorVariantFromPalette(mPalette As Map, sVariantOrToken As String, sPaletteKey As String, iDefaultColor As Int) As Int
	If sVariantOrToken = Null Then Return iDefaultColor
	Dim name As String = sVariantOrToken.Trim
	If name.Length = 0 Then Return iDefaultColor
	Dim normalizedName As String = name.ToLowerCase.Trim
	Dim keyName As String = sPaletteKey.ToLowerCase.Trim

	' "primary-text", "error-text", etc. ? variant's own hue (not -content).
	If normalizedName.EndsWith("-text") Then
		Dim baseName As String = normalizedName.SubString2(0, normalizedName.Length - 5)
		Return ResolveTextColor(baseName, iDefaultColor)
	End If

	' "link-success", "link-primary", etc. ? strip "link-" prefix ? variant hue.
	If normalizedName.StartsWith("link-") Then
		Dim baseName As String = normalizedName.SubString(5)
		Return ResolveTextColor(baseName, iDefaultColor)
	End If

	' "text-success", "text-primary", etc. ? strip "text-" prefix ? variant hue.
	If normalizedName.StartsWith("text-") Then
		Dim baseName As String = normalizedName.SubString(5)
		Return ResolveTextColor(baseName, iDefaultColor)
	End If

	' Semantic variants should resolve through the variant palette first.
	Select Case normalizedName
		Case "none", "neutral", "primary", "secondary", "accent", "info", "success", "warning", "error"
			If keyName = "border" Then keyName = "back"
			Return ResolveVariantColor(mPalette, normalizedName, keyName, iDefaultColor)
	End Select

	Dim token As String = ResolveThemeColorTokenName(name)
	If token.Length > 0 Then
		Return GetTokenColor(token, iDefaultColor)
	End If

	If keyName = "border" Then keyName = "back"
	Return ResolveVariantColor(mPalette, name, keyName, iDefaultColor)
End Sub

Public Sub ResolveOnlineColor(sVariantName As String, iDefaultColor As Int) As Int
	Return ResolveVariantColor(DefaultPalette, sVariantName, "back", iDefaultColor)
End Sub

Public Sub ResolveOfflineColor(sVariantName As String, iDefaultColor As Int) As Int
	Dim c As Int = ResolveOnlineColor(sVariantName, iDefaultColor)
	Return Blend(c, xui.Color_Gray, 0.55)
End Sub

Public Sub Blend(iC1 As Int, iC2 As Int, dT As Double) As Int
	Dim r1 As Int = Bit.And(Bit.ShiftRight(iC1, 16), 0xFF)
	Dim g1 As Int = Bit.And(Bit.ShiftRight(iC1, 8), 0xFF)
	Dim b1 As Int = Bit.And(iC1, 0xFF)
	Dim r2 As Int = Bit.And(Bit.ShiftRight(iC2, 16), 0xFF)
	Dim g2 As Int = Bit.And(Bit.ShiftRight(iC2, 8), 0xFF)
	Dim b2 As Int = Bit.And(iC2, 0xFF)
	Return xui.Color_RGB(r1 + (r2-r1)*dT, g1 + (g2-g1)*dT, b1 + (b2-b1)*dT)
End Sub

Public Sub ShadowList As String
	'Matches Daisy usage of Tailwind shadow utility levels.
	Return "none|xs|sm|md|lg|xl|2xl"
End Sub

Public Sub NormalizeShadow(sName As String) As String
	If sName = Null Then Return "none"
	Dim v As String = sName.ToLowerCase.Trim
	If v.StartsWith("shadow-") Then v = v.SubString(7)
	If v = "shadow" Then v = "sm"
	If v = "" Then v = "none"
	Select Case v
		Case "none", "xs", "sm", "md", "lg", "xl", "2xl"
			Return v
		Case Else
			Return "none"
	End Select
End Sub

Public Sub ResolveShadowElevation(sLevel As String) As Float
	'Android-style elevation approximation for Tailwind shadow levels.
	Select Case NormalizeShadow(sLevel)
		Case "none"
			Return 0
		Case "xs"
			Return 2dip
		Case "sm"
			Return 3dip
		Case "md"
			Return 4dip
		Case "lg"
			Return 8dip
		Case "xl"
			Return 12dip
		Case "2xl"
			Return 16dip
		Case Else
			Return 0
	End Select
End Sub

Public Sub ResolveShadowSpec(sLevel As String) As Map
	'Tailwind 4 shadow tokens used by Daisy utility classes (px units).
	Select Case NormalizeShadow(sLevel)
		Case "xs"
			Return BuildShadowSpec(1, 2, 0, 0.05, 0, 0, 0, 0)
		Case "sm"
			Return BuildShadowSpec(1, 3, 0, 0.10, 1, 2, -1, 0.10)
		Case "md"
			Return BuildShadowSpec(4, 6, -1, 0.10, 2, 4, -2, 0.10)
		Case "lg"
			Return BuildShadowSpec(10, 15, -3, 0.10, 4, 6, -4, 0.10)
		Case "xl"
			Return BuildShadowSpec(20, 25, -5, 0.10, 8, 10, -6, 0.10)
		Case "2xl"
			Return BuildShadowSpec(25, 50, -12, 0.25, 0, 0, 0, 0)
		Case Else
			Return BuildShadowSpec(0, 0, 0, 0, 0, 0, 0, 0)
	End Select
End Sub

Public Sub MaskList As String
	Return "circle|square|rounded-none|rounded-sm|rounded|rounded-md|rounded-lg|rounded-xl|rounded-2xl|rounded-3xl|rounded-full|squircle|decagon|diamond|heart|hexagon|hexagon-2|pentagon|star|star-2|triangle|triangle-2|triangle-3|triangle-4|half-1|half-2"
End Sub

Public Sub MaskListSimple As String
	Return "circle|square|squircle|decagon|diamond|heart|hexagon|hexagon-2|pentagon|star|star-2|triangle|triangle-2|triangle-3|triangle-4|half-1|half-2"
End Sub

Public Sub NormalizeMask(sMaskName As String) As String
	If sMaskName = Null Then Return "circle"
	Dim m As String = sMaskName.ToLowerCase.Trim
	If m.StartsWith("mask-") Then m = m.SubString(5)
	If m = "none" Then Return "rounded-none"
	Select Case m
		Case "circle", "square", "rounded-none", "rounded-sm", "rounded", "rounded-md", "rounded-lg", "rounded-xl", "rounded-2xl", "rounded-3xl", "rounded-full", "squircle", "decagon", "diamond", "heart", "hexagon", "hexagon-2", "pentagon", "star", "star-2", "triangle", "triangle-2", "triangle-3", "triangle-4", "half-1", "half-2"
			Return m
		Case Else
			Return "circle"
	End Select
End Sub

Public Sub CreateMaskPath(fSize As Float, sMaskName As String) As B4XPath
	Return CreateMaskPathRect(fSize, fSize, sMaskName)
End Sub

Public Sub CreateMaskPathRect(fWidth As Float, fHeight As Float, sMaskName As String) As B4XPath
	Dim r As B4XRect
	r.Initialize(0, 0, fWidth, fHeight)
	Return CreateMaskPathInRect(r, sMaskName)
End Sub

Public Sub CreateMaskPathInRect(rcTargetRect As B4XRect, sMaskName As String) As B4XPath
	Dim m As String = NormalizeMask(sMaskName)
	Dim s As Float = Min(rcTargetRect.Width, rcTargetRect.Height)
	Dim ox As Float = rcTargetRect.Left + (rcTargetRect.Width - s) / 2
	Dim oy As Float = rcTargetRect.Top + (rcTargetRect.Height - s) / 2
	Select Case m
		Case "circle"
			Dim r As B4XRect
			r.Initialize(ox, oy, ox + s, oy + s)
			Dim p As B4XPath
			p.InitializeOval(r)
			Return p
		Case "squircle"
			Return CreateDaisySquirclePathAt(s, ox, oy)
		Case "square"
			Return CreateRectPathAt(s, ox, oy)
		Case "rounded-none", "rounded-sm", "rounded", "rounded-md", "rounded-lg", "rounded-xl", "rounded-2xl", "rounded-3xl", "rounded-full"
			Dim rrRound As B4XRect
			rrRound.Initialize(rcTargetRect.Left, rcTargetRect.Top, rcTargetRect.Right, rcTargetRect.Bottom)
			Dim baseSize As Float = Min(rrRound.Width, rrRound.Height)
			If m = "rounded-full" Then
				Dim pFull As B4XPath
				pFull.InitializeRoundedRect(rrRound, baseSize / 2)
				Return pFull
			End If
			Dim radius As Float = ResolveRoundedRadiusDip(m, baseSize)
			If radius <= 0 Then
				Dim pRect As B4XPath
				pRect.Initialize(rrRound.Left, rrRound.Top)
				pRect.LineTo(rrRound.Right, rrRound.Top)
				pRect.LineTo(rrRound.Right, rrRound.Bottom)
				pRect.LineTo(rrRound.Left, rrRound.Bottom)
				pRect.LineTo(rrRound.Left, rrRound.Top)
				Return pRect
			End If
			Dim pRound As B4XPath
			pRound.InitializeRoundedRect(rrRound, radius)
			Return pRound
		Case "decagon", "diamond", "hexagon", "hexagon-2", "pentagon", "star", "star-2", "triangle", "triangle-2", "triangle-3", "triangle-4"
			Return CreateDaisyPolygonMaskAt(m, s, ox, oy)
		Case "heart"
			Return CreateDaisyHeartPathAt(s, ox, oy)
		Case "half-1"
			Return CreateHalfRectPathAt(s, True, ox, oy)
		Case "half-2"
			Return CreateHalfRectPathAt(s, False, ox, oy)
		Case Else
			Dim re As B4XRect
			re.Initialize(ox, oy, ox + s, oy + s)
			Dim pe As B4XPath
			pe.InitializeOval(re)
			Return pe
	End Select
End Sub

Public Sub ResolveRoundedRadiusDip(sMaskName As String, fSize As Float) As Float
	Select Case sMaskName
		Case "rounded-none"
			Return 0
		Case "rounded-sm"
			Return Min(fSize / 2, 2dip)
		Case "rounded"
			Return Min(fSize / 2, 4dip)
		Case "rounded-md"
			Return Min(fSize / 2, 6dip)
		Case "rounded-lg"
			Return Min(fSize / 2, 8dip)
		Case "rounded-xl"
			Return Min(fSize / 2, 12dip)
		Case "rounded-2xl"
			Return Min(fSize / 2, 16dip)
		Case "rounded-3xl"
			Return Min(fSize / 2, 24dip)
		Case "rounded-full"
			Return fSize / 2
		Case Else
			Return Min(fSize / 2, 4dip)
	End Select
End Sub

'Matches DaisyUI mask-squircle SVG path:
'M100 0C20 0 0 20 0 100s20 100 100 100 100-20 100-100S180 0 100 0Z
Private Sub CreateDaisySquirclePathAt(fSize As Float, fOffsetX As Float, fOffsetY As Float) As B4XPath
	Dim scale As Float = fSize / 200
	Dim p As B4XPath
	p.Initialize(fOffsetX + 100 * scale, fOffsetY)
	AppendCubicApprox(p, fOffsetX, fOffsetY, scale, 100, 0, 20, 0, 0, 20, 0, 100, 16)
	AppendCubicApprox(p, fOffsetX, fOffsetY, scale, 0, 100, 0, 180, 20, 200, 100, 200, 16)
	AppendCubicApprox(p, fOffsetX, fOffsetY, scale, 100, 200, 180, 200, 200, 180, 200, 100, 16)
	AppendCubicApprox(p, fOffsetX, fOffsetY, scale, 200, 100, 200, 20, 180, 0, 100, 0, 16)
	Return p
End Sub

'Matches DaisyUI mask-heart SVG path (viewBox 200x185).
Private Sub CreateDaisyHeartPathAt(fSize As Float, fOffsetX As Float, fOffsetY As Float) As B4XPath
	Dim sourceW As Float = 200
	Dim sourceH As Float = 185
	Dim scale As Float = Min(fSize / sourceW, fSize / sourceH)
	Dim renderW As Float = sourceW * scale
	Dim renderH As Float = sourceH * scale
	Dim x0 As Float = fOffsetX + (fSize - renderW) / 2
	Dim y0 As Float = fOffsetY + (fSize - renderH) / 2
	Dim p As B4XPath
	p.Initialize(x0 + 100 * scale, y0 + 184.606 * scale)

	AppendSvgArcApprox(p, x0, y0, scale, 100, 184.606, 15.384, 15.384, 0, 0, 1, 91.347, 181.928, 20)
	AppendCubicApprox(p, x0, y0, scale, 91.347, 181.928, 53.565, 156.28, 37.205, 138.695, 28.182, 127.7, 18)
	AppendCubicApprox(p, x0, y0, scale, 28.182, 127.7, 8.952, 104.264, -0.254, 80.202, 0.005, 54.146, 18)
	AppendCubicApprox(p, x0, y0, scale, 0.005, 54.146, 0.308, 24.287, 24.264, 0, 53.406, 0, 18)
	AppendCubicApprox(p, x0, y0, scale, 53.406, 0, 74.598, 0, 89.275, 11.937, 97.822, 21.879, 14)
	AppendSvgArcApprox(p, x0, y0, scale, 97.822, 21.879, 2.884, 2.884, 0, 0, 0, 102.178, 21.879, 10)
	AppendCubicApprox(p, x0, y0, scale, 102.178, 21.879, 110.725, 11.927, 125.402, 0, 146.594, 0, 14)
	AppendCubicApprox(p, x0, y0, scale, 146.594, 0, 175.736, 0, 199.692, 24.287, 199.994, 54.151, 18)
	AppendCubicApprox(p, x0, y0, scale, 199.994, 54.151, 200.254, 80.212, 191.038, 104.273, 171.818, 127.705, 18)
	AppendCubicApprox(p, x0, y0, scale, 171.818, 127.705, 162.795, 138.699, 146.435, 156.285, 108.653, 181.933, 18)
	AppendSvgArcApprox(p, x0, y0, scale, 108.653, 181.933, 15.384, 15.384, 0, 0, 1, 100, 184.606, 20)
	p.LineTo(x0 + 100 * scale, y0 + 184.606 * scale)
	Return p
End Sub

'Uses DaisyUI SVG geometry for polygon-style masks.
Private Sub CreateDaisyPolygonMaskAt(sMaskName As String, fSize As Float, fOffsetX As Float, fOffsetY As Float) As B4XPath
	Select Case sMaskName
		Case "decagon"
			Return CreateSvgPolygonPathAt(192, 200, Array As Float( _
				96,0, 154.779,19.098, 191.106,69.098, 191.106,130.902, 154.779,180.902, _
				96,200, 37.221,180.902, 0.894,130.902, 0.894,69.098, 37.221,19.098), fSize, fOffsetX, fOffsetY)
		Case "diamond"
			Return CreateSvgPolygonPathAt(200, 200, Array As Float(100,0, 200,100, 100,200, 0,100), fSize, fOffsetX, fOffsetY)
		Case "hexagon"
			Return CreateDaisyHexagonPathAt(fSize, fOffsetX, fOffsetY)
		Case "hexagon-2"
			Return CreateDaisyHexagon2PathAt(fSize, fOffsetX, fOffsetY)
		Case "pentagon"
			Return CreateSvgPolygonPathAt(192, 181, Array As Float(96,0, 191.106,69.098, 154.779,180.902, 37.22,180.902, 0.894,69.098), fSize, fOffsetX, fOffsetY)
		Case "star"
			Return CreateSvgPolygonPathAt(192, 180, Array As Float( _
				96,137.263, 37.221,179.287, 59.384,110.898, 0.894,68.481, 73.37,68.238, _
				96,0, 118.63,68.238, 191.106,68.481, 132.616,110.898, 154.779,179.287), fSize, fOffsetX, fOffsetY)
		Case "star-2"
			Return CreateSvgPolygonPathAt(192, 180, Array As Float( _
				96,153.044, 37.221,179.287, 44.241,115.774, 0.894,68.481, 64.011,55.471, _
				96,0, 127.989,55.472, 191.106,68.482, 147.759,115.774, 154.779,179.287), fSize, fOffsetX, fOffsetY)
		Case "triangle"
			Return CreateSvgPolygonPathAt(174, 149, Array As Float(87,148.476, 0.397,148.661, 43.86,74.423, 87,0, 130.14,74.423, 173.603,148.661), fSize, fOffsetX, fOffsetY)
		Case "triangle-2"
			Return CreateSvgPolygonPathAt(174, 150, Array As Float(87,0.738, 173.603,0.554, 130.14,74.792, 87,149.214, 43.86,74.792, 0.397,0.554), fSize, fOffsetX, fOffsetY)
		Case "triangle-3"
			Return CreateSvgPolygonPathAt(150, 174, Array As Float(149.369,87.107, 149.554,173.71, 75.315,130.247, 0.893,87.107, 75.315,43.967, 149.554,0.505), fSize, fOffsetX, fOffsetY)
		Case "triangle-4"
			Return CreateSvgPolygonPathAt(150, 174, Array As Float(0.631,87.107, 0.446,0.505, 74.685,43.967, 149.107,87.107, 74.685,130.247, 0.446,173.71), fSize, fOffsetX, fOffsetY)
		Case Else
			Return CreateRectPathAt(fSize, fOffsetX, fOffsetY)
	End Select
End Sub

'Matches DaisyUI mask-hexagon SVG path (viewBox 182x201).
Private Sub CreateDaisyHexagonPathAt(fSize As Float, fOffsetX As Float, fOffsetY As Float) As B4XPath
	Dim sourceW As Float = 182
	Dim sourceH As Float = 201
	Dim scale As Float = Min(fSize / sourceW, fSize / sourceH)
	Dim renderW As Float = sourceW * scale
	Dim renderH As Float = sourceH * scale
	Dim x0 As Float = fOffsetX + (fSize - renderW) / 2
	Dim y0 As Float = fOffsetY + (fSize - renderH) / 2

	Dim p As B4XPath
	p.Initialize(x0 + 0.3 * scale, y0 + 65.486 * scale)
	AppendCubicApprox(p, x0, y0, scale, 0.3,65.486, 0.3,56.29, 6.987,45.423, 14.511,40.408, 12)
	p.LineTo(x0 + 76.371 * scale, y0 + 4.462 * scale)
	AppendCubicApprox(p, x0, y0, scale, 76.371,4.462, 84.731,-0.554, 97.27,-0.554, 105.629,4.462, 12)
	p.LineTo(x0 + 167.489 * scale, y0 + 40.408 * scale)
	AppendCubicApprox(p, x0, y0, scale, 167.489,40.408, 175.849,45.423, 181.7,56.29, 181.7,65.486, 12)
	p.LineTo(x0 + 181.7 * scale, y0 + 136.541 * scale)
	AppendCubicApprox(p, x0, y0, scale, 181.7,136.541, 181.7,145.737, 175.013,156.604, 167.489,161.62, 12)
	p.LineTo(x0 + 105.629 * scale, y0 + 197.565 * scale)
	AppendCubicApprox(p, x0, y0, scale, 105.629,197.565, 97.269,201.745, 84.73,201.745, 76.371,197.565, 12)
	p.LineTo(x0 + 14.51 * scale, y0 + 161.62 * scale)
	AppendCubicApprox(p, x0, y0, scale, 14.51,161.62, 6.151,157.44, 0.3,145.737, 0.3,136.54, 12)
	p.LineTo(x0 + 0.3 * scale, y0 + 65.486 * scale)
	Return p
End Sub

'Matches DaisyUI mask-hexagon-2 SVG path (viewBox 200x182).
Private Sub CreateDaisyHexagon2PathAt(fSize As Float, fOffsetX As Float, fOffsetY As Float) As B4XPath
	Dim sourceW As Float = 200
	Dim sourceH As Float = 182
	Dim scale As Float = Min(fSize / sourceW, fSize / sourceH)
	Dim renderW As Float = sourceW * scale
	Dim renderH As Float = sourceH * scale
	Dim x0 As Float = fOffsetX + (fSize - renderW) / 2
	Dim y0 As Float = fOffsetY + (fSize - renderH) / 2

	Dim p As B4XPath
	p.Initialize(x0 + 64.786 * scale, y0 + 181.4 * scale)
	AppendCubicApprox(p, x0, y0, scale, 64.786,181.4, 55.59,181.4, 44.723,174.713, 39.707,167.19, 12)
	p.LineTo(x0 + 3.762 * scale, y0 + 105.33 * scale)
	AppendCubicApprox(p, x0, y0, scale, 3.762,105.33, -1.254,96.97, -1.254,84.43, 3.762,76.071, 12)
	p.LineTo(x0 + 39.707 * scale, y0 + 14.211 * scale)
	AppendCubicApprox(p, x0, y0, scale, 39.707,14.211, 44.723,5.851, 55.59,0, 64.786,0, 12)
	p.LineTo(x0 + 135.841 * scale, y0 + 0 * scale)
	AppendCubicApprox(p, x0, y0, scale, 135.841,0, 145.037,0, 155.904,6.688, 160.92,14.211, 12)
	p.LineTo(x0 + 196.865 * scale, y0 + 76.071 * scale)
	AppendCubicApprox(p, x0, y0, scale, 196.865,76.071, 201.045,84.431, 201.045,96.97, 196.865,105.329, 12)
	p.LineTo(x0 + 160.92 * scale, y0 + 167.189 * scale)
	AppendCubicApprox(p, x0, y0, scale, 160.92,167.189, 156.74,175.549, 145.037,181.4, 135.841,181.4, 12)
	p.LineTo(x0 + 64.786 * scale, y0 + 181.4 * scale)
	Return p
End Sub

Private Sub CreateSvgPolygonPathAt(fSourceWidth As Float, fSourceHeight As Float, oPoints() As Float, Size As Float, OffsetX As Float, OffsetY As Float) As B4XPath
	Dim scale As Float = Min(Size / fSourceWidth, Size / fSourceHeight)
	Dim renderW As Float = fSourceWidth * scale
	Dim renderH As Float = fSourceHeight * scale
	Dim x0 As Float = OffsetX + (Size - renderW) / 2
	Dim y0 As Float = OffsetY + (Size - renderH) / 2
	Dim p As B4XPath
	p.Initialize(x0 + oPoints(0) * scale, y0 + oPoints(1) * scale)
	For i = 2 To oPoints.Length - 1 Step 2
		p.LineTo(x0 + oPoints(i) * scale, y0 + oPoints(i + 1) * scale)
	Next
	p.LineTo(x0 + oPoints(0) * scale, y0 + oPoints(1) * scale)
	Return p
End Sub

'Approximates a cubic bezier segment with line segments for B4XPath.
Private Sub AppendCubicApprox(Path As B4XPath, OffsetX As Float, OffsetY As Float, Scale As Float, _
	X0 As Float, Y0 As Float, X1 As Float, Y1 As Float, X2 As Float, Y2 As Float, X3 As Float, Y3 As Float, Steps As Int)
	Dim n As Int = Max(4, Steps)
	For i = 1 To n
		Dim t As Double = i / n
		Dim u As Double = 1 - t
		Dim x As Double = u * u * u * X0 + 3 * u * u * t * X1 + 3 * u * t * t * X2 + t * t * t * X3
		Dim y As Double = u * u * u * Y0 + 3 * u * u * t * Y1 + 3 * u * t * t * Y2 + t * t * t * Y3
		Path.LineTo(OffsetX + x * Scale, OffsetY + y * Scale)
	Next
End Sub

'Approximates an SVG elliptical arc segment with line segments.
Private Sub AppendSvgArcApprox(Path As B4XPath, OffsetX As Float, OffsetY As Float, Scale As Float, _
	X0 As Float, Y0 As Float, Rx As Float, Ry As Float, XAxisRotDeg As Float, LargeArcFlag As Int, SweepFlag As Int, X1 As Float, Y1 As Float, Steps As Int)
	Dim rx0 As Double = Abs(Rx)
	Dim ry0 As Double = Abs(Ry)
	If rx0 = 0 Or ry0 = 0 Then
		Path.LineTo(OffsetX + X1 * Scale, OffsetY + Y1 * Scale)
		Return
	End If
	Dim phi As Double = XAxisRotDeg * cPI / 180
	Dim cosPhi As Double = Cos(phi)
	Dim sinPhi As Double = Sin(phi)
	Dim dx2 As Double = (X0 - X1) / 2
	Dim dy2 As Double = (Y0 - Y1) / 2
	Dim x1p As Double = cosPhi * dx2 + sinPhi * dy2
	Dim y1p As Double = -sinPhi * dx2 + cosPhi * dy2

	Dim lambda As Double = (x1p * x1p) / (rx0 * rx0) + (y1p * y1p) / (ry0 * ry0)
	If lambda > 1 Then
		Dim scaleUp As Double = Sqrt(lambda)
		rx0 = rx0 * scaleUp
		ry0 = ry0 * scaleUp
	End If

	Dim rx2 As Double = rx0 * rx0
	Dim ry2 As Double = ry0 * ry0
	Dim num As Double = rx2 * ry2 - rx2 * y1p * y1p - ry2 * x1p * x1p
	Dim den As Double = rx2 * y1p * y1p + ry2 * x1p * x1p
	Dim factor As Double = 0
	If den <> 0 Then factor = Sqrt(Max(0, num / den))
	If LargeArcFlag = SweepFlag Then factor = -factor
	Dim cxp As Double = factor * (rx0 * y1p / ry0)
	Dim cyp As Double = factor * (-ry0 * x1p / rx0)

	Dim cx As Double = cosPhi * cxp - sinPhi * cyp + (X0 + X1) / 2
	Dim cy As Double = sinPhi * cxp + cosPhi * cyp + (Y0 + Y1) / 2

	Dim ux As Double = (x1p - cxp) / rx0
	Dim uy As Double = (y1p - cyp) / ry0
	Dim vx As Double = (-x1p - cxp) / rx0
	Dim vy As Double = (-y1p - cyp) / ry0

	Dim theta1 As Double = ATan2(uy, ux)
	Dim delta As Double = ATan2(ux * vy - uy * vx, ux * vx + uy * vy)
	If SweepFlag = 0 And delta > 0 Then delta = delta - 2 * cPI
	If SweepFlag = 1 And delta < 0 Then delta = delta + 2 * cPI

	Dim n As Int = Max(6, Steps)
	For i = 1 To n
		Dim t As Double = theta1 + delta * i / n
		Dim ct As Double = Cos(t)
		Dim st As Double = Sin(t)
		Dim x As Double = cx + cosPhi * rx0 * ct - sinPhi * ry0 * st
		Dim y As Double = cy + sinPhi * rx0 * ct + cosPhi * ry0 * st
		Path.LineTo(OffsetX + x * Scale, OffsetY + y * Scale)
	Next
End Sub

Private Sub CreateRectPathAt(fSize As Float, fOffsetX As Float, fOffsetY As Float) As B4XPath
	Dim p As B4XPath
	p.Initialize(fOffsetX, fOffsetY)
	p.LineTo(fOffsetX + fSize, fOffsetY)
	p.LineTo(fOffsetX + fSize, fOffsetY + fSize)
	p.LineTo(fOffsetX, fOffsetY + fSize)
	p.LineTo(fOffsetX, fOffsetY)
	Return p
End Sub

Private Sub CreateHalfRectPathAt(fSize As Float, bLeftHalf As Boolean, fOffsetX As Float, fOffsetY As Float) As B4XPath
	Dim x0 As Float = fOffsetX + IIf(bLeftHalf, 0, fSize / 2)
	Dim x1 As Float = fOffsetX + IIf(bLeftHalf, fSize / 2, fSize)
	Dim y0 As Float = fOffsetY
	Dim y1 As Float = fOffsetY + fSize
	Dim p As B4XPath
	p.Initialize(x0, y0)
	p.LineTo(x1, y0)
	p.LineTo(x1, y1)
	p.LineTo(x0, y1)
	p.LineTo(x0, y0)
	Return p
End Sub

' -
' Universal canvas clipping / view overflow utilities.
' Components should call these instead of duplicating native
' save/clipPath/restore and setClipChildren logic.
' -

' Clips a B4XCanvas to the shape defined by MaskName inside TargetRect.
' Call RestoreCanvasClip when done drawing to remove the clip.
' Returns True if the clip was applied, False if not (unsupported platform).
Public Sub ClipCanvasToShape(cvsCvs As B4XCanvas, rcTargetRect As B4XRect, sMaskName As String) As Boolean
	#If B4A
	' 1. Create the mask path
	Dim maskPath As B4XPath = CreateMaskPathInRect(rcTargetRect, sMaskName)
	
	' 2. Extract the native android.graphics.Path from the B4XPath wrapper
	Dim joPath As JavaObject = maskPath
	Dim nativePath As JavaObject = joPath.RunMethod("getObject", Null)
	
	' 3. Drill down: B4XCanvas ? B4A Canvas ? android.graphics.Canvas
	Dim jo As JavaObject = cvsCvs
	Dim b4aCanvas As JavaObject = jo.GetFieldJO("cvs")
	Dim nativeCanvas As JavaObject = b4aCanvas.GetFieldJO("canvas")
	
	' 4. Save and clip
	nativeCanvas.RunMethod("save", Null)
	nativeCanvas.RunMethod("clipPath", Array(nativePath))
	Return True
	#Else
	Dim ignoreCvs As Object = cvsCvs
	Dim ignoreRect As Object = rcTargetRect
	Dim ignoreMask As String = sMaskName
	Return False
	#End If
End Sub

' Restores the canvas state after a ClipCanvasToShape call.
' Must be called to undo the clip applied by ClipCanvasToShape.
Public Sub RestoreCanvasClip(cvsCvs As B4XCanvas)
	#If B4A
	Dim jo As JavaObject = cvsCvs
	Dim b4aCanvas As JavaObject = jo.GetFieldJO("cvs")
	Dim nativeCanvas As JavaObject = b4aCanvas.GetFieldJO("canvas")
	nativeCanvas.RunMethod("restore", Null)
	#Else
	Dim ignoreCvs As Object = cvsCvs
	#End If
End Sub

' Disables clip-children and clip-to-padding on a B4XView,
' allowing child views or canvas drawings to overflow its bounds
' (e.g. pulse animations, status indicators, drop shadows).
Public Sub DisableViewClipping(vView As B4XView)
	#If B4A
	Dim jo As JavaObject = vView
	jo.RunMethod("setClipChildren", Array(False))
	jo.RunMethod("setClipToPadding", Array(False))
	#Else
	Dim ignore As Object = vView
	#End If
End Sub

' Enables view-level shaped clipping (CSS overflow:hidden with a shape).
' Uses Android's ViewOutlineProvider + setClipToOutline to clip ALL children
' to the specified shape. This is the true overflow:hidden for non-rectangular bounds.
' NOTE: Android OutlineProvider only supports oval and rounded-rect shapes.
'       Complex masks (heart, hexagon, star etc.) are NOT supported at view level.
'       For those, use ClipCanvasToShape at the canvas drawing level instead.
Public Sub EnableShapedClipping(vView As B4XView, sMaskName As String)
	#If B4A
	Dim m As String = NormalizeMask(sMaskName)
	Dim jo As JavaObject = vView
	
	Select Case m
		Case "circle", "rounded-full"
			' Oval outline provider ? clips to a perfect circle/ellipse
			Dim provider As JavaObject
			provider.InitializeNewInstance("anywheresoftware.b4a.objects.CustomViewWrapper.OvalOutlineProvider", Null)
			jo.RunMethod("setOutlineProvider", Array(provider))
			jo.RunMethod("setClipToOutline", Array(True))
		Case "rounded-none", "square"
			' Rectangular ? just use default clip
			jo.RunMethod("setClipToOutline", Array(False))
		Case "rounded-sm", "rounded", "rounded-md", "rounded-lg", "rounded-xl", "rounded-2xl", "rounded-3xl"
			' Rounded-rect outline via corner radius
			Dim size As Float = Min(vView.Width, vView.Height)
			Dim radius As Float = ResolveRoundedRadiusDip(m, size)
			' Use background-based outline: set a rounded GradientDrawable,
			' Android will derive the outline from it automatically
			Dim gd As JavaObject
			gd.InitializeNewInstance("android.graphics.drawable.GradientDrawable", Null)
			gd.RunMethod("setCornerRadius", Array(radius))
			gd.RunMethod("setColor", Array(0))  ' Transparent ? we only want the outline shape
			jo.RunMethod("setBackground", Array(gd))
			jo.RunMethod("setClipToOutline", Array(True))
		Case Else
			' Complex masks (squircle, heart, hexagon etc.)
			' Android OutlineProvider cannot clip to arbitrary paths.
			' Caller should use ClipCanvasToShape for these instead.
			jo.RunMethod("setClipToOutline", Array(False))
	End Select
	#Else
	Dim ignore As Object = vView
	Dim ignoreMask As String = sMaskName
	#End If
End Sub

' Disables any previously applied shaped clipping on a view.
' Resets to Android's default rectangular clip behavior.
Public Sub DisableShapedClipping(vView As B4XView)
	#If B4A
	Dim jo As JavaObject = vView
	jo.RunMethod("setClipToOutline", Array(False))
	#Else
	Dim ignore As Object = vView
	#End If
End Sub

' Sets the line spacing multiple (line-height) for a view (Android TextView).
' Multiple: 1.0 is default, 1.5 is standard DaisyUI spacing.
' Add: extra pixels to add between lines (usually 0).
' Includes parity fix: setIncludeFontPadding(False) to remove Android's top/bottom spacing.
Public Sub SetLineSpacing(vView As B4XView, fMultiple As Float, fAdd As Float)
	#If B4A
	' Guard: only TextView/Label supports setIncludeFontPadding and setLineSpacing.
	' Panels (BALayout) do not. Use Try/Catch so callers passing a Panel are silently ignored.
	Try
		Dim jo As JavaObject = vView
		jo.RunMethod("setIncludeFontPadding", Array(False))
		jo.RunMethod("setLineSpacing", Array(fAdd, fMultiple))
	Catch
		' View is not a TextView - skip line spacing silently.
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyVariants.SetLineSpacing: " & LastException.Message)
	End Try				'ignore
	#Else
	Dim ignoreV As Object = vView
	Dim ignoreM As Float = fMultiple
	Dim ignoreA As Float = fAdd
	#End If
End Sub

Private Sub BuildShadowSpec(fY1 As Float, fBlur1 As Float, fSpread1 As Float, dAlpha1 As Double, fY2 As Float, fBlur2 As Float, fSpread2 As Float, dAlpha2 As Double) As Map
	Dim m As Map
	m.Initialize
	m.Put("y1", fY1)
	m.Put("blur1", fBlur1)
	m.Put("spread1", fSpread1)
	m.Put("alpha1", dAlpha1)
	m.Put("y2", fY2)
	m.Put("blur2", fBlur2)
	m.Put("spread2", fSpread2)
	m.Put("alpha2", dAlpha2)
	Return m
End Sub

Public Sub NormalizeDateTimeFormat(sValue As String, sDefaultFlatpickrFormat As String) As String
	Dim fallback As String = "D, j M Y H:i"
	If sDefaultFlatpickrFormat <> Null Then
		Dim candidate As String = sDefaultFlatpickrFormat.Trim
		If candidate.Length > 0 Then fallback = candidate
	End If
	If sValue = Null Then Return ConvertFlatpickrToDateFormat(fallback)
	Dim v As String = sValue.Trim
	If v.Length = 0 Then Return ConvertFlatpickrToDateFormat(fallback)
	If LooksLikeJavaDateFormat(v) Then Return v
	Dim converted As String = ConvertFlatpickrToDateFormat(v)
	If converted.Length = 0 Then Return ConvertFlatpickrToDateFormat(fallback)
	Return converted
End Sub

Public Sub FormatDateTime(sFormatText As String, lValueMillis As Long) As String
	Dim normalized As String = NormalizeDateTimeFormat(sFormatText, "D, j M Y H:i")
	Dim prevFormat As String = DateTime.DateFormat
	DateTime.DateFormat = normalized
	Dim result As String = DateTime.Date(lValueMillis)
	DateTime.DateFormat = prevFormat
	If result.Contains(FLATPICKR_UNIX_PLACEHOLDER) Then
		Dim unixSeconds As Long = lValueMillis / DateTime.TicksPerSecond
		result = result.Replace(FLATPICKR_UNIX_PLACEHOLDER, unixSeconds)
	End If
	Return result
End Sub

Public Sub LooksLikeJavaDateFormat(sFormatText As String) As Boolean
	Dim f As String = sFormatText
	If f.Contains("yyyy") Or f.Contains("yyy") Then Return True
	If f.Contains("yy") Then Return True
	If f.Contains("MMMM") Or f.Contains("MMM") Or f.Contains("MM") Then Return True
	If f.Contains("dd") Then Return True
	If f.Contains("HH") Or f.Contains("hh") Then Return True
	If f.Contains("mm") Or f.Contains("ss") Then Return True
	If f.Contains("EEE") Then Return True
	Return False
End Sub

Public Sub ConvertFlatpickrToDateFormat(sFormatText As String) As String
	If sFormatText = Null Then Return ""
	Dim sb As StringBuilder
	sb.Initialize
	Dim inLiteral As Boolean = False
	Dim escaped As Boolean = False
	For i = 0 To sFormatText.Length - 1
		Dim ch As String = sFormatText.CharAt(i)
		If escaped Then
			If inLiteral = False Then
				sb.Append("'")
				inLiteral = True
			End If
			If ch = "'" Then sb.Append("''") Else sb.Append(ch)
			escaped = False
			Continue
		End If
		If ch = "\" Then
			escaped = True
			Continue
		End If
		Dim mapped As String = FlatpickrTokenToDateToken(ch)
		If mapped.Length > 0 Then
			If inLiteral Then
				sb.Append("'")
				inLiteral = False
			End If
			sb.Append(mapped)
		Else
			If IsAsciiLetter(ch) Then
				If inLiteral = False Then
					sb.Append("'")
					inLiteral = True
				End If
				If ch = "'" Then sb.Append("''") Else sb.Append(ch)
			Else
				If inLiteral Then
					sb.Append("'")
					inLiteral = False
				End If
				If ch = "'" Then sb.Append("''") Else sb.Append(ch)
			End If
		End If
	Next
	If inLiteral Then sb.Append("'")
	Return sb.ToString
End Sub

Private Sub FlatpickrTokenToDateToken(sToken As String) As String
	Select Case sToken
		Case "d"
			Return "dd"
		Case "D"
			Return "EEE"
		Case "j"
			Return "d"
		Case "l"
			Return "EEEE"
		Case "F"
			Return "MMMM"
		Case "m"
			Return "MM"
		Case "n"
			Return "M"
		Case "M"
			Return "MMM"
		Case "y"
			Return "yy"
		Case "Y"
			Return "yyyy"
		Case "H"
			Return "HH"
		Case "h"
			Return "hh"
		Case "G"
			Return "H"
		Case "i"
			Return "mm"
		Case "S"
			Return "ss"
		Case "K"
			Return "a"
		Case "w"
			Return "u"
		Case "J"
			Return "d"
		Case "U"
			Return "'" & FLATPICKR_UNIX_PLACEHOLDER & "'"
		Case Else
			Return ""
	End Select
End Sub

Private Sub IsAsciiLetter(sCh As String) As Boolean
	If sCh.Length = 0 Then Return False
	Dim c As Int = Asc(sCh)
	Return (c >= 65 And c <= 90) Or (c >= 97 And c <= 122)
End Sub

Public Sub GetPropString(mProps As Map, sKey As String, sDefaultValue As String) As String
	If mProps.IsInitialized = False Then Return sDefaultValue
	If mProps.ContainsKey(sKey) = False Then Return sDefaultValue
	Dim o As Object = mProps.Get(sKey)
	If o = Null Then Return sDefaultValue
	Return o
End Sub

Public Sub GetPropFloat(mProps As Map, sKey As String, fDefaultValue As Float) As Float
	If mProps.IsInitialized = False Then Return fDefaultValue
	If mProps.ContainsKey(sKey) = False Then Return fDefaultValue
	Dim o As Object = mProps.Get(sKey)
	If o = Null Then Return fDefaultValue
	Try
		If IsNumber(o) Then Return o
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyVariants.GetPropFloat: " & LastException.Message)
	End Try			'ignore
	Try
		Dim s As String = "" & o
		Return ParseCssLengthToPx(s, fDefaultValue)
	Catch
		Return fDefaultValue
	End Try
End Sub

Public Sub GetPropInt(mProps As Map, sKey As String, iDefaultValue As Int) As Int
	If mProps.IsInitialized = False Then Return iDefaultValue
	If mProps.ContainsKey(sKey) = False Then Return iDefaultValue
	Dim o As Object = mProps.Get(sKey)
	If o = Null Then Return iDefaultValue
	Try
		If IsNumber(o) Then Return o
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyVariants.GetPropInt: " & LastException.Message)
	End Try			'ignore
	Try
		Dim s As String = "" & o
		Return ParseCssLengthToPx(s, iDefaultValue)
	Catch
		Return iDefaultValue
	End Try
End Sub

Public Sub GetPropLong(mProps As Map, sKey As String, lDefaultValue As Long) As Long
    If mProps.IsInitialized = False Then Return lDefaultValue
    If mProps.ContainsKey(sKey) = False Then Return lDefaultValue
    Dim o As Object = mProps.Get(sKey)
    If o = Null Then Return lDefaultValue
    Try
        If IsNumber(o) Then Return o
    Catch
        If B4XDaisyApp.DebugLogs Then Log("B4XDaisyVariants.GetPropLong: " & LastException.Message)
    End Try
    Return lDefaultValue
End Sub

Public Sub GetPropBool(mProps As Map, sKey As String, bDefaultValue As Boolean) As Boolean
	If mProps.IsInitialized = False Then Return bDefaultValue
	If mProps.ContainsKey(sKey) = False Then Return bDefaultValue
	Dim o As Object = mProps.Get(sKey)
	If o = Null Then Return bDefaultValue
	Return o
End Sub

Public Sub GetPropColor(mProps As Map, sKey As String, iDefaultValue As Int) As Int
	' Safely handle numeric colors and string tokens without causing a ClassCastException.
	If mProps.IsInitialized = False Then Return iDefaultValue
	If mProps.ContainsKey(sKey) = False Then Return iDefaultValue
	Dim o As Object = mProps.Get(sKey)
	Return ResolveColorValue(o, iDefaultValue)
End Sub

Sub ResolveColorValue(oValue As Object, iDefaultColor As Int) As Int
	If oValue = Null Then Return iDefaultColor
	If IsNumber(oValue) Then
		Dim c As Int = oValue
		' In B4X Designer, 0x00FFFFFF = 16777215 (transparent white) which is often used as default value for color properties.
		' If c is 0x00FFFFFF or 0, return DefaultColor unless DefaultColor was meant to be overwritten.
		If c = 0x00FFFFFF Or c = 0 Then Return iDefaultColor
		Return c
	End If
	Dim s As String = oValue
	s = s.Trim
	If s.Length = 0 Then Return iDefaultColor
	Return ResolveUtilityColor(s, iDefaultColor)
End Sub



Public Sub GetPropDip(mProps As Map, sKey As String, fDefaultDip As Float) As Float
	If mProps.IsInitialized = False Then Return fDefaultDip
	If mProps.ContainsKey(sKey) = False Then Return fDefaultDip
	Dim o As Object = mProps.Get(sKey)
	Return TailwindSizeToDip(o, fDefaultDip)
End Sub

Public Sub GetPropSizeDip(mProps As Map, sKey As String, oDefaultDip As Object) As Float
	' Accept either a numeric default or a size token string (e.g. "full", "12", "w-40").
	Dim def As Float
	If oDefaultDip = Null Then
		def = 0
	Else If IsNumber(oDefaultDip) Then
		def = oDefaultDip
	Else
		def = TailwindSizeToDip(oDefaultDip, 0)
	End If
	Return GetPropDip(mProps, sKey, def)
End Sub

Public Sub TailwindSizeToPx(oValue As Object, fDefaultPx As Float) As Float
	If oValue = Null Then Return Max(0, fDefaultPx)
	If oValue Is String Then
		Dim raw As String = oValue
		Dim s As String = raw.ToLowerCase.Trim
		If s.Length = 0 Then Return Max(0, fDefaultPx)
		
		'Accept class-like tokens: w-12, h-12, size-12.
		If s.StartsWith("w-") Or s.StartsWith("h-") Or s.StartsWith("size-") Then
			Dim p As Int = s.LastIndexOf("-")
			If p >= 0 And p < s.Length - 1 Then s = s.SubString(p + 1)
		End If
	
		'Accept bracket notation: [80px], [5rem], [12]
		If s.StartsWith("[") And s.EndsWith("]") And s.Length > 2 Then
			s = s.SubString2(1, s.Length - 1).Trim
		End If
	
		If s = "full" Or s = "screen" Then s = "100%"
		If s = "auto" Then Return Max(0, fDefaultPx)
	
		' Fractional tokens: 1/2, 1/3, 2/3, 3/4, etc.
		If s.Contains("/") Then
			Dim fracParts() As String = Regex.Split("/", s)
			If fracParts.Length = 2 Then
				Dim fracNum As Double = ParseCssNumber(fracParts(0).Trim, -1)
				Dim fracDen As Double = ParseCssNumber(fracParts(1).Trim, -1)
				If fracNum >= 0 And fracDen > 0 Then Return Max(0, fDefaultPx * fracNum / fracDen)
			End If
		End If
	
		If s.EndsWith("%") Then
			Dim pctText As String = s.SubString2(0, s.Length - 1).Trim
			Dim npct As Double = ParseCssNumber(pctText, -1)
			If npct >= 0 Then Return Max(0, fDefaultPx * npct / 100)
			Return Max(0, fDefaultPx)
		End If
	
		If s.EndsWith("dip") Then
			Dim ndip As Double = ParseCssNumber(s.SubString2(0, s.Length - 3), -1)
			If ndip >= 0 Then Return ndip
			Return Max(0, fDefaultPx)
		End If
	
		If s.EndsWith("px") Then
			Dim npx As Double = ParseCssNumber(s.SubString2(0, s.Length - 2), -1)
			If npx >= 0 Then Return npx
			Return Max(0, fDefaultPx)
		End If
	
		If s.EndsWith("rem") Then
			Dim nrem As Double = ParseCssNumber(s.SubString2(0, s.Length - 3), -1)
			If nrem >= 0 Then Return nrem * CSS_BASE_FONT_PX
			Return Max(0, fDefaultPx)
		End If
	
		If s.EndsWith("em") Then
			Dim nem As Double = ParseCssNumber(s.SubString2(0, s.Length - 2), -1)
			If nem >= 0 Then Return nem * CSS_BASE_FONT_PX
			Return Max(0, fDefaultPx)
		End If
	
		'Bare numbers in strings are Tailwind spacing tokens: "12" -> 12 * 0.25rem -> 48px.
		Dim ntw As Double = ParseCssNumber(s, -1)
		If ntw >= 0 Then Return ntw * TW_SPACE_STEP_PX
		Return Max(0, fDefaultPx)
	Else If IsNumber(oValue) Then
		'If the value is already a numeric type (Int/Float from a variable), treat it as a literal pixel/dip value.
		Dim pf As Float = oValue
		Return Max(0, pf)
	End If
	Return Max(0, fDefaultPx)
End Sub

Public Sub TailwindSizeToDip(oValue As Object, fDefaultDip As Float) As Float
	Dim defaultPx As Float = Max(0, fDefaultDip / 1dip)
	Dim px As Float = TailwindSizeToPx(oValue, defaultPx)
	Return px * 1dip
End Sub

' Resolves Tailwind spacing values (including gap tokens) to pixels.
' Supports: px, rem, em, %, bracket notation, bare scale numbers, and utility prefixes.
Public Sub TailwindSpacingToPx(oValue As Object, fDefaultPx As Float) As Float
	If oValue = Null Then Return Max(0, fDefaultPx)

	Dim raw As String = oValue
	Dim s As String = raw.ToLowerCase.Trim
	If s.Length = 0 Then Return Max(0, fDefaultPx)

	Dim token As String = NormalizeSpacingValueToken(s)
	If token.Length = 0 Then Return Max(0, fDefaultPx)

	' Tailwind spacing special token.
	If token = "px" Then Return 1

	' Accept bracket notation: [80px], [5rem], [12]
	If token.StartsWith("[") And token.EndsWith("]") And token.Length > 2 Then
		token = token.SubString2(1, token.Length - 1).Trim
	End If

	If token.EndsWith("%") Then
		Dim npct As Double = ParseCssNumber(token.SubString2(0, token.Length - 1), -1)
		If npct >= 0 Then Return Max(0, fDefaultPx * npct / 100)
		Return Max(0, fDefaultPx)
	End If
	If token.EndsWith("px") Then
		Dim npx As Double = ParseCssNumber(token.SubString2(0, token.Length - 2), -1)
		If npx >= 0 Then Return npx
		Return Max(0, fDefaultPx)
	End If
	If token.EndsWith("rem") Then
		Dim nrem As Double = ParseCssNumber(token.SubString2(0, token.Length - 3), -1)
		If nrem >= 0 Then Return nrem * CSS_BASE_FONT_PX
		Return Max(0, fDefaultPx)
	End If
	If token.EndsWith("em") Then
		Dim nem As Double = ParseCssNumber(token.SubString2(0, token.Length - 2), -1)
		If nem >= 0 Then Return nem * CSS_BASE_FONT_PX
		Return Max(0, fDefaultPx)
	End If

	' Bare numbers follow Tailwind v4 spacing: calc(var(--spacing) * n).
	Dim n As Double = ParseCssNumber(token, -1)
	If n >= 0 Then Return n * ResolveSpacingStepPx
	Return Max(0, fDefaultPx)
End Sub

Public Sub TailwindSpacingToDip(oValue As Object, fDefaultDip As Float) As Float
	Dim defaultPx As Float = Max(0, fDefaultDip / 1dip)
	Dim px As Float = TailwindSpacingToPx(oValue, defaultPx)
	Return px * 1dip
End Sub

Public Sub TailwindGapToDip(oValue As Object, fDefaultDip As Float) As Float
	Return TailwindSpacingToDip(oValue, fDefaultDip)
End Sub

' Parses utility strings like "gap-2", "gap-x-4", "gap-y-1.5".
' Returns map keys: gap_x, gap_y, gap.
Public Sub ParseGapUtilities(sUtilities As String, fDefaultGapDip As Float) As Map
	Dim gx As Float = Max(0, fDefaultGapDip)
	Dim gy As Float = Max(0, fDefaultGapDip)
	Dim m As Map
	m.Initialize

	Dim raw As String = IIf(sUtilities = Null, "", sUtilities.Trim)
	If raw.Length = 0 Then
		m.Put("gap_x", gx)
		m.Put("gap_y", gy)
		m.Put("gap", (gx + gy) / 2)
		Return m
	End If

	Dim tokens() As String = Regex.Split("\s+", raw)
	For Each t As String In tokens
		Dim u As String = t.ToLowerCase.Trim
		If u.StartsWith("gap-x-") Then
			gx = TailwindSpacingToDip(u.SubString(6), gx)
		Else If u.StartsWith("gap-y-") Then
			gy = TailwindSpacingToDip(u.SubString(6), gy)
		Else If u.StartsWith("gap-") Then
			Dim gv As Float = TailwindSpacingToDip(u.SubString(4), (gx + gy) / 2)
			gx = gv
			gy = gv
		End If
	Next

	m.Put("gap_x", gx)
	m.Put("gap_y", gy)
	m.Put("gap", (gx + gy) / 2)
	Return m
End Sub

Public Sub BorderStyleList As String
	Return "solid|dashed|dotted|double|hidden|none"
End Sub

' Resolves Tailwind border width tokens (v4-friendly) to dip.
' Supports: border, border-2, border-[3px], border-[0.125rem], border-px, bare numeric values.
Public Sub TailwindBorderWidthToDip(oValue As Object, fDefaultDip As Float) As Float
	If oValue = Null Then Return Max(0, fDefaultDip)
	Dim raw As String = oValue
	Dim s As String = NormalizeUtilityToken(raw.ToLowerCase.Trim)
	If s.Length = 0 Then Return Max(0, fDefaultDip)

	If s = "border" Then Return Max(0, GetBorderDip(IIf(fDefaultDip > 0, fDefaultDip, 1dip)))
	If s.StartsWith("border-") Then
		Dim rest As String = s.SubString(7)
		Dim sideParsed As Map = ParseBorderSideScope(rest)
		If sideParsed.GetDefault("has_scope", False) Then rest = sideParsed.GetDefault("value", "")
		If rest.Length = 0 Then Return Max(0, GetBorderDip(IIf(fDefaultDip > 0, fDefaultDip, 1dip)))
		s = rest
	End If

	If s = "px" Then Return 1dip
	If s = "thin" Then Return 1dip
	If s = "medium" Then Return 3dip
	If s = "thick" Then Return 5dip

	If s.StartsWith("[") And s.EndsWith("]") And s.Length > 2 Then
		s = s.SubString2(1, s.Length - 1).Trim
		If s.StartsWith("length:") Then s = s.SubString(7).Trim
	End If
	If s.StartsWith("(") And s.EndsWith(")") And s.Length > 2 Then
		s = s.SubString2(1, s.Length - 1).Trim
		If s.StartsWith("length:") Then s = s.SubString(7).Trim
	End If
	If s.Contains("--border") Then Return Max(0, GetBorderDip(IIf(fDefaultDip > 0, fDefaultDip, 1dip)))
	If s.StartsWith("--") Then Return Max(0, GetTokenDip(s, fDefaultDip))

	Dim px As Float = ParseCssLengthToPx(s, -1)
	If px >= 0 Then Return Max(0, px * 1dip)
	Return Max(0, fDefaultDip)
End Sub

' Resolves Tailwind rounded tokens to dip.
' Supports: rounded, rounded-sm/md/lg/xl/2xl/3xl/4xl/full/none, rounded-[10px], and Daisy rounded-box|field|selector.
Public Sub TailwindBorderRadiusToDip(oValue As Object, fDefaultDip As Float) As Float
	If oValue = Null Then Return Max(0, fDefaultDip)
	Dim raw As String = oValue
	Dim s As String = NormalizeUtilityToken(raw.ToLowerCase.Trim)
	If s.Length = 0 Then Return Max(0, fDefaultDip)
	If s.StartsWith("rounded-") Then s = s.SubString(8)

	Select Case s
		Case "", "default"
			Return 4dip
		Case "none"
			Return 0
		Case "sm"
			Return 2dip
		Case "md"
			Return 6dip
		Case "lg"
			Return 8dip
		Case "xl"
			Return 12dip
		Case "2xl"
			Return 16dip
		Case "3xl"
			Return 24dip
		Case "4xl"
			Return 32dip
		Case "full"
			Return 9999dip
		Case "box"
			Return Max(0, GetRadiusBoxDip(IIf(fDefaultDip > 0, fDefaultDip, 8dip)))
		Case "field"
			Return Max(0, GetRadiusFieldDip(IIf(fDefaultDip > 0, fDefaultDip, 6dip)))
		Case "selector"
			Return Max(0, GetRadiusSelectorDip(IIf(fDefaultDip > 0, fDefaultDip, 4dip)))
	End Select

	If s.StartsWith("[") And s.EndsWith("]") And s.Length > 2 Then
		s = s.SubString2(1, s.Length - 1).Trim
		If s.StartsWith("length:") Then s = s.SubString(7).Trim
	End If
	Dim px As Float = ParseCssLengthToPx(s, -1)
	If px >= 0 Then Return Max(0, px * 1dip)
	Return Max(0, fDefaultDip)
End Sub

' Resolves Tailwind border color tokens (including optional /opacity suffix) to a B4X color.
' Supports Daisy theme tokens, variant names, hex/rgb/rgba, common color names, and Tailwind hue-shade names.
Public Sub TailwindBorderColorToColor(sValue As String, iDefaultColor As Int) As Int
	If sValue = Null Then Return iDefaultColor
	Dim token As String = NormalizeUtilityToken(sValue.ToLowerCase.Trim)
	If token.Length = 0 Then Return iDefaultColor

	If token.StartsWith("border-") Then token = token.SubString(7)
	Dim scopeInfo As Map = ParseBorderSideScope(token)
	If scopeInfo.GetDefault("has_scope", False) Then token = scopeInfo.GetDefault("value", "")
	If token.Length = 0 Then Return iDefaultColor

	Return ResolveUtilityColorWithOpacity(token, iDefaultColor)
End Sub

' Parses utility strings such as:
' border, border-2, border-x-4, border-t, border-s, border-[3px],
' border-solid|dashed|dotted|double|hidden|none,
' border-primary/30, border-[#1f2937]/50, border-red-500,
' rounded, rounded-lg, rounded-t-md, rounded-ss-xl, rounded-[12px], rounded-t-box.
' Returns a map with width/color/style for all sides and corner radii.
Public Sub ParseBorderUtilities(sUtilities As String, fDefaultBorderDip As Float, iDefaultBorderColor As Int, fDefaultRadiusDip As Float, bRtlEnabled As Boolean) As Map
	Dim spec As Map = CreateDefaultBorderSpec(fDefaultBorderDip, iDefaultBorderColor, fDefaultRadiusDip)
	Dim raw As String = IIf(sUtilities = Null, "", sUtilities.Trim)
	If raw.Length = 0 Then Return spec

	Dim hasUtility As Boolean = False
	Dim parts() As String = Regex.Split("\s+", raw)
	For Each part As String In parts
		Dim u As String = NormalizeUtilityToken(part.ToLowerCase.Trim)
		If u.Length = 0 Then Continue
		If u.StartsWith("border") Then
			If ApplyBorderUtilityToken(spec, u, bRtlEnabled) Then hasUtility = True
		Else If u.StartsWith("rounded") Then
			If ApplyRoundedUtilityToken(spec, u, bRtlEnabled) Then hasUtility = True
		End If
	Next

	spec.Put("has_border_utility", hasUtility)
	SyncBorderAggregate(spec)
	SyncRadiusAggregate(spec)
	Return spec
End Sub

' Applies parsed border/radius values to a box model map.
' For non-uniform side widths, border_width uses the max side to avoid clipping.
Public Sub ApplyBorderSpecToBoxModel(mModel As Map, mBorderSpec As Map)
	If mModel.IsInitialized = False Or mBorderSpec.IsInitialized = False Then Return
	SyncBorderAggregate(mBorderSpec)
	SyncRadiusAggregate(mBorderSpec)

	Dim tw As Float = Max(0, mBorderSpec.GetDefault("border_top_width", 0))
	Dim rw As Float = Max(0, mBorderSpec.GetDefault("border_right_width", 0))
	Dim bw As Float = Max(0, mBorderSpec.GetDefault("border_bottom_width", 0))
	Dim lw As Float = Max(0, mBorderSpec.GetDefault("border_left_width", 0))
	Dim uniformW As Boolean = mBorderSpec.GetDefault("border_uniform_width", False)
	Dim resolvedW As Float = IIf(uniformW, tw, Max(Max(tw, rw), Max(bw, lw)))

	Dim style As String = mBorderSpec.GetDefault("border_style", "solid")
	If style = "none" Or style = "hidden" Then resolvedW = 0

	mModel.Put("border_width", resolvedW)
	mModel.Put("radius", Max(0, mBorderSpec.GetDefault("radius", 0)))
	mModel.Put("radius_tl", Max(0, mBorderSpec.GetDefault("radius_tl", 0)))
	mModel.Put("radius_tr", Max(0, mBorderSpec.GetDefault("radius_tr", 0)))
	mModel.Put("radius_br", Max(0, mBorderSpec.GetDefault("radius_br", 0)))
	mModel.Put("radius_bl", Max(0, mBorderSpec.GetDefault("radius_bl", 0)))
End Sub

Public Sub TailwindTextMetrics(oValue As Object, fDefaultFontSize As Float, fDefaultLineHeightPx As Float) As Map
	Dim defaultFont As Float = Max(1, fDefaultFontSize)
	Dim defaultLine As Float = Max(defaultFont, fDefaultLineHeightPx)
	Dim textToken As String = ""
	Dim leadingToken As String = ""

	If oValue <> Null Then
		Dim raw As String = oValue
		Dim s As String = raw.Trim
		If s.Length > 0 Then
			Dim parts() As String = Regex.Split("\s+", s)
			For Each p As String In parts
				Dim t As String = NormalizeUtilityToken(p)
				If t.Length = 0 Then Continue
				If textToken.Length = 0 And t.StartsWith("text-") Then
					textToken = t
				Else If leadingToken.Length = 0 And t.StartsWith("leading-") Then
					leadingToken = t
				End If
			Next
			If textToken.Length = 0 Then textToken = NormalizeUtilityToken(s)
		End If
	End If

	Dim sizeInfo As Map = ResolveTailwindTextToken(textToken, defaultFont, defaultLine)
	Dim fontSize As Float = sizeInfo.GetDefault("font_size", defaultFont)
	Dim linePx As Float = sizeInfo.GetDefault("line_height_px", defaultLine)
	Dim slashLeading As String = sizeInfo.GetDefault("leading_spec", "")
	If slashLeading.Length > 0 Then
		linePx = ResolveLeadingSpecToPx(slashLeading, fontSize, linePx)
	Else If leadingToken.Length > 0 Then
		linePx = ResolveLeadingSpecToPx(leadingToken, fontSize, linePx)
	End If

	Dim result As Map
	result.Initialize
	result.Put("font_size", fontSize)
	result.Put("font_size_dip", fontSize * 1dip)
	result.Put("line_height_px", linePx)
	result.Put("line_height_dip", linePx * 1dip)
	Return result
End Sub

' common resolver utilities added by standardization
Public Sub ResolvePxSizeSpec(fSizeDip As Float) As String
    Dim px As Int = Max(1, Round(fSizeDip / 1dip))
    Return px & "px"
End Sub

Public Sub ResolveWidthBase(vBase As B4XView, fDefaultValue As Float) As Float
    If vBase.IsInitialized Then
        Dim parent As B4XView = vBase.Parent
        If parent.IsInitialized And parent.Width > 0 Then Return parent.Width
        If vBase.Width > 0 Then Return vBase.Width
    End If
    Return fDefaultValue
End Sub

Public Sub ResolveHeightBase(vBase As B4XView, fDefaultValue As Float) As Float
    If vBase.IsInitialized Then
        Dim parent As B4XView = vBase.Parent
        If parent.IsInitialized And parent.Height > 0 Then Return parent.Height
        If vBase.Height > 0 Then Return vBase.Height
    End If
    Return fDefaultValue
End Sub

Public Sub ResolveTextSizeDip(sToken As String) As Float
    Dim tm As Map = TailwindTextMetrics(sToken, 14, 20)
    Return Max(1, tm.GetDefault("font_size", 14))
End Sub

' Maps a daisyUI field-size token (xs|sm|md|lg|xl) to the label font size in px,
' matching the floating-label font-size scale in label.css. Use this for
' label-above captions so they scale with the component Size.
Public Sub ResolveLabelSizeDip(sSizeToken As String) As Float
    Dim s As String = sSizeToken.ToLowerCase.Trim
    Select Case s
        Case "xs"
            Return 11
        Case "sm"
            Return 12
        Case "md"
            Return 14
        Case "lg"
            Return 18
        Case "xl"
            Return 22
        Case Else
            Return 14
    End Select
End Sub

''' <summary>
''' Measures a string using a canvas and returns the width with an optional buffer added.
''' This protects all callers from subtle clipping issues when laying out dynamic text.
''' </summary>
Public Sub MeasureTextWidthSafe(sText As String, fTextSize As Float, oTf As Object, fBufferDip As Float) As Int
    If sText = "" Then Return 0
    If fBufferDip = 0 Then fBufferDip = 4dip ' default buffer
    Dim p As B4XView = xui.CreatePanel("")
    p.SetLayoutAnimated(0, 0, 0, 2dip, 2dip)
    Dim cvs As B4XCanvas
    cvs.Initialize(p)
    Dim fnt As B4XFont
    #If B4A
    Dim nativeTf As Typeface = oTf
    fnt = xui.CreateFont(nativeTf, fTextSize)
    #Else
    fnt = xui.CreateDefaultFont(fTextSize)
    #End If
    Dim r As B4XRect = cvs.MeasureText(sText, fnt)
    cvs.Release
    Return Max(0, Ceil(r.Width) + fBufferDip)
End Sub

Public Sub MeasureTextHeightSafe(sText As String, fTextSize As Float, oTf As Object, iWidth As Int, fBufferDip As Float) As Int
    If fBufferDip = 0 Then fBufferDip = 4dip
    #If B4A
    Dim lbl As Label
    lbl.Initialize("")
    lbl.Text = sText
    lbl.TextSize = fTextSize
    Dim nativeTf As Typeface = oTf
    Dim jo As JavaObject = lbl
    jo.RunMethod("setTypeface", Array(nativeTf))
    lbl.Width = iWidth
    lbl.Height = 0
    Dim su As StringUtils
    Dim h As Int = su.MeasureMultilineTextHeight(lbl, sText)
    Return Max(0, h + fBufferDip)
    #Else
    Dim p As B4XView = xui.CreatePanel("")
    p.SetLayoutAnimated(0, 0, 0, iWidth, 2dip)
    Dim cvs As B4XCanvas
    cvs.Initialize(p)
    Dim fnt As B4XFont = xui.CreateDefaultFont(fTextSize)
    Dim r As B4XRect = cvs.MeasureText(sText, fnt)
    cvs.Release
    Dim lines As Int = Ceil(r.Width / iWidth)
    Return Max(0, Ceil(r.Height * lines) + fBufferDip)
    #End If
End Sub


Public Sub GetGlassSpec As Map
	' Returns active glass style values resolved from theme tokens.
	Dim m As Map
	m.Initialize
	Dim blurDip As Float = GetTokenDip("--glass-blur", 40dip)
	Dim glassOpacity As Float = ParsePercent01(GetTokenString("--glass-opacity", "30%"), 0.3)
	Dim reflectDegree As Float = GetTokenNumber("--glass-reflect-degree", 100)
	Dim reflectOpacity As Float = ParsePercent01(GetTokenString("--glass-reflect-opacity", "5%"), 0.05)
	Dim borderOpacity As Float = ParsePercent01(GetTokenString("--glass-border-opacity", "20%"), 0.2)
	Dim textShadowOpacity As Float = ParsePercent01(GetTokenString("--glass-text-shadow-opacity", "5%"), 0.05)
	m.Put("blur_dip", blurDip)
	m.Put("opacity", glassOpacity)
	m.Put("reflect_degree", reflectDegree)
	m.Put("reflect_opacity", reflectOpacity)
	m.Put("border_opacity", borderOpacity)
	m.Put("text_shadow_opacity", textShadowOpacity)
	Return m
End Sub

' Returns a glass spec map with opacity/border_opacity overridden by a size token.
' Size tokens: glass-xs (8%/8%), glass-sm (15%/12%), glass-md (30%/20%),
'              glass-lg (50%/35%), glass-xl (70%/50%). Empty or unrecognised = glass-md defaults.
Public Sub GetGlassSpecForSize(sSize As String) As Map
	Dim spec As Map = GetGlassSpec
	Dim s As String = sSize.ToLowerCase.Trim
	Dim opacity As Float
	Dim borderOpacity As Float
	Select Case s
		Case "glass-xs"
			opacity = 0.08
			borderOpacity = 0.08
		Case "glass-sm"
			opacity = 0.15
			borderOpacity = 0.12
		Case "glass-lg"
			opacity = 0.5
			borderOpacity = 0.35
		Case "glass-xl"
			opacity = 0.7
			borderOpacity = 0.5
		Case "glass-2xl"
			opacity = 0.85
			borderOpacity = 0.65
		Case Else
			' glass-md and any unrecognised value ? DaisyUI defaults
			Return spec
	End Select
	spec.Put("opacity", opacity)
	spec.Put("border_opacity", borderOpacity)
	Return spec
End Sub

Public Sub ApplyGlassStyle(vTarget As B4XView, fRadiusDip As Float, sSize As String)
	' Approximate daisy .glass style for B4X views.
	' Size is a glass size token (glass-xs|glass-sm|glass-md|glass-lg|glass-xl|glass-2xl).
	' Pass "" or "glass-md" for the DaisyUI default.
	If vTarget.IsInitialized = False Then Return
	Dim spec As Map = GetGlassSpecForSize(sSize)
	Dim bgAlpha As Float = Max(0, Min(1, spec.GetDefault("opacity", 0.3)))
	Dim borderAlpha As Float = Max(0, Min(1, spec.GetDefault("border_opacity", 0.2)))
	Dim back As Int = AlphaColor(xui.Color_White, bgAlpha)
	Dim stroke As Int = AlphaColor(xui.Color_White, borderAlpha)
	Dim rd As Float = Max(0, fRadiusDip)

	#If B4A
	If TryApplyGlassNative(vTarget, rd, bgAlpha, borderAlpha) Then Return
	#End If

	' Fallback for non-B4A / native failure.
	vTarget.SetColorAndBorder(back, Max(1dip, GetBorderDip(1dip)), stroke, rd)
End Sub

' Apply glass style with per-corner radii (B4A uses GradientDrawable.setCornerRadii).
' Mirror of ApplyGlassStyle but with independent corner values so a sheet can
' round only its top corners while keeping the bottom flush to the screen.
' Corner values in dip: TL=top-left, TR=top-right, BR=bottom-right, BL=bottom-left.
Public Sub ApplyGlassStylePerCorner(vTarget As B4XView, fTL As Float, fTR As Float, fBR As Float, fBL As Float, sSize As String)
	If vTarget.IsInitialized = False Then Return
	Dim spec As Map = GetGlassSpecForSize(sSize)
	Dim bgAlpha As Float = Max(0, Min(1, spec.GetDefault("opacity", 0.3)))
	Dim borderAlpha As Float = Max(0, Min(1, spec.GetDefault("border_opacity", 0.2)))
	Dim back As Int = AlphaColor(xui.Color_White, bgAlpha)
	Dim stroke As Int = AlphaColor(xui.Color_White, borderAlpha)

	#If B4A
	If TryApplyGlassNativePerCorner(vTarget, fTL, fTR, fBR, fBL, bgAlpha, borderAlpha) Then Return
	#End If

	' Fallback for non-B4A / native failure: uniform max radius.
	Dim maxR As Float = Max(fTL, Max(fTR, Max(fBR, fBL)))
	vTarget.SetColorAndBorder(back, Max(1dip, GetBorderDip(1dip)), stroke, maxR)
End Sub

' Apply background color with per-corner radii (B4A: uses GradientDrawable.setCornerRadii;
' other platforms fall back to a uniform max radius).
' Corner values in dip: TL=top-left, TR=top-right, BR=bottom-right, BL=bottom-left.
Public Sub SetColorPerCornerRadius(vView As B4XView, iBgColor As Int, fTL As Float, fTR As Float, fBR As Float, fBL As Float)
	#If B4A
	Dim gd As JavaObject
	gd.InitializeNewInstance("android.graphics.drawable.GradientDrawable", Null)
	gd.RunMethod("setColor", Array(iBgColor))
	Dim radii() As Float = Array As Float(fTL, fTL, fTR, fTR, fBR, fBR, fBL, fBL)
	gd.RunMethod("setCornerRadii", Array(radii))
	Dim jo As JavaObject = vView
	jo.RunMethod("setBackground", Array As Object(gd))
	#Else
	Dim maxR As Float = Max(fTL, Max(fTR, Max(fBR, fBL)))
	vView.SetColorAndBorder(iBgColor, 0, 0, maxR)
	#End If
End Sub

Public Sub ApplyGlassTextStyle(vTextTarget As B4XView)
	' Applies subtle text shadow style where available.
	If vTextTarget.IsInitialized = False Then Return
	Dim spec As Map = GetGlassSpec
	Dim a As Float = Max(0, Min(1, spec.GetDefault("text_shadow_opacity", 0.05)))
	#If B4A
	Try
		Dim j As JavaObject = vTextTarget
		Dim shadowColor As Int = AlphaColor(xui.Color_Black, a)
		j.RunMethod("setShadowLayer", Array As Object(1dip, 0, 1dip, shadowColor))
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyVariants.ApplyGlassTextStyle: " & LastException.Message)
	End Try   'ignore
	#End If
End Sub

Private Sub ParsePercent01(sValue As String, fDefaultValue As Float) As Float
	If sValue = Null Then Return Max(0, Min(1, fDefaultValue))
	Dim s As String = sValue.ToLowerCase.Trim
	If s.Length = 0 Then Return Max(0, Min(1, fDefaultValue))
	If s.EndsWith("%") Then
		Dim n As String = s.SubString2(0, s.Length - 1).Trim
		If IsNumber(n) Then Return Max(0, Min(1, n / 100))
	End If
	If IsNumber(s) Then
		Dim v As Float = s
		If v > 1 Then v = v / 100
		Return Max(0, Min(1, v))
	End If
	Return Max(0, Min(1, fDefaultValue))
End Sub

Public Sub AlphaColor(iColorValue As Int, fAlpha01 As Float) As Int
	Dim a As Int = Max(0, Min(255, Round(255 * Max(0, Min(1, fAlpha01)))))
	Dim r As Int = Bit.And(Bit.ShiftRight(iColorValue, 16), 0xFF)
	Dim g As Int = Bit.And(Bit.ShiftRight(iColorValue, 8), 0xFF)
	Dim b As Int = Bit.And(iColorValue, 0xFF)
	Return Bit.Or(Bit.ShiftLeft(a, 24), Bit.Or(Bit.ShiftLeft(r, 16), Bit.Or(Bit.ShiftLeft(g, 8), b)))
End Sub

#If B4A
Private Sub TryApplyGlassNative(vTarget As B4XView, fRadiusDip As Float, fBgOpacity As Float, fBorderOpacity As Float) As Boolean
	Try
		Dim gd As JavaObject
		gd.InitializeNewInstance("android.graphics.drawable.GradientDrawable", Null)
		gd.RunMethod("setShape", Array(0)) 'RECTANGLE
		gd.RunMethod("setCornerRadius", Array(Max(0, fRadiusDip)))
		gd.RunMethod("setColor", Array(0))
		Dim strokeWidth As Int = Max(1dip, GetBorderDip(1dip))
		gd.RunMethod("setStroke", Array(strokeWidth, AlphaColor(xui.Color_White, fBorderOpacity)))
		' 135deg highlight gradient: semi-white -> transparent.
		Dim ori As JavaObject
		ori.InitializeStatic("android.graphics.drawable.GradientDrawable$Orientation")
		gd.RunMethod("setOrientation", Array(ori.GetField("TL_BR")))
		Dim clr As Object = Array As Int(AlphaColor(xui.Color_White, fBgOpacity), AlphaColor(xui.Color_White, 0))
		gd.RunMethod("setColors", Array(clr))

		Dim j As JavaObject = vTarget
		j.RunMethod("setBackground", Array(gd))
		' Small elevation approximation for glass depth.
		j.RunMethod("setElevation", Array(2dip))
		Return True
	Catch
		Return False
	End Try
End Sub

' Per-corner variant of TryApplyGlassNative. Uses GradientDrawable.setCornerRadii
' so the glass surface can round only the top corners of a bottom-anchored sheet.
Private Sub TryApplyGlassNativePerCorner(vTarget As B4XView, fTL As Float, fTR As Float, fBR As Float, fBL As Float, fBgOpacity As Float, fBorderOpacity As Float) As Boolean
	Try
		Dim gd As JavaObject
		gd.InitializeNewInstance("android.graphics.drawable.GradientDrawable", Null)
		gd.RunMethod("setShape", Array(0)) 'RECTANGLE
		Dim radii() As Float = Array As Float(Max(0,fTL), Max(0,fTL), Max(0,fTR), Max(0,fTR), Max(0,fBR), Max(0,fBR), Max(0,fBL), Max(0,fBL))
		gd.RunMethod("setCornerRadii", Array(radii))
		gd.RunMethod("setColor", Array(0))
		Dim strokeWidth As Int = Max(1dip, GetBorderDip(1dip))
		gd.RunMethod("setStroke", Array(strokeWidth, AlphaColor(xui.Color_White, fBorderOpacity)))
		' 135deg highlight gradient: semi-white -> transparent.
		Dim ori As JavaObject
		ori.InitializeStatic("android.graphics.drawable.GradientDrawable$Orientation")
		gd.RunMethod("setOrientation", Array(ori.GetField("TL_BR")))
		Dim clr As Object = Array As Int(AlphaColor(xui.Color_White, fBgOpacity), AlphaColor(xui.Color_White, 0))
		gd.RunMethod("setColors", Array(clr))

		Dim j As JavaObject = vTarget
		j.RunMethod("setBackground", Array(gd))
		' Small elevation approximation for glass depth.
		j.RunMethod("setElevation", Array(2dip))
		Return True
	Catch
		Return False
	End Try
End Sub
#End If

'-
' JOIN UTILITY HELPERS (daisyui join.css parity)
'-
' Join groups buttons/inputs with merged borders and smart corners.
' Usage:
'   Dim joinSpec As Map = B4XDaisyVariants.GetJoinSpec("horizontal")
'   B4XDaisyVariants.ApplyJoinToContainer(pnlJoin, joinSpec)
'   B4XDaisyVariants.ApplyJoinItemToChild(btn, joinSpec, index, totalItems)
'-

' Returns a join spec map with layout direction and radius rules.
' Orientation: "horizontal" (default), "vertical"
Public Sub GetJoinSpec(sOrientation As String) As Map
	Dim m As Map
	m.Initialize
	Dim orient As String = sOrientation.ToLowerCase.Trim
	If orient = "vertical" Then
		m.Put("orientation", "vertical")
	Else
		m.Put("orientation", "horizontal")
	End If
	m.Put("radius_field", GetRadiusFieldDip(8dip))
	m.Put("border_width", GetBorderDip(1dip))
	Return m
End Sub

' Apply join layout to the container panel (stores orientation in spec, not view).
Public Sub ApplyJoinToContainer(vContainer As B4XView, mSpec As Map)
	' Placeholder: spec already contains orientation; container just needs to exist.
	If vContainer.IsInitialized = False Then Return
End Sub

' Apply join-item styling to a child view within a join group.
' Index is 0-based; Total is the number of join items in the group.
Public Sub ApplyJoinItemToChild(vItem As B4XView, mSpec As Map, iIndex As Int, iTotal As Int)
	If vItem.IsInitialized = False Then Return
	If mSpec.IsInitialized = False Then Return
	If iTotal <= 0 Then Return

	Dim orient As String = mSpec.GetDefault("orientation", "horizontal")
	Dim radiusField As Float = mSpec.GetDefault("radius_field", 8dip)
	Dim borderWidth As Float = mSpec.GetDefault("border_width", 1dip)

	Dim tl As Float = 0, tr As Float = 0, br As Float = 0, bl As Float = 0
	Dim negMarginX As Int = 0, negMarginY As Int = 0

	If iTotal = 1 Then
		' Only child: fully rounded
		tl = radiusField: tr = radiusField: br = radiusField: bl = radiusField
	Else If iIndex = 0 Then
		' First child
		If orient = "vertical" Then
			tl = radiusField: tr = radiusField: br = 0: bl = 0
			negMarginY = 0
		Else
			tl = radiusField: tr = 0: br = 0: bl = radiusField
			negMarginX = 0
		End If
	Else If iIndex = iTotal - 1 Then
		' Last child
		If orient = "vertical" Then
			tl = 0: tr = 0: br = radiusField: bl = radiusField
			negMarginY = -Ceil(borderWidth)
		Else
			tl = 0: tr = radiusField: br = radiusField: bl = 0
			negMarginX = -Ceil(borderWidth)
		End If
	Else
		' Middle child: no rounded corners, negative margin to overlap
		tl = 0: tr = 0: br = 0: bl = 0
		If orient = "vertical" Then
			negMarginY = -Ceil(borderWidth)
		Else
			negMarginX = -Ceil(borderWidth)
		End If
	End If

	#If B4A
	Try
		Dim gd As JavaObject
		gd.InitializeNewInstance("android.graphics.drawable.GradientDrawable", Null)
		gd.RunMethod("setShape", Array(0)) ' RECTANGLE
		Dim radii() As Float = Array As Float(tl, tl, tr, tr, br, br, bl, bl)
		gd.RunMethod("setCornerRadii", Array(radii))
		' Preserve existing background color if any.
		Dim bg As Int = 0
		Try
			Dim joItem As JavaObject = vItem
			Dim drawable As JavaObject = joItem.RunMethod("getBackground", Null)
			If drawable.IsInitialized Then
				bg = drawable.RunMethod("getColor", Null)
			End If
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisyVariants.ApplyJoinItemToChild: " & LastException.Message)
		End Try
		If bg = 0 Then bg = GetTokenColor("--color-base-100", xui.Color_White)
		gd.RunMethod("setColor", Array(bg))
		Dim strokeColor As Int = GetTokenColor("--color-base-300", xui.Color_RGB(203, 213, 225))
		gd.RunMethod("setStroke", Array(Ceil(borderWidth), strokeColor))
		Dim jo As JavaObject = vItem
		jo.RunMethod("setBackground", Array(gd))
	Catch
		' Fallback: use B4X standard border
		vItem.SetColorAndBorder(GetTokenColor("--color-base-100", xui.Color_White), Ceil(borderWidth), _
			GetTokenColor("--color-base-300", xui.Color_RGB(203, 213, 225)), radiusField)
	End Try
	#Else
	' B4i/B4J fallback: uniform radius (use max of the four)
	Dim maxR As Float = Max(Max(tl, tr), Max(br, bl))
	vItem.SetColorAndBorder(GetTokenColor("--color-base-100", xui.Color_White), Ceil(borderWidth), _
		GetTokenColor("--color-base-300", xui.Color_RGB(203, 213, 225)), maxR)
	#End If

	' Apply negative margin for border overlap (B4A only for now).
	#If B4A
	If negMarginX <> 0 Or negMarginY <> 0 Then
		Try
			Dim lp As JavaObject = vItem
			Dim parentObj As JavaObject = lp.RunMethod("getLayoutParams", Null)
			If parentObj.IsInitialized Then
				Dim curL As Int = parentObj.GetField("leftMargin")
				Dim curT As Int = parentObj.GetField("topMargin")
				parentObj.SetField("leftMargin", curL + negMarginX)
				parentObj.SetField("topMargin", curT + negMarginY)
				lp.RunMethod("setLayoutParams", Array(parentObj))
			End If
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisyVariants.ApplyJoinItemToChild: " & LastException.Message)
		End Try
	End If
	#End If
End Sub

' Convenience: apply join to all children of a container automatically.
Public Sub ApplyJoinToAllChildren(vContainer As B4XView, mSpec As Map)
	If vContainer.IsInitialized = False Then Return
	Dim total As Int = vContainer.NumberOfViews
	For i = 0 To total - 1
		Dim child As B4XView = vContainer.GetView(i)
		ApplyJoinItemToChild(child, mSpec, i, total)
	Next
End Sub

Public Sub TailwindTextFontSize(oValue As Object, fDefaultFontSize As Float) As Float
	Dim m As Map = TailwindTextMetrics(oValue, fDefaultFontSize, fDefaultFontSize * 1.5)
	Return m.GetDefault("font_size", fDefaultFontSize)
End Sub

Public Sub TailwindTextLineHeightDip(oValue As Object, fDefaultLineHeightDip As Float) As Float
	Dim defaultLinePx As Float = Max(1, fDefaultLineHeightDip / 1dip)
	Dim m As Map = TailwindTextMetrics(oValue, 14, defaultLinePx)
	Return m.GetDefault("line_height_dip", fDefaultLineHeightDip)
End Sub

Private Sub ResolveTailwindTextToken(sToken As String, fDefaultFontSize As Float, fDefaultLineHeightPx As Float) As Map
	Dim t As String = sToken.ToLowerCase.Trim
	Dim leadingSpec As String = ""
	Dim pSlash As Int = t.IndexOf("/")
	If pSlash >= 0 Then
		leadingSpec = t.SubString(pSlash + 1).Trim
		t = t.SubString2(0, pSlash).Trim
	End If
	If t.StartsWith("text-") Then t = t.SubString(5)

	Dim m As Map
	m.Initialize
		Select Case t
		Case "xs"
			m.Put("font_size", 12)
			m.Put("line_height_px", 16)
		Case "sm"
			m.Put("font_size", 14)
			m.Put("line_height_px", 20)
		Case "base", "md"
			m.Put("font_size", 16)
			m.Put("line_height_px", 24)
		Case "lg"
			m.Put("font_size", 18)
			m.Put("line_height_px", 28)
		Case "xl"
			m.Put("font_size", 20)
			m.Put("line_height_px", 28)
		Case "2xl"
			m.Put("font_size", 24)
			m.Put("line_height_px", 32)
		Case "3xl"
			m.Put("font_size", 30)
			m.Put("line_height_px", 36)
		Case "4xl"
			m.Put("font_size", 36)
			m.Put("line_height_px", 40)
		Case "5xl"
			m.Put("font_size", 48)
			m.Put("line_height_px", 48)
		Case "6xl"
			m.Put("font_size", 60)
			m.Put("line_height_px", 60)
		Case "7xl"
			m.Put("font_size", 72)
			m.Put("line_height_px", 72)
		Case "8xl"
			m.Put("font_size", 96)
			m.Put("line_height_px", 96)
		Case "9xl"
			m.Put("font_size", 128)
			m.Put("line_height_px", 128)
		Case "h1"
			m.Put("font_size", 26)
			m.Put("line_height_px", 31.2)
		Case "h2"
			m.Put("font_size", 24)
			m.Put("line_height_px", 28.8)
		Case "h3"
			m.Put("font_size", 22)
			m.Put("line_height_px", 26.4)
		Case "h4"
			m.Put("font_size", 20)
			m.Put("line_height_px", 24)
		Case "h5"
			m.Put("font_size", 18)
			m.Put("line_height_px", 21.6)
		Case "h6"
			m.Put("font_size", 16)
			m.Put("line_height_px", 19.2)
		Case Else
			Dim customPx As Float = ParseCssLengthToPx(t, fDefaultFontSize)
			m.Put("font_size", customPx)
			m.Put("line_height_px", Max(customPx, fDefaultLineHeightPx))
	End Select
	m.Put("leading_spec", leadingSpec)
	Return m
End Sub

Private Sub ResolveLeadingSpecToPx(sSpec As String, fFontSize As Float, fDefaultLineHeightPx As Float) As Float
	Dim s As String = sSpec.ToLowerCase.Trim
	If s.Length = 0 Then Return Max(fFontSize, fDefaultLineHeightPx)
	If s.StartsWith("leading-") Then s = s.SubString(8).Trim

	Select Case s
		Case "none"
			Return Max(1, fFontSize * 1.0)
		Case "tight"
			Return Max(1, fFontSize * 1.25)
		Case "snug"
			Return Max(1, fFontSize * 1.375)
		Case "normal"
			Return Max(1, fFontSize * 1.5)
		Case "relaxed"
			Return Max(1, fFontSize * 1.625)
		Case "loose"
			Return Max(1, fFontSize * 2.0)
	End Select

	If s.StartsWith("[") And s.EndsWith("]") And s.Length > 2 Then
		s = s.SubString2(1, s.Length - 1).Trim
	End If
	If s.EndsWith("%") Then
		Dim pct As Double = ParseCssNumber(s.SubString2(0, s.Length - 1), -1)
		If pct >= 0 Then Return Max(1, fFontSize * pct / 100)
	End If

	Dim n As Double = ParseCssNumber(s, -1)
	If n >= 0 Then Return Max(1, n * TW_SPACE_STEP_PX)
	Return Max(1, ParseCssLengthToPx(s, fDefaultLineHeightPx))
End Sub

Private Sub CreateDefaultBorderSpec(fDefaultBorderDip As Float, iDefaultBorderColor As Int, fDefaultRadiusDip As Float) As Map
	Dim spec As Map
	spec.Initialize
	Dim w As Float = Max(0, fDefaultBorderDip)
	Dim r As Float = Max(0, fDefaultRadiusDip)

	spec.Put("border_width", w)
	spec.Put("border_top_width", w)
	spec.Put("border_right_width", w)
	spec.Put("border_bottom_width", w)
	spec.Put("border_left_width", w)

	spec.Put("border_style", "solid")
	spec.Put("border_top_style", "solid")
	spec.Put("border_right_style", "solid")
	spec.Put("border_bottom_style", "solid")
	spec.Put("border_left_style", "solid")

	spec.Put("border_color", iDefaultBorderColor)
	spec.Put("border_top_color", iDefaultBorderColor)
	spec.Put("border_right_color", iDefaultBorderColor)
	spec.Put("border_bottom_color", iDefaultBorderColor)
	spec.Put("border_left_color", iDefaultBorderColor)
	spec.Put("border_color_token", "")
	spec.Put("border_opacity", ColorAlpha01(iDefaultBorderColor))

	spec.Put("radius", r)
	spec.Put("radius_tl", r)
	spec.Put("radius_tr", r)
	spec.Put("radius_br", r)
	spec.Put("radius_bl", r)

	spec.Put("border_uniform_width", True)
	spec.Put("border_uniform_color", True)
	spec.Put("border_uniform_style", True)
	spec.Put("radius_uniform", True)
	spec.Put("has_border_utility", False)
	Return spec
End Sub

Private Sub ApplyBorderUtilityToken(mSpec As Map, sUtility As String, bRtlEnabled As Boolean) As Boolean
	If mSpec.IsInitialized = False Then Return False
	If sUtility = Null Then Return False
	Dim u As String = sUtility.ToLowerCase.Trim
	If u.Length = 0 Then Return False

	Dim defaultBorderDip As Float = GetBorderDip(1dip)
	If u = "border" Then
		SetBorderWidthScope(mSpec, "all", defaultBorderDip, bRtlEnabled)
		SyncBorderAggregate(mSpec)
		Return True
	End If
	If u.StartsWith("border-") = False Then Return False

	Dim rest As String = u.SubString(7).Trim
	If rest.Length = 0 Then
		SetBorderWidthScope(mSpec, "all", defaultBorderDip, bRtlEnabled)
		SyncBorderAggregate(mSpec)
		Return True
	End If

	If IsBorderStyleToken(rest) Then
		SetBorderStyleScope(mSpec, "all", NormalizeBorderStyle(rest), bRtlEnabled)
		SyncBorderAggregate(mSpec)
		Return True
	End If

	Dim scopeInfo As Map = ParseBorderSideScope(rest)
	Dim scope As String = "all"
	Dim valueToken As String = rest
	If scopeInfo.GetDefault("has_scope", False) Then
		scope = scopeInfo.GetDefault("scope", "all")
		valueToken = scopeInfo.GetDefault("value", "")
		If valueToken.Length = 0 Then
			SetBorderWidthScope(mSpec, scope, defaultBorderDip, bRtlEnabled)
			SyncBorderAggregate(mSpec)
			Return True
		End If
	End If

	If IsBorderStyleToken(valueToken) Then
		SetBorderStyleScope(mSpec, scope, NormalizeBorderStyle(valueToken), bRtlEnabled)
		SyncBorderAggregate(mSpec)
		Return True
	End If

	Dim maybeWidth As Float = ResolveBorderWidthTokenDip(valueToken, -1)
	If maybeWidth >= 0 Then
		SetBorderWidthScope(mSpec, scope, maybeWidth, bRtlEnabled)
		SyncBorderAggregate(mSpec)
		Return True
	End If

	Dim baseColor As Int = mSpec.GetDefault("border_color", xui.Color_Black)
	Dim c As Int = ResolveUtilityColorWithOpacity(valueToken, baseColor)
	SetBorderColorScope(mSpec, scope, c, bRtlEnabled)
	mSpec.Put("border_color_token", valueToken)
	SyncBorderAggregate(mSpec)
	Return True
End Sub

Private Sub ApplyRoundedUtilityToken(mSpec As Map, sUtility As String, bRtlEnabled As Boolean) As Boolean
	If mSpec.IsInitialized = False Then Return False
	If sUtility = Null Then Return False
	Dim u As String = sUtility.ToLowerCase.Trim
	If u.Length = 0 Then Return False
	If u.StartsWith("rounded") = False Then Return False

	Dim scope As String = "all"
	Dim valueToken As String = "default"
	If u = "rounded" Then
		scope = "all"
		valueToken = "default"
	Else If u.StartsWith("rounded-") Then
		Dim rest As String = u.SubString(8).Trim
		Dim scopeInfo As Map = ParseRoundedScope(rest)
		If scopeInfo.GetDefault("has_scope", False) Then
			scope = scopeInfo.GetDefault("scope", "all")
			valueToken = scopeInfo.GetDefault("value", "")
			If valueToken.Length = 0 Then valueToken = "default"
		Else
			scope = "all"
			valueToken = rest
			If valueToken.Length = 0 Then valueToken = "default"
		End If
	Else
		Return False
	End If

	Dim fallbackRadius As Float = Max(0, mSpec.GetDefault("radius", 4dip))
	Dim r As Float = TailwindBorderRadiusToDip(valueToken, fallbackRadius)
	SetRoundedScope(mSpec, scope, r, bRtlEnabled)
	SyncRadiusAggregate(mSpec)
	Return True
End Sub

Private Sub ParseBorderSideScope(sToken As String) As Map
	Dim m As Map
	m.Initialize
	m.Put("has_scope", False)
	m.Put("scope", "all")
	m.Put("value", sToken)
	If sToken = Null Then Return m

	Dim t As String = sToken.ToLowerCase.Trim
	If t.Length = 0 Then Return m
	Dim scopes() As String = Array As String("x", "y", "t", "r", "b", "l", "s", "e")
	For Each sc As String In scopes
		If t = sc Then
			m.Put("has_scope", True)
			m.Put("scope", sc)
			m.Put("value", "")
			Return m
		End If
		Dim pref As String = sc & "-"
		If t.StartsWith(pref) And t.Length > pref.Length Then
			m.Put("has_scope", True)
			m.Put("scope", sc)
			m.Put("value", t.SubString(pref.Length))
			Return m
		End If
	Next
	Return m
End Sub

Private Sub ParseRoundedScope(sToken As String) As Map
	Dim m As Map
	m.Initialize
	m.Put("has_scope", False)
	m.Put("scope", "all")
	m.Put("value", sToken)
	If sToken = Null Then Return m

	Dim t As String = sToken.ToLowerCase.Trim
	If t.Length = 0 Then Return m
	Dim scopes() As String = Array As String("ss", "se", "ee", "es", "tl", "tr", "br", "bl", "s", "e", "t", "b", "l", "r")
	For Each sc As String In scopes
		If t = sc Then
			m.Put("has_scope", True)
			m.Put("scope", sc)
			m.Put("value", "")
			Return m
		End If
		Dim pref As String = sc & "-"
		If t.StartsWith(pref) And t.Length > pref.Length Then
			m.Put("has_scope", True)
			m.Put("scope", sc)
			m.Put("value", t.SubString(pref.Length))
			Return m
		End If
	Next
	Return m
End Sub

Private Sub ResolveBorderWidthTokenDip(sToken As String, fFallbackDip As Float) As Float
	If sToken = Null Then Return fFallbackDip
	Dim s As String = sToken.ToLowerCase.Trim
	If s.Length = 0 Then Return fFallbackDip
	If s = "default" Then Return GetBorderDip(IIf(fFallbackDip >= 0, fFallbackDip, 1dip))
	If s = "px" Then Return 1dip
	If s = "thin" Then Return 1dip
	If s = "medium" Then Return 3dip
	If s = "thick" Then Return 5dip

	If s.StartsWith("[") And s.EndsWith("]") And s.Length > 2 Then
		s = s.SubString2(1, s.Length - 1).Trim
		If s.StartsWith("length:") Then s = s.SubString(7).Trim
	End If
	If s.StartsWith("(") And s.EndsWith(")") And s.Length > 2 Then
		s = s.SubString2(1, s.Length - 1).Trim
		If s.StartsWith("length:") Then s = s.SubString(7).Trim
	End If
	If s.Contains("--border") Then Return GetBorderDip(IIf(fFallbackDip >= 0, fFallbackDip, 1dip))
	If s.StartsWith("--") Then Return GetTokenDip(s, IIf(fFallbackDip >= 0, fFallbackDip, 1dip))

	Dim px As Float = ParseCssLengthToPx(s, -1)
	If px >= 0 Then Return Max(0, px * 1dip)
	Return fFallbackDip
End Sub

Private Sub ResolveUtilityColorWithOpacity(sColorToken As String, iDefaultColor As Int) As Int
	If sColorToken = Null Then Return iDefaultColor
	Dim s As String = sColorToken.ToLowerCase.Trim
	If s.Length = 0 Then Return iDefaultColor

	Dim alpha01 As Float = 1
	Dim pSlash As Int = s.LastIndexOf("/")
	If pSlash > 0 And pSlash < s.Length - 1 Then
		alpha01 = ParseUtilityOpacity01(s.SubString(pSlash + 1), 1)
		s = s.SubString2(0, pSlash).Trim
	End If

	Dim baseColor As Int = ResolveUtilityColor(s, iDefaultColor)
	Dim a As Float = Max(0, Min(1, ColorAlpha01(baseColor) * alpha01))
	Return AlphaColor(baseColor, a)
End Sub

Private Sub ResolveUtilityColor(sColorToken As String, iDefaultColor As Int) As Int
	If sColorToken = Null Then Return iDefaultColor
	Dim s As String = sColorToken.ToLowerCase.Trim
	If s.Length = 0 Then Return iDefaultColor

	If s.StartsWith("[") And s.EndsWith("]") And s.Length > 2 Then
		s = s.SubString2(1, s.Length - 1).Trim
	End If
	If s.StartsWith("color:") Then s = s.SubString(6).Trim
	If s = "current" Or s = "inherit" Then Return iDefaultColor
	If s = "transparent" Then Return xui.Color_Transparent
	If s.StartsWith("--") Then Return GetTokenColor(s, iDefaultColor)

	Dim themeKey As String = ResolveThemeColorTokenName(s)
	If themeKey.Length > 0 Then Return GetTokenColor(themeKey, iDefaultColor)
	Dim normalizedVariant As String = NormalizeVariant(s)
	If normalizedVariant <> "none" Then Return ResolveVariantColor(DefaultPalette, normalizedVariant, "back", iDefaultColor)

	If s.StartsWith("#") Then Return ParseHexColorToken(s, iDefaultColor)
	If s.StartsWith("rgb(") Or s.StartsWith("rgba(") Then Return ParseRgbColorToken(s, iDefaultColor)
	If s.StartsWith("hsl(") Or s.StartsWith("hsla(") Then Return ParseHslColorToken(s, iDefaultColor)
	If s.StartsWith("var(") Then
		Dim pVar As Int = s.IndexOf("--")
		If pVar >= 0 Then
			Dim tail As String = s.SubString(pVar)
			Dim pEnd As Int = tail.IndexOf(")")
			If pEnd >= 0 Then tail = tail.SubString2(0, pEnd)
			Return GetTokenColor(tail, iDefaultColor)
		End If
	End If

	Dim basic As Int = ResolveCssNamedColor(s, -1)
	If basic <> -1 Then Return basic
	Dim tw As Int = ResolveTailwindPaletteColor(s, -1)
	If tw <> -1 Then Return tw
	If IsNumber(s) Then Return s
	Return iDefaultColor
End Sub

Private Sub ResolveCssNamedColor(sName As String, iDefaultColor As Int) As Int
	Select Case sName
		Case "black"
			Return xui.Color_Black
		Case "white"
			Return xui.Color_White
		Case "red"
			Return xui.Color_Red
		Case "green"
			Return xui.Color_Green
		Case "blue"
			Return xui.Color_Blue
		Case "yellow"
			Return xui.Color_Yellow
		Case "cyan", "aqua"
			Return xui.Color_Cyan
		Case "magenta", "fuchsia"
			Return xui.Color_Magenta
		Case "gray", "grey"
			Return xui.Color_Gray
		Case "orange"
			Return xui.Color_RGB(249, 115, 22)
		Case "pink"
			Return xui.Color_RGB(236, 72, 153)
		Case "purple"
			Return xui.Color_RGB(168, 85, 247)
		Case "teal"
			Return xui.Color_RGB(20, 184, 166)
		Case "lime"
			Return xui.Color_RGB(132, 204, 22)
		Case "amber"
			Return xui.Color_RGB(245, 158, 11)
		Case "indigo"
			Return xui.Color_RGB(99, 102, 241)
		Case "rose"
			Return xui.Color_RGB(244, 63, 94)
		Case "slate"
			Return xui.Color_RGB(100, 116, 139)
		Case "zinc"
			Return xui.Color_RGB(113, 113, 122)
		Case "neutral"
			Return xui.Color_RGB(115, 115, 115)
		Case "stone"
			Return xui.Color_RGB(120, 113, 108)
		Case Else
			Return iDefaultColor
	End Select
End Sub

Private Sub ResolveTailwindPaletteColor(sToken As String, iDefaultColor As Int) As Int
	If sToken = Null Then Return iDefaultColor
	Dim s As String = sToken.ToLowerCase.Trim
	If s.Length = 0 Then Return iDefaultColor

	Dim hue As String = s
	Dim shade As Int = 500
	Dim p As Int = s.LastIndexOf("-")
	If p > 0 And p < s.Length - 1 Then
		Dim shadeText As String = s.SubString(p + 1).Trim
		If IsNumber(shadeText) Then
			hue = s.SubString2(0, p).Trim
			shade = shadeText
		End If
	End If

	Dim base500 As Int = ResolveTailwindHue500(hue, -1)
	If base500 = -1 Then Return iDefaultColor
	Return ShadeTailwindColor(base500, shade)
End Sub

Private Sub ResolveTailwindHue500(sHue As String, iDefaultColor As Int) As Int
	Select Case sHue
		Case "slate"
			Return xui.Color_RGB(100, 116, 139)
		Case "gray", "grey"
			Return xui.Color_RGB(107, 114, 128)
		Case "zinc"
			Return xui.Color_RGB(113, 113, 122)
		Case "neutral"
			Return xui.Color_RGB(115, 115, 115)
		Case "stone"
			Return xui.Color_RGB(120, 113, 108)
		Case "red"
			Return xui.Color_RGB(239, 68, 68)
		Case "orange"
			Return xui.Color_RGB(249, 115, 22)
		Case "amber"
			Return xui.Color_RGB(245, 158, 11)
		Case "yellow"
			Return xui.Color_RGB(234, 179, 8)
		Case "lime"
			Return xui.Color_RGB(132, 204, 22)
		Case "green"
			Return xui.Color_RGB(34, 197, 94)
		Case "emerald"
			Return xui.Color_RGB(16, 185, 129)
		Case "teal"
			Return xui.Color_RGB(20, 184, 166)
		Case "cyan"
			Return xui.Color_RGB(6, 182, 212)
		Case "sky"
			Return xui.Color_RGB(14, 165, 233)
		Case "blue"
			Return xui.Color_RGB(59, 130, 246)
		Case "indigo"
			Return xui.Color_RGB(99, 102, 241)
		Case "violet"
			Return xui.Color_RGB(139, 92, 246)
		Case "purple"
			Return xui.Color_RGB(168, 85, 247)
		Case "fuchsia"
			Return xui.Color_RGB(217, 70, 239)
		Case "pink"
			Return xui.Color_RGB(236, 72, 153)
		Case "rose"
			Return xui.Color_RGB(244, 63, 94)
		Case Else
			Return iDefaultColor
	End Select
End Sub

Private Sub ShadeTailwindColor(iBaseColor As Int, iShade As Int) As Int
	Dim s As Int = iShade
	If s <= 50 Then Return Blend(iBaseColor, xui.Color_White, 0.92)
	If s < 500 Then
		Dim tLight As Float = (500 - s) / 450
		Return Blend(iBaseColor, xui.Color_White, Max(0, Min(1, tLight * 0.92)))
	End If
	If s = 500 Then Return iBaseColor
	If s >= 950 Then Return Blend(iBaseColor, xui.Color_Black, 0.72)
	Dim tDark As Float = (s - 500) / 450
	Return Blend(iBaseColor, xui.Color_Black, Max(0, Min(1, tDark * 0.72)))
End Sub

Private Sub ParseHexColorToken(sValue As String, iDefaultColor As Int) As Int
	Try
		Dim hex As String = sValue.Trim
		If hex.StartsWith("#") Then hex = hex.SubString(1)
		Select Case hex.Length
			Case 3
				Dim r3 As Int = Bit.ParseInt(hex.SubString2(0, 1) & hex.SubString2(0, 1), 16)
				Dim g3 As Int = Bit.ParseInt(hex.SubString2(1, 2) & hex.SubString2(1, 2), 16)
				Dim b3 As Int = Bit.ParseInt(hex.SubString2(2, 3) & hex.SubString2(2, 3), 16)
				Return xui.Color_ARGB(255, r3, g3, b3)
			Case 4
				Dim r4 As Int = Bit.ParseInt(hex.SubString2(0, 1) & hex.SubString2(0, 1), 16)
				Dim g4 As Int = Bit.ParseInt(hex.SubString2(1, 2) & hex.SubString2(1, 2), 16)
				Dim b4 As Int = Bit.ParseInt(hex.SubString2(2, 3) & hex.SubString2(2, 3), 16)
				Dim a4 As Int = Bit.ParseInt(hex.SubString2(3, 4) & hex.SubString2(3, 4), 16)
				Return xui.Color_ARGB(a4, r4, g4, b4)
			Case 6
				Dim r6 As Int = Bit.ParseInt(hex.SubString2(0, 2), 16)
				Dim g6 As Int = Bit.ParseInt(hex.SubString2(2, 4), 16)
				Dim b6 As Int = Bit.ParseInt(hex.SubString2(4, 6), 16)
				Return xui.Color_ARGB(255, r6, g6, b6)
			Case 8
				' CSS 8-digit hex uses RRGGBBAA.
				Dim r8 As Int = Bit.ParseInt(hex.SubString2(0, 2), 16)
				Dim g8 As Int = Bit.ParseInt(hex.SubString2(2, 4), 16)
				Dim b8 As Int = Bit.ParseInt(hex.SubString2(4, 6), 16)
				Dim a8 As Int = Bit.ParseInt(hex.SubString2(6, 8), 16)
				Return xui.Color_ARGB(a8, r8, g8, b8)
			Case Else
				Return iDefaultColor
		End Select
	Catch
		Return iDefaultColor
	End Try
End Sub

Private Sub ParseRgbColorToken(sValue As String, iDefaultColor As Int) As Int
	Try
		Dim s As String = sValue.Trim
		Dim p1 As Int = s.IndexOf("(")
		Dim p2 As Int = s.LastIndexOf(")")
		If p1 < 0 Or p2 <= p1 Then Return iDefaultColor
		Dim inside As String = s.SubString2(p1 + 1, p2).Trim
		If inside.Length = 0 Then Return iDefaultColor

		inside = inside.Replace("/", ",")
		inside = Regex.Replace("\s+", inside, ",")
		inside = Regex.Replace(",+", inside, ",")
		If inside.StartsWith(",") Then inside = inside.SubString(1)
		If inside.EndsWith(",") Then inside = inside.SubString2(0, inside.Length - 1)

		Dim parts() As String = Regex.Split(",", inside)
		If parts.Length < 3 Then Return iDefaultColor
		Dim r As Int = ParseColorChannel(parts(0), -1)
		Dim g As Int = ParseColorChannel(parts(1), -1)
		Dim b As Int = ParseColorChannel(parts(2), -1)
		If r < 0 Or g < 0 Or b < 0 Then Return iDefaultColor
		Dim a01 As Float = 1
		If parts.Length >= 4 Then a01 = ParseUtilityOpacity01(parts(3), 1)
		Return xui.Color_ARGB(Round(255 * Max(0, Min(1, a01))), r, g, b)
	Catch
		Return iDefaultColor
	End Try
End Sub

Private Sub ParseHslColorToken(sValue As String, iDefaultColor As Int) As Int
	Try
		Dim s As String = sValue.Trim
		Dim p1 As Int = s.IndexOf("(")
		Dim p2 As Int = s.LastIndexOf(")")
		If p1 < 0 Or p2 <= p1 Then Return iDefaultColor
		Dim inside As String = s.SubString2(p1 + 1, p2).Trim
		If inside.Length = 0 Then Return iDefaultColor

		inside = inside.Replace("/", ",")
		inside = Regex.Replace("\s+", inside, ",")
		inside = Regex.Replace(",+", inside, ",")
		If inside.StartsWith(",") Then inside = inside.SubString(1)
		If inside.EndsWith(",") Then inside = inside.SubString2(0, inside.Length - 1)

		Dim parts() As String = Regex.Split(",", inside)
		If parts.Length < 3 Then Return iDefaultColor

		Dim hText As String = parts(0).ToLowerCase.Trim
		If hText.EndsWith("deg") Then hText = hText.SubString2(0, hText.Length - 3).Trim
		Dim h As Float = ParseCssNumber(hText, 0)
		Dim s01 As Float = ParseUtilityOpacity01(parts(1), -1)
		Dim l01 As Float = ParseUtilityOpacity01(parts(2), -1)
		If s01 < 0 Or l01 < 0 Then Return iDefaultColor

		Dim rgb As Map = HslToRgb(h, s01, l01)
		Dim a01 As Float = 1
		If parts.Length >= 4 Then a01 = ParseUtilityOpacity01(parts(3), 1)
		Return xui.Color_ARGB(Round(255 * Max(0, Min(1, a01))), rgb.GetDefault("r", 0), rgb.GetDefault("g", 0), rgb.GetDefault("b", 0))
	Catch
		Return iDefaultColor
	End Try
End Sub

Private Sub HslToRgb(fH As Float, fS As Float, fL As Float) As Map
	Dim h01 As Float = fH / 360
	Do While h01 < 0
		h01 = h01 + 1
	Loop
	Do While h01 >= 1
		h01 = h01 - 1
	Loop
	Dim s01 As Float = Max(0, Min(1, fS))
	Dim l01 As Float = Max(0, Min(1, fL))
	Dim r As Float
	Dim g As Float
	Dim b As Float
	If s01 = 0 Then
		r = l01
		g = l01
		b = l01
	Else
		Dim q As Float = IIf(l01 < 0.5, l01 * (1 + s01), l01 + s01 - l01 * s01)
		Dim p As Float = 2 * l01 - q
		r = HueToRgb(p, q, h01 + (1 / 3))
		g = HueToRgb(p, q, h01)
		b = HueToRgb(p, q, h01 - (1 / 3))
	End If
	Dim m As Map
	m.Initialize
	m.Put("r", Round(255 * Max(0, Min(1, r))))
	m.Put("g", Round(255 * Max(0, Min(1, g))))
	m.Put("b", Round(255 * Max(0, Min(1, b))))
	Return m
End Sub

Private Sub HueToRgb(fP As Float, fQ As Float, fTIn As Float) As Float
	Dim t As Float = fTIn
	If t < 0 Then t = t + 1
	If t > 1 Then t = t - 1
	If t < 1 / 6 Then Return fP + (fQ - fP) * 6 * t
	If t < 1 / 2 Then Return fQ
	If t < 2 / 3 Then Return fP + (fQ - fP) * (2 / 3 - t) * 6
	Return fP
End Sub

Private Sub ParseColorChannel(sText As String, iDefaultValue As Int) As Int
	If sText = Null Then Return iDefaultValue
	Dim s As String = sText.ToLowerCase.Trim
	If s.Length = 0 Then Return iDefaultValue
	If s.EndsWith("%") Then
		Dim pct As Double = ParseCssNumber(s.SubString2(0, s.Length - 1), -1)
		If pct < 0 Then Return iDefaultValue
		Return Round(Max(0, Min(255, 255 * pct / 100)))
	End If
	Dim n As Double = ParseCssNumber(s, -1)
	If n < 0 Then Return iDefaultValue
	Return Round(Max(0, Min(255, n)))
End Sub

Private Sub ParseUtilityOpacity01(sValue As String, fDefaultValue As Float) As Float
	If sValue = Null Then Return Max(0, Min(1, fDefaultValue))
	Dim s As String = sValue.ToLowerCase.Trim
	If s.Length = 0 Then Return Max(0, Min(1, fDefaultValue))
	If s.StartsWith("[") And s.EndsWith("]") And s.Length > 2 Then
		s = s.SubString2(1, s.Length - 1).Trim
	End If
	If s.EndsWith("%") Then
		Dim pct As Double = ParseCssNumber(s.SubString2(0, s.Length - 1), -1)
		If pct >= 0 Then Return Max(0, Min(1, pct / 100))
		Return Max(0, Min(1, fDefaultValue))
	End If
	Dim n As Double = ParseCssNumber(s, -1)
	If n < 0 Then Return Max(0, Min(1, fDefaultValue))
	If n > 1 Then n = n / 100
	Return Max(0, Min(1, n))
End Sub

Private Sub ColorAlpha01(iColorValue As Int) As Float
	Dim a As Int = Bit.And(Bit.ShiftRight(iColorValue, 24), 0xFF)
	Return a / 255
End Sub

Private Sub IsBorderStyleToken(sToken As String) As Boolean
	Dim s As String = NormalizeBorderStyle(sToken)
	Return s.Length > 0
End Sub

Private Sub NormalizeBorderStyle(sToken As String) As String
	If sToken = Null Then Return ""
	Dim s As String = sToken.ToLowerCase.Trim
	If s.StartsWith("border-") Then s = s.SubString(7).Trim
	Select Case s
		Case "solid", "dashed", "dotted", "double", "hidden", "none"
			Return s
		Case Else
			Return ""
	End Select
End Sub

Private Sub SetBorderWidthScope(mSpec As Map, sScope As String, fWidthDip As Float, bRtlEnabled As Boolean)
	Dim v As Float = Max(0, fWidthDip)
	Select Case sScope
		Case "all"
			mSpec.Put("border_top_width", v)
			mSpec.Put("border_right_width", v)
			mSpec.Put("border_bottom_width", v)
			mSpec.Put("border_left_width", v)
		Case "x"
			mSpec.Put("border_left_width", v)
			mSpec.Put("border_right_width", v)
		Case "y"
			mSpec.Put("border_top_width", v)
			mSpec.Put("border_bottom_width", v)
		Case "t"
			mSpec.Put("border_top_width", v)
		Case "r"
			mSpec.Put("border_right_width", v)
		Case "b"
			mSpec.Put("border_bottom_width", v)
		Case "l"
			mSpec.Put("border_left_width", v)
		Case "s"
			If bRtlEnabled Then
				mSpec.Put("border_right_width", v)
			Else
				mSpec.Put("border_left_width", v)
			End If
		Case "e"
			If bRtlEnabled Then
				mSpec.Put("border_left_width", v)
			Else
				mSpec.Put("border_right_width", v)
			End If
	End Select
End Sub

Private Sub SetBorderStyleScope(mSpec As Map, sScope As String, sStyleValue As String, bRtlEnabled As Boolean)
	Dim styleResolved As String = NormalizeBorderStyle(sStyleValue)
	If styleResolved.Length = 0 Then styleResolved = "solid"
	Select Case sScope
		Case "all"
			mSpec.Put("border_top_style", styleResolved)
			mSpec.Put("border_right_style", styleResolved)
			mSpec.Put("border_bottom_style", styleResolved)
			mSpec.Put("border_left_style", styleResolved)
		Case "x"
			mSpec.Put("border_left_style", styleResolved)
			mSpec.Put("border_right_style", styleResolved)
		Case "y"
			mSpec.Put("border_top_style", styleResolved)
			mSpec.Put("border_bottom_style", styleResolved)
		Case "t"
			mSpec.Put("border_top_style", styleResolved)
		Case "r"
			mSpec.Put("border_right_style", styleResolved)
		Case "b"
			mSpec.Put("border_bottom_style", styleResolved)
		Case "l"
			mSpec.Put("border_left_style", styleResolved)
		Case "s"
			If bRtlEnabled Then
				mSpec.Put("border_right_style", styleResolved)
			Else
				mSpec.Put("border_left_style", styleResolved)
			End If
		Case "e"
			If bRtlEnabled Then
				mSpec.Put("border_left_style", styleResolved)
			Else
				mSpec.Put("border_right_style", styleResolved)
			End If
	End Select
End Sub

Private Sub SetBorderColorScope(mSpec As Map, sScope As String, iColorValue As Int, bRtlEnabled As Boolean)
	Select Case sScope
		Case "all"
			mSpec.Put("border_top_color", iColorValue)
			mSpec.Put("border_right_color", iColorValue)
			mSpec.Put("border_bottom_color", iColorValue)
			mSpec.Put("border_left_color", iColorValue)
		Case "x"
			mSpec.Put("border_left_color", iColorValue)
			mSpec.Put("border_right_color", iColorValue)
		Case "y"
			mSpec.Put("border_top_color", iColorValue)
			mSpec.Put("border_bottom_color", iColorValue)
		Case "t"
			mSpec.Put("border_top_color", iColorValue)
		Case "r"
			mSpec.Put("border_right_color", iColorValue)
		Case "b"
			mSpec.Put("border_bottom_color", iColorValue)
		Case "l"
			mSpec.Put("border_left_color", iColorValue)
		Case "s"
			If bRtlEnabled Then
				mSpec.Put("border_right_color", iColorValue)
			Else
				mSpec.Put("border_left_color", iColorValue)
			End If
		Case "e"
			If bRtlEnabled Then
				mSpec.Put("border_left_color", iColorValue)
			Else
				mSpec.Put("border_right_color", iColorValue)
			End If
	End Select
End Sub

Private Sub SetRoundedScope(mSpec As Map, sScope As String, fRadiusDip As Float, bRtlEnabled As Boolean)
	Dim r As Float = Max(0, fRadiusDip)
	Select Case sScope
		Case "all"
			mSpec.Put("radius_tl", r)
			mSpec.Put("radius_tr", r)
			mSpec.Put("radius_br", r)
			mSpec.Put("radius_bl", r)
		Case "t"
			mSpec.Put("radius_tl", r)
			mSpec.Put("radius_tr", r)
		Case "b"
			mSpec.Put("radius_bl", r)
			mSpec.Put("radius_br", r)
		Case "l"
			mSpec.Put("radius_tl", r)
			mSpec.Put("radius_bl", r)
		Case "r"
			mSpec.Put("radius_tr", r)
			mSpec.Put("radius_br", r)
		Case "tl"
			mSpec.Put("radius_tl", r)
		Case "tr"
			mSpec.Put("radius_tr", r)
		Case "br"
			mSpec.Put("radius_br", r)
		Case "bl"
			mSpec.Put("radius_bl", r)
		Case "s"
			If bRtlEnabled Then
				mSpec.Put("radius_tr", r)
				mSpec.Put("radius_br", r)
			Else
				mSpec.Put("radius_tl", r)
				mSpec.Put("radius_bl", r)
			End If
		Case "e"
			If bRtlEnabled Then
				mSpec.Put("radius_tl", r)
				mSpec.Put("radius_bl", r)
			Else
				mSpec.Put("radius_tr", r)
				mSpec.Put("radius_br", r)
			End If
		Case "ss"
			If bRtlEnabled Then
				mSpec.Put("radius_tr", r)
			Else
				mSpec.Put("radius_tl", r)
			End If
		Case "se"
			If bRtlEnabled Then
				mSpec.Put("radius_tl", r)
			Else
				mSpec.Put("radius_tr", r)
			End If
		Case "ee"
			If bRtlEnabled Then
				mSpec.Put("radius_bl", r)
			Else
				mSpec.Put("radius_br", r)
			End If
		Case "es"
			If bRtlEnabled Then
				mSpec.Put("radius_br", r)
			Else
				mSpec.Put("radius_bl", r)
			End If
	End Select
End Sub

Private Sub SyncBorderAggregate(mSpec As Map)
	If mSpec.IsInitialized = False Then Return
	Dim tw As Float = Max(0, mSpec.GetDefault("border_top_width", 0))
	Dim rw As Float = Max(0, mSpec.GetDefault("border_right_width", 0))
	Dim bw As Float = Max(0, mSpec.GetDefault("border_bottom_width", 0))
	Dim lw As Float = Max(0, mSpec.GetDefault("border_left_width", 0))
	Dim uniformW As Boolean = (tw = rw And rw = bw And bw = lw)
	mSpec.Put("border_uniform_width", uniformW)
	mSpec.Put("border_width", IIf(uniformW, tw, Max(Max(tw, rw), Max(bw, lw))))

	Dim tc As Int = mSpec.GetDefault("border_top_color", xui.Color_Black)
	Dim rc As Int = mSpec.GetDefault("border_right_color", tc)
	Dim bc As Int = mSpec.GetDefault("border_bottom_color", tc)
	Dim lc As Int = mSpec.GetDefault("border_left_color", tc)
	Dim uniformC As Boolean = (tc = rc And rc = bc And bc = lc)
	mSpec.Put("border_uniform_color", uniformC)
	mSpec.Put("border_color", tc)
	mSpec.Put("border_opacity", ColorAlpha01(tc))

	Dim ts As String = mSpec.GetDefault("border_top_style", "solid")
	Dim rs As String = mSpec.GetDefault("border_right_style", ts)
	Dim bs As String = mSpec.GetDefault("border_bottom_style", ts)
	Dim ls As String = mSpec.GetDefault("border_left_style", ts)
	Dim uniformS As Boolean = (ts = rs And rs = bs And bs = ls)
	mSpec.Put("border_uniform_style", uniformS)
	mSpec.Put("border_style", ts)
End Sub

Private Sub SyncRadiusAggregate(mSpec As Map)
	If mSpec.IsInitialized = False Then Return
	Dim tl As Float = Max(0, mSpec.GetDefault("radius_tl", 0))
	Dim tr As Float = Max(0, mSpec.GetDefault("radius_tr", 0))
	Dim br As Float = Max(0, mSpec.GetDefault("radius_br", 0))
	Dim bl As Float = Max(0, mSpec.GetDefault("radius_bl", 0))
	Dim uniformR As Boolean = (tl = tr And tr = br And br = bl)
	mSpec.Put("radius_uniform", uniformR)
	mSpec.Put("radius", IIf(uniformR, tl, Max(Max(tl, tr), Max(br, bl))))
End Sub

Private Sub NormalizeUtilityToken(sToken As String) As String
	If sToken = Null Then Return ""
	Dim t As String = sToken.Trim
	If t.Length = 0 Then Return ""
	Dim p As Int = t.LastIndexOf(":")
	If p >= 0 And p < t.Length - 1 Then t = t.SubString(p + 1)
	Return t
End Sub

''' <summary>
''' Extracts the raw spacing token from a utility class string like "px-4" -> "4", "p-2" -> "2".
''' Public alias used by B4XDaisyInput and other components.
''' </summary>
Public Sub ExtractSpacingValue(sValue As String) As String
	Return NormalizeSpacingValueToken(sValue)
End Sub

''' <summary>
''' Resolves a single-character icon string to the appropriate icon Typeface.
''' Returns Typeface.DEFAULT when the character doesn't match known icon fonts.
''' Used by B4XDaisyInput.ApplyIconLabel for inline icon characters.
''' </summary>
Public Sub ResolveIconTypeface(sIcon As String) As Typeface
	If sIcon.Length <> 1 Then Return Typeface.DEFAULT
	Dim code As Int = Asc(sIcon)
	' Font Awesome Free solid icons typically use the Private Use Area (PUA)
	' Common ranges: 0xF000-0xF8FF, 0xE000-0xE800
	' Material Icons use 0xE000-0xE800 range
	If code >= 0xE000 And code <= 0xF8FF Then
		' Icon font resolution - B4X CreateFontAwesome returns B4XFont
		' which doesn't expose Typeface in this version. Return DEFAULT and
		' let icon rendering fall back to CSS class-based icons.
		Return Typeface.DEFAULT
	End If
	Return Typeface.DEFAULT
End Sub

Private Sub NormalizeSpacingValueToken(sValue As String) As String
	Dim s As String = NormalizeUtilityToken(sValue.ToLowerCase)
	If s.Length = 0 Then Return ""

	' Strip common utility prefixes while preserving the trailing spacing token.
	Dim prefixes() As String = Array As String( _
		"gap-x-", "gap-y-", "gap-", _
		"space-x-", "space-y-", _
		"px-", "py-", "pt-", "pr-", "pb-", "pl-", "ps-", "pe-", "p-", _
		"mx-", "my-", "mt-", "mr-", "mb-", "ml-", "ms-", "me-", "m-", _
		"w-", "h-", "size-" _
	)
	For Each pref As String In prefixes
		If s.StartsWith(pref) And s.Length > pref.Length Then
			Return s.SubString(pref.Length).Trim
		End If
	Next
	Return s
End Sub

Private Sub NormalizeSizeValueToken(sValue As String) As String
	Dim s As String = NormalizeUtilityToken(sValue.ToLowerCase)
	If s.Length = 0 Then Return ""

	If s.StartsWith("w-") Or s.StartsWith("h-") Or s.StartsWith("size-") Then
		Dim p As Int = s.LastIndexOf("-")
		If p >= 0 And p < s.Length - 1 Then s = s.SubString(p + 1)
	End If

	If s.StartsWith("[") And s.EndsWith("]") And s.Length > 2 Then
		s = s.SubString2(1, s.Length - 1).Trim
	End If

	If s = "full" Or s = "screen" Then s = "100%"
	Return s
End Sub

Private Sub HasExplicitCssSizeUnit(sToken As String) As Boolean
	If sToken = Null Then Return False
	Dim s As String = sToken.Trim.ToLowerCase
	If s.Length = 0 Then Return False
	Return s.EndsWith("px") Or s.EndsWith("rem") Or s.EndsWith("em")
End Sub

Public Sub ContainsAny(sText As String, oNeedles() As String) As Boolean
	If sText = Null Then Return False
	Dim s As String = sText.ToLowerCase
	For Each n As String In oNeedles
		If n = Null Then Continue
		Dim k As String = n.ToLowerCase
		If k.Length = 0 Then Continue
		If s.Contains(k) Then Return True
	Next
	Return False
End Sub

Public Sub IsRtl As Boolean
	#If B4A
	Try
		Dim joLocale As JavaObject
		joLocale.InitializeStatic("java.util.Locale")
		Dim localeObj As Object = joLocale.RunMethod("getDefault", Null)
		Dim joTextUtils As JavaObject
		joTextUtils.InitializeStatic("android.text.TextUtils")
		Dim dir As Int = joTextUtils.RunMethod("getLayoutDirectionFromLocale", Array(localeObj))
		Return dir = 1
	Catch
		Return False
	End Try
	#Else
	Return False
	#End If
End Sub

Private Sub ParseCssLengthToPx(sValue As String, fDefaultPx As Float) As Float
	Dim s As String = sValue.ToLowerCase.Trim
	If s.Length = 0 Then Return fDefaultPx
	If s.StartsWith("[") And s.EndsWith("]") And s.Length > 2 Then
		s = s.SubString2(1, s.Length - 1).Trim
	End If
	If s.EndsWith("px") Then
		Dim npx As Double = ParseCssNumber(s.SubString2(0, s.Length - 2), -1)
		If npx >= 0 Then Return npx
		Return fDefaultPx
	End If
	If s.EndsWith("rem") Then
		Dim nrem As Double = ParseCssNumber(s.SubString2(0, s.Length - 3), -1)
		If nrem >= 0 Then Return nrem * CSS_BASE_FONT_PX
		Return fDefaultPx
	End If
	If s.EndsWith("em") Then
		Dim nem As Double = ParseCssNumber(s.SubString2(0, s.Length - 2), -1)
		If nem >= 0 Then Return nem * CSS_BASE_FONT_PX
		Return fDefaultPx
	End If
	Dim n As Double = ParseCssNumber(s, -1)
	If n >= 0 Then Return n
	Return fDefaultPx
End Sub

Private Sub ResolveSpacingStepPx As Float
	Dim raw As String = GetTokenString("--spacing", "0.25rem")
	Dim px As Float = ParseCssLengthToPx(raw, 4)
	Return Max(0.0001, px)
End Sub

Private Sub ParseCssNumber(sText As String, dDefaultValue As Double) As Double
	Dim s As String = sText.Trim
	If s.Length = 0 Then Return dDefaultValue
	If IsNumber(s) = False Then Return dDefaultValue
	Return s
End Sub
Public Sub NormalizeRounded(sValue As String) As String
	If sValue = Null Then Return "rounded-none"
	Dim s As String = sValue.ToLowerCase.Trim
	Select Case s
		Case "", "theme", "selector"
			Return "rounded-md" ' Default for daisy
		Case "none", "rounded-none"
			Return "rounded-none"
		Case "sm", "rounded-sm"
			Return "rounded-sm"
		Case "default", "rounded"
			Return "rounded"
		Case "md", "rounded-md"
			Return "rounded-md"
		Case "lg", "rounded-lg"
			Return "rounded-lg"
		Case "xl", "rounded-xl"
			Return "rounded-xl"
		Case "2xl", "rounded-2xl"
			Return "rounded-2xl"
		Case "3xl", "rounded-3xl"
			Return "rounded-3xl"
		Case "full", "rounded-full"
			Return "rounded-full"
		Case "box", "rounded-box"
			Return "rounded-box"     ' DaisyUI --rounded-box: 1rem
		Case "field", "rounded-field"
			Return "rounded-field"   ' DaisyUI --rounded-field: 0.5rem
		Case "selector", "rounded-selector"
			Return "rounded-selector" ' DaisyUI --rounded-selector: 0.25rem
		Case Else
			Return "rounded-md"
	End Select
End Sub

Public Sub ResolveRoundedDip(sRounded As String, fDefaultDip As Float) As Float
	Select Case NormalizeRounded(sRounded)
		Case "rounded-none"
			Return 0
		Case "rounded-sm"
			Return 2dip
		Case "rounded"
			Return 4dip
		Case "rounded-md"
			Return 6dip
		Case "rounded-lg"
			Return 8dip
		Case "rounded-xl"
			Return 12dip
		Case "rounded-2xl"
			Return 16dip
		Case "rounded-3xl"
			Return 24dip
		Case "rounded-full"
			Return 9999dip
		Case "rounded-box"
			Return GetRadiusBoxDip(IIf(fDefaultDip > 0, fDefaultDip, 16dip))  ' DaisyUI --radius-box (theme-aware)
		Case "rounded-field"
			Return GetRadiusFieldDip(IIf(fDefaultDip > 0, fDefaultDip, 8dip))   ' DaisyUI --radius-field (theme-aware)
		Case "rounded-selector"
			Return GetRadiusSelectorDip(IIf(fDefaultDip > 0, fDefaultDip, 4dip)) ' DaisyUI --radius-selector (theme-aware)
		Case Else
			Return fDefaultDip
	End Select
End Sub

Public Sub SetAlpha(iColor As Int, iAlpha As Int) As Int
	Dim r As Int = Bit.And(Bit.ShiftRight(iColor, 16), 0xFF)
	Dim g As Int = Bit.And(Bit.ShiftRight(iColor, 8), 0xFF)
	Dim b As Int = Bit.And(iColor, 0xFF)
	Return Bit.Or(Bit.ShiftLeft(iAlpha, 24), Bit.Or(Bit.ShiftLeft(r, 16), Bit.Or(Bit.ShiftLeft(g, 8), b)))
End Sub

Public Sub ShiftColor(iColor As Int, fFactor As Float) As Int
	Dim a As Int = Bit.And(Bit.ShiftRight(iColor, 24), 0xFF)
	Dim r As Int = Bit.And(Bit.ShiftRight(iColor, 16), 0xFF)
	Dim g As Int = Bit.And(Bit.ShiftRight(iColor, 8), 0xFF)
	Dim b As Int = Bit.And(iColor, 0xFF)
	r = Max(0, Min(255, r * fFactor))
	g = Max(0, Min(255, g * fFactor))
	b = Max(0, Min(255, b * fFactor))
	Return Bit.Or(Bit.ShiftLeft(a, 24), Bit.Or(Bit.ShiftLeft(r, 16), Bit.Or(Bit.ShiftLeft(g, 8), b)))
End Sub

Public Sub CloneProps(mProps As Map) As Map
	Dim m As Map
	m.Initialize
	If mProps.IsInitialized Then
		For Each k As Object In mProps.Keys
			m.Put(k, mProps.Get(k))
		Next
	End If
	Return m
End Sub

Public Sub DisableClipping(vView As B4XView)
	' Disable clipping on a single view.  This is the canonical implementation used
	' throughout the library.  Components should call this directly rather than
	' re-implement the logic themselves.
	If vView.IsInitialized = False Then Return
	#If B4A
	Try
		Dim jo As JavaObject = vView
		jo.RunMethod("setClipChildren", Array(False))
		jo.RunMethod("setClipToPadding", Array(False))
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyVariants.DisableClipping: " & LastException.Message)
	End Try   'ignore
	#End If
End Sub

' Convenience helper that disables clipping on the supplied view and, optionally,
' a number of its ancestors.  Pass a negative value for MaxLevels to walk all the
' way to the root.
Public Sub DisableClippingChain(vStartView As B4XView, iMaxLevels As Int)
	If vStartView.IsInitialized = False Then Return
	Dim v As B4XView = vStartView
	Dim count As Int = 0
	Do While v.IsInitialized
		DisableClipping(v)
		' when walking up the tree the parent might be a ViewRootImpl or other
		' non-View object; attempting to access .Parent would crash when
		' the internal cast fails.  Wrap in Try and bail out if we cannot
		' obtain a usable parent.
		Try
			Dim pv As B4XView = v.Parent
			If pv.IsInitialized = False Then Exit
			v = pv
		Catch
			' parent not a view, stop climbing
			Exit
		End Try
		count = count + 1
		If iMaxLevels >= 0 And count > iMaxLevels Then Exit
	Loop
End Sub

' Recursively disable clipping on the view and all of its ancestors.  This mirrors
' the implementation previously duplicated in several components (e.g. tooltip).
Public Sub DisableClippingRecursive(vView As B4XView)
	DisableClippingChain(vView, -1)
End Sub

Public Sub ApplyElevation(vView As B4XView, sShadowLevel As String)
	If vView.IsInitialized = False Then Return
	Dim e As Float = ResolveShadowElevation(sShadowLevel)
	#If B4A
	Try
		Dim jo As JavaObject = vView
		jo.RunMethod("setElevation", Array(e))
		jo.RunMethod("setTranslationZ", Array(e))
		' Clip content to the rounded outline
		jo.RunMethod("setClipToOutline", Array(True))
		' Explicitly set BACKGROUND outline provider so the shadow follows the
		' corner radius of the background drawable on all Android API levels
		Try
			Dim ovp As JavaObject
			ovp.InitializeStatic("android.view.ViewOutlineProvider")
			jo.RunMethod("setOutlineProvider", Array As Object(ovp.GetField("BACKGROUND")))
			jo.RunMethod("invalidateOutline", Null)
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisyVariants.ApplyElevation: " & LastException.Message)
		End Try
	Catch
		Try
			Dim p As Panel = vView
			p.Elevation = e
		Catch
			If B4XDaisyApp.DebugLogs Then Log("B4XDaisyVariants.ApplyElevation: " & LastException.Message)
		End Try   'ignore
	End Try
	#End If
End Sub

'**** FLEX"

'-
' PUBLIC API - CONTAINER
'-

Public Sub ParseFlexContainerTokens(sTokenString As String) As Map
    Dim r As Map
    r.Initialize
    
    r.Put("hasDirection", False)
    r.Put("direction", "row")
    
    r.Put("hasWrapMode", False)
    r.Put("wrapmode", "wrap")
    
    r.Put("hasJustify", False)
    r.Put("justify", "start")
    
    r.Put("hasItems", False)
    r.Put("items", "start")
    
    r.Put("hasContent", False)
    r.Put("content", "start")
    
    r.Put("hasGapX", False) : r.Put("gapx", 0)
    r.Put("hasGapY", False) : r.Put("gapy", 0)
    
    r.Put("hasPadding", False)
    r.Put("pl", 0) : r.Put("pt", 0) : r.Put("pr", 0) : r.Put("pb", 0)
    
    If sTokenString = Null Then Return r
    
    Dim tokens() As String = Regex.Split("\s+", sTokenString.Trim)
    For Each tRaw As String In tokens
        Dim t As String = tRaw.Trim.ToLowerCase
        If t = "" Then Continue
    Next
    
    Return r
End Sub

Public Sub ApplyFlexContainerTokens(fp As B4XDaisyFlexPanel, sTokenString As String, bDoRelayout As Boolean)
    If fp.IsInitialized = False Then Return
    Dim parsed As Map = ParseFlexContainerTokens(sTokenString)
    ApplyParsedFlexContainerTokens(fp, parsed, bDoRelayout)
End Sub

Public Sub ApplyParsedFlexContainerTokens(fp As B4XDaisyFlexPanel, mParsed As Map, bDoRelayout As Boolean)
    If fp.IsInitialized = False Then Return
    If mParsed.IsInitialized = False Then Return
    
    fp.BeginUpdate
    
    If GetMapBool(mParsed, "hasDirection", False) Then fp.Direction = GetMapString(mParsed, "direction", fp.Direction)
    If GetMapBool(mParsed, "hasWrapMode", False) Then fp.WrapMode = GetMapString(mParsed, "wrapmode", fp.WrapMode)
    If GetMapBool(mParsed, "hasJustify", False) Then fp.JustifyContent = GetMapString(mParsed, "justify", fp.JustifyContent)
    If GetMapBool(mParsed, "hasItems", False) Then fp.AlignItems = GetMapString(mParsed, "items", fp.AlignItems)
    If GetMapBool(mParsed, "hasContent", False) Then fp.AlignContent = GetMapString(mParsed, "content", fp.AlignContent)
    
    If GetMapBool(mParsed, "hasGapX", False) Then fp.GapX = GetMapInt(mParsed, "gapx", fp.GapX)
    If GetMapBool(mParsed, "hasGapY", False) Then fp.GapY = GetMapInt(mParsed, "gapy", fp.GapY)
    
    If GetMapBool(mParsed, "hasPadding", False) Then
        fp.PaddingLeft = GetMapInt(mParsed, "pl", fp.PaddingLeft)
        fp.PaddingTop = GetMapInt(mParsed, "pt", fp.PaddingTop)
        fp.PaddingRight = GetMapInt(mParsed, "pr", fp.PaddingRight)
        fp.PaddingBottom = GetMapInt(mParsed, "pb", fp.PaddingBottom)
    End If
    
    fp.EndUpdate(bDoRelayout)
End Sub

'-
' PUBLIC API - ITEM
'-

Public Sub ParseFlexItemTokens(sTokenString As String) As Map
    Dim r As Map
    r.Initialize
    
    'flex + constraints
    r.Put("hasFlex", False)
    r.Put("grow", 0)
    r.Put("shrink", 1)
    r.Put("minw", -1)
    r.Put("maxw", -1)
    r.Put("minh", -1)
    r.Put("maxh", -1)
    
    'absolute basis (w/h)
    r.Put("hasBasis", False)
    r.Put("basisw", -1)
    r.Put("basish", -1)
    
    'main-axis absolute basis (needs direction at apply time)
    r.Put("hasBasisMainAbs", False)
    r.Put("basis_main_abs", -1)
    
    'percent basis
    r.Put("hasBasisPct", False)
    r.Put("basis_main_pct", -1)
    r.Put("basis_cross_pct", -1)
    
    'margins
    r.Put("hasMargins", False)
    r.Put("ml", 0) : r.Put("mt", 0) : r.Put("mr", 0) : r.Put("mb", 0)
    
    'align/order/wrapbefore
    r.Put("hasAlignSelf", False)
    r.Put("alignself", "auto")
    
    r.Put("hasOrder", False)
    r.Put("order", 0)
    
    r.Put("hasWrapBefore", False)
    r.Put("wrapbefore", False)
    
    If sTokenString = Null Then Return r
    
    Dim tokens() As String = Regex.Split("\s+", sTokenString.Trim)
    For Each tRaw As String In tokens
        Dim t As String = tRaw.Trim.ToLowerCase
        If t = "" Then Continue
    Next
    
    Return r
End Sub

Public Sub ApplyFlexItemTokens(fp As B4XDaisyFlexPanel, vView As B4XView, sTokenString As String, bDoRelayout As Boolean)
    If fp.IsInitialized = False Then Return
    If vView.IsInitialized = False Then Return
    
    Dim parsed As Map = ParseFlexItemTokens(sTokenString)
    ApplyParsedFlexItemTokens(fp, vView, parsed, bDoRelayout)
End Sub

Public Sub ApplyParsedFlexItemTokens(fp As B4XDaisyFlexPanel, vView As B4XView, mParsed As Map, bDoRelayout As Boolean)
    If fp.IsInitialized = False Then Return
    If vView.IsInitialized = False Then Return
    If mParsed.IsInitialized = False Then Return
    
    Dim it As B4XDaisyFlexItem = fp.Item(vView)
    
    'Flex + constraints
    If GetMapBool(mParsed, "hasFlex", False) Then
        it.Flex(GetMapFloat(mParsed, "grow", 0), GetMapFloat(mParsed, "shrink", 1)) _
          .MinW(GetMapInt(mParsed, "minw", -1)) _
          .MaxW(GetMapInt(mParsed, "maxw", -1)) _
          .MinH(GetMapInt(mParsed, "minh", -1)) _
          .MaxH(GetMapInt(mParsed, "maxh", -1))
    End If
    
    'basis-20 (main axis absolute) -> map to w/h based on panel direction
    If GetMapBool(mParsed, "hasBasisMainAbs", False) Then
        Dim b As Int = GetMapInt(mParsed, "basis_main_abs", -1)
        Dim dir As String = fp.Direction.ToLowerCase
        mParsed.Put("hasBasis", True)
        If dir.StartsWith("row") Then
            mParsed.Put("basisw", b)
        Else
            mParsed.Put("basish", b)
        End If
    End If
    
    'Absolute basis
    If GetMapBool(mParsed, "hasBasis", False) Then
        it.Basis(GetMapInt(mParsed, "basisw", -1), GetMapInt(mParsed, "basish", -1))
    End If
    
    'Percent basis
    If GetMapBool(mParsed, "hasBasisPct", False) Then
        it.BasisPercent(GetMapFloat(mParsed, "basis_main_pct", -1), GetMapFloat(mParsed, "basis_cross_pct", -1))
    End If
    
    'Margins
    If GetMapBool(mParsed, "hasMargins", False) Then
        it.Margins( _
            GetMapInt(mParsed, "ml", 0), _
            GetMapInt(mParsed, "mt", 0), _
            GetMapInt(mParsed, "mr", 0), _
            GetMapInt(mParsed, "mb", 0))
    End If
    
    'Align self
    If GetMapBool(mParsed, "hasAlignSelf", False) Then
        it.AlignSelf(GetMapString(mParsed, "alignself", "auto"))
    End If
    
    'Order
    If GetMapBool(mParsed, "hasOrder", False) Then
        it.Order(GetMapInt(mParsed, "order", 0))
    End If
    
    'Wrap-before
    If GetMapBool(mParsed, "hasWrapBefore", False) Then
        it.WrapBefore(GetMapBool(mParsed, "wrapbefore", False))
    End If
    
    it.ApplyEx(bDoRelayout)
End Sub

'-
' INTERNAL PARSER - CONTAINER
'-

Private Sub ParseContainerTokenIntoMap(mR As Map, sT As String) As Boolean
    'Direction
    Select sT
        Case "flex-row"
            mR.Put("hasDirection", True) : mR.Put("direction", "row")
            Return True
        Case "flex-row-reverse"
            mR.Put("hasDirection", True) : mR.Put("direction", "row-reverse")
            Return True
        Case "flex-col"
            mR.Put("hasDirection", True) : mR.Put("direction", "column")
            Return True
        Case "flex-col-reverse"
            mR.Put("hasDirection", True) : mR.Put("direction", "column-reverse")
            Return True
    End Select
    
    'Wrap mode
    Select sT
        Case "flex-wrap"
            mR.Put("hasWrapMode", True) : mR.Put("wrapmode", "wrap")
            Return True
        Case "flex-nowrap"
            mR.Put("hasWrapMode", True) : mR.Put("wrapmode", "nowrap")
            Return True
        Case "flex-wrap-reverse"
            mR.Put("hasWrapMode", True) : mR.Put("wrapmode", "wrap-reverse")
            Return True
    End Select
    
    'Justify
    If sT.StartsWith("justify-") Then
        Dim s As String = sT.SubString(8)
        Select s
            Case "start"
                mR.Put("hasJustify", True) : mR.Put("justify", "start") : Return True
            Case "center"
                mR.Put("hasJustify", True) : mR.Put("justify", "center") : Return True
            Case "end"
                mR.Put("hasJustify", True) : mR.Put("justify", "end") : Return True
            Case "between"
                mR.Put("hasJustify", True) : mR.Put("justify", "space-between") : Return True
            Case "around"
                mR.Put("hasJustify", True) : mR.Put("justify", "space-around") : Return True
            Case "evenly"
                mR.Put("hasJustify", True) : mR.Put("justify", "space-evenly") : Return True
        End Select
    End If
    
    'Align items
    If sT.StartsWith("items-") Then
        Dim i As String = sT.SubString(6)
        Select i
            Case "start"
                mR.Put("hasItems", True) : mR.Put("items", "start") : Return True
            Case "center"
                mR.Put("hasItems", True) : mR.Put("items", "center") : Return True
            Case "end"
                mR.Put("hasItems", True) : mR.Put("items", "end") : Return True
            Case "stretch"
                mR.Put("hasItems", True) : mR.Put("items", "stretch") : Return True
        End Select
    End If
    
    'Align content
    If sT.StartsWith("content-") Then
        Dim c As String = sT.SubString(8)
        Select c
            Case "start"
                mR.Put("hasContent", True) : mR.Put("content", "start") : Return True
            Case "center"
                mR.Put("hasContent", True) : mR.Put("content", "center") : Return True
            Case "end"
                mR.Put("hasContent", True) : mR.Put("content", "end") : Return True
            Case "stretch"
                mR.Put("hasContent", True) : mR.Put("content", "stretch") : Return True
            Case "between"
                mR.Put("hasContent", True) : mR.Put("content", "space-between") : Return True
            Case "around"
                mR.Put("hasContent", True) : mR.Put("content", "space-around") : Return True
            Case "evenly"
                mR.Put("hasContent", True) : mR.Put("content", "space-evenly") : Return True
        End Select
    End If
    
    'Gap
    If sT.StartsWith("gap-") Then
        'Could be gap-2 OR gap-x-2 OR gap-y-2
        If sT.StartsWith("gap-x-") Then
            Dim ngx As NullableFloat = TryParseFloat(sT.SubString(6))
            If ngx.Success Then
                mR.Put("hasGapX", True)
                mR.Put("gapx", SpaceTokenToPx(ngx.Value))
                Return True
            End If
        Else If sT.StartsWith("gap-y-") Then
            Dim ngy As NullableFloat = TryParseFloat(sT.SubString(6))
            If ngy.Success Then
                mR.Put("hasGapY", True)
                mR.Put("gapy", SpaceTokenToPx(ngy.Value))
                Return True
            End If
        Else
            Dim ng As NullableFloat = TryParseFloat(sT.SubString(4))
            If ng.Success Then
                Dim px As Int = SpaceTokenToPx(ng.Value)
                mR.Put("hasGapX", True) : mR.Put("gapx", px)
                mR.Put("hasGapY", True) : mR.Put("gapy", px)
                Return True
            End If
        End If
    End If
    
    'Padding
    If ParsePaddingToken(mR, sT) Then Return True
    
    Return False
End Sub

Private Sub ParsePaddingToken(mR As Map, sT As String) As Boolean
    'p-2, px-2, py-1, pt-2, pr-1, pb-2, pl-1
    If sT.StartsWith("p-") Then
        Dim n As NullableFloat = TryParseFloat(sT.SubString(2))
        If n.Success Then
            Dim px As Int = SpaceTokenToPx(n.Value)
            mR.Put("hasPadding", True)
            mR.Put("pl", px) : mR.Put("pt", px) : mR.Put("pr", px) : mR.Put("pb", px)
            Return True
        End If
    End If
    
    If sT.StartsWith("px-") Then
        Dim n2 As NullableFloat = TryParseFloat(sT.SubString(3))
        If n2.Success Then
            Dim px2 As Int = SpaceTokenToPx(n2.Value)
            mR.Put("hasPadding", True)
            mR.Put("pl", px2) : mR.Put("pr", px2)
            Return True
        End If
    End If
    
    If sT.StartsWith("py-") Then
        Dim n3 As NullableFloat = TryParseFloat(sT.SubString(3))
        If n3.Success Then
            Dim px3 As Int = SpaceTokenToPx(n3.Value)
            mR.Put("hasPadding", True)
            mR.Put("pt", px3) : mR.Put("pb", px3)
            Return True
        End If
    End If
    
    If sT.StartsWith("pt-") Then
        Dim n4 As NullableFloat = TryParseFloat(sT.SubString(3))
        If n4.Success Then
            mR.Put("hasPadding", True)
            mR.Put("pt", SpaceTokenToPx(n4.Value))
            Return True
        End If
    End If
    
    If sT.StartsWith("pr-") Then
        Dim n5 As NullableFloat = TryParseFloat(sT.SubString(3))
        If n5.Success Then
            mR.Put("hasPadding", True)
            mR.Put("pr", SpaceTokenToPx(n5.Value))
            Return True
        End If
    End If
    
    If sT.StartsWith("pb-") Then
        Dim n6 As NullableFloat = TryParseFloat(sT.SubString(3))
        If n6.Success Then
            mR.Put("hasPadding", True)
            mR.Put("pb", SpaceTokenToPx(n6.Value))
            Return True
        End If
    End If
    
    If sT.StartsWith("pl-") Then
        Dim n7 As NullableFloat = TryParseFloat(sT.SubString(3))
        If n7.Success Then
            mR.Put("hasPadding", True)
            mR.Put("pl", SpaceTokenToPx(n7.Value))
            Return True
        End If
    End If
    
    Return False
End Sub

'-
' INTERNAL PARSER - ITEM
'-

Private Sub ParseItemTokenIntoMap(mR As Map, sT As String) As Boolean
    'Boolean aliases
    If sT = "grow" Then
        mR.Put("hasFlex", True)
        mR.Put("grow", 1)
        Return True
    End If
    
    If sT = "shrink" Then
        mR.Put("hasFlex", True)
        mR.Put("shrink", 1)
        Return True
    End If
    
    If sT = "wrap-before" Then
        mR.Put("hasWrapBefore", True)
        mR.Put("wrapbefore", True)
        Return True
    End If
    
    'Align self
    If sT.StartsWith("self-") Then
        Dim s As String = sT.SubString(5)
        Select s
            Case "auto", "start", "center", "end", "stretch", "flex-start", "flex-end"
                mR.Put("hasAlignSelf", True)
                mR.Put("alignself", s)
                Return True
        End Select
    End If
    
    'Order
    If sT.StartsWith("order-") Then
        Dim nOrder As NullableInt = TryParseInt(sT.SubString(6))
        If nOrder.Success Then
            mR.Put("hasOrder", True)
            mR.Put("order", nOrder.Value)
            Return True
        End If
    End If
    
    'Grow / Shrink numeric
    If sT.StartsWith("grow-") Then
        Dim ng As NullableFloat = TryParseFloat(sT.SubString(5))
        If ng.Success Then
            mR.Put("hasFlex", True)
            mR.Put("grow", ng.Value)
            Return True
        End If
    End If
    
    If sT.StartsWith("shrink-") Then
        Dim ns As NullableFloat = TryParseFloat(sT.SubString(7))
        If ns.Success Then
            mR.Put("hasFlex", True)
            mR.Put("shrink", ns.Value)
            Return True
        End If
    End If
    
    'Basis
    If sT.StartsWith("basis-") Then
        If ParseBasisToken(mR, sT.SubString(6)) Then Return True
    End If
    
    'Min/Max size
    If sT.StartsWith("min-w-") Then
        Dim n1 As NullableFloat = TryParseFloat(sT.SubString(6))
        If n1.Success Then
            mR.Put("hasFlex", True)
            mR.Put("minw", SpaceTokenToPx(n1.Value))
            Return True
        End If
    End If
    
    If sT.StartsWith("min-h-") Then
        Dim n2 As NullableFloat = TryParseFloat(sT.SubString(6))
        If n2.Success Then
            mR.Put("hasFlex", True)
            mR.Put("minh", SpaceTokenToPx(n2.Value))
            Return True
        End If
    End If
    
    If sT.StartsWith("max-w-") Then
        Dim n3 As NullableFloat = TryParseFloat(sT.SubString(6))
        If n3.Success Then
            mR.Put("hasFlex", True)
            mR.Put("maxw", SpaceTokenToPx(n3.Value))
            Return True
        End If
    End If
    
    If sT.StartsWith("max-h-") Then
        Dim n4 As NullableFloat = TryParseFloat(sT.SubString(6))
        If n4.Success Then
            mR.Put("hasFlex", True)
            mR.Put("maxh", SpaceTokenToPx(n4.Value))
            Return True
        End If
    End If
    
    'Margins
    If ParseMarginToken(mR, sT) Then Return True
    
    Return False
End Sub

Private Sub ParseBasisToken(mR As Map, sSuffix As String) As Boolean
    'basis-full -> 100%
    If sSuffix = "full" Then
        mR.Put("hasBasisPct", True)
        mR.Put("basis_main_pct", 100)
        Return True
    End If
    
    'basis-w-20 / basis-h-10 => explicit axis basis
    If sSuffix.StartsWith("w-") Then
        Dim nw As NullableFloat = TryParseFloat(sSuffix.SubString(2))
        If nw.Success Then
            mR.Put("hasBasis", True)
            mR.Put("basisw", SpaceTokenToPx(nw.Value))
            Return True
        End If
    End If
    
    If sSuffix.StartsWith("h-") Then
        Dim nh As NullableFloat = TryParseFloat(sSuffix.SubString(2))
        If nh.Success Then
            mR.Put("hasBasis", True)
            mR.Put("basish", SpaceTokenToPx(nh.Value))
            Return True
        End If
    End If
    
    'basis-1/2, basis-2/3, etc
    If sSuffix.Contains("/") Then
        Dim p() As String = Regex.Split("/", sSuffix)
        If p.Length = 2 Then
            Dim a As NullableFloat = TryParseFloat(p(0))
            Dim b As NullableFloat = TryParseFloat(p(1))
            If a.Success And b.Success And b.Value <> 0 Then
                mR.Put("hasBasisPct", True)
                mR.Put("basis_main_pct", (a.Value / b.Value) * 100)
                Return True
            End If
        End If
    End If
    
    'basis-20 => main-axis absolute basis, resolved on apply
    Dim n As NullableFloat = TryParseFloat(sSuffix)
    If n.Success Then
        mR.Put("hasBasisMainAbs", True)
        mR.Put("basis_main_abs", SpaceTokenToPx(n.Value))
        Return True
    End If
    
    Return False
End Sub

Private Sub ParseMarginToken(mR As Map, sT As String) As Boolean
    'm-2, mx-2, my-1, mt-2, mr-1, mb-2, ml-1
    If sT.StartsWith("m-") Then
        Dim n As NullableFloat = TryParseFloat(sT.SubString(2))
        If n.Success Then
            Dim px As Int = SpaceTokenToPx(n.Value)
            mR.Put("hasMargins", True)
            mR.Put("ml", px) : mR.Put("mt", px) : mR.Put("mr", px) : mR.Put("mb", px)
            Return True
        End If
    End If
    
    If sT.StartsWith("mx-") Then
        Dim n2 As NullableFloat = TryParseFloat(sT.SubString(3))
        If n2.Success Then
            Dim px2 As Int = SpaceTokenToPx(n2.Value)
            mR.Put("hasMargins", True)
            mR.Put("ml", px2) : mR.Put("mr", px2)
            Return True
        End If
    End If
    
    If sT.StartsWith("my-") Then
        Dim n3 As NullableFloat = TryParseFloat(sT.SubString(3))
        If n3.Success Then
            Dim px3 As Int = SpaceTokenToPx(n3.Value)
            mR.Put("hasMargins", True)
            mR.Put("mt", px3) : mR.Put("mb", px3)
            Return True
        End If
    End If
    
    If sT.StartsWith("mt-") Then
        Dim n4 As NullableFloat = TryParseFloat(sT.SubString(3))
        If n4.Success Then
            mR.Put("hasMargins", True)
            mR.Put("mt", SpaceTokenToPx(n4.Value))
            Return True
        End If
    End If
    
    If sT.StartsWith("mr-") Then
        Dim n5 As NullableFloat = TryParseFloat(sT.SubString(3))
        If n5.Success Then
            mR.Put("hasMargins", True)
            mR.Put("mr", SpaceTokenToPx(n5.Value))
            Return True
        End If
    End If
    
    If sT.StartsWith("mb-") Then
        Dim n6 As NullableFloat = TryParseFloat(sT.SubString(3))
        If n6.Success Then
            mR.Put("hasMargins", True)
            mR.Put("mb", SpaceTokenToPx(n6.Value))
            Return True
        End If
    End If
    
    If sT.StartsWith("ml-") Then
        Dim n7 As NullableFloat = TryParseFloat(sT.SubString(3))
        If n7.Success Then
            mR.Put("hasMargins", True)
            mR.Put("ml", SpaceTokenToPx(n7.Value))
            Return True
        End If
    End If
    
    Return False
End Sub

'-
' UTILITIES
'-

Private Sub SpaceTokenToPx(fTokenValue As Float) As Int
    Dim dips As Float = fTokenValue * FLEX_SPACE_UNIT_DIP
    Return DipToCurrent(Round(dips))
End Sub

Private Sub GetMapInt(mMap As Map, sK As String, iD As Int) As Int
    If mMap.IsInitialized = False Then Return iD
    If mMap.ContainsKey(sK) = False Then Return iD
    Return mMap.Get(sK)
End Sub

Private Sub GetMapFloat(mMap As Map, sK As String, fD As Float) As Float
    If mMap.IsInitialized = False Then Return fD
    If mMap.ContainsKey(sK) = False Then Return fD
    Return mMap.Get(sK)
End Sub

Private Sub GetMapString(mMap As Map, sK As String, sD As String) As String
    If mMap.IsInitialized = False Then Return sD
    If mMap.ContainsKey(sK) = False Then Return sD
    Return mMap.Get(sK)
End Sub

Private Sub GetMapBool(mMap As Map, sK As String, bD As Boolean) As Boolean
    If mMap.IsInitialized = False Then Return bD
    If mMap.ContainsKey(sK) = False Then Return bD
    Return mMap.Get(sK)
End Sub

Private Sub TryParseInt(sValue As String) As NullableInt
    Dim r As NullableInt
    r.Initialize
    Try
        r.Success = True
        r.Value = sValue
    Catch
        r.Success = False
        r.Value = 0
    End Try
    Return r
End Sub

Private Sub TryParseFloat(sValue As String) As NullableFloat
    Dim r As NullableFloat
    r.Initialize
    Try
        r.Success = True
        r.Value = sValue
    Catch
        r.Success = False
        r.Value = 0
    End Try
    Return r
End Sub

' Switches the global theme and forcefully updates all Daisy components on the given root view (e.g. Root of a B4XPage)
Public Sub ApplyThemeToPage(sThemeName As String, vRootView As B4XView)
    ' 1. Update the global state
    SetActiveTheme(sThemeName)
    
    ' 2. Cascade the update to all views on the page
    UpdateThemeRecursive(vRootView)
End Sub

Private Sub UpdateThemeRecursive(vParent As B4XView)
    For i = 0 To vParent.NumberOfViews - 1
        Dim v As B4XView = vParent.GetView(i)
        
        ' Check if this view is a Daisy component wrapper
        If v.Tag <> Null And v.Tag Is Object Then
            ' Duck-typing: Check if the custom class instance has an UpdateTheme method
            If xui.SubExists(v.Tag, "UpdateTheme", 0) Then
                CallSub(v.Tag, "UpdateTheme")
            End If
        End If
        
        ' Recursively search children (for panels, layouts, etc)
        If v.NumberOfViews > 0 Then
            UpdateThemeRecursive(v)
        End If
    Next
End Sub

' Centralized helper to apply dashed/dotted/solid borders using native Android drawables where needed.
' Supports B4A (Native Dash/Dot), B4i/B4J (Fallbacks to Solid).
Public Sub ApplyDashedBorder(vTarget As B4XView, iFillColor As Int, fBorderWidth As Float, iBorderColor As Int, fRadius As Float, sStyle As String)
    #If B4A
    Try
        Dim bw As Int = Max(0, fBorderWidth)
        Dim s As String = IIf(sStyle = Null, "solid", sStyle.ToLowerCase.Trim)
        If s = "dashed" Or s = "dash" Or s = "dotted" Or s = "dot" Then
            Dim dashW As Float = 0
            Dim dashGap As Float = 0
            If s = "dashed" Or s = "dash" Then
                dashW = Max(4dip, bw * 3)
                dashGap = Max(3dip, bw * 2)
            Else If s = "dotted" Or s = "dot" Then
                dashW = Max(2dip, bw)
                dashGap = Max(2dip, bw)
            End If
            
            Dim gd As JavaObject
            gd.InitializeNewInstance("android.graphics.drawable.GradientDrawable", Null)
            gd.RunMethod("setShape", Array(0)) 'RECTANGLE
            gd.RunMethod("setColor", Array(iFillColor))
            
            ' Use setCornerRadius (single float) for GradientDrawable.getOutline() compatibility
            ' across all Android API levels - setCornerRadii falls back to rect outline on < API 31
            gd.RunMethod("setCornerRadius", Array(fRadius))
            
            If bw > 0 Then
                gd.RunMethod("setStroke", Array(bw, iBorderColor, dashW, dashGap))
            End If
            
            Dim jo As JavaObject = vTarget
            jo.RunMethod("setBackground", Array(gd))
            
            ' For larger components with children at edges (like Card or Collapse), 
            ' the children might cover the border. One could add padding here if needed,
            ' but we keep it identical to Badge/Button for now.
        Else
            ' Build a GradientDrawable explicitly so setCornerRadius(float) is used
            ' (single-value call).  B4X's SetColorAndBorder uses setCornerRadii(float[])
            ' internally; when that array form is used, GradientDrawable.getOutline()
            ' falls back to setConvexPath which the Android shadow renderer does NOT
            ' support - making the elevation shadow rectangular even on rounded buttons.
            ' Using setCornerRadius(float) ensures getOutline() calls outline.setRoundRect()
            ' so shadows correctly follow the button's corner radius.
            Dim gdSolid As JavaObject
            gdSolid.InitializeNewInstance("android.graphics.drawable.GradientDrawable", Null)
            gdSolid.RunMethod("setShape", Array(0)) 'RECTANGLE
            gdSolid.RunMethod("setColor", Array(iFillColor))
            gdSolid.RunMethod("setCornerRadius", Array(fRadius))
            If bw > 0 Then
                gdSolid.RunMethod("setStroke", Array(bw, iBorderColor))
            End If
            Dim joTarget As JavaObject = vTarget
            joTarget.RunMethod("setBackground", Array(gdSolid))
        End If
    Catch
        vTarget.SetColorAndBorder(iFillColor, fBorderWidth, iBorderColor, fRadius)
    End Try
    #Else
    vTarget.SetColorAndBorder(iFillColor, fBorderWidth, iBorderColor, fRadius)
    #End If
End Sub

''' <summary>
''' Shifts all sibling views whose Top > View.Top by Delta dip, and adjusts the parent
''' panel height accordingly. Used by Accordion and standalone Collapse to auto-restack
''' page siblings after an expand/collapse without requiring page-level relayout code.
''' AnimDuration: 0 for instant, > 0 for animated.
''' </summary>
Public Sub ShiftSiblingsBelow(vView As B4XView, iDelta As Int, iAnimDuration As Int)
    If iDelta = 0 Then Return
    If vView.IsInitialized = False Then Return
    Dim parent As B4XView = vView.Parent
    If parent.IsInitialized = False Then Return
    For i = 0 To parent.NumberOfViews - 1
        Dim v As B4XView = parent.GetView(i)
        If v <> vView And v.Top > vView.Top Then
            v.SetLayoutAnimated(iAnimDuration, v.Left, v.Top + iDelta, v.Width, v.Height)
        End If
    Next
    parent.Height = parent.Height + iDelta
End Sub

''' <summary>
''' Creates a bordered background for an EditText (or any B4XView) using ColorDrawable.
''' Returns a ColorDrawable with the specified border properties.
''' Usage: EditText1.Background = B4XDaisyVariants.CreateEditTextBorder(BackgroundColor, BorderWidth, BorderColor, CornerDip)
''' </summary>
Public Sub CreateEditTextBorder(iBackgroundColor As Int, iBorderWidthDip As Int, iBorderColor As Int, iCornerDip As Int) As ColorDrawable
    Dim cd As ColorDrawable
    cd.Initialize2(iBackgroundColor, iCornerDip, iBorderWidthDip, iBorderColor)
    Return cd
End Sub

''' <summary>
''' Applies a bordered background directly to an EditText (or any B4XView).
''' This is a convenience wrapper around CreateEditTextBorder.
''' Usage: B4XDaisyVariants.ApplyEditTextBorder(EditText1, BackgroundColor, BorderWidth, BorderColor, CornerDip)
''' </summary>
Public Sub ApplyEditTextBorder(vTarget As B4XView, iBackgroundColor As Int, iBorderWidthDip As Int, iBorderColor As Int, iCornerDip As Int)
    #If B4A
    Try
        Dim cd As JavaObject
        cd.InitializeNewInstance("android.graphics.drawable.GradientDrawable", Null)
        cd.RunMethod("setShape", Array(0)) ' RECTANGLE
        cd.RunMethod("setColor", Array(iBackgroundColor))
        cd.RunMethod("setCornerRadius", Array(iCornerDip))
        If iBorderWidthDip > 0 Then
            cd.RunMethod("setStroke", Array(iBorderWidthDip, iBorderColor))
        End If
        Dim jo As JavaObject = vTarget
        jo.RunMethod("setBackground", Array(cd))
    Catch
        ' Fallback to B4X's built-in method
        vTarget.SetColorAndBorder(iBackgroundColor, iBorderWidthDip, iBorderColor, iCornerDip)
    End Try
    #Else
    vTarget.SetColorAndBorder(iBackgroundColor, iBorderWidthDip, iBorderColor, iCornerDip)
    #End If
End Sub


#Region Form Validation Helpers
''' <summary>
''' Recursively validates every control inside Parent that exposes a Validate() method.
''' Returns True only if every called Validate() returned True.
''' </summary>
Public Sub ValidateRequiredControls(vParent As B4XView) As Boolean
	Return ValidateRequiredControlsRecursive(vParent)
End Sub

Private Sub ValidateRequiredControlsRecursive(vParent As B4XView) As Boolean
	If vParent.IsInitialized = False Then Return True
	Dim allValid As Boolean = True
	Try
		Dim count As Int = vParent.NumberOfViews
		For i = 0 To count - 1
			Dim v As B4XView = vParent.GetView(i)
			If v.Tag <> Null And xui.SubExists(v.Tag, "Validate", 0) Then
				If CallSub(v.Tag, "Validate") = False Then allValid = False
			End If
			If v.NumberOfViews > 0 Then
				If ValidateRequiredControlsRecursive(v) = False Then allValid = False
			End If
		Next
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyVariants.ValidateRequiredControlsRecursive: " & LastException.Message)
	End Try
	Return allValid
End Sub

''' <summary>
''' Validates a list of component instances (or their B4XViews).
''' Each item must expose a Validate() method.
''' </summary>
Public Sub ValidateControls(lstControls As List) As Boolean
	If lstControls.IsInitialized = False Then Return True
	Dim allValid As Boolean = True
	Try
		For Each obj As Object In lstControls
			Dim target As Object = obj
			If obj Is B4XView Then
				Dim v As B4XView = obj
				If v.Tag <> Null Then target = v.Tag
			End If
			If target <> Null And xui.SubExists(target, "Validate", 0) Then
				If CallSub(target, "Validate") = False Then allValid = False
			End If
		Next
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyVariants.ValidateControls: " & LastException.Message)
	End Try
	Return allValid
End Sub
#End Region


#Region Event Raising Helpers

Sub RaiseEventIfSubExists(oCallback As Object, sFullSubName As String, lstParams As List) As Boolean
	If oCallback = Null Then Return False
	If lstParams = Null Or lstParams.IsInitialized = False Then
        Dim empty As List
        empty.Initialize
        lstParams = empty
    End If
	Dim argc As Int = SubArgCount(oCallback, sFullSubName)
    If argc < 0 Then
        If xui.SubExists(oCallback, sFullSubName, lstParams.Size) Then
            argc = lstParams.Size
        Else If xui.SubExists(oCallback, sFullSubName, 0) Then
            argc = 0
        End If
    End If

    If argc = 0 Then
        If xui.SubExists(oCallback, sFullSubName, 0) Then
            Try
                CallSub(oCallback, sFullSubName)
                Return True
            Catch
                If B4XDaisyApp.DebugLogs Then Log("B4XDaisyVariants.RaiseEventIfSubExists: " & sFullSubName & " - " & LastException.Message)
                Return False
            End Try
        End If
    Else If argc = 1 Then
        If xui.SubExists(oCallback, sFullSubName, 1) Then
            Dim arg0 As Object = Null
            If lstParams.Size > 0 Then arg0 = lstParams.Get(0)
            Try
                CallSub2(oCallback, sFullSubName, arg0)
                Return True
            Catch
                If B4XDaisyApp.DebugLogs Then Log("B4XDaisyVariants.RaiseEventIfSubExists: " & sFullSubName & " - " & LastException.Message)
                Return False
            End Try
        End If
    Else If argc = 2 Then
        If xui.SubExists(oCallback, sFullSubName, 2) Then
            Dim p0 As Object = Null
            Dim p1 As Object = Null
            If lstParams.Size > 0 Then p0 = lstParams.Get(0)
            If lstParams.Size > 1 Then p1 = lstParams.Get(1)
            Try
                CallSub3(oCallback, sFullSubName, p0, p1)
                Return True
            Catch
                If B4XDaisyApp.DebugLogs Then Log("B4XDaisyVariants.RaiseEventIfSubExists: " & sFullSubName & " - " & LastException.Message)
                Return False
            End Try
        End If
    End If
	Return False
End Sub


Public Sub SubArgCount(oTarget As Object, sSubName As String) As Int
	#If B4A
	If oTarget = Null Then Return -1
	If argCache.IsInitialized = False Then argCache.Initialize
	'
	Try
	Dim r As Reflector
	r.Target = oTarget 
	'get the class name
	Dim className As String = r.TypeName ' Retrieves the class name
	'lets see if we have a cache already
	Dim key As String = className & "|" & sSubName.ToLowerCase
	Dim cached As Object = argCache.Get(key)
	If cached <> Null Then
		Dim ci As Int = cached
		Return ci
	End If
	
	' 1. Get the java.lang.Class object and set it as the new Reflector target
	r.Target = r.RunMethod("getClass")

	' 2. Retrieve the array of declared methods from the Class object
	Dim methods() As Object = r.RunMethod("getDeclaredMethods")
	Dim paramCount As Int = -1
	' 4. Iterate through the methods to find the one you want
	For Each mObj As Object In methods
		Dim m As JavaObject = mObj ' Wrap the java.lang.reflect.Method in a JavaObject
		Dim methodName As String = m.RunMethod("getName", Null)
    	' Check if it is the target method 
		' (note: B4A compiled subs start with an underscore and are lowercased)
		If methodName = $"_${sSubName.ToLowerCase}"$ Then
			' 5. Call getParameterCount using JavaObject
			paramCount = m.RunMethod("getParameterCount", Null)
			' FIX: in Debug mode (Rapid Debugger) class-module subs are compiled with an extra
			' leading "__ref" parameter whose type is the class itself. It must not be counted,
			' otherwise RaiseEventIfSubExists calls CallSub3 and the sub signature no longer matches.
			If paramCount > 0 Then
				Dim ptypes() As Object = m.RunMethod("getParameterTypes", Null)
				Dim p0 As JavaObject = ptypes(0)
				Dim p0Name As String = p0.RunMethod("getName", Null)
				If p0Name = className Then paramCount = paramCount - 1
			End If
			Exit
		End If
	Next
	argCache.Put(key, paramCount)
	Return paramCount
    Catch
		Return -1
	End Try	
	#Else
        Return -1
    #End If
End Sub
#End Region

#Region Touch Intercept Helpers
#If B4A
' Prevents parent scroll containers from intercepting touch gestures on Android.
' Pass the custom view's mBase and the touch action value.
Public Sub RequestDisallowParentIntercept(vView As B4XView, iAction As Int)
    If iAction = 0 Or iAction = 2 Then ' ACTION_DOWN or ACTION_MOVE
        Dim current As JavaObject = vView
        Do While current.IsInitialized
            Dim parentView As JavaObject
            Try
                parentView = current.RunMethod("getParent", Null)
            Catch
                Exit
            End Try
            If parentView.IsInitialized = False Then Exit
            Try
                parentView.RunMethod("requestDisallowInterceptTouchEvent", Array(True))
            Catch
                ' Ignore exceptions when attempting touch disallowance
            	If B4XDaisyApp.DebugLogs Then Log("B4XDaisyVariants.RequestDisallowParentIntercept: " & LastException.Message)
            End Try
            Try
                Dim parentClass As String = GetType(parentView)
                If parentClass.Contains("ViewRootImpl") Then Exit
            Catch
                Exit
            End Try
            current = parentView
        Loop
    End If
End Sub
#End If
#End Region
