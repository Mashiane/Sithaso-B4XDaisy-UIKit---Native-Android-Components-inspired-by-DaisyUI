B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#IgnoreWarnings:12
Sub Class_Globals
    Private Root As B4XView
    Private xui As XUI
    Private svHost As ScrollView
    Private pnlHost As B4XView
    Private PAGE_PAD As Int = 12dip
End Sub

Public Sub Initialize As Object
    Return Me
End Sub

' /**
'  * Initializes button demo page and renders Daisy examples.
'  */
Private Sub B4XPage_Created(Root1 As B4XView)
    Root = Root1
    Root.Color = xui.Color_RGB(245, 247, 250)
    B4XPages.SetTitle(Me, "button")

    svHost.Initialize(Max(1dip, Root.Height))
    Root.AddView(svHost, 0, 0, Root.Width, Root.Height)
    pnlHost = svHost.Panel
    pnlHost.Color = xui.Color_Transparent

    RenderExamples(Root.Width, Root.Height)
End Sub

' /**
'  * Reflows the scroll host and rerenders examples.
'  */
Private Sub B4XPage_Resize(Width As Int, Height As Int)
    If svHost.IsInitialized Then svHost.SetLayoutAnimated(0, 0, 0, Width, Height)
    RenderExamples(Width, Height)
End Sub

' /**
'  * Builds linear, docs-inspired button examples.
'  */
Private Sub RenderExamples(Width As Int, Height As Int)
    If pnlHost.IsInitialized = False Then Return
    pnlHost.RemoveAllViews

    Dim maxW As Int = Max(260dip, Width - (PAGE_PAD * 2))
    Dim y As Int = PAGE_PAD
    Dim x As Int

    ' /**
    '  * Example 1: Button.
    '  */
    y = AddSectionTitle("Button", y, maxW)
    Dim bDefault As B4XDaisyButton
    bDefault.Initialize(Me, "component")
    bDefault.AddToParent(pnlHost, PAGE_PAD, y, 120dip, 40dip)
    bDefault.Text = "Default"
    bDefault.Tag = "button-default"
    y = y + 54dip

    ' /**
    '  * Example 2: Button sizes.
    '  */
    y = AddSectionTitle("Button sizes", y, maxW)
    x = PAGE_PAD

    Dim bXs As B4XDaisyButton
    bXs.Initialize(Me, "component")
    Dim vSizeXs As B4XView = bXs.AddToParent(pnlHost, x, y, 70dip, 24dip)
    bXs.Text = "Xsmall"
    bXs.Size = "xs"
    bXs.Tag = "size-xs"
    x = vSizeXs.Left + vSizeXs.Width + 8dip

    Dim bSm As B4XDaisyButton
    bSm.Initialize(Me, "component")
    bSm.AddToParent(pnlHost, x, y, 70dip, 32dip)
    bSm.Text = "Small"
    bSm.Size = "sm"
    bSm.Tag = "size-sm"
    y = y + 44dip

    Dim bMd As B4XDaisyButton
    bMd.Initialize(Me, "component")
    Dim vSizeMd As B4XView = bMd.AddToParent(pnlHost, PAGE_PAD, y + 8dip, 76dip, 40dip)
    bMd.Text = "Medium"
    bMd.Size = "md"
    bMd.Tag = "size-md"

    Dim bLg As B4XDaisyButton
    bLg.Initialize(Me, "component")
    Dim xSizeLg As Int = vSizeMd.Left + vSizeMd.Width + 8dip
    bLg.AddToParent(pnlHost, xSizeLg, y, 76dip, 48dip)
    bLg.Text = "Large"
    bLg.Size = "lg"
    bLg.Tag = "size-lg"
    y = y + 60dip

    Dim bXl As B4XDaisyButton
    bXl.Initialize(Me, "component")
    bXl.AddToParent(pnlHost, PAGE_PAD, y, 96dip, 56dip)
    bXl.Text = "Xlarge"
    bXl.Size = "xl"
    bXl.Tag = "size-xl"
    y = y + 70dip

    ' /**
     '  * Example 4: Buttons colors.
     '  */
    y = AddSectionTitle("Buttons colors", y, maxW)
    Dim bcNeutral As B4XDaisyButton
    bcNeutral.Initialize(Me, "component")
    Dim vColorNeutral As B4XView = bcNeutral.AddToParent(pnlHost, PAGE_PAD, y, 86dip, 40dip)
    bcNeutral.Text = "Neutral"
    bcNeutral.Variant = "neutral"
    bcNeutral.Tag = "color-neutral"

    Dim bcPrimary As B4XDaisyButton
    bcPrimary.Initialize(Me, "component")
    Dim xColor2 As Int = vColorNeutral.Left + vColorNeutral.Width + 8dip
    bcPrimary.AddToParent(pnlHost, xColor2, y, 86dip, 40dip)
    bcPrimary.Text = "Primary"
    bcPrimary.Variant = "primary"
    bcPrimary.Tag = "color-primary"
    y = y + 52dip

    Dim bcSecondary As B4XDaisyButton
    bcSecondary.Initialize(Me, "component")
    Dim vColorSecondary As B4XView = bcSecondary.AddToParent(pnlHost, PAGE_PAD, y, 90dip, 40dip)
    bcSecondary.Text = "Secondary"
    bcSecondary.Variant = "secondary"
    bcSecondary.Tag = "color-secondary"

    Dim bcAccent As B4XDaisyButton
    bcAccent.Initialize(Me, "component")
    xColor2 = vColorSecondary.Left + vColorSecondary.Width + 8dip
    bcAccent.AddToParent(pnlHost, xColor2, y, 78dip, 40dip)
    bcAccent.Text = "Accent"
    bcAccent.Variant = "accent"
    bcAccent.Tag = "color-accent"
    y = y + 52dip

    Dim bcInfo As B4XDaisyButton
    bcInfo.Initialize(Me, "component")
    Dim vColorInfo As B4XView = bcInfo.AddToParent(pnlHost, PAGE_PAD, y, 66dip, 40dip)
    bcInfo.Text = "Info"
    bcInfo.Variant = "info"
    bcInfo.Tag = "color-info"

    Dim bcSuccess As B4XDaisyButton
    bcSuccess.Initialize(Me, "component")
    xColor2 = vColorInfo.Left + vColorInfo.Width + 8dip
    bcSuccess.AddToParent(pnlHost, xColor2, y, 86dip, 40dip)
    bcSuccess.Text = "Success"
    bcSuccess.Variant = "success"
    bcSuccess.Tag = "color-success"
    y = y + 52dip

    Dim bcWarning As B4XDaisyButton
    bcWarning.Initialize(Me, "component")
    Dim vColorWarning As B4XView = bcWarning.AddToParent(pnlHost, PAGE_PAD, y, 86dip, 40dip)
    bcWarning.Text = "Warning"
    bcWarning.Variant = "warning"
    bcWarning.Tag = "color-warning"

    Dim bcError As B4XDaisyButton
    bcError.Initialize(Me, "component")
    xColor2 = vColorWarning.Left + vColorWarning.Width + 8dip
    bcError.AddToParent(pnlHost, xColor2, y, 72dip, 40dip)
    bcError.Text = "Error"
    bcError.Variant = "error"
    bcError.Tag = "color-error"
    y = y + 60dip

    ' /**
    '  * Example 5: Soft buttons.
    '  */
    y = AddSectionTitle("Soft buttons", y, maxW)
    Dim bsDefault As B4XDaisyButton
    bsDefault.Initialize(Me, "component")
    Dim vSoftDefault As B4XView = bsDefault.AddToParent(pnlHost, PAGE_PAD, y, 86dip, 40dip)
    bsDefault.Text = "Default"
    bsDefault.Style = "soft"
    bsDefault.Tag = "soft-default"

    Dim bsPrimary As B4XDaisyButton
    bsPrimary.Initialize(Me, "component")
    Dim xSoft2 As Int = vSoftDefault.Left + vSoftDefault.Width + 8dip
    bsPrimary.AddToParent(pnlHost, xSoft2, y, 86dip, 40dip)
    bsPrimary.Text = "Primary"
    bsPrimary.Style = "soft"
    bsPrimary.Variant = "primary"
    bsPrimary.Tag = "soft-primary"

    Dim bsSuccess As B4XDaisyButton
    bsSuccess.Initialize(Me, "component")
    bsSuccess.AddToParent(pnlHost, PAGE_PAD, y + 48dip, 86dip, 40dip)
    bsSuccess.Text = "Success"
    bsSuccess.Style = "soft"
    bsSuccess.Variant = "success"
    bsSuccess.Tag = "soft-success"
    y = y + 108dip

    ' /**
    '  * Example 6: Outline buttons.
    '  */
    y = AddSectionTitle("Outline buttons", y, maxW)
    Dim boDefault As B4XDaisyButton
    boDefault.Initialize(Me, "component")
    Dim vOutlineDefault As B4XView = boDefault.AddToParent(pnlHost, PAGE_PAD, y, 86dip, 40dip)
    boDefault.Text = "Default"
    boDefault.Style = "outline"
    boDefault.Tag = "outline-default"

    Dim boPrimary As B4XDaisyButton
    boPrimary.Initialize(Me, "component")
    Dim xOutline2 As Int = vOutlineDefault.Left + vOutlineDefault.Width + 8dip
    boPrimary.AddToParent(pnlHost, xOutline2, y, 86dip, 40dip)
    boPrimary.Text = "Primary"
    boPrimary.Style = "outline"
    boPrimary.Variant = "primary"
    boPrimary.Tag = "outline-primary"

    Dim boWarning As B4XDaisyButton
    boWarning.Initialize(Me, "component")
    boWarning.AddToParent(pnlHost, PAGE_PAD, y + 48dip, 86dip, 40dip)
    boWarning.Text = "Warning"
    boWarning.Style = "outline"
    boWarning.Variant = "warning"
    boWarning.Tag = "outline-warning"
    y = y + 108dip

    ' /**
    '  * Example 7: Dash buttons.
    '  */
    y = AddSectionTitle("Dash buttons", y, maxW)
    Dim bdDefault As B4XDaisyButton
    bdDefault.Initialize(Me, "component")
    Dim vDashDefault As B4XView = bdDefault.AddToParent(pnlHost, PAGE_PAD, y, 86dip, 40dip)
    bdDefault.Text = "Default"
    bdDefault.Style = "dash"
    bdDefault.Tag = "dash-default"

    Dim bdPrimary As B4XDaisyButton
    bdPrimary.Initialize(Me, "component")
    Dim xDash2 As Int = vDashDefault.Left + vDashDefault.Width + 8dip
    bdPrimary.AddToParent(pnlHost, xDash2, y, 86dip, 40dip)
    bdPrimary.Text = "Primary"
    bdPrimary.Style = "dash"
    bdPrimary.Variant = "primary"
    bdPrimary.Tag = "dash-primary"

    Dim bdError As B4XDaisyButton
    bdError.Initialize(Me, "component")
    bdError.AddToParent(pnlHost, PAGE_PAD, y + 48dip, 86dip, 40dip)
    bdError.Text = "Error"
    bdError.Style = "dash"
    bdError.Variant = "error"
    bdError.Tag = "dash-error"
    y = y + 108dip

    ' /**
    '  * Example 8: Neutral outline and dash style.
    '  */
    y = AddSectionTitle("neutral button with outline or dash style", y, maxW)
    Dim bnOutline As B4XDaisyButton
    bnOutline.Initialize(Me, "component")
    bnOutline.AddToParent(pnlHost, PAGE_PAD, y, 96dip, 40dip)
    bnOutline.Text = "Outline"
    bnOutline.Style = "outline"
    bnOutline.Variant = "neutral"
    bnOutline.Tag = "neutral-outline"

    Dim bnDash As B4XDaisyButton
    bnDash.Initialize(Me, "component")
    bnDash.AddToParent(pnlHost, PAGE_PAD + 102dip, y, 96dip, 40dip)
    bnDash.Text = "Dash"
    bnDash.Style = "dash"
    bnDash.Variant = "neutral"
    bnDash.Tag = "neutral-dash"
    y = y + 56dip

    ' /**
    '  * Example 9: Active buttons.
    '  */
    y = AddSectionTitle("Active buttons", y, maxW)
    Dim baDefault As B4XDaisyButton
    baDefault.Initialize(Me, "component")
    baDefault.AddToParent(pnlHost, PAGE_PAD, y, 86dip, 40dip)
    baDefault.Text = "Default"
    baDefault.Active = True
    baDefault.Tag = "active-default"

    Dim baPrimary As B4XDaisyButton
    baPrimary.Initialize(Me, "component")
    baPrimary.AddToParent(pnlHost, PAGE_PAD + 92dip, y, 86dip, 40dip)
    baPrimary.Text = "Primary"
    baPrimary.Active = True
    baPrimary.Variant = "primary"
    baPrimary.Tag = "active-primary"
    y = y + 56dip

    ' /**
    '  * Example 10: Ghost and link buttons.
    '  */
    y = AddSectionTitle("Buttons ghost and button link", y, maxW)
    Dim bgGhost As B4XDaisyButton
    bgGhost.Initialize(Me, "component")
    bgGhost.AddToParent(pnlHost, PAGE_PAD, y, 86dip, 40dip)
    bgGhost.Text = "Ghost"
    bgGhost.Style = "ghost"
    bgGhost.Tag = "ghost"

    Dim bgLink As B4XDaisyButton
    bgLink.Initialize(Me, "component")
    bgLink.AddToParent(pnlHost, PAGE_PAD + 92dip, y, 86dip, 40dip)
    bgLink.Text = "Link"
    bgLink.Style = "link"
    bgLink.Tag = "link"
    y = y + 56dip

    ' /**
    '  * Example 11: Wide button.
    '  */
    y = AddSectionTitle("Wide button", y, maxW)
    Dim bwWide As B4XDaisyButton
    bwWide.Initialize(Me, "component")
    bwWide.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
    bwWide.Text = "Wide"
    bwWide.Wide = True
    bwWide.Tag = "wide"
    y = y + 56dip

    ' /**
    '  * Example 12: Disabled buttons.
    '  */
    y = AddSectionTitle("Disabled buttons", y, maxW)
    Dim bDisAttr As B4XDaisyButton
    bDisAttr.Initialize(Me, "component")
    bDisAttr.AddToParent(pnlHost, PAGE_PAD, y, 200dip, 40dip)
    bDisAttr.Text = "Disabled attribute"
    bDisAttr.Disabled = True
    bDisAttr.Tag = "disabled-attr"
    y = y + 56dip

    ' /**
    '  * Example 13: Square and circle buttons.
    '  */
    y = AddSectionTitle("Square button and circle button", y, maxW)
    Dim bSquare As B4XDaisyButton
    bSquare.Initialize(Me, "component")
    bSquare.AddToParent(pnlHost, PAGE_PAD, y, 40dip, 40dip)
    bSquare.Text = ""
    bSquare.IconName = "heart-solid.svg"
    bSquare.Square = True
    bSquare.Tag = "square"

    Dim bCircle As B4XDaisyButton
    bCircle.Initialize(Me, "component")
    bCircle.AddToParent(pnlHost, PAGE_PAD + 48dip, y, 40dip, 40dip)
    bCircle.Text = ""
    bCircle.IconName = "heart-solid.svg"
    bCircle.Circle = True
    bCircle.Tag = "circle"
    y = y + 56dip

    ' /**
    '  * Example 14: Button with icon.
    '  */
    y = AddSectionTitle("Button with Icon", y, maxW)
    Dim bIconL As B4XDaisyButton
    bIconL.Initialize(Me, "component")
    bIconL.AddToParent(pnlHost, PAGE_PAD, y, 112dip, 40dip)
    bIconL.Text = "Like"
    bIconL.IconName = "heart-solid.svg"
    bIconL.Tag = "icon-left"

    Dim bIconR As B4XDaisyButton
    bIconR.Initialize(Me, "component")
    bIconR.AddToParent(pnlHost, PAGE_PAD + 120dip, y, 112dip, 40dip)
    bIconR.Text = "Next"
    bIconR.IconName = "arrow-right-solid.svg"
    bIconR.Tag = "icon-right"
    y = y + 56dip

    ' /**
    '  * Example 15: Button block.
    '  */
    y = AddSectionTitle("Button block", y, maxW)
    Dim bBlock As B4XDaisyButton
    bBlock.Initialize(Me, "component")
    bBlock.AddToParent(pnlHost, PAGE_PAD, y, maxW, 40dip)
    bBlock.Text = "Block"
    bBlock.Block = True
    bBlock.Tag = "block"
    y = y + 56dip

    ' /**
    '  * Example 16: Button with loading spinner.
    '  */
    y = AddSectionTitle("Button with loading spinner", y, maxW)
    Dim bLoadSquare As B4XDaisyButton
    bLoadSquare.Initialize(Me, "component")
    bLoadSquare.AddToParent(pnlHost, PAGE_PAD, y, 40dip, 40dip)
    bLoadSquare.Square = True
    bLoadSquare.Loading = True
    bLoadSquare.Text = ""
    bLoadSquare.Tag = "load-square"

    Dim bLoadText As B4XDaisyButton
    bLoadText.Initialize(Me, "component")
    bLoadText.AddToParent(pnlHost, PAGE_PAD + 48dip, y, 132dip, 40dip)
    bLoadText.Loading = True
    bLoadText.Text = "Loading"
    bLoadText.Tag = "load-text"
    y = y + 56dip

    ' /**
    '  * Example 17: Login buttons.
    '  */
    y = AddSectionTitle("Login buttons", y, maxW)

    Dim bLoginEmail As B4XDaisyButton
    bLoginEmail.Initialize(Me, "component")
    bLoginEmail.AddToParent(pnlHost, PAGE_PAD, y, 0, 0)
    bLoginEmail.Text = "Login with Email"
    bLoginEmail.IconName = "login-email.svg"
    bLoginEmail.BackgroundColor = xui.Color_White
    bLoginEmail.TextColor = xui.Color_RGB(17, 24, 39)
    bLoginEmail.BorderColor = xui.Color_RGB(229, 229, 229)
    bLoginEmail.Tag = "login-email"
    y = y + 48dip

    Dim bLoginGithub As B4XDaisyButton
    bLoginGithub.Initialize(Me, "component")
    bLoginGithub.AddToParent(pnlHost, PAGE_PAD, y, 0, 0)
    bLoginGithub.Text = "Login with GitHub"
    bLoginGithub.IconName = "login-github.svg"
    bLoginGithub.BackgroundColor = xui.Color_RGB(0, 0, 0)
    bLoginGithub.TextColor = xui.Color_White
    bLoginGithub.BorderColor = xui.Color_RGB(0, 0, 0)
    bLoginGithub.Tag = "login-github"
    y = y + 48dip

    Dim bLoginGoogle As B4XDaisyButton
    bLoginGoogle.Initialize(Me, "component")
    bLoginGoogle.AddToParent(pnlHost, PAGE_PAD, y, 0, 0)
    bLoginGoogle.Text = "Login with Google"
    bLoginGoogle.IconName = "login-google.svg"
    bLoginGoogle.BackgroundColor = xui.Color_White
    bLoginGoogle.TextColor = xui.Color_RGB(17, 24, 39)
    bLoginGoogle.BorderColor = xui.Color_RGB(229, 229, 229)
    bLoginGoogle.Tag = "login-google"
    y = y + 48dip

    Dim bLoginFacebook As B4XDaisyButton
    bLoginFacebook.Initialize(Me, "component")
    bLoginFacebook.AddToParent(pnlHost, PAGE_PAD, y, 0, 0)
    bLoginFacebook.Text = "Login with Facebook"
    bLoginFacebook.IconName = "login-facebook.svg"
    bLoginFacebook.BackgroundColor = xui.Color_RGB(26, 119, 242)
    bLoginFacebook.TextColor = xui.Color_White
    bLoginFacebook.BorderColor = xui.Color_RGB(0, 95, 216)
    bLoginFacebook.Tag = "login-facebook"
    y = y + 48dip

    Dim bLoginX As B4XDaisyButton
    bLoginX.Initialize(Me, "component")
    bLoginX.AddToParent(pnlHost, PAGE_PAD, y, 0, 0)
    bLoginX.Text = "Login with X"
    bLoginX.IconName = "login-x.svg"
    bLoginX.BackgroundColor = xui.Color_RGB(0, 0, 0)
    bLoginX.TextColor = xui.Color_White
    bLoginX.BorderColor = xui.Color_RGB(0, 0, 0)
    bLoginX.Tag = "login-x"
    y = y + 48dip

    Dim bLoginKakao As B4XDaisyButton
    bLoginKakao.Initialize(Me, "component")
    bLoginKakao.AddToParent(pnlHost, PAGE_PAD, y, 0, 0)
    bLoginKakao.Text = "Login with Kakao"
    bLoginKakao.IconName = "login-kakao.svg"
    bLoginKakao.BackgroundColor = xui.Color_RGB(254, 229, 2)
    bLoginKakao.TextColor = xui.Color_RGB(24, 22, 0)
    bLoginKakao.BorderColor = xui.Color_RGB(241, 216, 0)
    bLoginKakao.Tag = "login-kakao"
    y = y + 48dip

    Dim bLoginApple As B4XDaisyButton
    bLoginApple.Initialize(Me, "component")
    bLoginApple.AddToParent(pnlHost, PAGE_PAD, y, 0, 0)
    bLoginApple.Text = "Login with Apple"
    bLoginApple.IconName = "login-apple.svg"
    bLoginApple.BackgroundColor = xui.Color_RGB(0, 0, 0)
    bLoginApple.TextColor = xui.Color_White
    bLoginApple.BorderColor = xui.Color_RGB(0, 0, 0)
    bLoginApple.Tag = "login-apple"
    y = y + 48dip

    Dim bLoginAmazon As B4XDaisyButton
    bLoginAmazon.Initialize(Me, "component")
    bLoginAmazon.AddToParent(pnlHost, PAGE_PAD, y, 0, 0)
    bLoginAmazon.Text = "Login with Amazon"
    bLoginAmazon.IconName = "login-amazon.svg"
    bLoginAmazon.BackgroundColor = xui.Color_RGB(255, 153, 0)
    bLoginAmazon.TextColor = xui.Color_RGB(0, 0, 0)
    bLoginAmazon.BorderColor = xui.Color_RGB(225, 125, 0)
    bLoginAmazon.Tag = "login-amazon"
    y = y + 48dip

    Dim bLoginMicrosoft As B4XDaisyButton
    bLoginMicrosoft.Initialize(Me, "component")
    bLoginMicrosoft.AddToParent(pnlHost, PAGE_PAD, y, 0, 0)
    bLoginMicrosoft.Text = "Login with Microsoft"
    bLoginMicrosoft.IconName = "login-microsoft.svg"
    bLoginMicrosoft.BackgroundColor = xui.Color_RGB(47, 47, 47)
    bLoginMicrosoft.TextColor = xui.Color_White
    bLoginMicrosoft.BorderColor = xui.Color_RGB(0, 0, 0)
    bLoginMicrosoft.Tag = "login-microsoft"
    y = y + 48dip

    Dim bLoginLine As B4XDaisyButton
    bLoginLine.Initialize(Me, "component")
    bLoginLine.AddToParent(pnlHost, PAGE_PAD, y, 0, 0)
    bLoginLine.Text = "Login with LINE"
    bLoginLine.IconName = "login-line.svg"
    bLoginLine.BackgroundColor = xui.Color_RGB(3, 199, 85)
    bLoginLine.TextColor = xui.Color_White
    bLoginLine.BorderColor = xui.Color_RGB(0, 181, 68)
    bLoginLine.Tag = "login-line"
    y = y + 48dip

    Dim bLoginSlack As B4XDaisyButton
    bLoginSlack.Initialize(Me, "component")
    bLoginSlack.AddToParent(pnlHost, PAGE_PAD, y, 0, 0)
    bLoginSlack.Text = "Login with Slack"
    bLoginSlack.IconName = "login-slack.svg"
    bLoginSlack.BackgroundColor = xui.Color_RGB(98, 32, 105)
    bLoginSlack.TextColor = xui.Color_White
    bLoginSlack.BorderColor = xui.Color_RGB(89, 22, 96)
    bLoginSlack.Tag = "login-slack"
    y = y + 48dip

    Dim bLoginLinkedIn As B4XDaisyButton
    bLoginLinkedIn.Initialize(Me, "component")
    bLoginLinkedIn.AddToParent(pnlHost, PAGE_PAD, y, 0, 0)
    bLoginLinkedIn.Text = "Login with LinkedIn"
    bLoginLinkedIn.IconName = "login-linkedin.svg"
    bLoginLinkedIn.BackgroundColor = xui.Color_RGB(9, 103, 194)
    bLoginLinkedIn.TextColor = xui.Color_White
    bLoginLinkedIn.BorderColor = xui.Color_RGB(0, 89, 179)
    bLoginLinkedIn.Tag = "login-linkedin"
    y = y + 48dip

    Dim bLoginVK As B4XDaisyButton
    bLoginVK.Initialize(Me, "component")
    bLoginVK.AddToParent(pnlHost, PAGE_PAD, y, 0, 0)
    bLoginVK.Text = "Login with VK"
    bLoginVK.IconName = "login-vk.svg"
    bLoginVK.BackgroundColor = xui.Color_RGB(71, 105, 143)
    bLoginVK.TextColor = xui.Color_White
    bLoginVK.BorderColor = xui.Color_RGB(53, 86, 123)
    bLoginVK.Tag = "login-vk"
    y = y + 48dip

    Dim bLoginWeChat As B4XDaisyButton
    bLoginWeChat.Initialize(Me, "component")
    bLoginWeChat.AddToParent(pnlHost, PAGE_PAD, y, 0, 0)
    bLoginWeChat.Text = "Login with WeChat"
    bLoginWeChat.IconName = "login-wechat.svg"
    bLoginWeChat.BackgroundColor = xui.Color_RGB(94, 187, 43)
    bLoginWeChat.TextColor = xui.Color_White
    bLoginWeChat.BorderColor = xui.Color_RGB(78, 170, 12)
    bLoginWeChat.Tag = "login-wechat"
    y = y + 48dip

    Dim bLoginMetaMask As B4XDaisyButton
    bLoginMetaMask.Initialize(Me, "component")
    bLoginMetaMask.AddToParent(pnlHost, PAGE_PAD, y, 0, 0)
    bLoginMetaMask.Text = "Login with MetaMask"
    bLoginMetaMask.IconName = "login-metamask.svg"
    bLoginMetaMask.BackgroundColor = xui.Color_White
    bLoginMetaMask.TextColor = xui.Color_RGB(17, 24, 39)
    bLoginMetaMask.BorderColor = xui.Color_RGB(229, 229, 229)
    bLoginMetaMask.Tag = "login-metamask"
    y = y + 56dip

    pnlHost.Height = Max(Height, y + PAGE_PAD)
End Sub

Private Sub AddSectionTitle(Text As String, Y As Int, Width As Int) As Int
    Dim titleLbl As Label
    titleLbl.Initialize("")
    titleLbl.Text = Text
    titleLbl.TextColor = xui.Color_RGB(30, 41, 59)
    titleLbl.TextSize = 16
    titleLbl.Typeface = Typeface.DEFAULT_BOLD
    pnlHost.AddView(titleLbl, PAGE_PAD, Y, Width, 24dip)
    Return Y + 26dip
End Sub

' /**
'  * Handles click feedback for rendered examples.
'  */
Private Sub component_Click(Tag As Object)
    #If B4A
    Dim s As String = Tag
    If s.Length = 0 Then s = "button"
    ToastMessageShow("Clicked: " & s, False)
    #End If
End Sub

Private Sub B4XPage_Appear
    CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub
