B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private PhotoStack As B4XDaisyStack
	Private StackView As B4XView
	Private StackWidth As Int
	Private StackHeight As Int
	Private AvatarLayers As List
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.Color = xui.Color_RGB(245, 247, 250)
	B4XPages.SetTitle(Me, "Stack Photos")
	AvatarLayers.Initialize

	StackWidth = B4XDaisyVariants.TailwindSizeToDip("w-48", 192dip)
	StackHeight = B4XDaisyVariants.TailwindSizeToDip("h-64", 256dip)
	PhotoStack.Initialize(Me, "")
	StackView = PhotoStack.AddToParent(Root, 0, 0, StackWidth, StackHeight)

	PhotoStack.Direction = "bottom"
	PhotoStack.setLayoutAnimationMs(0)
	'Balanced spacing for h-64 photos: visible layering without oversized gaps.
	PhotoStack.setStepPrimary(18)
	PhotoStack.setStepSecondary(8)
'	StackView = PhotoStack.AddToParent(Root, 0, 0, StackWidth, StackHeight)

	AddPhotoLayer("photo-1559703248-dcaaec9fab78")
	AddPhotoLayer("photo-1565098772267-60af42b81ef2")
	AddPhotoLayer("photo-1572635148818-ef6fd45eb394")

	LayoutStack(Root.Width, Root.Height)
	RefreshAvatarLayerSizes
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	LayoutStack(Width, Height)
	RefreshAvatarLayerSizes
End Sub

Private Sub LayoutStack(Width As Int, Height As Int)
	If StackView.IsInitialized = False Then Return
	Dim x As Int = Max(0, (Width - StackWidth) / 2)
	Dim y As Int = Max(0, (Height - StackHeight) / 2)
	StackView.SetLayoutAnimated(0, x, y, StackWidth, StackHeight)
End Sub

Private Sub AddPhotoLayer(BaseName As String)
	Dim avatar As B4XDaisyAvatar
	avatar.Initialize(Me, "")
	Dim avatarView As B4XView = avatar.AddToParent(StackView, 0, 0, StackWidth, StackHeight)
	avatar.SetImage(ResolvePhotoAsset(BaseName))
	avatar.SetRoundedBox(True)
	avatar.SetShowOnline(False)
	avatar.SetShadow("none")
	avatar.SetRingWidth(0)
	avatar.SetRingOffset(0)
	avatar.SetWidth("48")
	avatar.SetHeight("64")
	avatar.SetCenterOnParent(True)
'	Dim avatarView As B4XView = avatar.AddToParent(StackView, 0, 0, StackWidth, StackHeight)
	PhotoStack.AddLayer(avatarView)
	AvatarLayers.Add(CreateMap("avatar": avatar, "view": avatarView))
End Sub

Private Sub RefreshAvatarLayerSizes
	If AvatarLayers.IsInitialized = False Then Return
	For Each entry As Map In AvatarLayers
		Dim avatar As B4XDaisyAvatar = entry.Get("avatar")
		Dim avatarView As B4XView = entry.Get("view")
		avatar.ResizeToParent(avatarView)
	Next
End Sub

Private Sub ResolvePhotoAsset(BaseName As String) As String
	Dim name As String = BaseName.Trim
	If name.Length = 0 Then Return "face21.jpg"
	If File.Exists(File.DirAssets, name) Then Return name
	If File.Exists(File.DirAssets, name & ".webp") Then Return name & ".webp"
	If File.Exists(File.DirAssets, name & ".jpg") Then Return name & ".jpg"
	If File.Exists(File.DirAssets, name & ".png") Then Return name & ".png"
	Return "face21.jpg"
End Sub
