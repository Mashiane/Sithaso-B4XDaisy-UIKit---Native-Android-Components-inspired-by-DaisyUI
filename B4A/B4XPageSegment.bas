B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.5
@EndOfDesignText@
' B4XPageSegment
' Demonstrates the B4XDaisySegment component based on the Ionic v8 API specifications.
#IgnoreWarnings:12,9

#Region Variables
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private pageScroll As B4XDaisyPageScroll
	Private pnlHost As B4XView

	' Event log display
	Private lblLog As Label
	Private xlblLog As B4XView
	
	' Views for switcher demo
	Private pnlSwitch1, pnlSwitch2, pnlSwitch3 As B4XView
End Sub
#End Region

#Region Initialization
Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
	Root = Root1

	pageScroll.Initialize(Me, "pageScroll")
	pageScroll.AddToParent(Root, 0, 0, Root.Width, Root.Height)
	pnlHost = pageScroll.Panel

	RenderExamples(Root.Width, Root.Height)
End Sub

Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub
#End Region

#Region Rendering
Private Sub RenderExamples(Width As Int, Height As Int)
	If pnlHost.IsInitialized = False Then Return
	pageScroll.Clear

	Dim maxW As Int = pageScroll.UsableWidth
	Dim padding As Int = pageScroll.PagePadding
	Dim gap As Int = pageScroll.YGap
	Dim y As Int = padding

	' --- Event Log ---
	y = pageScroll.AddSectionTitle("Event Log", y, False)
	lblLog.Initialize("")
	xlblLog = lblLog
	xlblLog.Text = "Interact with a segment to see events..."
	xlblLog.TextColor = xui.Color_RGB(100, 116, 139)
	xlblLog.TextSize = 13
	pnlHost.AddView(xlblLog, padding, y, maxW, 30dip)
	y = y + 30dip + gap

	' --- 1. Basic Usage ---
	y = pageScroll.AddSectionTitle("1. Basic Usage (Fixed Width)", y, False)
	
	' 1a. Icon Start
	y = pageScroll.AddSectionTitle("  - Icon Start", y, False)
	Dim segBasic As B4XDaisySegment
	segBasic.Initialize(Me, "segment")
	segBasic.BackgroundColor = "primary"
	segBasic.ButtonLayout = "icon-start"
	segBasic.AddButton("call", "Call", "phone-solid.svg")
	segBasic.AddButton("heart", "Heart", "heart-solid.svg")
	segBasic.AddButton("pin", "Pin", "location-dot-solid-full.svg")
	segBasic.SetValue("call")
	segBasic.AddToParent(pnlHost, padding, y, maxW, 40dip)
	y = y + segBasic.View.Height + gap

	' 1b. Icon End
	y = pageScroll.AddSectionTitle("  - Icon End", y, False)
	Dim segBasicEnd As B4XDaisySegment
	segBasicEnd.Initialize(Me, "segment")
	segBasicEnd.BackgroundColor = "secondary"
	segBasicEnd.ButtonLayout = "icon-end"
	segBasicEnd.AddButton("call", "Call", "phone-solid.svg")
	segBasicEnd.AddButton("heart", "Heart", "heart-solid.svg")
	segBasicEnd.AddButton("pin", "Pin", "location-dot-solid-full.svg")
	segBasicEnd.SetValue("call")
	segBasicEnd.AddToParent(pnlHost, padding, y, maxW, 40dip)
	y = y + segBasicEnd.View.Height + gap

	' 1c. Text Only
	y = pageScroll.AddSectionTitle("  - Text Only (No Icons)", y, False)
	Dim segBasicText As B4XDaisySegment
	segBasicText.Initialize(Me, "segment")
	segBasicText.BackgroundColor = "accent"
	segBasicText.AddLabel("call", "Call")
	segBasicText.AddLabel("heart", "Heart")
	segBasicText.AddLabel("pin", "Pin")
	segBasicText.SetValue("call")
	segBasicText.AddToParent(pnlHost, padding, y, maxW, 40dip)
	y = y + segBasicText.View.Height + gap

	' 1d. Icon Only
	y = pageScroll.AddSectionTitle("  - Icon Only (No Text)", y, False)
	Dim segBasicIconOnly As B4XDaisySegment
	segBasicIconOnly.Initialize(Me, "segment")
	segBasicIconOnly.BackgroundColor = "success"
	segBasicIconOnly.ButtonLayout = "label-hide"
	segBasicIconOnly.AddIcon("call", "phone-solid.svg")
	segBasicIconOnly.AddIcon("heart", "heart-solid.svg")
	segBasicIconOnly.AddIcon("pin", "location-dot-solid-full.svg")
	segBasicIconOnly.SetValue("call")
	segBasicIconOnly.AddToParent(pnlHost, padding, y, maxW, 40dip)
	y = y + segBasicIconOnly.View.Height + gap

	' --- 2. Scrollable Segments ---
	y = pageScroll.AddSectionTitle("2. Scrollable Segments", y, False)
	
	' 2a. Text Only
	y = pageScroll.AddSectionTitle("  - Text Only", y, False)
	Dim segScrollable As B4XDaisySegment
	segScrollable.Initialize(Me, "segment")
	segScrollable.BackgroundColor = "secondary"
	segScrollable.Scrollable = True
	Dim items() As String = Array As String("Home", "Favorites", "Recent", "Archived", "Deleted", "Spam", "Drafts")
	For Each item As String In items
		segScrollable.AddLabel(item.ToLowerCase, item)
	Next
	segScrollable.SetValue("recent")
	segScrollable.AddToParent(pnlHost, padding, y, maxW, 40dip)
	y = y + segScrollable.View.Height + gap

	' 2b. Icon Start
	y = pageScroll.AddSectionTitle("  - Icon Start", y, False)
	Dim segScrollIconStart As B4XDaisySegment
	segScrollIconStart.Initialize(Me, "segment")
	segScrollIconStart.BackgroundColor = "primary"
	segScrollIconStart.Scrollable = True
	segScrollIconStart.ButtonLayout = "icon-start"
	Dim icons() As String = Array As String("user-solid.svg", "heart-solid.svg", "phone-solid.svg", "envelope-solid.svg", "location-dot-solid-full.svg", "music-solid.svg", "image-solid.svg")
	For i = 0 To items.Length - 1
		segScrollIconStart.AddButton(items(i).ToLowerCase, items(i), icons(i))
	Next
	segScrollIconStart.SetValue("recent")
	segScrollIconStart.AddToParent(pnlHost, padding, y, maxW, 40dip)
	y = y + segScrollIconStart.View.Height + gap

	' 2c. Icon End
	y = pageScroll.AddSectionTitle("  - Icon End", y, False)
	Dim segScrollIconEnd As B4XDaisySegment
	segScrollIconEnd.Initialize(Me, "segment")
	segScrollIconEnd.BackgroundColor = "accent"
	segScrollIconEnd.Scrollable = True
	segScrollIconEnd.ButtonLayout = "icon-end"
	For i = 0 To items.Length - 1
		segScrollIconEnd.AddButton(items(i).ToLowerCase, items(i), icons(i))
	Next
	segScrollIconEnd.SetValue("recent")
	segScrollIconEnd.AddToParent(pnlHost, padding, y, maxW, 40dip)
	y = y + segScrollIconEnd.View.Height + gap

	' --- 2d. Scrollable Icons (No Text) ---
	y = pageScroll.AddSectionTitle("2d. Scrollable Icons (No Text)", y, False)
    
	' 2b-1. Primary Color
	y = pageScroll.AddSectionTitle("  - Primary Theme", y, False)
	Dim segScrollIconsPri As B4XDaisySegment
	segScrollIconsPri.Initialize(Me, "segment")
	segScrollIconsPri.BackgroundColor = "primary"
	segScrollIconsPri.Scrollable = True
	segScrollIconsPri.ButtonLayout = "label-hide"
	Dim iconFiles() As String = Array As String("phone-solid.svg", "heart-solid.svg", "location-dot-solid-full.svg", "image-solid.svg", "music-solid.svg", "envelope-solid.svg", "user-solid.svg")
	For i = 0 To iconFiles.Length - 1
		segScrollIconsPri.AddIcon("icon_" & i, iconFiles(i))
	Next
	segScrollIconsPri.SetValue("icon_0")
	segScrollIconsPri.AddToParent(pnlHost, padding, y, maxW, 40dip)
	y = y + segScrollIconsPri.View.Height + gap

	' 2b-2. Secondary Color
	y = pageScroll.AddSectionTitle("  - Secondary Theme", y, False)
	Dim segScrollIconsSec As B4XDaisySegment
	segScrollIconsSec.Initialize(Me, "segment")
	segScrollIconsSec.BackgroundColor = "secondary"
	segScrollIconsSec.Scrollable = True
	segScrollIconsSec.ButtonLayout = "label-hide"
	For i = 0 To iconFiles.Length - 1
		segScrollIconsSec.AddIcon("icon_" & i, iconFiles(i))
	Next
	segScrollIconsSec.SetValue("icon_0")
	segScrollIconsSec.AddToParent(pnlHost, padding, y, maxW, 40dip)
	y = y + segScrollIconsSec.View.Height + gap

	' 2b-3. Success Color
	y = pageScroll.AddSectionTitle("  - Success Theme", y, False)
	Dim segScrollIconsSuc As B4XDaisySegment
	segScrollIconsSuc.Initialize(Me, "segment")
	segScrollIconsSuc.BackgroundColor = "success"
	segScrollIconsSuc.Scrollable = True
	segScrollIconsSuc.ButtonLayout = "label-hide"
	For i = 0 To iconFiles.Length - 1
		segScrollIconsSuc.AddIcon("icon_" & i, iconFiles(i))
	Next
	segScrollIconsSuc.SetValue("icon_0")
	segScrollIconsSuc.AddToParent(pnlHost, padding, y, maxW, 40dip)
	y = y + segScrollIconsSuc.View.Height + gap

	' 2b-4. Warning Color
	y = pageScroll.AddSectionTitle("  - Warning Theme", y, False)
	Dim segScrollIconsWar As B4XDaisySegment
	segScrollIconsWar.Initialize(Me, "segment")
	segScrollIconsWar.BackgroundColor = "warning"
	segScrollIconsWar.Scrollable = True
	segScrollIconsWar.ButtonLayout = "label-hide"
	For i = 0 To iconFiles.Length - 1
		segScrollIconsWar.AddIcon("icon_" & i, iconFiles(i))
	Next
	segScrollIconsWar.SetValue("icon_0")
	segScrollIconsWar.AddToParent(pnlHost, padding, y, maxW, 40dip)
	y = y + segScrollIconsWar.View.Height + gap

	' 2b-5. Error Color
	y = pageScroll.AddSectionTitle("  - Error Theme", y, False)
	Dim segScrollIconsErr As B4XDaisySegment
	segScrollIconsErr.Initialize(Me, "segment")
	segScrollIconsErr.BackgroundColor = "error"
	segScrollIconsErr.Scrollable = True
	segScrollIconsErr.ButtonLayout = "label-hide"
	For i = 0 To iconFiles.Length - 1
		segScrollIconsErr.AddIcon("icon_" & i, iconFiles(i))
	Next
	segScrollIconsErr.SetValue("icon_0")
	segScrollIconsErr.AddToParent(pnlHost, padding, y, maxW, 40dip)
	y = y + segScrollIconsErr.View.Height + gap

	' --- 3. Theming (Colors) ---
	y = pageScroll.AddSectionTitle("3. Theming (Success & Warning)", y, False)
	Dim segSuccess As B4XDaisySegment
	segSuccess.Initialize(Me, "segment")
	segSuccess.BackgroundColor = "success"
	segSuccess.AddLabel("yes", "Accept")
	segSuccess.AddLabel("no", "Decline")
	segSuccess.SetValue("yes")
	segSuccess.AddToParent(pnlHost, padding, y, maxW, 40dip)
	y = y + segSuccess.View.Height + gap / 2

	Dim segWarning As B4XDaisySegment
	segWarning.Initialize(Me, "segment")
	segWarning.BackgroundColor = "warning"
	segWarning.AddLabel("low", "Low")
	segWarning.AddLabel("medium", "Medium")
	segWarning.AddLabel("high", "High")
	segWarning.SetValue("medium")
	segWarning.AddToParent(pnlHost, padding, y, maxW, 40dip)
	y = y + segWarning.View.Height + gap

	' --- 4. Content Panel Switcher ---
	y = pageScroll.AddSectionTitle("4. Content Switcher (Page-controlled Panels)", y, False)
	Dim segSwipeable As B4XDaisySegment
	segSwipeable.Initialize(Me, "segment")
	segSwipeable.BackgroundColor = "primary"
	segSwipeable.AddLabel("c_first", "First")
	segSwipeable.AddLabel("c_second", "Second")
	segSwipeable.AddLabel("c_third", "Third")
	segSwipeable.SetValue("c_first")
	segSwipeable.AddToParent(pnlHost, padding, y, maxW, 40dip)
	y = y + segSwipeable.View.Height + gap
    
	' Create Content Panels stacked in the layout
	pnlSwitch1 = CreateContentPanel("First Content Panel (Switch)", xui.Color_RGB(224, 242, 254), xui.Color_RGB(3, 105, 161))
	pnlHost.AddView(pnlSwitch1, padding, y, maxW, 150dip)
    
	pnlSwitch2 = CreateContentPanel("Second Content Panel (Switch)", xui.Color_RGB(220, 252, 231), xui.Color_RGB(21, 128, 61))
	pnlHost.AddView(pnlSwitch2, padding, y, maxW, 150dip)
    
	pnlSwitch3 = CreateContentPanel("Third Content Panel (Switch)", xui.Color_RGB(254, 240, 138), xui.Color_RGB(161, 98, 7))
	pnlHost.AddView(pnlSwitch3, padding, y, maxW, 150dip)
	y = y + 150dip + gap
    
	UpdateSwitchPanels("c_first")

	' --- 5. Disabled Segment ---
	y = pageScroll.AddSectionTitle("5. Disabled Segment", y, False)
	Dim segDisabled As B4XDaisySegment
	segDisabled.Initialize(Me, "segment")
	segDisabled.BackgroundColor = "primary"
	segDisabled.Disabled = True
	segDisabled.AddLabel("opt1", "Option 1")
	segDisabled.AddLabel("opt2", "Option 2")
	segDisabled.SetValue("opt1")
	segDisabled.AddToParent(pnlHost, padding, y, maxW, 40dip)
	y = y + segDisabled.View.Height + gap

	' --- 6. Custom Button Layouts ---
	y = pageScroll.AddSectionTitle("6. Custom Button Layouts (Icon Position)", y, False)
	
	' 6a. Icon Top (lg)
	y = pageScroll.AddSectionTitle("  - Icon Top (lg)", y, False)
	Dim segIconTop As B4XDaisySegment
	segIconTop.Initialize(Me, "segment")
	segIconTop.BackgroundColor = "secondary"
	segIconTop.ButtonSize = "lg"
	segIconTop.ButtonLayout = "icon-top"
	segIconTop.AddButton("b1", "Photos", "image-solid.svg")
	segIconTop.AddButton("b2", "Music", "music-solid.svg")
	segIconTop.SetValue("b1")
	segIconTop.AddToParent(pnlHost, padding, y, maxW, 48dip)
	y = y + segIconTop.View.Height + gap
    
	' 6b. Icon Top (md)
	y = pageScroll.AddSectionTitle("  - Icon Top (md)", y, False)
	Dim segIconTopMd As B4XDaisySegment
	segIconTopMd.Initialize(Me, "segment")
	segIconTopMd.BackgroundColor = "secondary"
	segIconTopMd.ButtonSize = "md"
	segIconTopMd.ButtonLayout = "icon-top"
	segIconTopMd.AddButton("b1", "Photos", "image-solid.svg")
	segIconTopMd.AddButton("b2", "Music", "music-solid.svg")
	segIconTopMd.SetValue("b1")
	segIconTopMd.AddToParent(pnlHost, padding, y, maxW, 40dip)
	y = y + segIconTopMd.View.Height + gap
    
	' 6c. Icon Bottom (lg)
	y = pageScroll.AddSectionTitle("  - Icon Bottom (lg)", y, False)
	Dim segIconBottom As B4XDaisySegment
	segIconBottom.Initialize(Me, "segment")
	segIconBottom.BackgroundColor = "success"
	segIconBottom.ButtonSize = "lg"
	segIconBottom.ButtonLayout = "icon-bottom"
	segIconBottom.AddButton("b1", "Photos", "image-solid.svg")
	segIconBottom.AddButton("b2", "Music", "music-solid.svg")
	segIconBottom.SetValue("b1")
	segIconBottom.AddToParent(pnlHost, padding, y, maxW, 48dip)
	y = y + segIconBottom.View.Height + gap
    
	' 6d. Icon Bottom (md)
	y = pageScroll.AddSectionTitle("  - Icon Bottom (md)", y, False)
	Dim segIconBottomMd As B4XDaisySegment
	segIconBottomMd.Initialize(Me, "segment")
	segIconBottomMd.BackgroundColor = "success"
	segIconBottomMd.ButtonSize = "md"
	segIconBottomMd.ButtonLayout = "icon-bottom"
	segIconBottomMd.AddButton("b1", "Photos", "image-solid.svg")
	segIconBottomMd.AddButton("b2", "Music", "music-solid.svg")
	segIconBottomMd.SetValue("b1")
	segIconBottomMd.AddToParent(pnlHost, padding, y, maxW, 40dip)
	y = y + segIconBottomMd.View.Height + gap

	' --- 7. Sizing Variants ---
	y = pageScroll.AddSectionTitle("7. Sizing Variants (xs to xl)", y, False)
    
	' 7a. Extra Small (xs)
	y = pageScroll.AddSectionTitle("  - Extra Small (xs)", y, False)
	Dim segSizeXS As B4XDaisySegment
	segSizeXS.Initialize(Me, "segment")
	segSizeXS.BackgroundColor = "primary"
	segSizeXS.ButtonSize = "xs"
	segSizeXS.AddLabel("xs1", "XS One")
	segSizeXS.AddLabel("xs2", "XS Two")
	segSizeXS.SetValue("xs1")
	segSizeXS.AddToParent(pnlHost, padding, y, maxW, 24dip)
	y = y + segSizeXS.View.Height + gap
    
	' 7b. Medium (md)
	y = pageScroll.AddSectionTitle("  - Medium (md)", y, False)
	Dim segSizeMD As B4XDaisySegment
	segSizeMD.Initialize(Me, "segment")
	segSizeMD.BackgroundColor = "success"
	segSizeMD.ButtonSize = "md"
	segSizeMD.AddLabel("md1", "MD One")
	segSizeMD.AddLabel("md2", "MD Two")
	segSizeMD.SetValue("md1")
	segSizeMD.AddToParent(pnlHost, padding, y, maxW, 40dip)
	y = y + segSizeMD.View.Height + gap
    
	' 7c. Large (lg)
	y = pageScroll.AddSectionTitle("  - Large (lg)", y, False)
	Dim segSizeLG As B4XDaisySegment
	segSizeLG.Initialize(Me, "segment")
	segSizeLG.BackgroundColor = "secondary"
	segSizeLG.ButtonSize = "lg"
	segSizeLG.AddLabel("lg1", "LG One")
	segSizeLG.AddLabel("lg2", "LG Two")
	segSizeLG.SetValue("lg1")
	segSizeLG.AddToParent(pnlHost, padding, y, maxW, 48dip)
	y = y + segSizeLG.View.Height + gap
    
	' 7d. Extra Large (xl)
	y = pageScroll.AddSectionTitle("  - Extra Large (xl)", y, False)
	Dim segSizeXL As B4XDaisySegment
	segSizeXL.Initialize(Me, "segment")
	segSizeXL.BackgroundColor = "accent"
	segSizeXL.ButtonSize = "xl"
	segSizeXL.AddLabel("xl1", "XL One")
	segSizeXL.AddLabel("xl2", "XL Two")
	segSizeXL.SetValue("xl1")
	segSizeXL.AddToParent(pnlHost, padding, y, maxW, 56dip)
	y = y + segSizeXL.View.Height + gap

	' --- 8. Custom Background Color Panels ---
	y = pageScroll.AddSectionTitle("8. Custom Background Panels", y, False)
	Dim segCustomBg As B4XDaisySegment
	segCustomBg.Initialize(Me, "segment")
	segCustomBg.BackgroundColor = xui.Color_RGB(29, 78, 216) ' Royal Blue-700 (Bold)
	segCustomBg.AddLabel("c1", "Royal Blue")
	segCustomBg.AddLabel("c2", "Panel")
	segCustomBg.SetValue("c1")
	segCustomBg.AddToParent(pnlHost, padding, y, maxW, 40dip)
	y = y + segCustomBg.View.Height + gap

	' --- 9. Rounded Corner Variants ---
	y = pageScroll.AddSectionTitle("9. Rounded Corner Variants", y, False)
    
	' 9a. Rounded None
	y = pageScroll.AddSectionTitle("  - Rounded None", y, False)
	Dim segRoundNone As B4XDaisySegment
	segRoundNone.Initialize(Me, "segment")
	segRoundNone.Rounded = "none"
	segRoundNone.AddLabel("rn1", "Square")
	segRoundNone.AddLabel("rn2", "Borders")
	segRoundNone.SetValue("rn1")
	segRoundNone.AddToParent(pnlHost, padding, y, maxW, 40dip)
	y = y + segRoundNone.View.Height + gap
    
	' 9b. Rounded Medium (md)
	y = pageScroll.AddSectionTitle("  - Rounded Medium (md)", y, False)
	Dim segRoundMd As B4XDaisySegment
	segRoundMd.Initialize(Me, "segment")
	segRoundMd.Rounded = "md"
	segRoundMd.AddLabel("rm1", "Medium")
	segRoundMd.AddLabel("rm2", "Corners")
	segRoundMd.SetValue("rm1")
	segRoundMd.AddToParent(pnlHost, padding, y, maxW, 40dip)
	y = y + segRoundMd.View.Height + gap
    
	' 9c. Rounded Full (Pill Shape)
	y = pageScroll.AddSectionTitle("  - Rounded Full (Pill Shape)", y, False)
	Dim segRoundFull As B4XDaisySegment
	segRoundFull.Initialize(Me, "segment")
	segRoundFull.Rounded = "full"
	segRoundFull.AddLabel("rf1", "Pill Shape")
	segRoundFull.AddLabel("rf2", "Segment")
	segRoundFull.SetValue("rf1")
	segRoundFull.AddToParent(pnlHost, padding, y, maxW, 40dip)
	y = y + segRoundFull.View.Height + gap

	' --- 10. Shadow Variations ---
	y = pageScroll.AddSectionTitle("10. Shadow Variations", y, False)
    
	' 10a. Shadow Small (sm)
	y = pageScroll.AddSectionTitle("  - Shadow Small (sm)", y, False)
	Dim segShadowSm As B4XDaisySegment
	segShadowSm.Initialize(Me, "segment")
	segShadowSm.Shadow = "sm"
	segShadowSm.AddLabel("ss1", "Shadow Small")
	segShadowSm.AddLabel("ss2", "Control")
	segShadowSm.SetValue("ss1")
	segShadowSm.AddToParent(pnlHost, padding, y, maxW, 40dip)
	y = y + segShadowSm.View.Height + gap
    
	' 10b. Shadow Medium (md)
	y = pageScroll.AddSectionTitle("  - Shadow Medium (md)", y, False)
	Dim segShadowMd As B4XDaisySegment
	segShadowMd.Initialize(Me, "segment")
	segShadowMd.Shadow = "md"
	segShadowMd.AddLabel("smd1", "Shadow Medium")
	segShadowMd.AddLabel("smd2", "Control")
	segShadowMd.SetValue("smd1")
	segShadowMd.AddToParent(pnlHost, padding, y, maxW, 40dip)
	y = y + segShadowMd.View.Height + gap
    
	' 10c. Shadow Large (lg)
	y = pageScroll.AddSectionTitle("  - Shadow Large (lg)", y, False)
	Dim segShadowLg As B4XDaisySegment
	segShadowLg.Initialize(Me, "segment")
	segShadowLg.Shadow = "lg"
	segShadowLg.AddLabel("slg1", "Shadow Large")
	segShadowLg.AddLabel("slg2", "Control")
	segShadowLg.SetValue("slg1")
	segShadowLg.AddToParent(pnlHost, padding, y, maxW, 40dip)
	y = y + segShadowLg.View.Height + gap

	' --- 11. Variant Active Colors (No Background) ---
	y = pageScroll.AddSectionTitle("11. Active Color Variants (No Container Backdrop)", y, False)
    
	' 11a. Active Primary
	y = pageScroll.AddSectionTitle("  - Active Primary", y, False)
	Dim segActPri As B4XDaisySegment
	segActPri.Initialize(Me, "segment")
	segActPri.ActiveColor = "primary"
	segActPri.AddLabel("ap1", "Primary Selected")
	segActPri.AddLabel("ap2", "Option Two")
	segActPri.SetValue("ap1")
	segActPri.AddToParent(pnlHost, padding, y, maxW, 40dip)
	y = y + segActPri.View.Height + gap
    
	' 11b. Active Secondary
	y = pageScroll.AddSectionTitle("  - Active Secondary", y, False)
	Dim segActSec As B4XDaisySegment
	segActSec.Initialize(Me, "segment")
	segActSec.ActiveColor = "secondary"
	segActSec.AddLabel("as1", "Secondary Selected")
	segActSec.AddLabel("as2", "Option Two")
	segActSec.SetValue("as1")
	segActSec.AddToParent(pnlHost, padding, y, maxW, 40dip)
	y = y + segActSec.View.Height + gap

	' 11c. Active Success
	y = pageScroll.AddSectionTitle("  - Active Success", y, False)
	Dim segActSuc As B4XDaisySegment
	segActSuc.Initialize(Me, "segment")
	segActSuc.ActiveColor = "success"
	segActSuc.AddLabel("asuc1", "Success Selected")
	segActSuc.AddLabel("asuc2", "Option Two")
	segActSuc.SetValue("asuc1")
	segActSuc.AddToParent(pnlHost, padding, y, maxW, 40dip)
	y = y + segActSuc.View.Height + gap

	' 11d. Active Warning
	y = pageScroll.AddSectionTitle("  - Active Warning", y, False)
	Dim segActWar As B4XDaisySegment
	segActWar.Initialize(Me, "segment")
	segActWar.ActiveColor = "warning"
	segActWar.AddLabel("awar1", "Warning Selected")
	segActWar.AddLabel("awar2", "Option Two")
	segActWar.SetValue("awar1")
	segActWar.AddToParent(pnlHost, padding, y, maxW, 40dip)
	y = y + segActWar.View.Height + gap

	' 11e. Active Error
	y = pageScroll.AddSectionTitle("  - Active Error", y, False)
	Dim segActErr As B4XDaisySegment
	segActErr.Initialize(Me, "segment")
	segActErr.ActiveColor = "error"
	segActErr.AddLabel("aerr1", "Error Selected")
	segActErr.AddLabel("aerr2", "Option Two")
	segActErr.SetValue("aerr1")
	segActErr.AddToParent(pnlHost, padding, y, maxW, 40dip)
	y = y + segActErr.View.Height + gap

	pageScroll.AutoFit
End Sub

Private Sub UpdateSwitchPanels(Value As String)
	If pnlSwitch1.IsInitialized = False Then Return
	If Value = "c_first" Or Value = "c_second" Or Value = "c_third" Then
		pnlSwitch1.Visible = (Value = "c_first")
		pnlSwitch2.Visible = (Value = "c_second")
		pnlSwitch3.Visible = (Value = "c_third")
	End If
End Sub

Private Sub CreateContentPanel(Text As String, BgColor As Int, TextColor As Int) As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim xp As B4XView = p
	xp.Color = BgColor
    
	Dim lbl As Label
	lbl.Initialize("")
	Dim xlbl As B4XView = lbl
	xlbl.Text = Text
	xlbl.TextColor = TextColor
	xlbl.TextSize = 16
	xlbl.SetTextAlignment("CENTER", "CENTER")
    
	xp.AddView(xlbl, 0, 0, 100%x, 150dip)
	Return xp
End Sub
#End Region

#Region Events
Private Sub segment_Changed(Value As String)
	If xlblLog.IsInitialized Then
		xlblLog.Text = "Segment Changed: " & Value
	End If
	UpdateSwitchPanels(Value)
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
	If pageScroll.IsInitialized Then pageScroll.Base_Resize(Width, Height)
	RenderExamples(Width, Height)
End Sub
#End Region
