B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=11
@EndOfDesignText@
#IgnoreWarnings:12,9
Sub Class_Globals
	#if B4A
	Private ion As Object
	Private OldIntent As Intent
	Private Provider As FileProvider
	Private TempFolder As String
	Private TempFileIndex As Int
	#end if
	Type LoadResult (Success As Boolean, Dir As String, FileName As String, RealName As String, Size As Long, Modified As Long, MimeType As String, Image As B4XBitmap)

End Sub

Public Sub Initialize
	#if B4A
	Provider.Initialize
	If Provider.SharedFolder <> "" Then File.MakeDir("", Provider.SharedFolder)
	TempFolder = Provider.SharedFolder
	DeleteTemporaryFiles
	#end if
End Sub

#if B4A
Private Sub GetTempFile (sExt As String) As String
	TempFileIndex = TempFileIndex + 1
	If sExt <> "" And sExt.StartsWith(".") = False Then sExt = "." & sExt
	Return "daisy-media-temp-" & TempFileIndex & sExt
End Sub

'Deletes leftover temp media files. Called on Initialize.
Public Sub DeleteTemporaryFiles
	If TempFolder = "" Then Return
	Try
		For Each f As String In File.ListFiles(TempFolder)
			If f.StartsWith("daisy-media-temp-") Then File.Delete(TempFolder, f)
		Next
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyFileHandler.DeleteTemporaryFiles error: " & LastException.Message)
	End Try
End Sub

Private Sub DetectImageMime (sFolder As String, sFileName As String) As String
	If File.Size(sFolder, sFileName) < 4 Then
		If B4XDaisyApp.DebugLogs Then Log("file size too small")
		Return ""
	End If
	Dim in As InputStream = File.OpenInput(sFolder, sFileName)
	Dim b(4) As Byte
	ReadBytesFully(in, b, 4)
	in.Close
	If b(0) = (0xff).As(Byte) And b(1) = (0xd8).As(Byte) Then
		Return "image/jpeg"
	Else if b(0) = (0x47).As(Byte) And b(1) = (0x49).As(Byte) And b(2) = (0x46).As(Byte) Then
		Return "image/gif"
	Else
		Return "image/*"
	End If
End Sub

Private Sub ReadBytesFully(In As InputStream, oData() As Byte, Len As Int) As Byte()
	Dim count = 0, Read As Int
	Do While count < Len And Read > -1
		Read = In.ReadBytes(oData, count, Len - count)
		count = count + Read
	Loop
	Return oData
End Sub
#End If

#if B4A
Public Sub SaveAs (Source As InputStream, sMimeType As String, sTitle As String) As ResumableSub
	Dim intent As Intent
	intent.Initialize("android.intent.action.CREATE_DOCUMENT", "")
	intent.AddCategory("android.intent.category.OPENABLE")
	intent.PutExtra("android.intent.extra.TITLE", sTitle)
	intent.SetType(sMimeType)
	StartActivityForResult(intent)
	Wait For ion_Event (MethodName As String, Args() As Object)
	If IsResultOk(Args) Then
		Dim result As Intent = GetResultIntent(Args)
		If result.IsInitialized Then
			Dim jo As JavaObject = result
			Dim ctxt As JavaObject
			Dim ContentResolver As JavaObject = ctxt.InitializeContext.RunMethodJO("getContentResolver", Null)
			Dim out As OutputStream = ContentResolver.RunMethod("openOutputStream", Array(jo.RunMethod("getData", Null), "wt"))
			File.Copy2(Source, out)
			out.Close
			Return True
		End If
	End If
	Return False
End Sub

Public Sub Load As ResumableSub
	Return LoadWithFilter("text/*", "Choose text file")
End Sub

Public Sub LoadWithFilter (sMimeType As String, sTitle As String) As ResumableSub
	Dim cc As ContentChooser
	cc.Initialize("cc")
	If sMimeType = "" Then sMimeType = "*/*"
	If sTitle = "" Then sTitle = "Choose file"
	cc.Show(sMimeType, sTitle)
	Wait For CC_Result (Success As Boolean, Dir As String, FileName As String)
	Dim res As LoadResult = CreateLoadResult(Success, Dir, FileName)
	If res.Success Then
		ExtractInformationFromURI(res.FileName, res)
		If res.MimeType <> "" And res.MimeType.StartsWith("image/") Then
			Try
				res.Image = LoadBitmapSample(res.Dir, res.FileName, 1000, 1000)
			Catch
				If B4XDaisyApp.DebugLogs Then Log("B4XDaisyFileHandler LoadWithFilter Image Error: " & LastException.Message)
			End Try
		End If
	End If
	Return res
End Sub

Public Sub RecordAudio As ResumableSub
	#If B4A
	Dim res As LoadResult = CreateLoadResult(False, "", "")
	Try
		Dim i As Intent
		i.Initialize("android.provider.MediaStore.RECORD_SOUND", "")
		StartActivityForResult(i)
		Wait For ion_Event (MethodName As String, Args() As Object)
		If IsResultOk(Args) Then
			Dim result As Intent = GetResultIntent(Args)
			If result <> Null And result.IsInitialized Then
				Try
					Dim uriStr As String = result.GetData
					If uriStr <> "" Then
						res.FileName = uriStr
						res.Success = True
						res.MimeType = "audio/*"
						ExtractInformationFromURI(res.FileName, res)
					End If
				Catch
					If B4XDaisyApp.DebugLogs Then Log("RecordAudio uri extraction error: " & LastException.Message)
				End Try
			End If
		End If
		If res.Success Then Return res
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyFileHandler RecordAudio RECORD_SOUND error: " & LastException.Message)
	End Try

	' Fallback: pick an existing audio file via ContentChooser if sound recorder intent fails or returns empty
	Try
		Dim cc As ContentChooser
		cc.Initialize("cc")
		cc.Show("audio/*", "Choose audio")
		Wait For CC_Result (Success As Boolean, Dir As String, FileName As String)
		If Success Then
			res = CreateLoadResult(True, Dir, FileName)
			ExtractInformationFromURI(res.FileName, res)
		End If
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyFileHandler RecordAudio fallback error: " & LastException.Message)
	End Try
	Return res
	#Else
	Dim res As LoadResult = CreateLoadResult(False, "", "")
	Return res
	#End If
End Sub

Private Sub StartActivityForResult(i As Intent)
	Dim jo As JavaObject = GetBA
	ion = jo.CreateEvent("anywheresoftware.b4a.IOnActivityResult", "ion", Null)
	jo.RunMethod("startActivityForResult", Array(ion, i))
End Sub

Private Sub GetBA As Object
	Return Me.As(JavaObject).RunMethod("getBA", Null)
End Sub

Private Sub IsResultOk (oArgs() As Object) As Boolean
	If oArgs = Null Or oArgs.Length = 0 Then Return False
	For Each arg As Object In oArgs
		If arg <> Null And IsNumber(arg) Then
			Dim val As Int = arg
			If val = -1 Then Return True
		End If
	Next
	Return False
End Sub

Private Sub GetResultIntent (oArgs() As Object) As Intent
	Dim noIntent As Intent
	If oArgs = Null Or oArgs.Length < 2 Then Return noIntent
	If oArgs(1) <> Null Then
		Try
			Dim resIntent As Intent = oArgs(1)
			Return resIntent
		Catch
			If B4XDaisyApp.DebugLogs Then Log("GetResultIntent cast error: " & LastException.Message)
		End Try
	End If
	Return noIntent
End Sub

Private Sub ExtractInformationFromURI (sUri As String, res As LoadResult)
	Try
		Dim resolver As ContentResolver
		resolver.Initialize("")
		Dim u As Uri
		u.Parse(sUri)
		Dim rs As ResultSet = resolver.Query(u, Null, "", Null, "")
		If rs.NextRow Then
			Dim columns As B4XSet = B4XCollections.CreateSet
			For i = 0 To rs.ColumnCount - 1
				columns.Add(rs.GetColumnName(i))
			Next
			If columns.Contains("_display_name") Then res.RealName = rs.GetString("_display_name")
			If columns.Contains("_size") Then res.Size = rs.GetLong("_size")
			If columns.Contains("last_modified") Then res.Modified = rs.GetLong("last_modified")
			If columns.Contains("mime_type") Then res.MimeType = rs.GetString("mime_type")
		End If
		rs.Close
	Catch
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyFileHandler.ExtractInformationFromURI: " & LastException.Message)
	End Try
End Sub

Public Sub CheckForReceivedFiles As LoadResult
	Dim Activity As Activity = B4XPages.GetNativeParent(B4XPages.MainPage)
	If IsRelevantIntent(Activity.GetStartingIntent) Then
		Dim in As Intent = Activity.GetStartingIntent
		Dim uri As String
		If in.HasExtra("android.intent.extra.STREAM") Then
			uri = in.As(JavaObject).RunMethod("getParcelableExtra", Array("android.intent.extra.STREAM"))
		Else
			uri = in.GetData
		End If
		Dim res As LoadResult = CreateLoadResult(True, "ContentDir", uri)
		ExtractInformationFromURI(res.FileName, res)
		Return res
	End If
	Return CreateLoadResult(False, "", "")
End Sub

Private Sub IsRelevantIntent(in As Intent) As Boolean
	If in.IsInitialized And in <> OldIntent And in.Action = in.ACTION_VIEW Then
		OldIntent = in
		Return True
	End If
	Return False
End Sub

#else if B4i
Public Sub SaveAs(oParentPage As Object, oAnchorView As Object, sText As String) As ResumableSub
	Dim avc As ActivityViewController
	avc.Initialize("avc", Array(sText))
	avc.Show(B4XPages.GetNativeParent(oParentPage), oAnchorView)
	Wait For avc_Complete (Success As Boolean, ActivityType As String)
	Return Success
End Sub

Public Sub Load (oParentPage As Object, oAnchorView As Object) As ResumableSub
	Dim DocumentPicker As DocumentPickerViewController
	DocumentPicker.InitializeImport("picker", Array("public.text"))
	DocumentPicker.Show(B4XPages.GetNativeParent(oParentPage), oAnchorView)
	Wait For Picker_Complete (Success As Boolean, URLs As List)
	If Success And URLs.Size > 0 Then
		Return UrlToLoadResult(URLs.Get(0))
	End If
	Return CreateLoadResult(False, "", "")
End Sub

Public Sub UrlToLoadResult(sUrl As String) As LoadResult
	Dim res As LoadResult = CreateLoadResult(IIf(File.Exists(sUrl, ""), True, False), sUrl, "")
	res.RealName = res.Dir.SubString(res.Dir.LastIndexOf("/") + 1)
	res.Size = File.Size(res.Dir, "")
	Return res
End Sub
#end if

Private Sub CreateLoadResult (bSuccess As Boolean, sDir As String, sFileName As String) As LoadResult
	Dim t1 As LoadResult
	t1.Initialize
	t1.Success = bSuccess
	t1.Dir = sDir
	t1.FileName = sFileName
	Return t1
End Sub
