B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
#IgnoreWarnings: 12

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
#DesignerProperty: Key: Scrollable, DisplayName: Scrollable, FieldType: Boolean, DefaultValue: False, Description: Enables scrolling when steps overflow the container. Horizontal for horizontal orientation, vertical for vertical orientation.
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
    Private MI_STEP_MIN_W As Int = 56dip
    Private MI_STEP_H_VERT As Int = 64dip
    Private MI_VERT_CIRCLE_X As Int = 4dip
    Private MI_VERT_LABEL_LEFT As Int = 48dip

    ' Runtime computed values
    Private miComputedHeight As Int = 0
End Sub

''' <summary>
''' Initializes the component.
''' </summary>
Public Sub Initialize(Callback As Object, EventName As String)
    mCallBack = Callback
    mEventName = EventName
    mSteps.Initialize
End Sub

''' <summary>
''' Designer entry point.
''' </summary>
Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
    mBase = Base
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

    ApplyDesignerProps(Props)
    Refresh
End Sub
#End Region

#Region Public API
''' <summary>
''' Returns the public base view.
''' </summary>
Public Sub getView As B4XView
    Return mBase
End Sub

''' <summary>
''' Adds the component to a parent B4XView.
''' </summary>
Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
    If Parent.IsInitialized = False Then Return mBase
    If mBase.IsInitialized = False Then
        Dim p As Panel
        p.Initialize("mBase")
        Dim b As B4XView = p
        b.Color = xui.Color_Transparent
        b.SetLayoutAnimated(0, 0, 0, Max(1dip, Width), Max(1dip, Height))
        DesignerCreateView(b, Null, BuildRuntimeProps)
    End If
    Parent.AddView(mBase, Left, Top, Max(1dip, Width), Max(1dip, Height))
    Base_Resize(mBase.Width, mBase.Height)
    Return mBase
End Sub

''' <summary>
''' Adds a step item with a variant color.
''' Variant: "primary", "secondary", "accent", "neutral", "info", "success", "warning", "error", or "" for default/inactive.
''' </summary>
Public Sub AddStep(Text As String, Variant As String)
    If mSteps.IsInitialized = False Then mSteps.Initialize
    mSteps.Add(CreateStepItem(Text, Variant, "", "", "", ""))
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub AddStepWithContent(Text As String, Variant As String, Content As String)
    If mSteps.IsInitialized = False Then mSteps.Initialize
    mSteps.Add(CreateStepItem(Text, Variant, Content, "", "", ""))
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Adds a step with a custom icon/emoji displayed inside the step circle (step-icon equivalent).
''' </summary>
Public Sub AddStepWithIcon(Text As String, Variant As String, Icon As String)
    If mSteps.IsInitialized = False Then mSteps.Initialize
    mSteps.Add(CreateStepItem(Text, Variant, "", Icon, "", ""))
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Adds a step with a custom SVG icon from the Files/Assets folder displayed inside the step circle.
''' </summary>
Public Sub AddStepWithSvgIcon(Text As String, Variant As String, SvgFileName As String)
    If mSteps.IsInitialized = False Then mSteps.Initialize
    mSteps.Add(CreateStepItem(Text, Variant, "", "", SvgFileName, "svg"))
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

''' <summary>
''' Replaces all steps from a list of Maps.
''' Each Map may contain: "Text" (String), "Variant" (String), "Content" (String), "Icon" (String), "SvgIcon" (String), "IconType" (String).
''' </summary>
Public Sub SetSteps(Steps As List)
    If mSteps.IsInitialized = False Then mSteps.Initialize
    mSteps.Initialize
    For Each rawStep As Object In Steps
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
Public Sub setOrientation(Value As String)
    msOrientation = NormalizeOrientation(Value)
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
Public Sub setEnabled(Value As Boolean)
    mbEnabled = Value
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
Public Sub setVisible(Value As Boolean)
    mbVisible = Value
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
Public Sub setTag(Value As Object)
    mTag = Value
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
Public Sub setActiveColor(Value As String)
    msActiveColor = NormalizeVariant(Value)
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
Public Sub setActiveStep(Value As Int)
    miActiveStep = Value
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
Public Sub setPadding(Value As String)
    msPadding = IIf(Value = Null, "", Value)
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
Public Sub setMargin(Value As String)
    msMargin = IIf(Value = Null, "", Value)
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
Public Sub setScrollable(Value As Boolean)
    mbScrollable = Value
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
''' Sets the width using a Tailwind token or CSS size (e.g. "w-full", "w-1/2", "320px").
''' </summary>
Public Sub setWidth(Value As String)
    msWidth = IIf(Value = Null, "w-full", Value.ToLowerCase.Trim)
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
Public Sub setHeight(Value As String)
    msHeight = IIf(Value = Null, "h-auto", Value.ToLowerCase.Trim)
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
    mBase.Color = xui.Color_Transparent

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
        Return mSteps.Size * MI_STEP_H_VERT
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
            Dim contentH As Int = Max(scrollH, stepCount * MI_STEP_H_VERT)
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
            Dim contentW As Int = Max(scrollW, stepCount * MI_STEP_MIN_W)
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

Private Sub BoxModelGetFloat(Box As Map, Key As String, DefaultVal As Int) As Int
    If Box.IsInitialized = False Then Return DefaultVal
    If Box.ContainsKey(Key) = False Then Return DefaultVal
    Dim o As Object = Box.Get(Key)
    If o = Null Then Return DefaultVal
    Dim v As Float = o
    Return v
End Sub

Private Sub ApplySpacingSpecToBox(Box As Map, PaddingSpec As String, MarginSpec As String)
    Dim rtl As Boolean = False
    Dim p As String = IIf(PaddingSpec = Null, "", PaddingSpec.Trim)
    Dim m As String = IIf(MarginSpec = Null, "", MarginSpec.Trim)
    If p.Length > 0 Then
        If p.Contains("-") Then
            B4XDaisyBoxModel.ApplyPaddingUtilities(Box, p, rtl)
        Else
            Dim pv As Float = B4XDaisyBoxModel.TailwindSpacingToDip(p, 0dip)
            Box.Put("padding_left", pv)
            Box.Put("padding_top", pv)
            Box.Put("padding_right", pv)
            Box.Put("padding_bottom", pv)
        End If
    End If
    If m.Length > 0 Then
        If m.Contains("-") Then
            B4XDaisyBoxModel.ApplyMarginUtilities(Box, m, rtl)
        Else
            Dim mv As Float = B4XDaisyBoxModel.TailwindSpacingToDip(m, 0dip)
            Box.Put("margin_left", mv)
            Box.Put("margin_top", mv)
            Box.Put("margin_right", mv)
            Box.Put("margin_bottom", mv)
        End If
    End If
End Sub
#End Region

#Region Base Events
Public Sub Base_Resize(Width As Double, Height As Double)
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Private Sub stepCircle_Click
    If mbEnabled = False Then Return
    Dim senderView As B4XView = Sender
    If senderView.Tag = Null Then Return
    Dim idx As Int = senderView.Tag
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

    Dim containerW As Int = Max(MI_STEP_MIN_W * n, mContentPanel.Width)
    Dim stepW As Int = Max(MI_STEP_MIN_W, Round(containerW / n))
    Dim barY As Int = Round((MI_CIRCLE_ROW_H - MI_BAR_THICKNESS) / 2)
    Dim circleY As Int = Round((MI_CIRCLE_ROW_H - MI_CIRCLE_SIZE) / 2)

    Dim defaultBg As Int = B4XDaisyVariants.GetTokenColor("--color-base-300", xui.Color_RGB(214, 218, 228))
    Dim defaultFg As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(31, 41, 55))

    ' Pass 1: connector bars — bar for step i connects center of circle (i-1) to center of circle i
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

    ' Pass 3: step labels below circle row — multiline with dynamic height
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
    Dim stepH As Int = MI_STEP_H_VERT
    Dim circleY As Int = Round((stepH - MI_CIRCLE_SIZE) / 2)
    Dim circleCenter As Int = circleY + Round(MI_CIRCLE_SIZE / 2)
    Dim barX As Int = MI_VERT_CIRCLE_X + Round((MI_CIRCLE_SIZE - MI_BAR_THICKNESS) / 2)
    Dim labelW As Int = Max(1dip, containerW - MI_VERT_LABEL_LEFT - 4dip)
    Dim labelH As Int = 20dip

    Dim defaultBg As Int = B4XDaisyVariants.GetTokenColor("--color-base-300", xui.Color_RGB(214, 218, 228))
    Dim defaultFg As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_RGB(31, 41, 55))

    ' Pass 1: connector bars — bar for step i connects step (i-1) center to step i center
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

Private Sub ApplyDesignerProps(Props As Map)
    mbEnabled = B4XDaisyVariants.GetPropBool(Props, "Enabled", True)
    mbVisible = B4XDaisyVariants.GetPropBool(Props, "Visible", True)
    msOrientation = NormalizeOrientation(B4XDaisyVariants.GetPropString(Props, "Orientation", "horizontal"))
    msActiveColor = NormalizeVariant(B4XDaisyVariants.GetPropString(Props, "ActiveColor", "primary"))
    If msActiveColor.Length = 0 Then msActiveColor = "primary"
    miActiveStep = B4XDaisyVariants.GetPropInt(Props, "ActiveStep", -1)
    msPadding = B4XDaisyVariants.GetPropString(Props, "Padding", "")
    msMargin = B4XDaisyVariants.GetPropString(Props, "Margin", "")
    mbScrollable = B4XDaisyVariants.GetPropBool(Props, "Scrollable", False)
    Dim widthSpec As String = B4XDaisyVariants.GetPropString(Props, "Width", "w-full").ToLowerCase.Trim
    If widthSpec.Length = 0 Then widthSpec = "w-full"
    msWidth = widthSpec
    Dim heightSpec As String = B4XDaisyVariants.GetPropString(Props, "Height", "h-auto").ToLowerCase.Trim
    If heightSpec.Length = 0 Then heightSpec = "h-auto"
    msHeight = heightSpec
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
        "Width": msWidth, _
        "Height": msHeight)
End Sub

Private Sub CreateStepItem(Text As String, Variant As String, Content As String, Icon As String, SvgIcon As String, IconType As String) As Map
    Dim m As Map
    m.Initialize
    m.Put("Text", Text)
    m.Put("Variant", NormalizeVariant(Variant))
    m.Put("Content", Content)
    m.Put("Icon", Icon)
    m.Put("SvgIcon", SvgIcon)
    m.Put("IconType", IconType)
    Return m
End Sub

Private Sub NormalizeVariant(Value As String) As String
    If Value = Null Then Return ""
    Dim v As String = Value.ToLowerCase.Trim
    Select Case v
        Case "neutral", "primary", "secondary", "accent", "info", "success", "warning", "error"
            Return v
    End Select
    Return ""
End Sub

Private Sub NormalizeOrientation(Value As String) As String
    If Value = Null Then Return "horizontal"
    If Value.ToLowerCase.Trim = "vertical" Then Return "vertical"
    Return "horizontal"
End Sub

Private Sub ResolveStepBg(StepData As Map, Index As Int, DefaultBg As Int) As Int
    If miActiveStep >= 0 And Index <= miActiveStep Then
        Return B4XDaisyVariants.GetTokenColor("--color-" & msActiveColor, DefaultBg)
    End If
    Dim variant As String = ""
    If StepData.ContainsKey("Variant") Then variant = StepData.Get("Variant")
    If variant.Length = 0 Then Return DefaultBg
    Return B4XDaisyVariants.GetTokenColor("--color-" & variant, DefaultBg)
End Sub

Private Sub ResolveStepFg(StepData As Map, Index As Int, DefaultFg As Int) As Int
    If miActiveStep >= 0 And Index <= miActiveStep Then
        Return B4XDaisyVariants.GetTokenColor("--color-" & msActiveColor & "-content", DefaultFg)
    End If
    Dim variant As String = ""
    If StepData.ContainsKey("Variant") Then variant = StepData.Get("Variant")
    If variant.Length = 0 Then Return DefaultFg
    Return B4XDaisyVariants.GetTokenColor("--color-" & variant & "-content", DefaultFg)
End Sub

Private Sub ResolveCircleText(StepData As Map, Index As Int) As String
    Dim iconType As String = ""
    If StepData.ContainsKey("IconType") Then iconType = StepData.Get("IconType")
    If iconType = "svg" Then Return ""
    Dim icon As String = ""
    If StepData.ContainsKey("Icon") Then icon = StepData.Get("Icon")
    If icon.Length > 0 Then Return icon
    Dim content As String = ""
    If StepData.ContainsKey("Content") Then content = StepData.Get("Content")
    If content.Length > 0 Then Return content
    Return "" & (Index + 1)
End Sub
#End Region
