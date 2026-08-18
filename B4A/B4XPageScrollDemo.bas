B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

'/**
' * @class B4XPageScrollDemo
' * @description
' *  Welcome to the Page Scroll Demo! 
' *  This page acts as a starter template to show how to build clean, scrollable pages.
' *  Instead of writing tons of manual ScrollView code on every new page, we use a single 
' *  helper class (B4XDaisyPageScroll) which handles all the scroll view setup and resizing.
' */
#IgnoreWarnings:12,9

' ELI15: Class_Globals is like the main inventory of our page. Any variables declared here 
' can be used by any subroutine (Sub) on this page. If we declared them inside a Sub instead, 
' they would only exist inside that specific Sub and disappear as soon as it finished running.
' ELI15: Class_Globals is like the main inventory of our page. Any variables declared here
' can be used by any subroutine (Sub) on this page. If we declared them inside a Sub instead,
' they would only exist inside that specific Sub and disappear as soon as it finished running.
Sub Class_Globals
    ' ELI15: Root is the main parent panel (background canvas) of this screen. 
    ' All other views/controls will be added directly or indirectly on top of this.
    Private Root As B4XView
    
    ' ELI15: xui is a helper tool that lets us write code once and have it work on Android (B4A),
    ' iOS (B4i), and Desktop (B4J). It translates colors, layout calls, and dialogs.
    Private xui As XUI
    
    ' ELI15: This is our scrollable layout helper. It automatically creates an under-the-hood 
    ' ScrollView (so users can swipe up/down to see more) and handles details like spacing.
    Private pageScroll As B4XDaisyPageScroll
    
    ' ELI15: pnlHost is the actual scrollable panel inside the scroll view. 
    ' When we add things to pnlHost, they automatically scroll with it.
    Private pnlHost As B4XView
    
    ' ELI15: A custom text input view for entering an email address.
    Private txtEmail As B4XDaisyInput
    
    ' ELI15: A custom text input view for entering a password (automatically masks characters).
    Private txtPassword As B4XDaisyInput
    
    ' ELI15: A custom button that triggers an action when tapped.
    Private btnSubmit As B4XDaisyButton

    ' ELI15: A custom avatar view for displaying the user's profile image.
    Private avatar As B4XDaisyAvatar

    ' ELI15: Floating scroll shortcut buttons (smooth animated scroll).
    Private btnTop As B4XDaisyButton
    Private btnBottom As B4XDaisyButton
    Private btnLock As B4XDaisyButton
End Sub

''' <summary>
''' Initializes the template page instance.
''' </summary>
' ELI15: Initialize is like the constructor. It allocates memory and prepares this class 
' instance to be used by other pages. It returns the page object itself (Me) so B4XPages knows about it.
Public Sub Initialize As Object
    Return Me
End Sub

''' <summary>
''' This event is automatically called by the system once when the page is first created in memory.
''' Think of it as the place where we construct the skeleton of our user interface.
''' </summary>
' ELI15: B4XPage_Created is called only ONCE when this screen is born. 
' We get a reference to the screen's root panel (Root1) and use it to build our layout skeleton.
Private Sub B4XPage_Created (Root1 As B4XView)
    ' Save the screen's main container panel reference so we can use it later.
    Root = Root1
    
    ' ELI15: 1. Setup the Scroll container. 
    ' We link it to this page ("Me") so it knows where to send click events,
    ' and add it to Root, stretching it to cover the entire width and height of the screen.
    pageScroll.Initialize(Me, "pageScroll")
    pageScroll.AddToParent(Root, 0, 0, Root.Width, Root.Height)
    
    ' ELI15: 2. Get the scrollable content canvas.
    ' pageScroll.Panel returns the inner container where we can place all our scrollable controls.
    pnlHost = pageScroll.Panel
    
    ' ELI15: 3. Assemble and position the visual controls.
    BuildForm

    ' ELI15: 4. Floating Top / Bottom buttons that animate the scroll view.
    ' Rounded-full pill buttons with an icon + text label. Their _Click handlers take
    ' no arguments (the Tag is unused here); B4XDaisyButton.RaiseClick prefers the
    ' no-argument _Click form and falls back to _Click(Tag) only when that exists.
    btnTop.Initialize(Me, "btnTop")
    btnTop.AddToParent(Root, 0, 0, 112dip, 40dip)
    btnTop.Text = "Top"
    btnTop.IconName = "arrow-up-solid.svg"
    btnTop.Variant = "primary"
    btnTop.Rounded = "rounded-full"
    btnTop.Size = "sm"

    btnBottom.Initialize(Me, "btnBottom")
    btnBottom.AddToParent(Root, 0, 0, 112dip, 40dip)
    btnBottom.Text = "Bottom"
    btnBottom.IconName = "arrow-down-solid.svg"
    btnBottom.Variant = "neutral"
    btnBottom.Rounded = "rounded-full"
    btnBottom.Size = "sm"

    btnLock.Initialize(Me, "btnLock")
    btnLock.AddToParent(Root, 0, 0, 112dip, 40dip)
    btnLock.Text = "Lock"
    btnLock.IconName = "user-lock-solid.svg"
    btnLock.Variant = "neutral"
    btnLock.Rounded = "rounded-full"
    btnLock.Size = "sm"

    LayoutFloatButtons
End Sub

''' <summary>
''' This event triggers whenever this page slides onto the screen.
''' It is the perfect place to hide the screen loading animation.
''' </summary>
' ELI15: B4XPage_Appear is triggered every single time the user navigates to this page.
' Since the views are now fully drawn and visible on the screen, this is the perfect time
' to focus the cursor on our first input field so the user can start typing immediately.
Private Sub B4XPage_Appear
    ' Tell the B4XPages manager that our layout loading is completed.
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
    
    ' ELI15: Request keyboard focus on the email input field, but only if it has been fully created.
    If txtEmail.IsInitialized Then
        txtEmail.Focus = True
    End If
End Sub

''' <summary>
''' Builds all the form components and places them in a vertical stack.
''' </summary>
' ELI15: BuildForm positions our layout controls sequentially from top to bottom.
' In B4X, since we don't have CSS flow by default, we stack elements like Lego blocks 
' by tracking a vertical coordinate 'y' and incrementing it after adding each element.
Private Sub BuildForm
    ' ELI15: We start placing views from the top page margin (padding) downwards.
    Dim y As Int = pageScroll.PagePadding + (Root.Height * 0.20)
    
    ' ELI15: 0. Add a Profile Avatar above the section title.
    ' We initialize the avatar, place it centered horizontally at coordinate 'y' with 80dip width/height,
    ' and load the image 'mashymain.jpg' directly from B4A's Assets directory (File.DirAssets).
    avatar.Initialize(Me, "avatar")
    avatar.AddToParent(pnlHost, (pageScroll.UsableWidth - 80dip) / 2, y, 80dip, 80dip)
    avatar.CenterOnParent = True
    avatar.setAvatarBitmap(xui.LoadBitmap(File.DirAssets, "mashymain.jpg"), Null)
    y = y + avatar.GetActualHeight + pageScroll.YGap
    
    ' ELI15: 1. Add a Section Title.
    ' The helper creates a styled label, positions it at coordinate 'y', aligns/centers it if the third 
    ' argument is True, and returns the new vertical coordinate immediately below this title.
    y = pageScroll.AddSectionTitle("Login to Your Account", y, True)
    
    ' ELI15: 2. Email Address Input Field.
    ' We initialize the custom view, add it to our scrollable pnlHost container at (padding, y)
    ' with full usable screen width and a standard height (40dip).
    txtEmail.Initialize(Me, "txtEmail")
    txtEmail.AddToParent(pnlHost, pageScroll.PagePadding, y, pageScroll.UsableWidth, 40dip)
    txtEmail.LabelAbove = "Email Address"
    txtEmail.Placeholder = "email@example.com"
    txtEmail.InputType = "email"
    
    ' ELI15: Update the 'y' marker: previous y + height of the email view + the configured vertical gap.
    y = y + txtEmail.GetComputedHeight + pageScroll.YGap
    
    ' ELI15: 3. Password Input Field.
    ' Same process as email: initialize, place at the new coordinate 'y', set it to password mask input type.
    txtPassword.Initialize(Me, "txtPassword")
    txtPassword.AddToParent(pnlHost, pageScroll.PagePadding, y, pageScroll.UsableWidth, 40dip)
    txtPassword.LabelAbove = "Password"
    txtPassword.Placeholder = "Password"
    txtPassword.InputType = "password"
    txtPassword.PasswordChar = "*"
    txtPassword.Text = "password"
    
    ' ELI15: Shift our 'y' marker down again to clear space for the next view.
    y = y + txtPassword.GetComputedHeight + pageScroll.YGap
    
    ' ELI15: 4. Submit Login Button.
    ' Initialize and place the primary action button below the input fields.
    btnSubmit.Initialize(Me, "btnSubmit")
    btnSubmit.AddToParent(pnlHost, pageScroll.PagePadding, y, pageScroll.UsableWidth, 48dip)
    btnSubmit.Text = "Login"
    btnSubmit.Variant = "primary"
    
    ' ELI15: Shift our 'y' marker down once more.
    y = y + btnSubmit.GetComputedHeight + pageScroll.YGap
    
    ' ELI15: 5. Auto-fit the Scroll Panel.
    ' Since we just dynamically added multiple views to pnlHost, the ScrollView needs to know the 
    ' new total height. AutoFit calculates this total height and resizes the scroll canvas 
    ' so that the user can scroll smoothly without cutting off any elements at the bottom.
    pageScroll.AutoFit
End Sub

''' <summary>
''' This event triggers automatically whenever the device screen changes size 
''' (for example, when a user rotates their phone between portrait and landscape modes).
''' </summary>
' ELI15: B4XPage_Resize is triggered when the screen rotates or is resized (like split-screen).
' If we don't resize our pageScroll container here, it will keep its old dimensions and 
' look off-center, too narrow, or clipped. This updates the ScrollView to fit the new width/height.
Private Sub B4XPage_Resize (Width As Int, Height As Int)
    ' Pass the new dimensions to the pageScroll component so it recalculates and stretches.
    If pageScroll.IsInitialized Then pageScroll.Base_Resize(Width, Height)
    LayoutFloatButtons
End Sub

''' <summary>
''' Event callback that runs when the submit button is clicked.
''' </summary>
' ELI15: This is our click event handler. When the user taps the login button (btnSubmit), 
' the B4X framework looks for a subroutine matching `[EventName]_Click` on the target callback class.
Private Sub btnSubmit_Click(Tag As Object)
    ' Print the entered email to the IDE log console for debugging purposes.
End Sub

''' <summary>
''' Positions the floating Top / Bottom buttons at the bottom-right of the screen.
''' </summary>
Private Sub LayoutFloatButtons
    If btnTop.View.IsInitialized = False Then Return
    Dim btnW As Int = 112dip
    Dim btnH As Int = 40dip
    Dim margin As Int = 12dip
    Dim gap As Int = 8dip
    Dim x As Int = Root.Width - btnW - margin
    Dim yBottom As Int = Root.Height - btnH - margin
    btnBottom.SetLayoutAnimated(0, x, yBottom, btnW, btnH)
    btnTop.SetLayoutAnimated(0, x, yBottom - btnH - gap, btnW, btnH)
    btnLock.SetLayoutAnimated(0, x, yBottom - (btnH + gap) * 2, btnW, btnH)
    btnTop.BringToFront
    btnBottom.BringToFront
    btnLock.BringToFront
End Sub

Private Sub btnTop_Click (Tag As Object)
    pageScroll.ScrollToTop(True)
End Sub

Private Sub btnBottom_Click (Tag As Object)
    pageScroll.ScrollToBottom(True)
End Sub

Private Sub btnLock_Click (Tag As Object)
    pageScroll.ScrollEnabled = Not(pageScroll.ScrollEnabled)
    btnLock.Variant = IIf(pageScroll.ScrollEnabled, "neutral", "error")
    #If B4A
        B4XPages.MainPage.ShowToast("Scroll " & IIf(pageScroll.ScrollEnabled, "enabled", "locked"), False)
    #End If
End Sub
