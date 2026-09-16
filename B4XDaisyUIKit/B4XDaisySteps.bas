B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9

#Region Events
#Event: StepClick (Index As Int, Tag As Object)
#End Region

#Region Designer Properties
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Enables or disables the component.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Shows or hides the component.
#DesignerProperty: Key: Orientation, DisplayName: Orientation, FieldType: String, DefaultValue: horizontal, List: horizontal|vertical, Description: Layout direction: horizontal (default) or vertical.
#DesignerProperty: Key: ActiveColor, DisplayName: Active Color, FieldType: String, DefaultValue: primary, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Color variant for active/completed steps.
#DesignerProperty: Key: ActiveStep, DisplayName: Active Step, FieldType: Int, DefaultValue: -1, Description: Index of the active step (0-based). Steps up to and including this index use ActiveColor. -1 means no active highlighting.
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: String, DefaultValue: , Description: Tailwind padding tokens (e.g., p-4, px-2 py-1).
#DesignerProperty: Key: Margin, DisplayName: Margin, FieldType: String, DefaultValue: , Description: Tailwind margin tokens (e.g., m-4, mx-auto, mb-2).
#DesignerProperty: Key: CircleSize, DisplayName: Circle Size, FieldType: Int, DefaultValue: 32, Description: Diameter of the step circle in dip.
#DesignerProperty: Key: StepGap, DisplayName: Step Gap, FieldType: Int, DefaultValue: 0, Description: Extra spacing (in dip) added between steps. 0 keeps the default spacing. Widens step columns in horizontal orientation and step rows in vertical orientation.
#DesignerProperty: Key: Scrollable, DisplayName: Scrollable, FieldType: Boolean, DefaultValue: False, Description: Enables scrolling when steps overflow the container. Horizontal for horizontal orientation, vertical for vertical orientation.
#DesignerProperty: Key: ConnectOnClick, DisplayName: Connect On Click, FieldType: Boolean, DefaultValue: False, Description: When True, clicking a step connects (fills) the connector lines and circles up to and including the clicked step by updating the active step index.
#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: w-full, Description: Tailwind size token or CSS size used as preferred width.
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: h-auto, Description: Tailwind size token, CSS size, or h-auto.
#End Region

#Region Variables
Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object

    Private mSteps As List

    Private mbEnabled As Boolean = True
    Private mbVisible As Boolean = True
    Private msOrientation As String = "horizontal"
    Private msActiveColor As String = "primary"
    Private miActiveStep As Int = -1
    Private msPadding As String = ""
    Private msMargin As String = ""
    Private mbScrollable As Boolean = False
    Private mbConnectOnClick As Boolean = False
    Private miStepGap As Int = 0
    Private miCircleSize As Int = 32
    Private msContentParent As String = "none"
    Private msWidth As String = "w-full"
    Private msHeight As String = "h-auto"

    Private mContentPanel As B4XView
    Private mHScroll As B4XView
    Private mHScrollTyped As HorizontalScrollView
    Private mVScroll As B4XView
    Private mVScrollTyped As ScrollView

    Private LayoutConstantsApplied As Boolean = False

    ' Layout constants
    Private MI_CIRCLE_SIZE As Int = 32dip
    Private MI_BAR_THICKNESS As Int = 8dip
    Private MI_CIRCLE_ROW_H As Int = 40dip
    Private MI_LABEL_ROW_H As Int = 28dip
    Private MI_STEP_H_HORIZ As Int = 68dip
    Private MI_STEP_MIN_W As Int = 64dip
    Private MI_STEP_H_VERT As Int = 64dip
    Private MI_VERT_CIRCLE_X As Int = 4dip
    Private MI_VERT_LABEL_LEFT As Int = 48dip

    ' Runtime computed values
    Private miComputedHeight As Int = 0
	Private inResize As Boolean = False
End Sub

''' <summary>
''' Initializes the component.
''' </summary>
Public Sub Initialize(oCallback As Object, sEventName As String)
    mCallBack = oCallback
    mEventName = sEventName
    mSteps.Initialize
End Sub

''' <summary>
''' Designer entry point.
''' </summary>
Public Sub DesignerCreateView(oBase As Object, lblLbl As Label, mProps As Map)
    mBase = oBase
    mTag = mBase.Tag
    mBase.Tag = Me
    mBase.Color = xui.Color_Transparent

    Dim pnl As Panel
    pnl.Initialize("")
    mContentPanel = pnl
    mContentPanel.Color = xui.Color_Transparent
    mBase.AddView(mContentPanel, 0, 0, mBase.Width, mBase.Height)
    msContentParent = "base"

    Dim hsv As HorizontalScrollView
    hsv.Initialize(0, 0)
    mHScroll = hsv
    mHScrollTyped = hsv
    mHScroll.Color = xui.Color_Transparent
    mHScroll.SetVisibleAnimated(0, False)
    mBase.AddView(mHScroll, 0, 0, mBase.Width, mBase.Height)

    Dim sv As ScrollView
    sv.Initialize(0)
    mVScroll = sv
    mVScrollTyped = sv
    mVScroll.Color = xui.Color_Transparent
    mVScroll.SetVisibleAnimated(0, False)
    mBase.AddView(mVScroll, 0, 0, mBase.Width, mBase.Height)

    ApplyDesignerProps(mProps)
    Refresh
End Sub
#End Region

#Region Public API
''' <summary>
''' Returns the public base view.
''' </summary>
Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub
''' <summary>
''' Adds the component to a parent B4XView.
''' </summary>
Public Sub AddToParent(vParent As B4XView, iLeft As Int, iTop As Int, iWidth As Int, iHeight As Int) As B4XView
    If vParent.IsInitialized = False Then Return mBase
    If mBase.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("mBase")
        Dim b As B4XView = p
        b.Color = xui.Color_Transparent
        b.SetLayoutAnimated(0, 0, 0, Max(1dip, iWidth), Max(1dip, iHeight))
        DesignerCreateView(b, Null, BuildRuntimeProps)
    End If
    vParent.AddView(mBase, iLeft, iTop, Max(1dip, iWidth), Max(1dip, iHeight))
    Base_Resize(mBase.Width, mBase.Height)
    Return mBase
End Sub

''' <summary>
''' Adds a step item with a variant color.
''' Variant: "primary", "secondary", "accent", "neutral", "info", "success", "warning", "error", or "" for default/inactive.
''' </summary>
Public Sub AddStep(sText As String, sVariant As String)
    If mSteps.IsInitialized = False Then mSteps.Initialize
    mSteps.Add(CreateStepItem(sText, sVariant, "", "", "", ""))
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub AddStepWithContent(sText As String, sVariant As String, sContent As String)
    If mSteps.IsInitialized = False Then mSteps.Initialize
    mSteps.Add(CreateStepItem(sText, sVariant, sContent, "", "", ""))
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Adds a step with a custom icon/emoji displayed inside the step circle (step-icon equivalent).
''' </summary>
Public Sub AddStepWithIcon(sText As String, sVariant As String, sIcon As String)
    If mSteps.IsInitialized = False Then mSteps.Initialize
    mSteps.Add(CreateStepItem(sText, sVariant, "", sIcon, "", ""))
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Adds a step with a custom SVG icon from the Files/Assets folder displayed inside the step circle.
''' </summary>
Public Sub AddStepWithSvgIcon(sText As String, sVariant As String, sSvgFileName As String)
    If mSteps.IsInitialized = False Then mSteps.Initialize
    mSteps.Add(CreateStepItem(sText, sVariant, "", "", sSvgFileName, "svg"))
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Replaces all steps from a list of Maps.
''' Each Map may contain: "Text" (String), "Variant" (String), "Content" (String), "Icon" (String), "SvgIcon" (String), "IconType" (String).
''' </summary>
Public Sub SetSteps(lstSteps As List)
    If mSteps.IsInitialized = False Then mSteps.Initialize
    mSteps.Initialize
    For Each rawStep As Object In lstSteps
        If rawStep Is Map Then
            Dim m As Map = rawStep
            Dim t As String = ""
            If m.ContainsKey("Text") Then
                t = m.Get("Text")
            End If
            Dim v As String = ""
            If m.ContainsKey("Variant") Then
                v = m.Get("Variant")
            End If
            Dim c As String = ""
            If m.ContainsKey("Content") Then
                c = m.Get("Content")
            End If
            Dim ico As String = ""
            If m.ContainsKey("Icon") Then
                ico = m.Get("Icon")
            End If
            Dim svgIco As String = ""
            If m.ContainsKey("SvgIcon") Then
                svgIco = m.Get("SvgIcon")
            End If
            Dim icoType As String = ""
            If m.ContainsKey("IconType") Then
                icoType = m.Get("IconType")
            End If
            mSteps.Add(CreateStepItem(t, v, c, ico, svgIco, icoType))
        End If
    Next
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Removes all steps.
''' </summary>
Public Sub ClearSteps
    mSteps.Initialize
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Returns the number of steps currently in the list.
''' </summary>
Public Sub getStepCount As Int
    If mSteps.IsInitialized = False Then Return 0
    Return mSteps.Size
End Sub

''' <summary>
''' Sets the layout orientation: "horizontal" (default) or "vertical".
''' </summary>
Public Sub setOrientation(sValue As String)
    msOrientation = NormalizeOrientation(sValue)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Gets the layout orientation.
''' </summary>
Public Sub getOrientation As String
    Return msOrientation
End Sub

''' <summary>
''' Sets the enabled state.
''' </summary>
Public Sub setEnabled(bValue As Boolean)
    mbEnabled = bValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Gets the enabled state.
''' </summary>
Public Sub getEnabled As Boolean
    Return mbEnabled
End Sub

''' <summary>
''' Sets the visible state.
''' </summary>
Public Sub setVisible(bValue As Boolean)
    mbVisible = bValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Gets the visible state.
''' </summary>
Public Sub getVisible As Boolean
    Return mbVisible
End Sub

''' <summary>
''' Sets the component tag.
''' </summary>
Public Sub setTag(oValue As Object)
    mTag = oValue
End Sub

''' <summary>
''' Gets the component tag.
''' </summary>
Public Sub getTag As Object
    Return mTag
End Sub

''' <summary>
''' Sets the active color variant for completed steps (e.g., "primary", "secondary", "accent").
''' </summary>
Public Sub setActiveColor(sValue As String)
    msActiveColor = NormalizeVariant(sValue)
    If msActiveColor.Length = 0 Then msActiveColor = "primary"
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Gets the active color variant.
''' </summary>
Public Sub getActiveColor As String
    Return msActiveColor
End Sub

''' <summary>
''' Sets the active step index (0-based). Steps up to and including this index are highlighted with ActiveColor.
''' Use -1 to disable active step highlighting.
''' </summary>
Public Sub setActiveStep(iValue As Int)
    miActiveStep = iValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Gets the active step index.
''' </summary>
Public Sub getActiveStep As Int
    Return miActiveStep
End Sub

''' <summary>
''' Sets padding using Tailwind spacing tokens (e.g., "p-4", "px-2 py-1").
''' </summary>
Public Sub setPadding(sValue As String)
    msPadding = IIf(sValue = Null, "", sValue)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Gets the current padding token string.
''' </summary>
Public Sub getPadding As String
    Return msPadding
End Sub

''' <summary>
''' Sets margin using Tailwind spacing tokens (e.g., "m-4", "mx-auto", "mb-2").
''' </summary>
Public Sub setMargin(sValue As String)
    msMargin = IIf(sValue = Null, "", sValue)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Gets the current margin token string.
''' </summary>
Public Sub getMargin As String
    Return msMargin
End Sub

''' <summary>
''' Enables or disables scrolling when steps overflow the container.
''' </summary>
Public Sub setScrollable(bValue As Boolean)
    mbScrollable = bValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Gets the current scrollable state.
''' </summary>
Public Sub getScrollable As Boolean
    Return mbScrollable
End Sub

''' <summary>
''' Enables or disables the connect-on-click behavior. When True, tapping a step
''' updates the active step index to the tapped step, filling the connector lines
''' and circles up to and including that step (DaisyUI steps bar connection).
''' </summary>

Public Sub getCircleSize As Int
    Return miCircleSize
End Sub

Public Sub setCircleSize(iValue As Int)
    miCircleSize = Max(1, iValue)
End Sub

Public Sub setConnectOnClick(bValue As Boolean)
    mbConnectOnClick = bValue
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Gets the current connect-on-click state.
''' </summary>
Public Sub getConnectOnClick As Boolean
    Return mbConnectOnClick
End Sub

''' <summary>
''' Sets the extra gap (in dip) between steps. 0 keeps the default spacing.
''' The value is added to the step column width in horizontal orientation and to the
''' step row height in vertical orientation, producing more space between consecutive
''' step circles and their connector bars.
''' </summary>
Public Sub setStepGap(iValue As Int)
    miStepGap = Max(0, iValue)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Gets the extra gap (in dip) between steps.
''' </summary>
Public Sub getStepGap As Int
    Return miStepGap
End Sub

''' <summary>
''' Sets the width using a Tailwind token or CSS size (e.g. "w-full", "w-1/2", "320px").
''' </summary>
Public Sub setWidth(sValue As String)
    msWidth = IIf(sValue = Null, "w-full", sValue.ToLowerCase.Trim)
    If msWidth.Length = 0 Then msWidth = "w-full"
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Gets the current width token.
''' </summary>
Public Sub getWidth As String
    Return msWidth
End Sub

''' <summary>
''' Sets the height using a Tailwind token or CSS size (e.g. "h-auto", "h-64", "300px").
''' Use "h-auto" to let the component size itself to fit content.
''' </summary>
Public Sub setHeight(sValue As String)
    msHeight = IIf(sValue = Null, "h-auto", sValue.ToLowerCase.Trim)
    If msHeight.Length = 0 Then msHeight = "h-auto"
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Gets the current height token.
''' </summary>
Public Sub getHeight As String
    Return msHeight
End Sub

''' <summary>
''' Forces re-resolution of theme-aware colors.
''' </summary>
Public Sub UpdateTheme
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Applies the current state to all child views.
''' </summary>
Public Sub Refresh
    If mBase.IsInitialized = False Then Return
    mBase.Visible = mbVisible
    mBase.Enabled = mbEnabled
    ' Disabled: dim the whole indicator (matches the Checkbox/Radio disabled family).
    mBase.Alpha = IIf(mbEnabled, 1.0, 0.3)

    If mHScroll.IsInitialized Then
        mHScroll.SetLayoutAnimated(0, 0, 0, mBase.Width, mBase.Height)
    End If
    If mVScroll.IsInitialized Then
        mVScroll.SetLayoutAnimated(0, 0, 0, mBase.Width, mBase.Height)
    End If

    If mbScrollable Then
        If msOrientation = "vertical" Then
            mHScroll.SetVisibleAnimated(0, False)
            mVScroll.SetVisibleAnimated(0, True)
            If msContentParent <> "vscroll" Then
                mContentPanel.RemoveViewFromParent
                mVScrollTyped.Panel.AddView(mContentPanel, 0, 0, mBase.Width, mBase.Height)
                msContentParent = "vscroll"
            End If
        Else
            mHScroll.SetVisibleAnimated(0, True)
            mVScroll.SetVisibleAnimated(0, False)
            If msContentParent <> "hscroll" Then
                mContentPanel.RemoveViewFromParent
                mHScrollTyped.Panel.AddView(mContentPanel, 0, 0, mBase.Width, mBase.Height)
                msContentParent = "hscroll"
            End If
        End If
    Else
        mHScroll.SetVisibleAnimated(0, False)
        mVScroll.SetVisibleAnimated(0, False)
        If msContentParent <> "base" Then
            mContentPanel.RemoveViewFromParent
            mBase.AddView(mContentPanel, 0, 0, mBase.Width, mBase.Height)
            msContentParent = "base"
        End If
    End If

    ApplyBoxModel

    If mContentPanel.IsInitialized Then
        mContentPanel.RemoveAllViews
        If mSteps.IsInitialized = False Then Return
        If mSteps.Size = 0 Then Return

        If msOrientation = "vertical" Then
            RenderVertical
        Else
            RenderHorizontal
        End If
    End If

    If mbScrollable = False Then
        B4XDaisyVariants.DisableClippingRecursive(mBase)
    End If
End Sub

''' <summary>
''' Returns the computed height required to display all steps at the current orientation.
''' Call this to size the component correctly before or after AddToParent.
''' </summary>
Public Sub GetComputedHeight As Int
    If mSteps.IsInitialized = False Or mSteps.Size = 0 Then Return MI_STEP_H_HORIZ
    If msOrientation = "vertical" Then
        Return mSteps.Size * (MI_STEP_H_VERT + miStepGap)
    Else
        If miComputedHeight > 0 Then Return miComputedHeight
        Return MI_STEP_H_HORIZ
    End If
End Sub

Private Sub ApplyBoxModel
    If mContentPanel.IsInitialized = False Then Return
    Dim box As Map = B4XDaisyBoxModel.CreateDefaultModel
    ApplySpacingSpecToBox(box, msPadding, msMargin)

    Dim pl As Int = BoxModelGetFloat(box, "padding_left", 0)
    Dim pt As Int = BoxModelGetFloat(box, "padding_top", 0)
    Dim pr As Int = BoxModelGetFloat(box, "padding_right", 0)
    Dim pb As Int = BoxModelGetFloat(box, "padding_bottom", 0)
    Dim ml As Int = BoxModelGetFloat(box, "margin_left", 0)
    Dim mt As Int = BoxModelGetFloat(box, "margin_top", 0)
    Dim mr As Int = BoxModelGetFloat(box, "margin_right", 0)
    Dim mb As Int = BoxModelGetFloat(box, "margin_bottom", 0)

    Dim scrollW As Int = Max(1dip, mBase.Width - Max(0, ml) - Max(0, mr) - pl - pr)
    Dim scrollH As Int = Max(1dip, mBase.Height - Max(0, mt) - Max(0, mb) - pt - pb)

    If mbScrollable Then
        If msOrientation = "vertical" Then
            Dim stepCount As Int = 0
            If mSteps.IsInitialized Then stepCount = mSteps.Size
            Dim contentH As Int = Max(scrollH, stepCount * (MI_STEP_H_VERT + miStepGap))
            mContentPanel.SetLayoutAnimated(0, 0, 0, scrollW, contentH)
            mVScroll.SetLayoutAnimated(0, Max(0, pl), Max(0, pt), scrollW, scrollH)
            mVScrollTyped.Panel.Height = contentH
            mVScrollTyped.Panel.Width = scrollW
            mVScrollTyped.ScrollPosition = 0
        Else
            #If B4A
            Dim stepCount As Int = 0
            If mSteps.IsInitialized Then stepCount = mSteps.Size
            Dim horizH As Int = Max(scrollH, miComputedHeight)
            If horizH < 68dip Then horizH = 68dip
            Dim contentW As Int = Max(scrollW, stepCount * (MI_STEP_MIN_W + miStepGap))
            mContentPanel.SetLayoutAnimated(0, 0, 0, contentW, horizH)
            mHScroll.SetLayoutAnimated(0, Max(0, pl), Max(0, pt), scrollW, horizH)
            mHScrollTyped.Panel.Width = contentW
            mHScrollTyped.Panel.Height = horizH
            Dim jo As JavaObject = mHScrollTyped
            jo.RunMethod("scrollTo", Array(0, 0))
            #End If
        End If
    Else
        mContentPanel.SetLayoutAnimated(0, Max(0, pl), Max(0, pt), scrollW, scrollH)
    End If
End Sub

Private Sub BoxModelGetFloat(mBox As Map, sKey As String, iDefaultVal As Int) As Int
    If mBox.IsInitialized = False Then Return iDefaultVal
    If mBox.ContainsKey(sKey) = False Then Return iDefaultVal
    Dim o As Object = mBox.Get(sKey)
    If o = Null Then Return iDefaultVal
    Dim v As Float = o
    Return v
End Sub

Private Sub ApplySpacingSpecToBox(mBox As Map, sPaddingSpec As String, sMarginSpec As String)
    Dim rtl As Boolean = False
    Dim p As String = IIf(sPaddingSpec = Null, "", sPaddingSpec.Trim)
    Dim m As String = IIf(sMarginSpec = Null, "", sMarginSpec.Trim)
    If p.Length > 0 Then
        If p.Contains("-") Then
            B4XDaisyBoxModel.ApplyPaddingUtilities(mBox, p, rtl)
        Else
            Dim pv As Float = B4XDaisyBoxModel.TailwindSpacingToDip(p, 0dip)
            mBox.Put("padding_left", pv)
            mBox.Put("padding_top", pv)
            mBox.Put("padding_right", pv)
            mBox.Put("padding_bottom", pv)
        End If
    End If
    If m.Length > 0 Then
        If m.Contains("-") Then
            B4XDaisyBoxModel.ApplyMarginUtilities(mBox, m, rtl)
        Else
            Dim mv As Float = B4XDaisyBoxModel.TailwindSpacingToDip(m, 0dip)
            mBox.Put("margin_left", mv)
            mBox.Put("margin_top", mv)
            mBox.Put("margin_right", mv)
            mBox.Put("margin_bottom", mv)
        End If
    End If
End Sub
#End Region

#Region Base Events
Public Sub Base_Resize(dWidth As Double, dHeight As Double)
    If mBase.IsInitialized = False Then Return
    If inResize Then Return
    inResize = True
    Refresh
    inResize = False
End Sub

Private Sub stepCircle_Click
    If mbEnabled = False Then Return
    Dim senderView As B4XView = Sender
    If senderView.Tag = Null Then Return
    Dim idx As Int = senderView.Tag
    ' ConnectOnClick: tapping a step fills the connector lines/circles
    ' up to and including the tapped step by moving the active step index.
    If mbConnectOnClick Then
        miActiveStep = idx
        Refresh
    End If
    If xui.SubExists(mCallBack, mEventName & "_StepClick", 2) Then
        CallSub3(mCallBack, mEventName & "_StepClick", idx, mTag)
    End If
End Sub
#End Region

#Region Rendering
' DaisyUI token support map for parity validation:
' steps step step-icon steps-horizontal steps-vertical lg:steps-horizontal
' step-neutral step-primary step-secondary step-accent
' step-info step-success step-warning step-error
' col-start-1 grid grid-cols-1 grid-cols-2 grid-flow-col grid-flow-row
' grid-rows-1 grid-rows-2 h-2 h-8 h-full inline-grid
' overflow-hidden overflow-x-auto place-items-center place-self-center
' relative rounded-full row-start-1 text-center top-0 w-2 w-8 w-full
' Note: lg:steps-horizontal is a Tailwind responsive breakpoint modifier.
' In B4X, orientation is set explicitly via setOrientation("horizontal"|"vertical").

Private Sub RenderHorizontal
    ' steps (horizontal):
    ' - Each step column has equal width: total / n
    ' - Row 1 (MI_CIRCLE_ROW_H): connector bar + circle (circle on top)
    ' - Row 2 (MI_LABEL_ROW_H): label text centered
    ' - Connector bar for step i is drawn in column (i-1) using step i's variant color
    '   This matches CSS: bar has margin-inline-start:-100% shifting it one column left
    '   First step has no bar.
    Dim n As Int = mSteps.Size
    If n = 0 Then Return

    Dim containerW As Int = Max((MI_STEP_MIN_W + miStepGap) * n, mContentPanel.Width)
    Dim stepW As Int = Max(MI_STEP_MIN_W + miStepGap, Round(containerW / n))
    Dim barY As Int = Round((MI_CIRCLE_ROW_H - MI_BAR_THICKNESS) / 2)
    Dim circleY As Int = Round((MI_CIRCLE_ROW_H - MI_CIRCLE_SIZE) / 2)

    Dim defaultBg As Int = B4XDaisyVariants.GetTokenColor("--color-base-300", xui.Color_RGB(214, 218, 228))
    Dim defaultFg As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(31, 41, 55))

    ' Pass 1: connector bars - bar for step i connects center of circle (i-1) to center of circle i
    For i = 1 To n - 1
        Dim stepI As Map = mSteps.Get(i)
        Dim barBg As Int = ResolveStepBg(stepI, i, defaultBg)
        Dim pnlBar As Panel
        pnlBar.Initialize("")
        Dim xvBar As B4XView = pnlBar
        xvBar.Color = barBg
        ' Bar starts from center of circle (i-1) to center of circle i
        Dim prevCircleCenterX As Int = (i - 1) * stepW + Round(stepW / 2)
        Dim currCircleCenterX As Int = i * stepW + Round(stepW / 2)
        Dim barLeft As Int = prevCircleCenterX
        Dim barWidth As Int = currCircleCenterX - prevCircleCenterX
        mContentPanel.AddView(xvBar, barLeft, barY, barWidth, MI_BAR_THICKNESS)
    Next

    ' Pass 2: circles (added after bars so they render on top)
    For i = 0 To n - 1
        Dim stepI As Map = mSteps.Get(i)
        Dim stepBg As Int = ResolveStepBg(stepI, i, defaultBg)
        Dim stepFg As Int = ResolveStepFg(stepI, i, defaultFg)
        Dim circleLeft As Int = i * stepW + Round((stepW - MI_CIRCLE_SIZE) / 2)

        Dim pnlCircle As Panel
        pnlCircle.Initialize("stepCircle")
        Dim xvCircle As B4XView = pnlCircle
        xvCircle.Tag = i
        xvCircle.SetColorAndBorder(stepBg, 0, xui.Color_Transparent, Round(MI_CIRCLE_SIZE / 2))
        mContentPanel.AddView(xvCircle, circleLeft, circleY, MI_CIRCLE_SIZE, MI_CIRCLE_SIZE)

        Dim iconType As String = ""
        If stepI.ContainsKey("IconType") Then
            iconType = stepI.Get("IconType")
        End If

        If iconType = "svg" Then
            Dim svgFile As String = ""
            If stepI.ContainsKey("SvgIcon") Then
                svgFile = stepI.Get("SvgIcon")
            End If
            If svgFile.Length > 0 Then
                Dim svgIcon As B4XDaisySvgIcon
                svgIcon.Initialize(Me, "")
                Dim svgSize As Int = Round(MI_CIRCLE_SIZE * 0.7)
                Dim svgOffset As Int = Round((MI_CIRCLE_SIZE - svgSize) / 2)
                Dim svgView As B4XView = svgIcon.AddToParent(xvCircle, svgOffset, svgOffset, svgSize, svgSize)
                svgIcon.SetClickable(False)
                svgIcon.SetSvgAsset(svgFile)
                svgIcon.SetPreserveOriginalColors(False)
                svgIcon.SetColor(stepFg)
            End If
        Else
            Dim lCircle As Label
            lCircle.Initialize("")
            Dim xvCircleLbl As B4XView = lCircle
            xvCircleLbl.Color = xui.Color_Transparent
            xvCircleLbl.TextColor = stepFg
            xvCircleLbl.TextSize = 18
            xvCircleLbl.SetTextAlignment("CENTER", "CENTER")
            xvCircleLbl.Text = ResolveCircleText(stepI, i)
            xvCircle.AddView(xvCircleLbl, 0, 0, MI_CIRCLE_SIZE, MI_CIRCLE_SIZE)
        End If
    Next

    ' Pass 3: step labels below circle row - multiline with dynamic height
    ' Follow project pattern: use StringUtils.MeasureMultilineTextHeight with "Ag" probe
    ' "Ag" includes both ascender and descender so measured height covers all glyphs
    Dim maxLabelH As Int = 0
    Dim tu As StringUtils
    For i = 0 To n - 1
        Dim stepI As Map = mSteps.Get(i)
        Dim labelText As String = ""
        If stepI.ContainsKey("Text") Then labelText = stepI.Get("Text")
        ' Create temp label with exact same properties as the real one
        Dim tmpLbl As Label
        tmpLbl.Initialize("")
        Dim xvTmp As B4XView = tmpLbl
        xvTmp.Color = xui.Color_Transparent
        xvTmp.TextColor = defaultFg
        xvTmp.TextSize = 11
        xvTmp.SetTextAlignment("TOP", "CENTER")
        xvTmp.Text = labelText
        xvTmp.Width = stepW
        xvTmp.Height = 0
        Dim h As Int = tu.MeasureMultilineTextHeight(xvTmp, labelText)
        If h < 14dip Then h = 14dip
        If h > maxLabelH Then maxLabelH = h
    Next
    ' Extra 4dip bottom buffer for Android font rendering edge cases
    miComputedHeight = MI_CIRCLE_ROW_H + maxLabelH + 4dip

    ' Resize content panel to fit circles + labels
    Dim contentH As Int = MI_CIRCLE_ROW_H + maxLabelH
    mContentPanel.Height = contentH

    ' Add labels at measured height
    Dim lblTop As Int = MI_CIRCLE_ROW_H
    For i = 0 To n - 1
        Dim stepI As Map = mSteps.Get(i)
        Dim labelText As String = ""
        If stepI.ContainsKey("Text") Then labelText = stepI.Get("Text")

        Dim lStep As Label
        lStep.Initialize("")
        Dim xvLabel As B4XView = lStep
        xvLabel.Color = xui.Color_Transparent
        xvLabel.TextColor = defaultFg
        xvLabel.TextSize = 11
        xvLabel.SetTextAlignment("TOP", "CENTER")
        xvLabel.Text = labelText
        mContentPanel.AddView(xvLabel, i * stepW, lblTop, stepW, maxLabelH)
    Next
End Sub

Private Sub RenderVertical
    ' steps-vertical:
    ' - Each step row has equal height: MI_STEP_H_VERT
    ' - Left column (40dip): connector bar (w=8dip, centered) + circle (32dip)
    ' - Right column: label text, vertically centered
    ' - Connector bar for step i runs from step (i-1) circle center to step i circle center
    '   First step has no bar.
    Dim n As Int = mSteps.Size
    If n = 0 Then Return

    Dim containerW As Int = Max(1dip, mContentPanel.Width)
    Dim stepH As Int = MI_STEP_H_VERT + miStepGap
    Dim circleY As Int = Round((stepH - MI_CIRCLE_SIZE) / 2)
    Dim circleCenter As Int = circleY + Round(MI_CIRCLE_SIZE / 2)
    Dim barX As Int = MI_VERT_CIRCLE_X + Round((MI_CIRCLE_SIZE - MI_BAR_THICKNESS) / 2)
    Dim labelW As Int = Max(1dip, containerW - MI_VERT_LABEL_LEFT - 4dip)
    Dim labelH As Int = 20dip

    Dim defaultBg As Int = B4XDaisyVariants.GetTokenColor("--color-base-300", xui.Color_RGB(214, 218, 228))
    Dim defaultFg As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(31, 41, 55))

    ' Pass 1: connector bars - bar for step i connects step (i-1) center to step i center
    For i = 1 To n - 1
        Dim stepI As Map = mSteps.Get(i)
        Dim barBg As Int = ResolveStepBg(stepI, i, defaultBg)
        ' Bar goes from step (i-1) circle center downward to step i circle center
        Dim barTopY As Int = (i - 1) * stepH + circleCenter
        Dim barHeight As Int = stepH
        Dim pnlBar As Panel
        pnlBar.Initialize("")
        Dim xvBar As B4XView = pnlBar
        xvBar.Color = barBg
        mContentPanel.AddView(xvBar, barX, barTopY, MI_BAR_THICKNESS, barHeight)
    Next

    ' Pass 2: circles (on top of bars)
    For i = 0 To n - 1
        Dim stepI As Map = mSteps.Get(i)
        Dim stepBg As Int = ResolveStepBg(stepI, i, defaultBg)
        Dim stepFg As Int = ResolveStepFg(stepI, i, defaultFg)
        Dim stepTopY As Int = i * stepH

        Dim pnlCircle As Panel
        pnlCircle.Initialize("stepCircle")
        Dim xvCircle As B4XView = pnlCircle
        xvCircle.Tag = i
        xvCircle.SetColorAndBorder(stepBg, 0, xui.Color_Transparent, Round(MI_CIRCLE_SIZE / 2))
        mContentPanel.AddView(xvCircle, MI_VERT_CIRCLE_X, stepTopY + circleY, MI_CIRCLE_SIZE, MI_CIRCLE_SIZE)

        Dim iconType As String = ""
        If stepI.ContainsKey("IconType") Then
            iconType = stepI.Get("IconType")
        End If

        If iconType = "svg" Then
            Dim svgFile As String = ""
            If stepI.ContainsKey("SvgIcon") Then
                svgFile = stepI.Get("SvgIcon")
            End If
            If svgFile.Length > 0 Then
                Dim svgIcon As B4XDaisySvgIcon
                svgIcon.Initialize(Me, "")
                Dim svgSize As Int = Round(MI_CIRCLE_SIZE * 0.7)
                Dim svgOffset As Int = Round((MI_CIRCLE_SIZE - svgSize) / 2)
                Dim svgView As B4XView = svgIcon.AddToParent(xvCircle, svgOffset, svgOffset, svgSize, svgSize)
                svgIcon.SetClickable(False)
                svgIcon.SetSvgAsset(svgFile)
                svgIcon.SetPreserveOriginalColors(False)
                svgIcon.SetColor(stepFg)
            End If
        Else
            Dim lCircle As Label
            lCircle.Initialize("")
            Dim xvCircleLbl As B4XView = lCircle
            xvCircleLbl.Color = xui.Color_Transparent
            xvCircleLbl.TextColor = stepFg
            xvCircleLbl.TextSize = 18
            xvCircleLbl.SetTextAlignment("CENTER", "CENTER")
            xvCircleLbl.Text = ResolveCircleText(stepI, i)
            xvCircle.AddView(xvCircleLbl, 0, 0, MI_CIRCLE_SIZE, MI_CIRCLE_SIZE)
        End If
    Next

    ' Pass 3: step labels to the right of circles, vertically centered
    For i = 0 To n - 1
        Dim stepI As Map = mSteps.Get(i)
        Dim labelText As String = ""
        If stepI.ContainsKey("Text") Then
            labelText = stepI.Get("Text")
        End If
        Dim stepTopY As Int = i * stepH
        Dim lblY As Int = stepTopY + Round((stepH - labelH) / 2)

        Dim lStep As Label
        lStep.Initialize("")
        Dim xvLabel As B4XView = lStep
        xvLabel.Color = xui.Color_Transparent
        xvLabel.TextColor = defaultFg
        xvLabel.TextSize = 12
        xvLabel.SetTextAlignment("CENTER", "LEFT")
        xvLabel.Text = labelText
        mContentPanel.AddView(xvLabel, MI_VERT_LABEL_LEFT, lblY, labelW, labelH)
    Next
End Sub

Private Sub ApplyDesignerProps(mProps As Map)
    mbEnabled = B4XDaisyVariants.GetPropBool(mProps, "Enabled", mbEnabled)
    mbVisible = B4XDaisyVariants.GetPropBool(mProps, "Visible", mbVisible)
    msOrientation = NormalizeOrientation(B4XDaisyVariants.GetPropString(mProps, "Orientation", msOrientation))
    msActiveColor = NormalizeVariant(B4XDaisyVariants.GetPropString(mProps, "ActiveColor", msActiveColor))
    If msActiveColor.Length = 0 Then msActiveColor = "primary"
    miActiveStep = B4XDaisyVariants.GetPropInt(mProps, "ActiveStep", miActiveStep)
    msPadding = B4XDaisyVariants.GetPropString(mProps, "Padding", msPadding)
    msMargin = B4XDaisyVariants.GetPropString(mProps, "Margin", msMargin)
    mbScrollable = B4XDaisyVariants.GetPropBool(mProps, "Scrollable", mbScrollable)
    mbConnectOnClick = B4XDaisyVariants.GetPropBool(mProps, "ConnectOnClick", mbConnectOnClick)
    miStepGap = Max(0, B4XDaisyVariants.GetPropInt(mProps, "StepGap", miStepGap))
    Dim widthSpec As String = B4XDaisyVariants.GetPropString(mProps, "Width", "w-full").ToLowerCase.Trim
    If widthSpec.Length = 0 Then widthSpec = "w-full"
    msWidth = widthSpec
    Dim heightSpec As String = B4XDaisyVariants.GetPropString(mProps, "Height", "h-auto").ToLowerCase.Trim
    If heightSpec.Length = 0 Then heightSpec = "h-auto"
    msHeight = heightSpec
    miCircleSize = Max(1, B4XDaisyVariants.GetPropInt(mProps, "CircleSize", miCircleSize))
End Sub

Private Sub BuildRuntimeProps As Map
    Return CreateMap( _
        "Enabled": mbEnabled, _
        "Visible": mbVisible, _
        "Orientation": msOrientation, _
        "ActiveColor": msActiveColor, _
        "ActiveStep": miActiveStep, _
        "Padding": msPadding, _
        "Margin": msMargin, _
        "Scrollable": mbScrollable, _
        "ConnectOnClick": mbConnectOnClick, _
        "StepGap": miStepGap, _
        "Width": msWidth, _
        "Height": msHeight)
End Sub

Private Sub CreateStepItem(sText As String, sVariant As String, sContent As String, sIcon As String, sSvgIcon As String, sIconType As String) As Map
    Dim m As Map
    m.Initialize
    m.Put("Text", sText)
    m.Put("Variant", NormalizeVariant(sVariant))
    m.Put("Content", sContent)
    m.Put("Icon", sIcon)
    m.Put("SvgIcon", sSvgIcon)
    m.Put("IconType", sIconType)
    Return m
End Sub

Private Sub NormalizeVariant(sValue As String) As String
    If sValue = Null Then Return ""
    Dim v As String = sValue.ToLowerCase.Trim
    Select Case v
        Case "neutral", "primary", "secondary", "accent", "info", "success", "warning", "error"
            Return v
    End Select
    Return ""
End Sub

Private Sub NormalizeOrientation(sValue As String) As String
    If sValue = Null Then Return "horizontal"
    If sValue.ToLowerCase.Trim = "vertical" Then Return "vertical"
    Return "horizontal"
End Sub

Private Sub ResolveStepBg(mStepData As Map, iIndex As Int, iDefaultBg As Int) As Int
    If miActiveStep >= 0 And iIndex <= miActiveStep Then
        Return B4XDaisyVariants.GetTokenColor("--color-" & msActiveColor, iDefaultBg)
    End If
    Dim variant As String = ""
    If mStepData.ContainsKey("Variant") Then variant = mStepData.Get("Variant")
    If variant.Length = 0 Then Return iDefaultBg
    Return B4XDaisyVariants.GetTokenColor("--color-" & variant, iDefaultBg)
End Sub

Private Sub ResolveStepFg(mStepData As Map, iIndex As Int, iDefaultFg As Int) As Int
    If miActiveStep >= 0 And iIndex <= miActiveStep Then
        Return B4XDaisyVariants.GetTokenColor("--color-" & msActiveColor & "-content", iDefaultFg)
    End If
    Dim variant As String = ""
    If mStepData.ContainsKey("Variant") Then variant = mStepData.Get("Variant")
    If variant.Length = 0 Then Return iDefaultFg
    Return B4XDaisyVariants.GetTokenColor("--color-" & variant & "-content", iDefaultFg)
End Sub

Private Sub ResolveCircleText(mStepData As Map, iIndex As Int) As String
    Dim iconType As String = ""
    If mStepData.ContainsKey("IconType") Then iconType = mStepData.Get("IconType")
    If iconType = "svg" Then Return ""
    Dim icon As String = ""
    If mStepData.ContainsKey("Icon") Then icon = mStepData.Get("Icon")
    If icon.Length > 0 Then Return icon
    Dim content As String = ""
    If mStepData.ContainsKey("Content") Then content = mStepData.Get("Content")
    If content.Length > 0 Then Return content
    Return "" & (iIndex + 1)
End Sub
#End Region

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

#End Region
