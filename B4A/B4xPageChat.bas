B4A=true
Group=Default Group\Pages
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	'Reusable chat component hosted by this page.
	Private DaisyChat As B4XDaisyChat
	'Guards to avoid duplicate sample/demo setup.
	Private SamplesLoaded As Boolean
	Private LocalAvatarPaths As List
	Private DemoStarted As Boolean
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created(Root1 As B4XView)
	Root = Root1
	Root.Color = xui.Color_RGB(245,245,245)
	
	'Create the chat control once and attach it to the page root.
	DaisyChat.Initialize(Me, "daisy")
	DaisyChat.AddToParent(Root)
	
	'Load/copy avatar image candidates from assets for demo use.
	LocalAvatarPaths = GetLocalAvatarPaths
	
	'Populate initial conversations when the view is ready.
	EnsureSamples
End Sub

Private Sub B4XPage_Resize(Width As Int, Height As Int)
	DaisyChat.Resize(Width, Height)
	EnsureSamples
End Sub

Private Sub EnsureSamples
	'Only populate once after the control has a valid size.
	If SamplesLoaded Then Return
	If DaisyChat.IsReady = False Then Return
	If Root.Width <= 0 Then Return
	
	Dim phrases As List
	phrases.Initialize
	phrases.AddAll(Array( _
		"What kind of nonsense is this", _
		"Put me on the Council and not make me a Master!??", _
		"That's never been done in the history of the Jedi.", _
		"It's insulting!", _
		"Calm down, Anakin.", _
		"You have been given a great honor.", _
		"To be on the Council at your age.", _
		"It's never happened before.", _
		"This B4XDaisyChat component is now self-contained.", _
		"Pages can set properties and feed conversations." _
	))
	Dim names As List
	names.Initialize
	names.AddAll(Array( _
		"Anakin Skywalker", _
		"Obi-Wan Kenobi", _
		"Ahsoka Tano", _
		"Padme Amidala Naberrie", _
		"Master Yoda of the Jedi Council", _
		"Mace Windu", _
		"Captain CT-7567 Rex", _
		"Leia Organa Solo", _
		"Han Solo", _
		"Luke Skywalker" _
	))
	DaisyChat.SetDateTimeFormat("D, j M Y H:i")
	DaisyChat.SetUseTimeAgo(True)
	DaisyChat.ShowOnline(False)
	Dim messages As List
	messages.Initialize
	
	'Create 40 alternating messages with deterministic timestamps.
	Dim baseTime As Long = DateTime.Now - (50 * DateTime.TicksPerMinute)
	For i = 0 To 39
		Dim currentSide As String = IIf(i Mod 2 = 0, "start", "end")
		Dim text As String = phrases.Get(i Mod phrases.Size)
		Dim msgTime As Long = baseTime + (i * DateTime.TicksPerMinute)
		Dim timeRaw As String = FormatInputDateTime(msgTime)
		If i Mod 10 = 9 Then
			text = text & " " & "This is a deliberately longer bubble to test line wrapping and dynamic row heights."
		End If
		Dim msg As Map
		msg.Initialize
		'Message schema expected by B4XDaisyChat:
		'id, side, text, header, header_time, footer, avatar
		msg.Put("id", "chat_" & (i + 1))
		msg.Put("side", currentSide)
		msg.Put("text", text)
		msg.Put("header", names.Get(Rnd(0, names.Size)))
		msg.Put("header_time", timeRaw)
		If currentSide = "start" Then
			msg.Put("footer", "Delivered")
		Else
			msg.Put("footer", "Seen at " & FormatDisplayTime(msgTime))
		End If
		Dim avatarPath As String = RandomAvatarFile
		If avatarPath.Length > 0 Then msg.Put("avatar", avatarPath)
		
		messages.Add(msg)
	Next
	
	DaisyChat.SetConversations(messages)
	SamplesLoaded = True
	'Run one guided demo sequence after data is visible.
	If DemoStarted = False Then
		DemoStarted = True
		RunDemoSequence
	End If
End Sub

Private Sub FormatInputDateTime(ValueMillis As Long) As String
	Dim prev As String = DateTime.DateFormat
	DateTime.DateFormat = "yyyy-MM-dd HH:mm"
	Dim result As String = DateTime.Date(ValueMillis)
	DateTime.DateFormat = prev
	Return result
End Sub

Private Sub FormatDisplayTime(ValueMillis As Long) As String
	Dim prev As String = DateTime.DateFormat
	DateTime.DateFormat = DaisyChat.GetDateTimeFormat
	Dim result As String = DateTime.Date(ValueMillis)
	DateTime.DateFormat = prev
	Return result
End Sub

Private Sub daisy_AvatarClick(tag As Object)
End Sub

Private Sub GetLocalAvatarPaths As List
	Dim result As List
	result.Initialize
	Dim seen As Map
	seen.Initialize
	
	'Use an internal folder so loaded files can be referenced by full path.
	Dim avatarDirName As String = "avatars"
	If File.Exists(File.DirInternal, avatarDirName) = False Then
		File.MakeDir(File.DirInternal, avatarDirName)
	End If
	Dim avatarDir As String = File.Combine(File.DirInternal, avatarDirName)
	
	Dim allFiles As List = File.ListFiles(File.DirAssets)
	For Each fn As String In allFiles
		If IsAvatarImageFile(fn) = False Then Continue
		Try
			'Copy to internal storage once; keep existing files.
			If File.Exists(avatarDir, fn) = False Then
				File.Copy(File.DirAssets, fn, avatarDir, fn)
			End If
		Catch
			'Ignore copy errors and continue with any already available files.
		End Try
		AddAvatarPathIfValid(result, seen, File.Combine(avatarDir, fn))
	Next
	
	If File.Exists(File.DirInternal, avatarDirName) Then
		Dim localFiles As List = File.ListFiles(avatarDir)
		For Each fn As String In localFiles
			If IsAvatarImageFile(fn) Then AddAvatarPathIfValid(result, seen, File.Combine(avatarDir, fn))
		Next
	End If
	Return result
End Sub

Private Sub AddAvatarPathIfValid(Result As List, Seen As Map, FullPath As String)
	Dim p As String = FullPath.Trim
	If p.Length = 0 Then Return
	Dim key As String = p.ToLowerCase
	If Seen.ContainsKey(key) Then Return
	Seen.Put(key, True)
	Result.Add(p)
End Sub

Private Sub IsAvatarImageFile(FileName As String) As Boolean
	Dim lower As String = FileName.ToLowerCase
	If lower.StartsWith("face") = False Then Return False
	If lower.EndsWith(".jpg") Or lower.EndsWith(".jpeg") Or lower.EndsWith(".png") Or lower.EndsWith(".webp") Then
		If lower.StartsWith("from.") Or lower.StartsWith("to.") Then Return False
		If lower = "default.png" Then Return False
		If lower = "nav-menu-header-bg.jpg" Then Return False
		Return True
	End If
	Return False
End Sub

Private Sub RandomAvatarFile As String
	If LocalAvatarPaths.IsInitialized = False Or LocalAvatarPaths.Size = 0 Then Return ""
	Return LocalAvatarPaths.Get(Rnd(0, LocalAvatarPaths.Size))
End Sub

Private Sub RunDemoSequence As ResumableSub
	'Pick a stable target in the middle of the list for update/delete tests.
	Dim ids As List = DaisyChat.GetBubbleIds
	If ids.IsInitialized = False Or ids.Size = 0 Then Return False
	Dim midIndex As Int = ids.Size / 2
	Dim targetId As String = ids.Get(midIndex)
	Dim prevId As String = ids.Get(Max(0, midIndex - 1))
	
'	Wait For (xui.MsgboxAsync("The demo will run with 5-second intervals between steps." & CRLF & "Tap OK to start tests.", "B4XDaisyChat Demo")) Msgbox_Result (dlgResult As Int)
	
	'Each step waits 5s so UI changes can be clearly observed.
	'1. Smoothly scroll to end
	Wait For (DaisyChat.SmoothScrollToBottom(1100)) Complete (ok1 As Boolean)
	Sleep(5000)
	'2. Smoothly scroll to beginning
	Wait For (DaisyChat.SmoothScrollToTop(1100)) Complete (ok2 As Boolean)
	Sleep(5000)
	'3. Smoothly scroll to middle-id message
	Wait For (DaisyChat.SmoothScrollToMessage(targetId, 1100)) Complete (ok3 As Boolean)
	Sleep(5000)
	'4. Scroll one conversation up from target
	Wait For (DaisyChat.SmoothScrollToMessage(prevId, 1100)) Complete (ok3b As Boolean)
	Sleep(5000)
	
	'5. Change avatar
	Dim newAvatar As B4XBitmap = RandomAvatarBitmap
	If newAvatar.IsInitialized Then DaisyChat.UpdateAvatarById(targetId, newAvatar)
	Sleep(5000)
	'6. Cycle through all supported avatar masks (target message only).
	Dim maskTokens() As String = Regex.Split("\|", B4XDaisyVariants.MaskList)
	For Each maskName As String In maskTokens
		If maskName.Trim.Length = 0 Then Continue
		DaisyChat.UpdateMessageById(targetId, CreateMap("avatar_mask": maskName))
		DaisyChat.UpdateFooterById(targetId, "Mask • " & maskName)
		Sleep(5000)
	Next
	'Reset mask to circle before continuing with online/ring tests.
	DaisyChat.UpdateMessageById(targetId, CreateMap("avatar_mask": "circle"))
	Sleep(5000)
	'7. Change name to random name
	DaisyChat.UpdateMessageById(targetId, CreateMap("header": RandomDemoName))
	Sleep(5000)
	'8. Change footer text
	DaisyChat.UpdateFooterById(targetId, "Realtime footer update")
	Sleep(5000)
	'9. Change time
	Dim changedTime As String = FormatInputDateTime(DateTime.Now - (17 * DateTime.TicksPerMinute))
	DaisyChat.UpdateMessageById(targetId, CreateMap("header_time": changedTime))
	Sleep(5000)
	'10. Change message
	DaisyChat.UpdateMessageById(targetId, CreateMap("text": "This message was updated in realtime by id."))
	Sleep(5000)
	'11. Footer to Read
	DaisyChat.UpdateFooterById(targetId, "Read")
	Sleep(5000)
	'12. Footer to Delivered
	DaisyChat.UpdateFooterById(targetId, "Delivered")
	Sleep(5000)
	'13. Footer to Seen
	DaisyChat.UpdateFooterById(targetId, "Seen")
	Sleep(5000)
	'14. Footer to Seen at ...
	DaisyChat.UpdateFooterById(targetId, "Seen at " & FormatDisplayTime(DateTime.Now))
	Sleep(5000)
	
	'15. Change text color (target message only)
	DaisyChat.UpdateMessageById(targetId, CreateMap("text_color": 0xFF7C2D12, "muted_color": 0xFF9A3412))
	Sleep(5000)
	'16. Change background color (target message only)
	DaisyChat.UpdateMessageById(targetId, CreateMap("back_color": 0xFFFDE68A))
	Sleep(5000)
	'17. Change to each variant (target message only)
	Dim variants As List
	variants.Initialize
	variants.AddAll(Array("neutral", "primary", "secondary", "accent", "info", "success", "warning", "error"))
	For Each v As String In variants
		DaisyChat.UpdateMessageById(targetId, CreateMap("variant": v, "back_color": 0, "text_color": 0, "muted_color": 0))
		Sleep(5000)
	Next
	'18. Show online status and cycle through all variant colors
	DaisyChat.ShowOnline(True)
	DaisyChat.UpdateOnlineStatusById(targetId, "online", 0)
	Sleep(5000)
	Dim palette As Map = DaisyChat.GetPalette
	For Each v As String In variants
		If palette.IsInitialized And palette.ContainsKey(v) Then
			Dim vm As Map = palette.Get(v)
			Dim onlineColor As Int = vm.Get("back")
			DaisyChat.UpdateOnlineStatusById(targetId, "online", onlineColor)
			DaisyChat.UpdateFooterById(targetId, "Online • " & v)
			Sleep(5000)
		End If
	Next
	
	'Before deleting, scroll to the message before target.
	Wait For (DaisyChat.SmoothScrollToMessage(prevId, 1100)) Complete (ok4 As Boolean)
	Sleep(5000)
	
	'21. Delete that conversation
	DaisyChat.DeleteMessageById(targetId)
	
	Return True
End Sub

Private Sub RandomAvatarBitmap As B4XBitmap
	'Load one random avatar from the pre-resolved full paths list.
	Dim empty As B4XBitmap
	Dim p As String = RandomAvatarFile
	If p.Length = 0 Then Return empty
	Dim slash1 As Int = p.LastIndexOf("/")
	Dim slash2 As Int = p.LastIndexOf("\")
	Dim slash As Int = Max(slash1, slash2)
	If slash <= 0 Then Return empty
	Dim dir As String = p.SubString2(0, slash)
	Dim fn As String = p.SubString(slash + 1)
	If File.Exists(dir, fn) = False Then Return empty
	Return xui.LoadBitmap(dir, fn)
End Sub

Private Sub RandomDemoName As String
	Dim options As List
	options.Initialize
	options.AddAll(Array( _
		"Aria Nightingale", _
		"Malcolm Rivers", _
		"Sophia Valente", _
		"Diego Harrington", _
		"Evelyn Starling", _
		"Rowan Fitzgerald", _
		"Nina Holloway", _
		"Jasper Kingsley" _
	))
	Return options.Get(Rnd(0, options.Size))
End Sub
