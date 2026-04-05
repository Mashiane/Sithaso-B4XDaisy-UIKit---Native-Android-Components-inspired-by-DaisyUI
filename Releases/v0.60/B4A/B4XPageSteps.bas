B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Region Variables
Sub Class_Globals
    Private Root As B4XView
    Private xui As XUI
    Private svHost As ScrollView
    Private pnlHost As B4XView
    Private PAGE_PAD As Int = 16dip
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
''' B4XPage Created event. Sets up the scroll host and renders all examples.
''' </summary>
Private Sub B4XPage_Created(Root1 As B4XView)
    Root = Root1
    Root.Color = B4XDaisyVariants.GetTokenColor("--color-base-200", xui.Color_RGB(245, 247, 250))
    B4XPages.SetTitle(Me, "Steps")

    svHost.Initialize(Max(1dip, Root.Height))
    Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
    pnlHost = svHost.Panel
    pnlHost.Color = xui.Color_Transparent

    RenderExamples(Root.Width, Root.Height)
End Sub
#End Region

#Region Rendering
''' <summary>
''' Renders all DaisyUI Steps examples in a linear top-to-bottom flow.
''' Each example follows: Initialize -> AddToParent -> property assignments.
''' </summary>
Private Sub RenderExamples(Width As Int, Height As Int)
    If pnlHost.IsInitialized = False Then Return
    pnlHost.RemoveAllViews

    Dim maxW As Int = Max(260dip, Width - (PAGE_PAD * 2))
    Dim contentLeft As Int = PAGE_PAD
    Dim y As Int = PAGE_PAD

    ' =========================================================
    ''' <summary>
    ''' Example 1: Basic horizontal steps (step-primary for completed steps).
    ''' Mirrors the first DaisyUI docs example.
    ''' </summary>
    y = AddSectionTitle(contentLeft, y, maxW, "1. Horizontal steps")
    y = AddDescription(contentLeft, y, maxW, "Completed steps use step-primary; pending steps use the default base color.")

    Dim ex1 As B4XDaisySteps
    ex1.Initialize(Me, "steps")
    ex1.AddStep("Register", "primary")
    ex1.AddStep("Choose plan", "primary")
    ex1.AddStep("Purchase", "")
    ex1.AddStep("Receive", "")
    Dim ex1H As Int = ex1.GetComputedHeight
    ex1.AddToParent(pnlHost, contentLeft, y, maxW, ex1H)
    y = y + ex1H + 20dip

    ' =========================================================
    ''' <summary>
    ''' Example 2: Vertical steps.
    ''' Mirrors the steps-vertical DaisyUI docs example.
    ''' </summary>
    y = AddSectionTitle(contentLeft, y, maxW, "2. Vertical steps")
    y = AddDescription(contentLeft, y, maxW, "Same steps rendered vertically — connector bars become vertical lines.")

    Dim ex2 As B4XDaisySteps
    ex2.Initialize(Me, "steps")
    ex2.setOrientation("vertical")
    ex2.AddStep("Register", "primary")
    ex2.AddStep("Choose plan", "primary")
    ex2.AddStep("Purchase", "")
    ex2.AddStep("Receive Product", "")
    Dim ex2H As Int = ex2.GetComputedHeight
    ex2.AddToParent(pnlHost, contentLeft, y, maxW, ex2H)
    y = y + ex2H + 20dip

    ' =========================================================
    ''' <summary>
    ''' Example 3: Responsive steps (lg:steps-horizontal).
    ''' Mirrors the lg:steps-horizontal DaisyUI docs example.
    ''' In DaisyUI, this renders vertical on mobile and horizontal on large screens.
    ''' In B4X, we demonstrate the concept with a note about responsive behavior.
    ''' </summary>
    y = AddSectionTitle(contentLeft, y, maxW, "3. Responsive steps (lg:steps-horizontal)")
    y = AddDescription(contentLeft, y, maxW, "In DaisyUI, steps are vertical by default on small screens and become horizontal on large screens (lg: breakpoint). In B4X, use B4XPage_Resize to switch orientation based on available width.")

    Dim ex3 As B4XDaisySteps
    ex3.Initialize(Me, "stepsResponsive")
    ex3.setOrientation("vertical")
    ex3.AddStep("Register", "primary")
    ex3.AddStep("Choose plan", "primary")
    ex3.AddStep("Purchase", "")
    ex3.AddStep("Receive Product", "")
    Dim ex3H As Int = ex3.GetComputedHeight
    ex3.AddToParent(pnlHost, contentLeft, y, maxW, ex3H)
    y = y + ex3H + 20dip

    ' =========================================================
    ''' <summary>
    ''' Example 4: Active step highlighting using ActiveColor and ActiveStep.
    ''' Demonstrates the B4X-specific active step feature.
    ''' </summary>
    y = AddSectionTitle(contentLeft, y, maxW, "4. Active step highlighting")
    y = AddDescription(contentLeft, y, maxW, "Steps up to and including the ActiveStep index are highlighted with the ActiveColor. Here ActiveStep=1 (second step) with ActiveColor='primary'.")

    Dim ex4 As B4XDaisySteps
    ex4.Initialize(Me, "stepsActive")
    ex4.setActiveColor("primary")
    ex4.setActiveStep(1)
    ex4.AddStep("Create" & CRLF & "Account", "")
    ex4.AddStep("Choose" & CRLF & "Your Plan", "")
    ex4.AddStep("Secure" & CRLF & "Payment", "")
    ex4.AddStep("Receive" & CRLF & "Product", "")
    Dim ex4H As Int = ex4.GetComputedHeight
    ex4.AddToParent(pnlHost, contentLeft, y, maxW, ex4H)
    y = y + ex4H + 20dip

    ' =========================================================
    ''' <summary>
    ''' Example 5: Custom icons using step-icon (emoji in the step circle).
    ''' Mirrors the step-icon DaisyUI docs example.
    ''' </summary>
    y = AddSectionTitle(contentLeft, y, maxW, "5. Custom icons (step-icon)")
    y = AddDescription(contentLeft, y, maxW, "Emoji or any text can replace the auto-number inside the step circle.")

    Dim ex5icons As B4XDaisySteps
    ex5icons.Initialize(Me, "steps")
    ex5icons.AddStepWithIcon("Step 1", "neutral", "😕")
    ex5icons.AddStepWithIcon("Step 2", "neutral", "😃")
    ex5icons.AddStepWithIcon("Step 3", "", "😍")
    Dim ex5iconsH As Int = ex5icons.GetComputedHeight
    ex5icons.AddToParent(pnlHost, contentLeft, y, maxW, ex5iconsH)
    y = y + ex5iconsH + 20dip

    ' =========================================================
    ''' <summary>
    ''' Example 6: Custom data-content markers.
    ''' Mirrors the data-content DaisyUI docs example (?, !, checkmark, cross, star, bullet).
    ''' </summary>
    y = AddSectionTitle(contentLeft, y, maxW, "6. Custom content markers")
    y = AddDescription(contentLeft, y, maxW, "The data-content attribute replaces the auto-number with any symbol.")

    Dim ex6markers As B4XDaisySteps
    ex6markers.Initialize(Me, "steps")
    ex6markers.setScrollable(True)
    ex6markers.AddStepWithContent("Step 1", "neutral", "?")
    ex6markers.AddStepWithContent("Step 2", "neutral", "!")
    ex6markers.AddStepWithContent("Step 3", "neutral", "✓")
    ex6markers.AddStepWithContent("Step 4", "neutral", "✕")
    ex6markers.AddStepWithContent("Step 5", "neutral", "★")
    ex6markers.AddStepWithContent("Step 6", "neutral", "")
    ex6markers.AddStepWithContent("Step 7", "neutral", "●")
    ex6markers.AddStepWithContent("Step 8", "neutral", "◆")
    ex6markers.AddStepWithContent("Step 9", "neutral", "▲")
    ex6markers.AddStepWithContent("Step 10", "neutral", "●")
    ex6markers.AddStepWithContent("Step 11", "neutral", "■")
    ex6markers.AddStepWithContent("Step 12", "neutral", "★")
    ex6markers.AddStepWithContent("Step 13", "neutral", "◎")
    ex6markers.AddStepWithContent("Step 14", "neutral", "✿")
    Dim ex6markersH As Int = ex6markers.GetComputedHeight
    ex6markers.AddToParent(pnlHost, contentLeft, y, maxW, ex6markersH)
    y = y + ex6markersH + 20dip

    ' =========================================================
    ''' <summary>
    ''' Example 7: Mixed variants — info + error step with custom content.
    ''' Mirrors the mixed-variant DaisyUI docs example (moon mission).
    ''' </summary>
    y = AddSectionTitle(contentLeft, y, maxW, "7. Mixed variants")
    y = AddDescription(contentLeft, y, maxW, "Different steps can use different variant colors in the same list.")

    Dim ex7mixed As B4XDaisySteps
    ex7mixed.Initialize(Me, "steps")
    ex7mixed.AddStep("Fly to moon", "info")
    ex7mixed.AddStep("Shrink the moon", "info")
    ex7mixed.AddStep("Grab the moon", "info")
    ex7mixed.AddStepWithContent("Sit on toilet", "error", "?")
    Dim ex7mixedH As Int = ex7mixed.GetComputedHeight
    ex7mixed.AddToParent(pnlHost, contentLeft, y, maxW, ex7mixedH)
    y = y + ex7mixedH + 20dip

    ' =========================================================
    ''' <summary>
    ''' Example 8: All color variants showcase.
    ''' Demonstrates every supported variant color on individual single-step rows.
    ''' </summary>
    y = AddSectionTitle(contentLeft, y, maxW, "8. All variants")
    y = AddDescription(contentLeft, y, maxW, "Every variant token mapped to its theme color.")

    Dim variantNames As List
    variantNames.Initialize
    variantNames.Add("neutral")
    variantNames.Add("primary")
    variantNames.Add("secondary")
    variantNames.Add("accent")
    variantNames.Add("info")
    variantNames.Add("success")
    variantNames.Add("warning")
    variantNames.Add("error")

    For Each vName As String In variantNames
        Dim exV As B4XDaisySteps
        exV.Initialize(Me, "steps")
        exV.AddStep(vName, vName)
        exV.AddStep("pending", "")
        Dim exVH As Int = exV.GetComputedHeight
        exV.AddToParent(pnlHost, contentLeft, y, maxW, exVH)
        y = y + exVH + 8dip
    Next
    y = y + 12dip

    ' =========================================================
    ''' <summary>
    ''' Example 9: Many steps scrollable (overflow-x-auto equivalent).
    ''' Mirrors the wide scrollable steps DaisyUI docs example.
    ''' </summary>
    y = AddSectionTitle(contentLeft, y, maxW, "9. Many steps (scrollable)")
    y = AddDescription(contentLeft, y, maxW, "When steps overflow the available width, each step shrinks to a minimum and the component scrolls horizontally.")

    Dim ex9scroll As B4XDaisySteps
    ex9scroll.Initialize(Me, "steps")
    ex9scroll.setScrollable(True)
    ex9scroll.AddStep("start", "")
    ex9scroll.AddStep("2", "secondary")
    ex9scroll.AddStep("3", "secondary")
    ex9scroll.AddStep("4", "secondary")
    ex9scroll.AddStep("5", "")
    ex9scroll.AddStep("6", "accent")
    ex9scroll.AddStep("7", "accent")
    ex9scroll.AddStep("8", "")
    ex9scroll.AddStep("9", "error")
    ex9scroll.AddStep("10", "error")
    ex9scroll.AddStep("11", "")
    ex9scroll.AddStep("12", "")
    ex9scroll.AddStep("13", "warning")
    ex9scroll.AddStep("14", "warning")
    ex9scroll.AddStep("15", "")
    ex9scroll.AddStep("16", "neutral")
    ex9scroll.AddStep("17", "neutral")
    ex9scroll.AddStep("18", "neutral")
    ex9scroll.AddStep("19", "neutral")
    ex9scroll.AddStep("20", "neutral")
    ex9scroll.AddStep("21", "neutral")
    ex9scroll.AddStep("22", "neutral")
    ex9scroll.AddStep("23", "neutral")
    ex9scroll.AddStep("end", "neutral")
    Dim ex9scrollH As Int = ex9scroll.GetComputedHeight
    ex9scroll.AddToParent(pnlHost, contentLeft, y, maxW, ex9scrollH)
    y = y + ex9scrollH + 20dip

    ' =========================================================
    ''' <summary>
    ''' Example 10: SVG icons in step circles.
    ''' Demonstrates the AddStepWithSvgIcon API using 5 SVG files from the Files folder.
    ''' </summary>
    y = AddSectionTitle(contentLeft, y, maxW, "10. SVG icons in step circles")
    y = AddDescription(contentLeft, y, maxW, "SVG icons from the Files folder rendered inside step circles — tinted by step state.")

    Dim ex10svg As B4XDaisySteps
    ex10svg.Initialize(Me, "steps")
    ex10svg.AddStepWithSvgIcon("Home", "primary", "dock-home.svg")
    ex10svg.AddStepWithSvgIcon("Inbox", "primary", "dock-inbox.svg")
    ex10svg.AddStepWithSvgIcon("Settings", "primary", "dock-settings.svg")
    ex10svg.AddStepWithSvgIcon("User", "", "user-solid.svg")
    ex10svg.AddStepWithSvgIcon("Check", "", "check-solid.svg")
    Dim ex10svgH As Int = ex10svg.GetComputedHeight
    ex10svg.AddToParent(pnlHost, contentLeft, y, maxW, ex10svgH)
    y = y + ex10svgH + 20dip

    ' =========================================================
    ''' <summary>
    ''' Example 11: SVG icons vertical steps with ActiveStep.
    ''' Shows SVG icons in a vertical layout with active step highlighting.
    ''' </summary>
    y = AddSectionTitle(contentLeft, y, maxW, "11. SVG icons (vertical, active step)")
    y = AddDescription(contentLeft, y, maxW, "Vertical orientation with SVG icons and ActiveStep=2 to highlight the first 3 steps.")

    Dim ex11svgVert As B4XDaisySteps
    ex11svgVert.Initialize(Me, "stepsSvgVert")
    ex11svgVert.setOrientation("vertical")
    ex11svgVert.setActiveStep(2)
    ex11svgVert.setActiveColor("success")
    ex11svgVert.AddStepWithSvgIcon("Register", "", "user-solid.svg")
    ex11svgVert.AddStepWithSvgIcon("Verify", "", "check-solid.svg")
    ex11svgVert.AddStepWithSvgIcon("Complete", "", "square-check-regular.svg")
    ex11svgVert.AddStepWithSvgIcon("Pending", "", "circle-question-regular.svg")
    Dim ex11svgVertH As Int = ex11svgVert.GetComputedHeight
    ex11svgVert.AddToParent(pnlHost, contentLeft, y, maxW, ex11svgVertH)
    y = y + ex11svgVertH + 20dip

    ' =========================================================
    ''' <summary>
    ''' Example 12: Horizontal scrollable steps — many steps in a fixed-width container.
    ''' Demonstrates the internal HorizontalScrollView when Scrollable=True (default).
    ''' </summary>
    y = AddSectionTitle(contentLeft, y, maxW, "12. Horizontal scrollable (many steps)")
    y = AddDescription(contentLeft, y, maxW, "24 steps in a fixed-height horizontal container — scroll to see all steps.")

    Dim ex12hscroll As B4XDaisySteps
    ex12hscroll.Initialize(Me, "steps")
    ex12hscroll.setOrientation("horizontal")
    ex12hscroll.setScrollable(True)
    For i = 1 To 24
        Dim variant As String = ""
        If i <= 6 Then
            variant = "primary"
        Else If i <= 12 Then
            variant = "secondary"
        Else If i <= 18 Then
            variant = "accent"
        Else
            variant = "neutral"
        End If
        ex12hscroll.AddStep("Step " & i, variant)
    Next
    ex12hscroll.AddToParent(pnlHost, contentLeft, y, maxW, 68dip)
    y = y + 68dip + 20dip

    ' =========================================================
    ''' <summary>
    ''' Example 13: Vertical scrollable steps — many steps in a fixed-height container.
    ''' Demonstrates the internal ScrollView when Scrollable=True with vertical orientation.
    ''' </summary>
    y = AddSectionTitle(contentLeft, y, maxW, "13. Vertical scrollable (many steps)")
    y = AddDescription(contentLeft, y, maxW, "20 steps in a 300dip tall vertical container — scroll to see all steps.")

    Dim ex13vscroll As B4XDaisySteps
    ex13vscroll.Initialize(Me, "stepsVScroll")
    ex13vscroll.setOrientation("vertical")
    ex13vscroll.setScrollable(True)
    ex13vscroll.setActiveStep(4)
    ex13vscroll.setActiveColor("info")
    For i = 1 To 20
        Dim variant As String = ""
        If i <= 5 Then
            variant = "info"
        Else If i <= 10 Then
            variant = "success"
        Else If i <= 15 Then
            variant = "warning"
        Else
            variant = "error"
        End If
        ex13vscroll.AddStep("Step " & i & " of 20", variant)
    Next
    Dim vscrollH As Int = 300dip
    ex13vscroll.AddToParent(pnlHost, contentLeft, y, maxW, vscrollH)
    y = y + vscrollH + 20dip

    pnlHost.Height = Max(Height, y + PAGE_PAD)
End Sub

''' <summary>
''' Renders a bold section title label.
''' Returns the new Y position after the title.
''' </summary>
Private Sub AddSectionTitle(Left As Int, Y As Int, Width As Int, Text As String) As Int
    Dim title As B4XDaisyText
    title.Initialize(Me, "")
    title.setAutoResize(True)
    title.AddToParent(pnlHost, Left, Y, Width, 0)
    title.Text = Text
    title.TextColor = xui.Color_RGB(30, 41, 59)
    title.TextSize = 15
    title.FontBold = True
    Dim titleH As Int = title.GetComputedHeight
    Return Y + titleH + 4dip
End Sub

''' <summary>
''' Renders a muted description label.
''' Returns the new Y position after the description.
''' </summary>
Private Sub AddDescription(Left As Int, Y As Int, Width As Int, Text As String) As Int
    Dim desc As B4XDaisyText
    desc.Initialize(Me, "")
    desc.setAutoResize(True)
    desc.AddToParent(pnlHost, Left, Y, Width, 0)
    desc.Text = Text
    desc.TextColor = xui.Color_RGB(100, 116, 139)
    desc.TextSize = 11
    Dim descH As Int = desc.GetComputedHeight
    Return Y + descH + 4dip
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
''' Fires when a step circle is tapped.
''' Shows a toast with the step index for quick event verification.
''' </summary>
Private Sub steps_StepClick(Index As Int, Tag As Object)
    #If B4A
    ToastMessageShow("Step " & (Index + 1) & " clicked", False)
    #End If
End Sub

Private Sub stepsSvgVert_StepClick(Index As Int, Tag As Object)
    #If B4A
    ToastMessageShow("SVG Step " & (Index + 1) & " clicked", False)
    #End If
End Sub

Private Sub stepsVScroll_StepClick(Index As Int, Tag As Object)
    #If B4A
    ToastMessageShow("VScroll Step " & (Index + 1) & " clicked", False)
    #End If
End Sub
#End Region
