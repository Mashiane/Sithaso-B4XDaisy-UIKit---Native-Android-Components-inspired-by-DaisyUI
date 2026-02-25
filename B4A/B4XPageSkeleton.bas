B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@
'B4XPageSkeleton.bas
Sub Class_Globals
	Private Root As B4XView 'ignore
	Private xui As XUI 'ignore
	Private mParent As B4XMainPage
	
	Private divAvatar As B4XDaisyDivision
	Private lblTitle As B4XDaisyText
	Private lblSubtitle As B4XDaisyText
	Private divCard As B4XDaisyDivision
	
	Private btnToggle As B4XDaisyDivision
	
	Private divCircle As B4XDaisyDivision
	Private divRect As B4XDaisyDivision
	Private divRect2 As B4XDaisyDivision
End Sub

Public Sub Initialize
	
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.Color = xui.Color_White
	
	'Scroll container
	Dim sv As ScrollView
	sv.Initialize(Root.Height)
	Root.AddView(sv, 0, 0, Root.Width, Root.Height)
	Dim content As B4XView = sv.Panel
	content.Color = xui.Color_Transparent
	
	Dim currentY As Int = 20dip
	
	'Header
	Dim lblHeader As B4XDaisyText
	lblHeader.Initialize(Me, "")
	lblHeader.AddToParent(content, 10dip, currentY, 300dip, 40dip)
	lblHeader.Text = "Skeleton"
	lblHeader.TextSize = "text-sm"
	lblHeader.FontBold = True
	currentY = currentY + 50dip
	
	'Control
	btnToggle.Initialize(Me, "btnToggle")
	btnToggle.AddToParent(content, 10dip, currentY, 150dip, 40dip)
	btnToggle.Text = "Toggle Skeleton"
	btnToggle.BackgroundColor = 0xFF570DF8 'Primary
	btnToggle.TextColor = xui.Color_White
	btnToggle.Rounded = "rounded"
	btnToggle.PlaceContentCenter = True
	currentY = currentY + 60dip
	
	'--- Example 1: Basic Shapes ---
	Dim lblEx1 As B4XDaisyText
	lblEx1.Initialize(Me, "")
	lblEx1.AddToParent(content, 10dip, currentY, 300dip, 30dip)
	lblEx1.Text = "Basic Shapes"
	lblEx1.TextSize = "text-sm"
	currentY = currentY + 35dip
	
	divCircle.Initialize(Me, "")
	divCircle.AddToParent(content, 10dip, currentY, 64dip, 64dip)
	divCircle.Width = "w-16"
	divCircle.Height = "h-16"
	divCircle.Rounded = "rounded-full"
	divCircle.BackgroundColor = 0xFFF3F4F6
	
	divRect.Initialize(Me, "")
	divRect.AddToParent(content, 90dip, currentY + 10dip, 128dip, 16dip)
	divRect.Width = "w-32"
	divRect.Height = "h-4"
	divRect.BackgroundColor = 0xFFF3F4F6
	
	divRect2.Initialize(Me, "")
	divRect2.AddToParent(content, 90dip, currentY + 30dip, 200dip, 16dip)
	divRect2.Width = "w-full"
	divRect2.Height = "h-4"
	divRect2.BackgroundColor = 0xFFF3F4F6
	
	currentY = currentY + 80dip
	
	'--- Example 2: Card ---
	Dim lblEx2 As B4XDaisyText
	lblEx2.Initialize(Me, "")
	lblEx2.AddToParent(content, 10dip, currentY, 300dip, 30dip)
	lblEx2.Text = "Profile Card (Toggle me)"
	lblEx2.TextSize = "text-sm"
	currentY = currentY + 35dip
	
	divCard.Initialize(Me, "")
	divCard.AddToParent(content, 10dip, currentY, 340dip, 200dip)
	divCard.Width = "w-full"
	divCard.Height = "h-52"
	divCard.Shadow = "xl"
	divCard.Rounded = "rounded"
	divCard.Padding = "p-4"
	divCard.BackgroundColor = 0xFFFFFFFF
	divCard.BorderWidth = 1dip
	divCard.BorderColor = 0xFFE5E7EB
	
	'Avatar in card
	divAvatar.Initialize(Me, "")
	divAvatar.AddToParent(divCard.View, 20dip, 20dip, 80dip, 80dip)
	divAvatar.Width = "w-20"
	divAvatar.Height = "h-20"
	divAvatar.BackgroundColor = 0xFF3B82F6 'Blue if not skeleton
	divAvatar.Rounded = "rounded-full"
	
	'Labels
	lblTitle.Initialize(Me, "")
	lblTitle.AddToParent(divCard.View, 120dip, 25dip, 200dip, 30dip)
	lblTitle.Text = "Jane Doe"
	lblTitle.TextSize = "text-xl"
	lblTitle.FontBold = True
	
	lblSubtitle.Initialize(Me, "")
	lblSubtitle.AddToParent(divCard.View, 120dip, 60dip, 200dip, 20dip)
	lblSubtitle.Text = "Senior Software Engineer at ACME Inc."
	lblSubtitle.TextSize = "text-sm"
	lblSubtitle.TextColor = 0xFF6B7280
	
	Dim lblDesc As B4XDaisyText
	lblDesc.Initialize(Me, "")
	lblDesc.AddToParent(divCard.View, 20dip, 120dip, 300dip, 60dip)
	lblDesc.Text = "Passionate about building scalable web applications and exploring new technologies."
	lblDesc.TextSize = "text-sm"
	lblDesc.SingleLine = False
	lblDesc.VAlign = "TOP"
	
	currentY = currentY + 220dip
	
	content.Height = currentY + 100dip
	
	'Start with skeleton non-active for the card
	ToggleSkeleton(False)
End Sub

Private Sub btnToggle_Click (Tag As Object)
	Dim isSkel As Boolean = Not(divAvatar.IsSkeleton)
	ToggleSkeleton(isSkel)
End Sub

Private Sub ToggleSkeleton(Active As Boolean)
	divAvatar.IsSkeleton = Active
	lblTitle.IsSkeleton = Active
	lblSubtitle.IsSkeleton = Active
	
	divCircle.IsSkeleton = Active
	divRect.IsSkeleton = Active
	divRect2.IsSkeleton = Active
	
	'Also toggle card container just for fun? No, usually card container stays, content skeletonizes.
	'But we can test overlaying skeleton on a div too.
	'divCard.IsSkeleton = Active 
	
	If Active Then
		btnToggle.Text = "Disable Skeleton"
	Else
		btnToggle.Text = "Enable Skeleton"
	End If
End Sub

Public Sub SetParent(Parent As B4XMainPage)
	mParent = Parent
End Sub


