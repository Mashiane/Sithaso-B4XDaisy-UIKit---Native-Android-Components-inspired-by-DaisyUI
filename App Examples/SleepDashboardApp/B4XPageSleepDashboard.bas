B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.70
@EndOfDesignText@

#IgnoreWarnings:12,9
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI

	' Page Navigation & Layout
	Private pageScroll As B4XDaisyPageScroll
	Private pnlHost    As B4XView
	Private navbar     As B4XDaisyNavbar

	Private pad        As Int
	Private gap        As Int
	Private maxW       As Int
	Private y          As Int
	Private NAVBAR_H   As Int = 56dip

	' Sleep Quality Score
	Private qualityStat As B4XDaisyStat
	Private qualityItem As B4XDaisyStatItem

	' Sleep Stages Breakdown
	Private stagesStat  As B4XDaisyStat
	Private deepItem    As B4XDaisyStatItem
	Private lightItem   As B4XDaisyStatItem
	Private remItem     As B4XDaisyStatItem

	' Visual Stage Progress Bars
	Private pDeep       As B4XDaisyProgress
	Private pLight      As B4XDaisyProgress
	Private pRem        As B4XDaisyProgress

	' Smart Alarm CTA
	Private smartAlarmBtn As B4XDaisyButton
	Private lastWidth     As Int = 0
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created(vRoot1 As B4XView)
	Root = vRoot1
	Root.RemoveAllViews

	BuildScroll
	BuildNavbar
	RenderContent
End Sub

Private Sub B4XPage_Appear
	CallSubDelayed(B4XPages.MainPage, "Page_Ready")
End Sub

Private Sub B4XPage_Resize(iWidth As Int, iHeight As Int)
	If navbar.IsInitialized Then navbar.SetLayoutAnimated(0, 0, 0, iWidth, NAVBAR_H)
	If pageScroll.IsInitialized Then
		pageScroll.Base_Resize(iWidth, iHeight - NAVBAR_H)
		If lastWidth <> iWidth Or pnlHost.NumberOfViews = 0 Then
			lastWidth = iWidth
			RenderContent
		End If
	End If
End Sub

Private Sub BuildScroll
	Dim scrollTop As Int = NAVBAR_H
	Dim scrollH   As Int = Root.Height - NAVBAR_H
	pageScroll.Initialize(Me, "pageScroll")
	pageScroll.AddToParent(Root, 0, scrollTop, Root.Width, scrollH)
	pageScroll.SendToBack
	pnlHost = pageScroll.Panel
End Sub

Private Sub BuildNavbar
	navbar.Initialize(Me, "navbar")
	navbar.AddToParent(Root, 0, 0, Root.Width, NAVBAR_H)
	navbar.BringToFront
	navbar.Title = "Sleep Dashboard"
	navbar.Variant = "primary"
	navbar.BackVisible = False
End Sub

Private Sub RenderContent
	If pageScroll.IsInitialized = False Then Return
	pageScroll.Clear

	pad  = pageScroll.PagePadding
	gap  = pageScroll.YGap
	maxW = pageScroll.UsableWidth
	y    = pad

	Try
		' === Section 1: Overall Quality Score ===
		y = pageScroll.AddSectionTitle("Sleep Quality Score", y, False) + 6dip

		qualityStat.Initialize(Me, "qualityStat")
		qualityStat.Orientation = "horizontal"
		qualityStat.EqualWidths = True
		qualityStat.Rounded = "rounded-box"
		qualityStat.Shadow = "md"
		qualityStat.AddToParent(pnlHost, pad, y, maxW, 96dip)

		qualityItem.Initialize(Me, "")
		qualityItem.Title = "Overall Sleep Quality"
		qualityItem.Value = "87"
		qualityItem.Suffix = "%"
		qualityItem.Description = "Optimal rest duration (7h 45m)"
		qualityItem.Variant = "primary"
		qualityItem.Animated = True
		qualityStat.AddItem(qualityItem)
		qualityStat.Refresh

		y = y + qualityStat.GetComputedHeight + gap

		' === Section 2: Sleep Stages Breakdown ===
		y = pageScroll.AddSectionTitle("Sleep Stages Breakdown", y, False) + 6dip

		stagesStat.Initialize(Me, "stagesStat")
		stagesStat.Orientation = "horizontal"
		stagesStat.EqualWidths = True
		stagesStat.Rounded = "rounded-box"
		stagesStat.Shadow = "md"
		stagesStat.AddToParent(pnlHost, pad, y, maxW, 96dip)

		deepItem.Initialize(Me, "")
		deepItem.Title = "Deep"
		deepItem.Value = "23"
		deepItem.Suffix = "%"
		deepItem.Description = "1h 48m"
		deepItem.Variant = "success"
		deepItem.Padding = "px-2 py-3"
		stagesStat.AddItem(deepItem)

		lightItem.Initialize(Me, "")
		lightItem.Title = "Light"
		lightItem.Value = "52"
		lightItem.Suffix = "%"
		lightItem.Description = "4h 02m"
		lightItem.Variant = "info"
		lightItem.Padding = "px-2 py-3"
		stagesStat.AddItem(lightItem)

		remItem.Initialize(Me, "")
		remItem.Title = "REM"
		remItem.Value = "25"
		remItem.Suffix = "%"
		remItem.Description = "1h 55m"
		remItem.Variant = "warning"
		remItem.Padding = "px-2 py-3"
		stagesStat.AddItem(remItem)

		stagesStat.Refresh

		y = y + stagesStat.GetComputedHeight + gap

		' === Section 3: Stage Distribution Progress Bars ===
		y = pageScroll.AddSectionTitle("Stage Distribution", y, False) + 6dip

		pDeep.Initialize(Me, "pDeep")
		pDeep.LabelAbove = "Deep Sleep (23%)"
		pDeep.LabelVisible = True
		pDeep.Variant = "success"
		pDeep.Value = 23
		pDeep.AddToParent(pnlHost, pad, y, maxW, 36dip)
		y = y + pDeep.GetComputedHeight + gap

		pLight.Initialize(Me, "pLight")
		pLight.LabelAbove = "Light Sleep (52%)"
		pLight.LabelVisible = True
		pLight.Variant = "info"
		pLight.Value = 52
		pLight.AddToParent(pnlHost, pad, y, maxW, 36dip)
		y = y + pLight.GetComputedHeight + gap

		pRem.Initialize(Me, "pRem")
		pRem.LabelAbove = "REM Sleep (25%)"
		pRem.LabelVisible = True
		pRem.Variant = "warning"
		pRem.Value = 25
		pRem.AddToParent(pnlHost, pad, y, maxW, 36dip)
		y = y + pRem.GetComputedHeight + (gap * 2)

		' === Section 4: Smart Alarm CTA ===
		smartAlarmBtn.Initialize(Me, "smartAlarmBtn")
		smartAlarmBtn.Text = "Configure Smart Alarm"
		smartAlarmBtn.Variant = "primary"
		smartAlarmBtn.Size = "lg"
		smartAlarmBtn.AddToParent(pnlHost, pad, y, maxW, 48dip)
		y = y + smartAlarmBtn.GetComputedHeight + gap

	Catch
		Log("B4XPageSleepDashboard.RenderContent: " & LastException.Message)
	End Try

	pageScroll.AutoFit
End Sub

Private Sub smartAlarmBtn_Click (oTag As Object)
	Dim mp As B4XMainPage = B4XPages.MainPage
	mp.ShowPageWithLoader("smart_alarm")
End Sub
