B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.5
@EndOfDesignText@
#IgnoreWarnings:12
#Event: Connect (data As Map)
#Event: Disconnect (data As Map)
#Event: ConnectError (data As Map)
#Event: RealTime (data As Map)
#Event: Changes (e As Map)
#Event: Change (Action As String, Record As Map, TableName As String)
#Event: AuthChange (Token As String, Model As Map)
#Event: BeforeSend (url As object, options As Object)
#Event: AfterSend (response As Object, data As Object)
'https://pocketbase.io/old/
'https://pocketbase.io/v023upgrade/jsvm/

Private Sub Class_Globals
	Public const DB_BOOL As String = "BOOL"
	Public const DB_INT As String = "INT"
	Public const DB_FILE As String = "FILE"
	Public const DB_STRING As String = "STRING"
	Public const DB_REAL As String = "REAL"
	Public const DB_BLOB As String = "FILE"
	Public const DB_FLOAT As String = "FLOAT"
	Public const DB_INTEGER As String = "INTEGER"
	Public const DB_TEXT As String = "TEXT"
	Public const DB_LONGTEXT As String = "TEXT"
	Public const DB_DOUBLE As String = "DOUBLE"
	Public const DB_NUMBER As String = "NUMBER"
	Public const DB_RELATION As String = "RELATION"
	Public const DB_JSON As String = "JSON"
	Public const DB_DATE As String = "DATE"
	'
	Type ProfileType (id As String, email As String, avatar As String, name As String, verified As Boolean, username As String, idnumber As String, token As String, size As Int)
	'
	Public UseAPIKey As Boolean
	Private mCallBack As Object			'ignore
	Private baseURL As String
	Private whereField As Map
	Private ops As List
	Private expand As List
	Private orderByL As List
	Private flds As List
	Public RowCount As Int
	Private lastPosition As Int
	Public Record As Map
	Public result As List
	Public Success As Boolean
	Private mEvent As String
	Private sTableName As String
	Public Tag As Object
	Public Schema As Map
	Public PrimaryKey As String = "id"
	Public DisplayField As String
	Public Singular As String
	Public Plural As String
	Public DisplayValue As String
	Public UserProfile As ProfileType
	Private formFields As Map			'ignore  'multipart form fields (replaces BANano formData)
	Private formFiles As List			'ignore  'multipart file descriptors (field, dir, filename)
	Public IsAuthenticated As Boolean
	Private combineL As List
	Public ShowLog As Boolean
	Public Operations As List
	Public UseBatch As Boolean = False	'ignoreshimmustaddbatchpbjs
	Public UseRawInsertForm As Boolean = True	'leancrudskipRecordUpsertForm
	Public UseRawUpdateForm As Boolean = True	'leancrudskipRecordUpsertForm
	Private sApiKey As String = ""	'ignore
	Public UsersCollectionName As String = "users"
	Public skipTotal As Boolean = True
	Public batchSize As Int = 50
	Public Upgrade As Boolean = False
	Private headers As Map
	Private batchRequests As List		'ignore  'batch request list (replaces BANano batchObject)
	Private bNoCache As Boolean = False
	Private hc As OkHttpClient			'ignore  'raw OkHttp client for realtime SSE
	Private fileFields As Map
	Public ListRule As String
	Public ViewRule As String
	Public CreateRule As String
	Public UpdateRule As String
	Public DeleteRule As String
	Private idxNames As Map
	Private uniqueIdxNames As Map
	Public MatchSchema As Boolean
	Public CountRecords As Boolean
	Private grpBy As List
	Public UserRecord As Map
	Public UserToken As String
	Public UserModel As Map
	Public UserValid As Boolean
	Public GetFiles As Boolean
	Private ownFilter As List
End Sub

'<code>
''initialize the connection to pocketbase with a collection to access
'pb.Initialize(Me, "pb", "http://127.0.0.1:8090", "projects")
'pb.SchemaAddText(Array("id", "name"))
'</code>
Public Sub Initialize(oModule As Object, sEventName As String, sUrl As String, sTable As String) As B4XDaisyPocketBase
	sTableName = sTable
	mCallBack = oModule
	skipTotal = True
	baseURL = sUrl
	whereField.Initialize
	ops.Initialize
	expand.Initialize
	orderByL.Initialize
	flds.Initialize
	Record.Initialize
	lastPosition = -1
	result.Initialize
	mEvent = sEventName
	PrimaryKey = "id"
	Schema.Initialize
	SchemaAddText1("id")
	fileFields.Initialize
	combineL.Initialize
	ShowLog = False
	batchSize = 50
	Upgrade = False
	headers.Initialize
	bNoCache = False
	ListRule = ""
	ViewRule =""
	CreateRule = ""
	UpdateRule = ""
	DeleteRule = ""
	idxNames.Initialize
	uniqueIdxNames.Initialize
	setNoCache(bNoCache)
	MatchSchema = True
	CountRecords = False
	grpBy.Initialize
	UserToken = ""
	UserModel = CreateMap()
	UserValid = False
	GetFiles = False
	ownFilter.Initialize
	formFields.Initialize
	formFiles.Initialize
	batchRequests.Initialize
	Return Me
End Sub

Sub AddFilter(sFltr As String)
	sFltr = sFltr.Trim
	If sFltr <> "" Then
		If ShowLog Then
			Log($"B4XDaisyPocketBase.AddFilter('${sFltr}')"$)
		End If
		ownFilter.Add(sFltr)
	End If
End Sub

Sub ClearHeaders
	headers.Initialize
End Sub

'required
Sub setApiKey(sValue As String)
	sApiKey = sValue
End Sub

Sub CancelAllRequests
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.CancelAllRequests"$)
	End If
	'Native OkHttp: no global cancel. Per-request cancel not supported via HttpJob.
	If B4XDaisyApp.DebugLogs Then Log("B4XDaisyPocketBase.CancelAllRequests: not supported in native B4A (OkHttpUtils2).")
End Sub

Sub SetAutoCancellation(bValue As Boolean)
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.SetAutoCancellation(${bValue})"$)
	End If
	'JS SDK auto-cancellation has no native equivalent; no-op.
End Sub

Sub CancelRequest(sReqKey As String)
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.CancelRequest(${sReqKey})"$)
	End If
	'No native per-request cancel via HttpJob; no-op.
End Sub

Sub setNoCache(bValue As Boolean)
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.setNoCache(${bValue})"$)
	End If
	bNoCache = bValue
	If bValue Then
		AddHeader("Cache-Control", "no-store")
	Else
		AddHeader("Cache-Control", "no-cache")
	End If
End Sub

Sub getNoCache As Boolean
	Return bNoCache
End Sub

Sub SchemaAddLongText1(sB As String) As B4XDaisyPocketBase
	Schema.Put(sB, DB_LONGTEXT)
	Return Me
End Sub

Sub SchemaAddLongText(lstBools As List) As B4XDaisyPocketBase
	For Each b As String In lstBools
		Schema.Put(b, DB_LONGTEXT)
	Next
	Return Me
End Sub


' SEND sub deleted as it is JS client specific and unused.

'put recursive object to a map
Sub PutRecursive(mData As Map, sPath As String, oValue As Object)
	Try
		If sPath = Null Or sPath = "" Then Return
		If mData = Null Or mData.IsInitialized = False Then Return
		If sPath.IndexOf(".") = -1 Then
			mData.Put(sPath, oValue)
		Else
			Dim items() As String = Regex.Split("\.", sPath)
			Dim current As Map = mData
			For i = 0 To items.Length - 2
				Dim pathStep As String = items(i)
				Dim nextMap As Map
				If current.ContainsKey(pathStep) Then
					Dim obj As Object = current.Get(pathStep)
					If obj Is Map Then
						nextMap = obj
					Else
						nextMap = CreateMap()
						current.Put(pathStep, nextMap)
					End If
				Else
					nextMap = CreateMap()
					current.Put(pathStep, nextMap)
				End If
				current = nextMap
			Next
			current.Put(items(items.Length - 1), oValue)
		End If
	Catch
		If B4XDaisyApp.DebugLogs Then Log("PutRecursive error: " & LastException.Message)
	End Try
End Sub

'get recursive data from a map
Sub GetRecursive(mData As Map, sPath As String) As Object
	Try
		If sPath = Null Or sPath = "" Then Return Null
		If mData = Null Or mData.IsInitialized = False Then Return Null
		If sPath.IndexOf(".") = -1 Then
			Return mData.Get(sPath)
		Else
			Dim items() As String = Regex.Split("\.", sPath)
			Dim current As Map = mData
			For i = 0 To items.Length - 2
				Dim pathStep As String = items(i)
				If current.ContainsKey(pathStep) = False Then Return Null
				Dim obj As Object = current.Get(pathStep)
				If obj Is Map Then
					current = obj
				Else
					Return Null
				End If
			Next
			Return current.Get(items(items.Length - 1))
		End If
	Catch
		Return Null
	End Try
End Sub



'publish a message to a subscription
Sub RealtimePublish(oModule As Object, sTopicName As String, sValue As String)
	If ShowLog Then
		Log($"B4XDaisyPocketBase.RealtimePublish(${sTopicName},${sValue})"$)
	End If
	Dim eName As String = $"${mEvent}_realtime"$
	If SubExists(oModule, eName) Then
		If ShowLog Then
			Log($"B4XDaisyPocketBase.RealtimePublish.${sTopicName}.${mEvent}_realtime exists."$)
		Else
			If B4XDaisyApp.DebugLogs Then Log($"B4XDaisyPocketBase.RealtimePublish.${sTopicName}.${mEvent}_realtime does NOT exists."$)
		End If
		'client.GetField("realtime").RunMethod("send", Array(topicName, value))
	End If
End Sub
Sub DELETE_ALL_REST(sTable As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTable}.DELETE_ALL_REST"$)
	End If
	Dim finalURL As String = $"/api/deleteall"$
	Dim body As Map = CreateMap("tablename": sTable)
	Wait For (ApiPost(finalURL, body)) Complete (res As Map)
	Return res
End Sub
Sub DELETE_ALL_RESTAUTH(sTable As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTable}.DELETE_ALL_RESTAUTH"$)
	End If
	Dim finalURL As String = $"/api/deleteallauth"$
	Dim body As Map = CreateMap("tablename": sTable)
	Wait For (ApiPost(finalURL, body)) Complete (res As Map)
	Return res
End Sub
Sub SERVER_DATE_TIME As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.SERVER_DATE_TIME"$)
	End If
	Dim finalURL As String = $"/api/servertime"$
	Dim body As Map = CreateMap()
	Wait For (ApiPost(finalURL, body)) Complete (res As Map)
	Return res
End Sub
Sub SEND_EMAIL_REST(sToEmail As String, sSubject As String, sMessage As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.SEND_EMAIL_REST(${sToEmail},${sSubject},${sMessage})"$)
	End If
	Try
		sMessage = sMessage.Replace("</br>", "<br/>")
		sMessage = sMessage.Replace(CRLF, "<br/>")
		Dim finalURL As String = $"/api/sendemail"$
		Dim body As Map = CreateMap("to": sToEmail, "subject": sSubject, "message": sMessage)
		Wait For (ApiPost(finalURL, body)) Complete (res As Map)
		Return res
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"SEND_EMAIL_REST: ${LastException.message}"$)
		Dim m As Map = CreateMap()
		Return m
	End Try
End Sub

Sub SetSchemaFromDataModel1(sSourceTable As String, mModels As Map)
	If ShowLog Then
		Log($"SDUI5MySQLRESTNative.${sSourceTable}.SetSchemaFromDataModel"$)
	End If
	If mModels.ContainsKey(sSourceTable) = False Then
		If B4XDaisyApp.DebugLogs Then Log($"SetSchemaFromDataModel.${sSourceTable} data-model does NOT exist!"$)
		Return
	End If
	Dim tm As Map = mModels.Get(sSourceTable)
	PrimaryKey = tm.GetDefault("pk", "")
	Schema.Initialize
	'set the field types
	Dim fldsx As List = tm.Get("fields").As(List)
	For Each fm As Map In fldsx
		Dim fldType As String = fm.Get("type")
		Dim fldName As String = fm.Get("name")
		Select Case fldType
			Case "LONGTEXT"
				SchemaAddLongText1(fldName)
			Case "FILE"
				SchemaAddFile1(fldName)
			Case "TEXT", "STRING"
				SchemaAddText1(fldName)
			Case "BLOB"
				SchemaAddFile1(fldName)
			Case "INT", "INTEGER"
				SchemaAddInt1(fldName)
			Case "DOUBLE", "REAL", "FLOAT"
				SchemaAddDouble1(fldName)
			Case "BOOL"
				SchemaAddBoolean1(fldName)
		End Select
	Next
End Sub

'set schema from data models
Sub SetSchemaFromDataModel(mModels As Map)
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.SetSchemaFromDataModel"$)
	End If
	If mModels.ContainsKey(sTableName) = False Then
		If B4XDaisyApp.DebugLogs Then Log($"SetSchemaFromDataModel.${sTableName} data-model does NOT exist!"$)
		Return
	End If
	Dim tm As Map = mModels.Get(sTableName)
	PrimaryKey = tm.GetDefault("pk", "")
	Schema.Initialize
	'set the field types
	Dim fldsx As List = tm.Get("fields").As(List)
	For Each fm As Map In fldsx
		Dim fldType As String = fm.Get("type")
		Dim fldName As String = fm.Get("name")
		Select Case fldType
			Case "LONGTEXT"
				SchemaAddLongText1(fldName)
			Case "FILE"
				SchemaAddFile1(fldName)
			Case "TEXT", "STRING"
				SchemaAddText1(fldName)
			Case "BLOB"
				SchemaAddFile1(fldName)
			Case "INT", "INTEGER"
				SchemaAddInt1(fldName)
			Case "DOUBLE", "REAL", "FLOAT"
				SchemaAddDouble1(fldName)
			Case "BOOL"
				SchemaAddBoolean1(fldName)
		End Select
	Next
End Sub

'set schema from data models
Sub SetFieldsFromDataModel(mModels As Map)
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.SetFieldsFromDataModel"$)
	End If
	If mModels.ContainsKey(sTableName) = False Then
		If B4XDaisyApp.DebugLogs Then Log($"SetFieldsFromDataModel.${sTableName} data-model does NOT exist!"$)
		Return
	End If
	Dim tm As Map = mModels.Get(sTableName)
	flds.Clear
	'set the field types
	Dim fldsx As List = tm.Get("fields").As(List)
	For Each fm As Map In fldsx
		Dim fldName As String = fm.Get("name")
		ADD_FIELD(fldName)
	Next
End Sub

'remove field selection from list
Sub RemoveFields(lstThemFields As List)
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.RemoveFields(${lstThemFields})"$)
	End If
	For Each fldName As String In lstThemFields
		Dim fldPos As Int = flds.IndexOf(fldName)
		If fldPos <> -1 Then flds.RemoveAt(fldPos)
	Next
End Sub

'for file fields, get its url
Sub BuildFileURL(sId As String, sFileName As String) As String
	Dim fPath As String = $"${baseURL}/api/files/${sTableName}/${sId}/${sFileName}"$
	Return fPath
End Sub

'for file fields, get its thumbnail
Sub BuildFileThumbNailURL(sId As String, sFileName As String, sWidth As String, sHeight As String) As String
	Dim fPath As String = $"${baseURL}/api/files/${sTableName}/${sId}/${sFileName}?thumb=${sWidth}x${sHeight}"$
	Return fPath
End Sub

Sub getFileURL(mRec As Map, sFilesFieldName As String) As String
	'get list of files
	Dim docs As List = mRec.Get(sFilesFieldName)
	'get the first file
	Dim firstFilename As String = docs.Get(0)
	'
	'Dim url As String = client.RunMethod("getFileUrl", Array(rec, firstFilename)).result
	'Return url
End Sub

'get the url link of a field in 
Sub GetURLLink(sFilesFieldName As String) As String
	'get list of files
	Dim strFile As String = Record.Get(sFilesFieldName)
	Dim sid As String = Record.Get(PrimaryKey)
	Dim fPath As String = $"${baseURL}/api/files/${sTableName}/${sid}/${strFile}"$
	Return fPath
End Sub

'get the url link of a field in 
Sub GetRecordURLLink(mRec As Map, sTable As String, sFilesFieldName As String) As String
	'get list of files
	Dim strFile As String = mRec.Get(sFilesFieldName)
	Dim sid As String = mRec.Get(PrimaryKey)
	Dim fPath As String = $"${baseURL}/api/files/${sTable}/${sid}/${strFile}"$
	Return fPath
End Sub

Sub setTableName(sValue As String)
	If ShowLog Then
		Log($"B4XDaisyPocketBase.setTableName(${sValue})"$)
	End If
	sTableName = sValue
End Sub

Sub SchemaAddIndex(sIdxName As String, bUnique As Boolean) As B4XDaisyPocketBase
	If bUnique Then
		uniqueIdxNames.Put(sIdxName, sIdxName)
	Else
		idxNames.Put(sIdxName, sIdxName)
	End If
	Return Me
End Sub

Sub SchemaAddIndexes(lstIdxNames1 As List) As B4XDaisyPocketBase
	For Each k As String In lstIdxNames1
		SchemaAddIndex(k, False)
	Next
	Return Me
End Sub

Sub SchemaAddUniqueIndexes(lstIdxNames1 As List) As B4XDaisyPocketBase
	For Each k As String In lstIdxNames1
		SchemaAddIndex(k, True)
	Next
	Return Me
End Sub

Sub SchemaAddBlob(lstBools As List) As B4XDaisyPocketBase
	For Each b As String In lstBools
		Schema.Put(b, DB_BLOB)
	Next
	Return Me
End Sub

Sub SchemaAddFile(lstBools As List) As B4XDaisyPocketBase
	For Each b As String In lstBools
		Schema.Put(b, DB_FILE)
	Next
	Return Me
End Sub

Sub SchemaAddFile1(sB As String) As B4XDaisyPocketBase
	Schema.Put(sB, DB_FILE)
	Return Me
End Sub

Sub SchemaAddBlob1(sB As String) As B4XDaisyPocketBase
	Schema.Put(sB, DB_BLOB)
	Return Me
End Sub
'schema add boolean
Sub SchemaAddBoolean(lstBools As List) As B4XDaisyPocketBase
	For Each b As String In lstBools
		Schema.Put(b, DB_BOOL)
	Next
	Return Me
End Sub
Sub SchemaAddBoolean1(sB As String) As B4XDaisyPocketBase
	Schema.Put(sB, DB_BOOL)
	Return Me
End Sub
Sub SchemaAddDouble1(sB As String) As B4XDaisyPocketBase
	Schema.Put(sB, DB_DOUBLE)
	Return Me
End Sub
'add double fields
Sub SchemaAddDouble(lstBools As List) As B4XDaisyPocketBase
	For Each b As String In lstBools
		Schema.Put(b, DB_DOUBLE)
	Next
	Return Me
End Sub
Sub SchemaAddFloat1(sB As String) As B4XDaisyPocketBase
	Schema.Put(sB, DB_FLOAT)
	Return Me
End Sub
Sub SchemaAddFloat(lstBools As List) As B4XDaisyPocketBase
	For Each b As String In lstBools
		Schema.Put(b, DB_FLOAT)
	Next
	Return Me
End Sub
Sub SchemaAddText1(sB As String) As B4XDaisyPocketBase
	Schema.Put(sB, DB_STRING)
	Return Me
End Sub
Sub SchemaAddText(lstBools As List) As B4XDaisyPocketBase
	For Each b As String In lstBools
		Schema.Put(b, DB_STRING)
	Next
	Return Me
End Sub
Sub SchemaAddInt1(sB As String) As B4XDaisyPocketBase
	Schema.Put(sB, DB_INT)
	Return Me
End Sub
Sub SchemaAddInt(lstBools As List) As B4XDaisyPocketBase
	For Each b As String In lstBools
		Schema.Put(b, DB_INT)
	Next
	Return Me
End Sub

Sub SchemaAddNumber(lstBools As List) As B4XDaisyPocketBase
	For Each b As String In lstBools
		Schema.Put(b, DB_NUMBER)
	Next
	Return Me
End Sub

Sub SchemaAddNumber1(sB As String) As B4XDaisyPocketBase
	Schema.Put(sB, DB_NUMBER)
	Return Me
End Sub

Sub SchemaAddRelation(lstBools As List) As B4XDaisyPocketBase
	For Each b As String In lstBools
		Schema.Put(b, DB_RELATION)
	Next
	Return Me
End Sub

Sub SchemaAddRelation1(sB As String) As B4XDaisyPocketBase
	Schema.Put(sB, DB_RELATION)
	Return Me
End Sub

Sub SchemaAddJson(lstBools As List) As B4XDaisyPocketBase
	For Each b As String In lstBools
		Schema.Put(b, DB_JSON)
	Next
	Return Me
End Sub

Sub SchemaAddJson1(sB As String) As B4XDaisyPocketBase
	Schema.Put(sB, DB_JSON)
	Return Me
End Sub


'add a header value
Sub AddHeader(sProp As String, sValue As String)
	headers.Put(sProp, sValue)
End Sub

'Convert a Map to a JSON string (replaces Map2Json).
Private Sub Map2Json(mMap As Map) As String
	Dim gen As JSONGenerator
	gen.Initialize(mMap)
	Return gen.ToString
End Sub

'Parse a JSON object string into a Map (replaces BANano.Await(json.ToMap)).
Private Sub Json2Map(sJsonText As String) As Map
	Dim jp As JSONParser
	Dim m As Map
	m.Initialize
	Try
		If sJsonText.Length > 0 Then
			jp.Initialize(sJsonText)
			m = jp.NextObject
		End If
	Catch
		If ShowLog Then Log($"Json2Map error: ${LastException.message}"$)
	End Try
	Return m
End Sub

'Parse a JSON array string into a List.
Private Sub Json2List(sJsonText As String) As List
	Dim jp As JSONParser
	Dim l As List
	l.Initialize
	Try
		If sJsonText.Length > 0 Then
			jp.Initialize(sJsonText)
			l = jp.NextArray
		End If
	Catch
		If ShowLog Then Log($"Json2List error: ${LastException.message}"$)
	End Try
	Return l
End Sub

'URL-encode a Map as a query string (from jPocketBase).
Private Sub Map2QueryString(mSm As Map) As String
	Dim SU As StringUtils
	Dim sb As StringBuilder
	sb.Initialize
	Dim iCnt As Int = 0
	Dim iTot As Int = mSm.Size - 1
	For Each mKey As String In mSm.Keys
		Dim mValue As String = mSm.Get(mKey)
		mValue = SU.EncodeUrl(mValue, "UTF8")
		mKey = mKey.Trim
		If mKey.EndsWith("=") = False Then mKey = mKey & "="
		sb.Append(mKey).Append(mValue)
		If iCnt < iTot Then sb.Append("&")
		iCnt = iCnt + 1
	Next
	Return sb.ToString
End Sub

'Apply all stored headers (incl. Authorization bearer + API key) to a HttpJob.
Private Sub ApplyHeaders(j As HttpJob)
	For Each k As String In headers.Keys
		j.GetRequest.SetHeader(k, headers.Get(k))
	Next
	If UserToken <> "" Then
		j.GetRequest.SetHeader("Authorization", "Bearer " & UserToken)
	End If
	If sApiKey <> "" Then
		j.GetRequest.SetHeader("x-token", sApiKey)
	End If
End Sub

'Build the records URL for the current collection.
Private Sub RecordsURL As String
	Return $"${baseURL}/api/collections/${sTableName}/records"$
End Sub

Private Sub RecordURL(sId As String) As String
	Return $"${baseURL}/api/collections/${sTableName}/records/${sId}"$
End Sub

'--- Centralized HttpJob request helpers (all ResumableSub, return via Wait For) ---

'POST JSON body, return parsed Map (replaces BANano SDK create/auth calls).
Private Sub ApiPost(sUrl As String, mBody As Map) As ResumableSub
	Dim out As Map = CreateMap()
	Dim j As HttpJob
	j.Initialize("pb", Me)
	j.PostString(sUrl, Map2Json(mBody))
	j.GetRequest.SetContentType("application/json")
	ApplyHeaders(j)
	Wait For (j) JobDone(j As HttpJob)
	If j.Success Then
		out = Json2Map(j.GetString)
	Else
		out = Json2Map(j.ErrorMessage)
		If out.IsInitialized = False Or out.Size = 0 Then out.Put("error", j.ErrorMessage)
		If ShowLog Then Log($"ApiPost ${sUrl} failed: ${j.ErrorMessage}"$)
	End If
	j.Release
	Return out
End Sub

'GET (url includes querystring), return parsed Map.
Private Sub ApiGet(sUrl As String) As ResumableSub
	Dim out As Map = CreateMap()
	Dim j As HttpJob
	j.Initialize("pb", Me)
	j.Download(sUrl)
	ApplyHeaders(j)
	Wait For (j) JobDone(j As HttpJob)
	If j.Success Then
		out = Json2Map(j.GetString)
	Else
		out = Json2Map(j.ErrorMessage)
		If out.IsInitialized = False Or out.Size = 0 Then out.Put("error", j.ErrorMessage)
		If ShowLog Then Log($"ApiGet ${sUrl} failed: ${j.ErrorMessage}"$)
	End If
	j.Release
	Return out
End Sub

'GET (url includes querystring), return parsed List (endpoints returning arrays).
Private Sub ApiGetList(sUrl As String) As ResumableSub
	Dim out As List
	out.Initialize
	Dim j As HttpJob
	j.Initialize("pb", Me)
	j.Download(sUrl)
	ApplyHeaders(j)
	Wait For (j) JobDone(j As HttpJob)
	If j.Success Then
		out = Json2List(j.GetString)
	Else
		If ShowLog Then Log($"ApiGetList ${sUrl} failed: ${j.ErrorMessage}"$)
	End If
	j.Release
	Return out
End Sub

'PATCH JSON body, return parsed Map (replaces SDK update calls).
Private Sub ApiPatch(sUrl As String, mBody As Map) As ResumableSub
	Dim out As Map = CreateMap()
	If mBody.IsInitialized And mBody.ContainsKey("id") Then mBody.Remove("id")
	Dim j As HttpJob
	j.Initialize("pb", Me)
	j.PatchString(sUrl, Map2Json(mBody))
	j.GetRequest.SetContentType("application/json")
	ApplyHeaders(j)
	Wait For (j) JobDone(j As HttpJob)
	If j.Success Then
		out = Json2Map(j.GetString)
	Else
		out = Json2Map(j.ErrorMessage)
		If out.IsInitialized = False Or out.Size = 0 Then out.Put("error", j.ErrorMessage)
		If ShowLog Then Log($"ApiPatch ${sUrl} failed: ${j.ErrorMessage}"$)
	End If
	j.Release
	Return out
End Sub

'DELETE, return success Boolean (replaces SDK delete calls).
Private Sub ApiDelete(sUrl As String) As ResumableSub
	Dim out As Boolean = False
	Dim j As HttpJob
	j.Initialize("pb", Me)
	j.Delete(sUrl)
	ApplyHeaders(j)
	Wait For (j) JobDone(j As HttpJob)
	out = j.Success
	If j.Success = False And ShowLog Then Log($"ApiDelete ${sUrl} failed: ${j.ErrorMessage}"$)
	j.Release
	Return out
End Sub

'this does not process files, use it to execute RAW SQL Commands on your collection
'<code>
'Do While pbComponents.NextRow
'Dim rec As Map = pbComponents.Record
'Dim sid As String = pbComponents.GetString("id")
'Loop
'</code>
Sub SELECT_RAW(sQry As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.SELECT_RAW"$)
	End If
	RowCount = 0
	lastPosition = -1
	result.Initialize
	Try
		Dim finalURL As String = $"/api/rawselect"$
		Dim body As Map = CreateMap("query": sQry, "perPage": batchSize, "skipTotal": skipTotal)
		Wait For (ApiPost(finalURL, body)) Complete (res As Map)
		result = res.Get("items")
		If result.IsInitialized = False Then result.Initialize
		RowCount = result.Size
		Return result
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"SELECT_RAW: ${LastException.message}"$)
		Return result
	End Try
End Sub

'<code>
'Do While pbComponents.NextRow
'Dim rec As Map = pbComponents.Record
'Dim sid As String = pbComponents.GetString("id")
'Loop
'</code>
Sub SELECT_ALL As ResumableSub
	Wait For (SELECT_ALL_FETCH) Complete (res As List)
	Return res
End Sub

'<code>
'Do While pbComponents.NextRow
'Dim rec As Map = pbComponents.Record
'Dim sid As String = pbComponents.GetString("id")
'Loop
'</code>
Sub SELECT_ALL_FETCH As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.SELECT_ALL_FETCH"$)
	End If
	If Schema.Size = 0 Then
		If B4XDaisyApp.DebugLogs Then Log($"B4XDaisyPocketBase.SELECT_ALL_FETCH: ${sTableName} - please execute SchemaAdd first to define your table schema!"$)
		Return Null
	End If
	lastPosition = -1
	result.Initialize
	Dim qsort As String = Join(",", orderByL)
	Dim qflds As String = Join(",", flds)
	Try
		Dim page As Int = 1
		Dim totalPages As Int = 1
		Do While page <= totalPages
			Dim finalURL As String = $"/api/getlist"$
			Dim body As Map = CreateMap()
			body.Put("collection", sTableName)
			body.Put("perPage", batchSize)
			body.Put("page", page)
			body.Put("getFiles", GetFiles)
			body.Put("sort", qsort)
			body.Put("fields", qflds)
			If page <> 1 Then body.Put("skipTotal", True)
			Wait For (ApiPost(finalURL, body)) Complete (mx As Map)
			Dim items As List = mx.Get("items")
			If items.IsInitialized = False Then items.Initialize
			If page = 1 Then totalPages = mx.GetDefault("totalPages", 1)
			result.AddAll(items)
			page = page + 1
		Loop
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"SELECT_ALL_FETCH: ${LastException.message}"$)
		Return Null
	End Try
	RowCount = result.Size
	Return result
End Sub

'record is saved as json string
'returns the record id
'<code>
'pb.PrepareRecord
'pb.SetField("id", 1)
'pb.SetField("username", "user1")
'BANano.Await(pb.CREATE_FETCH)
'</code>
Sub CREATE As ResumableSub
	Wait For (CREATE_FETCH) Complete (rid As String)
	Return rid
End Sub
'
'record is saved as json string
'returns the record id
'<code>
'pb.PrepareRecord
'pb.SetField("id", 1)
'pb.SetField("username", "user1")
'BANano.Await(pb.UPDATE_FETCH)
'</code>
Sub UPDATE As ResumableSub
	Wait For (UPDATE_FETCH) Complete (rid As String)
	Return rid
End Sub

'record is saved as json string
'returns the record id
'<code>
'BANano.Await(pb.DELETE_FETCH("id"))
'</code>
Sub DELETE_FETCH(sDelID As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.DELETE_FETCH"$)
	End If
	If Schema.Size = 0 Then
		If B4XDaisyApp.DebugLogs Then Log($"B4XDaisyPocketBase.DELETE_FETCH: ${sTableName} - please execute SchemaAdd first to define your table schema!"$)
		Return False
	End If
	If sDelID = "" Then
		If B4XDaisyApp.DebugLogs Then Log($"B4XDaisyPocketBase.DELETE_FETCH: ${sTableName} - ID has not been specified!"$)
		Return False
	End If
	Try
		Dim finalURL As String = $"/api/rawdelete/${sTableName}"$
		Dim body As Map = CreateMap("filter": $"id='${sDelID}'"$)
		Wait For (ApiPost(finalURL, body)) Complete (mx As Map)
		Dim bdeleted As Boolean = mx.GetDefault("deleted", False)
		bdeleted = CBool(bdeleted)
		Return bdeleted
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"DELETE_FETCH: ${LastException.message}"$)
		Return False
	End Try
End Sub
Sub findWhereOrderByFetch(mWhereMap As Map, lstWhereOps As List, lstOrderByx As List) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.findWhereOrderByFetch(${Map2Json(mWhereMap)},${lstWhereOps},${lstOrderByx})"$)
	End If
	If Schema.Size = 0 Then
		If B4XDaisyApp.DebugLogs Then Log($"B4XDaisyPocketBase.findWhereOrderByFetch: ${sTableName} - please execute SchemaAdd first to define your table schema!"$)
		Return Null
	End If
	Dim nFilter As String = ""
	If ownFilter.Size > 0 Then
		nFilter = Join(" ", ownFilter).trim
		nFilter = nFilter.replace("!=", "<>").replace("&&", "AND").replace("||", "OR").replace("~", "LIKE").trim
		nFilter = RemDelim(nFilter, "AND")
	End If
	Dim sb As StringBuilder
	sb.Initialize
	Dim i As Int
	Dim iWhere As Int = mWhereMap.Size - 1
	For i = 0 To iWhere
		Dim col As String = mWhereMap.GetKeyAt(i)
		col = MvField(col, 1, ".").Replace("&", "")
		Dim xVal As String = mWhereMap.GetValueAt(i)
		Dim opr As String = lstWhereOps.Get(i)
		opr = opr.Replace("!=", " <> ")
		opr = opr.Replace("~", " LIKE ")
		Dim com As String = combineL.Get(i)
		com = com.Replace("&&", " AND ")
		com = com.Replace("||", " OR ")
		sb.Append(col).Append(opr).Append(xVal).Append(com)
	Next
	Dim qfilter As String = RemDelim(sb.ToString, com).Trim
	Dim qsort As String = ""
	If lstOrderByx.IsInitialized Then qsort = Join(",", lstOrderByx)
	Dim qflds As String = Join(",", flds)
	Dim allRecords As List
	allRecords.Initialize
	Try
		Dim page As Int = 1
		Dim totalPages As Int = 1
		Do While page <= totalPages
			Dim finalURL As String = $"/api/getlist"$
			Dim body As Map = CreateMap()
			body.Put("collection", sTableName)
			body.Put("perPage", batchSize)
			body.Put("page", page)
			body.Put("getFiles", GetFiles)
			body.Put("sort", qsort)
			body.Put("fields", qflds)
			body.Put("ownFilter", nFilter)
			body.Put("filter", qfilter)
			If page <> 1 Then body.Put("skipTotal", True)
			Wait For (ApiPost(finalURL, body)) Complete (mx As Map)
			Dim items As List = mx.Get("items")
			If items.IsInitialized = False Then items.Initialize
			If page = 1 Then totalPages = mx.GetDefault("totalPages", 1)
			allRecords.AddAll(items)
			page = page + 1
		Loop
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"findWhereOrderByFetch: ${LastException.message}"$)
	End Try
	Return allRecords
End Sub



private Sub isBase64Image(sImgURL As String) As Boolean
	'Native: a base64 data-URL image starts with "data:image/".
	Return sImgURL.StartsWith("data:image/")
End Sub

'join list to mv string
private Sub Join(sDelimiter As String, lstItems As List) As String
	If lstItems.Size = 0 Then Return ""
	Dim i As Int
	Dim sbx As StringBuilder
	Dim fld As String
	sbx.Initialize
	fld = lstItems.Get(0)
	sbx.Append(fld)
	For i = 1 To lstItems.size - 1
		Dim fld As String = lstItems.Get(i)
		sbx.Append(sDelimiter).Append(fld)
	Next
	Dim sout As String = sbx.ToString
	sbx.Initialize
	Return sout
End Sub

Sub SELECT_ALL_USERS As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.SELECT_ALL_USERS"$)
	End If
	If Schema.Size = 0 Then
		If B4XDaisyApp.DebugLogs Then Log($"B4XDaisyPocketBase.SELECT_ALL: ${sTableName} - please execute SchemaAdd first to define your table schema!"$)
		Return Null
	End If
	For Each fld As String In Schema.keys
		Dim fldType As String = Schema.Get(fld)
		If fldType = DB_FILE Then
			FILE_FIELD(fld, $"${fld}url"$)
		End If
	Next
	lastPosition = -1
	result.Initialize
	Dim qsort As String = Join(",", orderByL)
	Dim qflds As String = Join(",", flds)
	Dim qexpand As String = Join(",", expand)
	Dim page As Int = 1
	Dim totalPages As Int = 1
	Try
		Do While page <= totalPages
			Dim opt As Map = CreateMap()
			opt.Put("collection", UsersCollectionName)
			opt.Put("page", page)
			opt.Put("perPage", batchSize)
			If qsort <> "" Then opt.Put("sort", qsort)
			If qflds <> "" Then opt.Put("fields", qflds)
			If qexpand <> "" Then opt.Put("expand", qexpand)
			If page <> 1 Then opt.Put("skipTotal", True)
			Wait For (ApiPost("/api/getlist", opt)) Complete (res As Map)
			Dim items As List = res.Get("items")
			If page = 1 Then totalPages = res.GetDefault("totalPages", 1)
			If fileFields.Size > 0 Then
				For Each r As Map In items
					For Each fk As String In fileFields.Keys
						Dim fv As String = fileFields.Get(fk)
						Dim fk1 As String = r.Get(fk)
						Dim pk1 As String = r.Get(PrimaryKey)
					fk1 = CStr(fk1).trim
						If fk1 <> "" Then
							Dim fk2 As String = $"${baseURL}/api/files/${UsersCollectionName}/${pk1}/${fk1}"$
							r.Put(fv, fk2)
							If GetFiles Then
								Wait For (GetFileAsDataURL(fk2)) Complete (fdata As String)
								Dim bisBase64Image As Boolean = isBase64Image(fdata)
								If bisBase64Image Then
									r.Put(fk, fdata)
								Else
									r.Put(fk, "")
								End If
							End If
						End If
					Next
				Next
			End If
			result.AddAll(items)
			page = page + 1
		Loop
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"SELECT_ALL_USERS: ${LastException.message}"$)
		Return Null
	End Try
	RowCount = result.Size
	lastPosition = -1
	Return result
End Sub

Sub SELECT_ALL_ADMINS As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.SELECT_ALL_ADMINS"$)
	End If
	If Schema.Size = 0 Then
		If B4XDaisyApp.DebugLogs Then Log($"B4XDaisyPocketBase.SELECT_ALL_ADMINS: ${sTableName} - please execute SchemaAdd first to define your table schema!"$)
		Return Null
	End If
	lastPosition = -1
	result.Initialize
	Dim qsort As String = Join(",", orderByL)
	Dim qflds As String = Join(",", flds)
	Dim qexpand As String = Join(",", expand)
	Dim xtablename As String = "admins"
	Try
		Dim page As Int = 1
		Dim totalPages As Int = 1
		If Upgrade Then
			xtablename = "_superusers"
		End If
		Do While page <= totalPages
			Dim opt As Map = CreateMap()
			opt.Put("collection", xtablename)
			opt.Put("page", page)
			opt.Put("perPage", batchSize)
			If qsort <> "" Then opt.Put("sort", qsort)
			If qflds <> "" Then opt.Put("fields", qflds)
			If qexpand <> "" Then opt.Put("expand", qexpand)
			If page <> 1 Then opt.Put("skipTotal", True)
			Wait For (ApiPost("/api/getlist", opt)) Complete (res As Map)
			If page = 1 Then totalPages = res.GetDefault("totalPages", 1)
			Dim items As List = res.Get("items")
			If fileFields.Size > 0 Then
				For Each r As Map In items
					For Each fk As String In fileFields.Keys
						Dim fv As String = fileFields.Get(fk)
						Dim fk1 As String = r.Get(fk)
						Dim pk1 As String = r.Get(PrimaryKey)
					fk1 = CStr(fk1).trim
						If fk1 <> "" Then
							Dim fk2 As String = $"${baseURL}/api/files/${xtablename}/${pk1}/${fk1}"$
							r.Put(fv, fk2)
							If GetFiles Then
								Wait For (GetFileAsDataURL(fk2)) Complete (fdata As String)
								Dim bisBase64Image As Boolean = isBase64Image(fdata)
								If bisBase64Image Then
									r.Put(fk, fdata)
								Else
									r.Put(fk, "")
								End If
							End If
						End If
					Next
				Next
			End If
			result.AddAll(items)
			page = page + 1
		Loop
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"SELECT_ALL_ADMINS: ${LastException.message}"$)
		Return Null
	End Try
	RowCount = result.Size
	lastPosition = -1
	Return result
End Sub

'get the data model for the current table
Sub GetDataModel As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.GetDataModel"$)
	End If
	selectFields(Array("name", "schema"))
	whereEqual("type", "base")
	whereEqual("name", sTableName)
	orderBy(Array("name"))
	Wait For (SELECT_COLLECTIONS) Complete (tblNames As List)
	Dim tbl As Map = tblNames.Get(0)
	Dim xflds As Map = CreateMap()
	Dim xSchema As List = tbl.Get("schema")
	For Each fld As Map In xSchema
		Dim fldname As String = fld.Get("name")
		Dim fldtype As String = fld.Get("type")
		xflds.Put(fldname, fldtype)
	Next
	xflds.Put("id", "text")
	xflds.Put("created", "text")
	xflds.Put("updated", "text")
	Return xflds
End Sub

'get the data model for the current table
Sub GetDataModelOfTable(sTblName As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.GetDataModelOfTable"$)
	End If
	selectFields(Array("name", "schema"))
	whereEqual("type", "base")
	whereEqual("name", sTblName)
	orderBy(Array("name"))
	Wait For (SELECT_COLLECTIONS) Complete (tblNames As List)
	Dim tbl As Map = tblNames.Get(0)
	Dim xflds As Map = CreateMap()
	Dim xSchema As List = tbl.Get("schema")
	For Each fld As Map In xSchema
		Dim fldname As String = fld.Get("name")
		Dim fldtype As String = fld.Get("type")
		xflds.Put(fldname, fldtype)
	Next
	xflds.Put("id", "text")
	xflds.Put("created", "text")
	xflds.Put("updated", "text")
	Return xflds
End Sub
Sub GetDataModels(sE As String, sP As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.GetDataModels"$)
	End If
	selectFields(Array("name", "schema"))
	whereEqual("type", "base")
	orderBy(Array("name"))
	Wait For (SELECT_ALL_COLLECTIONS(sE, sP)) Complete (tblNames As List)
	Dim models As Map = CreateMap()
	For Each tbl As Map In tblNames
		Dim xflds As Map = CreateMap()
		Dim sname As String = tbl.Get("name")
		Dim xSchema As List = tbl.Get("schema")
		For Each fld As Map In xSchema
			Dim fldname As String = fld.Get("name")
			Dim fldtype As String = fld.Get("type")
			xflds.Put(fldname, fldtype)
		Next
		xflds.Put("id", "text")
		xflds.Put("created", "text")
		xflds.Put("updated", "text")
		models.Put(sname, xflds)
	Next
	Return models
End Sub
Sub GetViews(sE As String, sP As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.GetViews"$)
	End If
	selectFields(Array("name"))
	whereEqual("type", "view")
	orderBy(Array("name"))
	Wait For (SELECT_ALL_COLLECTIONS(sE, sP)) Complete (tblNames As List)
	Dim vnames As List = ListOfMapsGetProperty(tblNames, "name")
	Return vnames
End Sub

'get all table names excluding views
Sub SELECT_ALL_COLLECTIONS_NAMES(sE As String, sP As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.SELECT_ALL_COLLECTIONS_NAMES"$)
	End If
	selectFields(Array("name"))
	whereEqual("type", "base")
	orderBy(Array("name"))
	Wait For (SELECT_ALL_COLLECTIONS(sE, sP)) Complete (tblNames As List)
	Dim tbNames As List = ListOfMapsGetProperty(tblNames, "name")
	Return tbNames
End Sub

'convert object to string
private Sub CStr(oO As Object) As String
	If oO = Null Then Return ""
	If oO = "null" Then Return ""
	If oO = "undefined" Then Return ""
	Return "" & oO
End Sub

private Sub ListOfMapsGetProperty(lstItems As List, sKey As String) As List
	sKey = CStr(sKey)
	Dim nList As List
	nList.Initialize
	'
	Dim recTot As Int = lstItems.Size - 1
	Dim recCnt As Int
	For recCnt = 0 To recTot
		Dim m As Map = lstItems.Get(recCnt)
		If m.ContainsKey(sKey) Then
			Dim v As String = m.Get(sKey)
			v = CStr(v)
			nList.Add(v)
		End If
	Next
	Return nList
End Sub

'<code>
'Do While pbComponents.NextRow
'Dim rec As Map = pbComponents.Record
'Dim sid As String = pbComponents.GetString("id")
'Loop
'</code>
Sub SELECT_COLLECTIONS() As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.SELECT_COLLECTIONS"$)
	End If
	lastPosition = -1
	result.Initialize
	Dim sb As StringBuilder
	sb.Initialize
	If ownFilter.Size > 0 Then
		Dim nfilter As String = Join(" ", ownFilter).trim
		sb.Append(nfilter)
	End If
	Dim i As Int
	Dim iWhere As Int = whereField.Size - 1
	For i = 0 To iWhere
		Dim col As String = whereField.GetKeyAt(i)
		col = MvField(col, 1, ".").Replace("&", "")
		Dim xVal As String = whereField.GetValueAt(i)
		Dim opr As String = ops.Get(i)
		Dim com As String = combineL.Get(i)
		sb.Append(col).Append(opr).Append(xVal).Append(com)
	Next
	Dim qfilter As String = RemDelim(sb.ToString, com).Trim
	Dim qsort As String = Join(",", orderByL)
	Dim qflds As String = Join(",", flds)
	Try
		Dim page As Int = 1
		Dim totalPages As Int = 1
		Do While page <= totalPages
			SetAuthorizationBearerToken(UserToken)
			Dim opt As Map = CreateMap()
			opt.Put("page", page)
			opt.Put("perPage", batchSize)
			opt.Put("cache", "no-store")
			If qsort <> "" Then opt.Put("sort", qsort)
			If qflds <> "" Then opt.Put("fields", qflds)
		If qfilter <> "" Then opt.Put("filter", qfilter)
		If page <> 1 Then opt.Put("skipTotal", True)

			Dim finalURL As String = $"/api/collections"$
			Dim queryParts As List
			queryParts.Initialize
			For Each k As String In opt.Keys
				Dim v As String = opt.Get(k)
				Dim su As StringUtils
				queryParts.Add(k & "=" & su.EncodeUrl(v, "UTF8"))
			Next
			If queryParts.Size > 0 Then
				finalURL = finalURL & "?" & Join("&", queryParts)
			End If
			
			Wait For (ApiGet(finalURL)) Complete (res As Map)
			If page = 1 Then totalPages = res.GetDefault("totalPages", 1)
			Dim items As List = res.Get("items")
			result.AddAll(items)
			page = page + 1
		Loop
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"SELECT_COLLECTIONS: ${LastException.message}"$)
		Return Null
	End Try
	RowCount = result.Size
	Return result
End Sub

'<code>
'Do While pbComponents.NextRow
'Dim rec As Map = pbComponents.Record
'Dim sid As String = pbComponents.GetString("id")
'Loop
'</code>
Sub SELECT_ALL_COLLECTIONS(sE As String, sP As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.SELECT_ALL_COLLECTIONS"$)
	End If
	If Schema.Size = 0 Then
		If B4XDaisyApp.DebugLogs Then Log($"B4XDaisyPocketBase.SELECT_ALL_COLLECTIONS: ${sTableName} - please execute SchemaAdd first to define your table schema!"$)
		Return Null
	End If
	UserProfile.Initialize
	UserProfile.size = 0
	Wait For (ADMIN_AUTH_WITH_PASSWORD(sE, sP)) Complete (authRes As Map)
	UserToken = authRes.Get("token")
	lastPosition = -1
	result.Initialize
	Dim sb As StringBuilder
	sb.Initialize
	If ownFilter.Size > 0 Then
		Dim nfilter As String = Join(" ", ownFilter).trim
		sb.Append(nfilter)
	End If
	Dim i As Int
	Dim iWhere As Int = whereField.Size - 1
	For i = 0 To iWhere
		Dim col As String = whereField.GetKeyAt(i)
		col = MvField(col, 1, ".").Replace("&", "")
		Dim xVal As String = whereField.GetValueAt(i)
		Dim opr As String = ops.Get(i)
		Dim com As String = combineL.Get(i)
		sb.Append(col).Append(opr).Append(xVal).Append(com)
	Next
	Dim qfilter As String = RemDelim(sb.ToString, com).Trim
	Dim qsort As String = Join(",", orderByL)
	Dim qflds As String = Join(",", flds)
	Try
		Dim page As Int = 1
		Dim totalPages As Int = 1
		Do While page <= totalPages
			SetAuthorizationBearerToken(UserToken)
			Dim opt As Map = CreateMap()
			opt.Put("page", page)
			opt.Put("perPage", batchSize)
			opt.Put("cache", "no-store")
			If qsort <> "" Then opt.Put("sort", qsort)
			If qflds <> "" Then opt.Put("fields", qflds)
		If qfilter <> "" Then opt.Put("filter", qfilter)
		If page <> 1 Then opt.Put("skipTotal", True)

			Dim finalURL As String = $"/api/collections"$
			Dim queryParts As List
			queryParts.Initialize
			For Each k As String In opt.Keys
				Dim v As String = opt.Get(k)
				Dim su As StringUtils
				queryParts.Add(k & "=" & su.EncodeUrl(v, "UTF8"))
			Next
			If queryParts.Size > 0 Then
				finalURL = finalURL & "?" & Join("&", queryParts)
			End If
			
			Wait For (ApiGet(finalURL)) Complete (res As Map)
			If page = 1 Then totalPages = res.GetDefault("totalPages", 1)
			Dim items As List = res.Get("items")
			result.AddAll(items)
			page = page + 1
		Loop
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"SELECT_ALL_COLLECTIONS: ${LastException.message}"$)
		Return Null
	End Try
	RowCount = result.Size
	Return result
End Sub

'<code>
'Sub pb_Change (Action As String, Record As Map, TableName As String)
'log(action)
'log(record)
'log(tablename)
'select case Action
'end select
'End Sub
'</code> 
Sub Subscribe(oModule As Object, sTable As String)
	If B4XDaisyApp.DebugLogs Then Log("Realtime subscribe is deferred for native B4A.")
End Sub

'PB_CONNECT, PB_DISCONNECT, PB_ERROR
Sub RealtimeSubscribe(sTopicName As String, oModule As Object, sMethodName As String)
	If B4XDaisyApp.DebugLogs Then Log("Realtime subscribe is deferred for native B4A.")
End Sub

Sub RealtimeUnSubscribe(sTopicName As String)
	If B4XDaisyApp.DebugLogs Then Log("Realtime unsubscribe is deferred for native B4A.")
End Sub

Sub RealtimeUnSubscribeByPrefix(sTopicName As String)
	If B4XDaisyApp.DebugLogs Then Log("Realtime unsubscribe is deferred.")
End Sub


Private Sub HandleChange(mRes As Map)
	If B4XDaisyApp.DebugLogs Then Log("HandleChange is deferred.")
End Sub


'subscribe to a record
Sub SubscribeToRecord(oModule As Object, sTable As String, sId As String)
	If B4XDaisyApp.DebugLogs Then Log("Realtime subscribe is deferred.")
End Sub

'unsubscribe, leave table blank for all
Sub UnSubscribe(sTable As String)
	If B4XDaisyApp.DebugLogs Then Log("Realtime unsubscribe is deferred.")
End Sub

Sub UnSubscribeToRecord(sTable As String, sId As String)
	If B4XDaisyApp.DebugLogs Then Log("Realtime unsubscribe is deferred.")
End Sub

'record is saved as json string
'returns the record id
'<code>
'BANano.Await(pb.CREATE_OR_UPDATE)
'</code>
Sub CREATE_OR_UPDATE As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.CREATE_OR_UPDATE"$)
	End If
	If Schema.Size = 0 Then
		If B4XDaisyApp.DebugLogs Then Log($"B4XDaisyPocketBase.CREATE_OR_UPDATE: ${sTableName} - please execute SchemaAdd first to define your table schema!"$)
		Return ""
	End If
	Try
		Dim Key As String = Record.GetDefault("id", "")
		DisplayValue = Record.GetDefault(DisplayField, "")
		Dim bThere As Boolean = False
		If Key <> "" Then
			Wait For (ContainsKey(Key)) Complete (bThere As Boolean)
		End If
		If bThere = False Then
			Wait For (CREATE_FETCH) Complete (k As String)
			Return k
		Else
			Wait For (UPDATE_FETCH) Complete (k As String)
			Return k
		End If
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"CREATE_OR_UPDATE: ${LastException.message}"$)
		Return ""
	End Try
End Sub

'ensure the query only return the id only
Sub GetAffectedID As B4XDaisyPocketBase
	flds.Initialize
	flds.Add("id")
	Return Me
End Sub


'record is saved as json string
'returns the record id
'<code>
'BANano.Await(pb.CREATE_OR_UPDATE_FORM(10))
'</code>
'Sub CREATE_OR_UPDATE_FORM(sID As String) As ResumableSub
'	If ShowLog Then
'		Log($"B4XDaisyPocketBase.${sTableName}.CREATE_OR_UPDATE_FORM"$)
'	End If
'	If Schema.Size = 0 Then
'		Log($"B4XDaisyPocketBase.CREATE_OR_UPDATE_FORM: ${sTableName} - please execute SchemaAdd first to define your table schema!"$)
'		Return ""
'	End If
'	Try
'		DisplayValue = Record.GetDefault(DisplayField, "")
'		Dim bThere As Boolean = False
'		If sID <> "" Then
'			Wait For (ContainsKey(sID)) Complete (bThere As Boolean)
'		End If
'		If bThere = False Then
'			If UseRawInsertForm Then
'				Wait For (ExecuteRawInsertForm) Complete (j As Map)
'			Else
'				Wait For (ApiPostMultipart(RecordsURL, formFields, formFiles)) Complete (res As Map)
'				Record = res
'			End If
'			If Record.ContainsKey("id") Then
'				Dim k As String = Record.Get("id")
'				Return k
'			End If
'			Return ""
'		Else
'			If UseRawUpdateForm Then
'				Wait For (ExecuteRawUpdateForm(sID)) Complete (j As Map)
'			Else
'				Wait For (ApiPatchMultipart(RecordURL(sID), formFields, formFiles)) Complete (res As Map)
'				Record = res
'			End If
'			If Record.ContainsKey("id") Then
'				Dim k As String = Record.Get("id")
'				Return k
'			End If
'			Return ""
'		End If
'	Catch
'		Log($"CREATE_OR_UPDATE_FORM: ${LastException.message}"$)
'		Return ""
'	End Try
'End Sub



'record is saved as json string
'returns the record id
'<code>
'BANano.Await(pb.CREATE_OR_UPDATE_BY_FIELD("email"))
'</code>
Sub CREATE_OR_UPDATE_BY_FIELD(sFldName As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.CREATE_OR_UPDATE_BY_FIELD(${sFldName})"$)
	End If
	If Schema.Size = 0 Then
		If B4XDaisyApp.DebugLogs Then Log($"B4XDaisyPocketBase.CREATE_OR_UPDATE_BY_FIELD: ${sTableName} - please execute SchemaAdd first to define your table schema!"$)
		Return ""
	End If
	Try
		Dim sKey As String = Record.GetDefault(sFldName, "")
		DisplayValue = Record.GetDefault(DisplayField, "")
		Dim bThere As Boolean = False
		Dim id As String = ""
		If sKey <> "" Then
			Wait For (READ_ID_BY_STRING(sFldName, sKey)) Complete (resId As String)
			id = resId
			If id <> "" Then bThere = True
		End If
		If bThere = False Then
			Wait For (CREATE_FETCH) Complete (k As String)
			Return k
		Else
			Record.Put("id", id)
			Wait For (UPDATE_FETCH) Complete (k As String)
			Return k
		End If
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"CREATE_OR_UPDATE_BY_FIELD: ${LastException.message}"$)
		Return ""
	End Try
End Sub
'Sub UPDATE_FILE(sid As String, fileField As String, fileObj As Map) As ResumableSub
'	Try
'		Dim fields As Map = CreateMap()
'		Dim files As List = Array(fileObj)
'		fileObj.Put("KeyName", fileField)
'		Dim url As String
'		If UseRawUpdateForm Then
'			'build a return fields list scoped to the single file field
'			formFields = fields
'			formFiles = files
'			formFields.Put("fields", $"id,${fileField},updated"$)
'			url = $"${baseURL}/api/rawupdateform/${sTableName}/${sid}"$
'			Wait For (ApiPatchMultipart(url, formFields, formFiles)) Complete (res As Map)
'			Record = res.Get("record")
'		Else
'			url = RecordURL(sid)
'			Wait For (ApiPatchMultipart(url, fields, files)) Complete (res As Map)
'			Record = res
'		End If
'		If Record.ContainsKey("id") Then
'			Dim k As String = Record.Get("id")
'			Return k
'		End If
'		Return ""
'	Catch
'		Log($"UPDATE_FILE: ${LastException.message}"$)
'		Return ""
'	End Try
'End Sub


''record is saved as json string
''returns the record id
''<code>
''pb.PrepareRecord
''pb.SetField("id", 1)
''pb.SetField("username", "user1")
''BANano.Await(pb.CREATE)
''</code>
'Sub CREATE As ResumableSub
'	If ShowLog Then
'		Log($"B4XDaisyPocketBase.${sTableName}.CREATE"$)
'	End If
'	If Schema.Size = 0 Then
'		Log($"B4XDaisyPocketBase.CREATE: ${sTableName} - please execute SchemaAdd first to define your table schema!"$)
'		Return ""
'	End If
'	'
'	Try
'		Dim qflds As String = Join(",", flds)
'		Dim qexpand As String = Join(",", expand)
'
'		Dim qs As Map = CreateMap()
'		If qflds <> "" Then qs.Put("fields", qflds)
'		If qexpand <> "" Then qs.Put("expand", qexpand)
'		Dim url As String = RecordsURL
'		If qs.Size > 0 Then url = $"${url}?${Map2QueryString(qs)}"$
'		If ShowLog Then
'			Log($"B4XDaisyPocketBase.${sTableName}.CREATE(${url})"$)
'		End If
'		'
'		Wait For (ApiPost(url, Record)) Complete (res As Map)
'		Record = res
'		If res.ContainsKey("id") Then
'			Dim k As String = res.Get("id")
'			Return k
'		End If
'		Return ""
'	Catch
'		Log($"CREATE: ${LastException.message}"$)
'		Return ""
'	End Try
'End Sub
'

'ceate a ecod using fomdata
'<code>
'pb.PrepareForm
'pb.SetFormFile("fileobj", fileObj)
'pb.SetFormField("username", "user1")
'dim m As map = BANano.Await(pb.CREATE_FORM)
'dim id as String = m.get("id")
'dim url as String = m.get("fileurl")
'</code>
Private Sub ExecuteRawInsertForm As ResumableSub
	Dim rid As String
	If formFields.ContainsKey("id") Then
		rid = CStr(formFields.Get("id"))
		formFields.Remove("id")
	Else
		rid = NextID
	End If
	Dim rf As List
	rf.Initialize
	For Each k As String In Schema.Keys
		rf.Add(k)
	Next
	rf.Add("id")
	rf.Add("created")
	rf.Add("updated")
	formFields.Put("returnFields", Join(",", rf))
	Dim shimURL As String = $"${baseURL}/api/rawinsertform/${sTableName}/${rid}"$
	Wait For (ApiPostMultipart(shimURL, formFields, formFiles)) Complete (res As Map)
	Dim innerRec As Object = res.Get("record")
	If innerRec Is Map Then
		Record = innerRec
	Else
		Record = CreateMap()
	End If
End Sub

'Private Sub ExecuteRawUpdateForm(sID As String) As ResumableSub
'	Dim rf As List
'	rf.Initialize
'	For Each k As String In Schema.Keys
'		rf.Add(k)
'	Next
'	rf.Add("id")
'	rf.Add("updated")
'	formFields.Put("fields", Join(",", rf))
'	Dim shimURL As String = $"${baseURL}/api/rawupdateform/${sTableName}/${sID}"$
'	Wait For (ApiPatchMultipart(shimURL, formFields, formFiles)) Complete (res As Map)
'	Dim innerRec As Object = res.Get("record")
'	If innerRec Is Map Then
'		Record = innerRec
'	Else
'		Record = CreateMap()
'	End If
'End Sub

Sub CREATE_FORM As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.CREATE_FORM"$)
	End If
	If Schema.Size = 0 Then
		If B4XDaisyApp.DebugLogs Then Log($"B4XDaisyPocketBase.CREATE: ${sTableName} - please execute SchemaAdd first to define your table schema!"$)
		Return Null
	End If
	For Each fld As String In Schema.keys
		Dim fldType As String = Schema.Get(fld)
		If fldType = DB_FILE Then
			FILE_FIELD(fld, $"${fld}url"$)
		End If
	Next
	Try
		If UseRawInsertForm Then
			Wait For (ExecuteRawInsertForm) Complete (j As Map)
		Else
			Wait For (ApiPostMultipart(RecordsURL, formFields, formFiles)) Complete (res As Map)
			Record = res
		End If
		If Record.ContainsKey(PrimaryKey) Then
			If fileFields.Size > 0 Then
				For Each fk As String In fileFields.keys
					Dim fv As String = fileFields.Get(fk)
					Dim fk1 As String = Record.Get(fk)
					Dim pk1 As String = Record.Get(PrimaryKey)
					fk1 = CStr(fk1).trim
					If fk1 <> "" Then
						Dim fk2 As String = $"${baseURL}/api/files/${sTableName}/${pk1}/${fk1}"$
						Record.Put(fv, fk2)
						If GetFiles Then
							Wait For (GetFileAsDataURL(fk2)) Complete (fdata As String)
							Dim bisBase64Image As Boolean = isBase64Image(fdata)
							If bisBase64Image Then
								Record.Put(fk, fdata)
							Else
								Record.Put(fk, "")
							End If
						End If
					End If
				Next
			End If
			Return Record
		Else
			Record = CreateMap()
			Return Record
		End If
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"CREATE_FORM: ${LastException.message}"$)
		Record = CreateMap()
		Return Record
	End Try
End Sub

'record is saved as json string
'returns the record id
'<code>
'pb.PrepareForm
'pb.SetFormFile("avatar", fileObj)
'pb.SetFormField("username", "user1")
'BANano.Await(pb.UPDATE_FORM)
'</code>
'Sub UPDATE_FORM(sID As String) As ResumableSub
'	If ShowLog Then
'		Log($"B4XDaisyPocketBase.${sTableName}.UPDATE_FORM"$)
'	End If
'	If Schema.Size = 0 Then
'		Log($"B4XDaisyPocketBase.UPDATE: ${sTableName} - please execute SchemaAdd first to define your table schema!"$)
'		Return Null
'	End If
'	For Each fld As String In Schema.keys
'		Dim fldType As String = Schema.Get(fld)
'		If fldType = DB_FILE Then
'			FILE_FIELD(fld, $"${fld}url"$)
'		End If
'	Next
'	Try
'		If UseRawUpdateForm Then
'			Wait For (ExecuteRawUpdateForm(sID)) Complete (j As Map)
'		Else
'			Wait For (ApiPatchMultipart(RecordURL(sID), formFields, formFiles)) Complete (res As Map)
'			Record = res
'		End If
'		If Record.ContainsKey(PrimaryKey) Then
'			If fileFields.Size > 0 Then
'				For Each fk As String In fileFields.keys
'					Dim fv As String = fileFields.Get(fk)
'					Dim fk1 As String = Record.Get(fk)
'					Dim pk1 As String = Record.Get(PrimaryKey)
'					fk1 = CStr(fk1).trim
'					If fk1 <> "" Then
'						Dim fk2 As String = $"${baseURL}/api/files/${sTableName}/${pk1}/${fk1}"$
'						Record.Put(fv, fk2)
'						If GetFiles Then
'							Wait For (GetFileAsDataURL(fk2)) Complete (fdata As String)
'							Dim bisBase64Image As Boolean = isBase64Image(fdata)
'							If bisBase64Image Then
'								Record.Put(fk, fdata)
'							Else
'								Record.Put(fk, "")
'							End If
'						End If
'					End If
'				Next
'			End If
'			Return Record
'		Else
'			Record = CreateMap()
'			Return Record
'		End If
'	Catch
'		Log($"UPDATE_FORM: ${LastException.message}"$)
'		Record = CreateMap()
'		Return Record
'	End Try
'End Sub

'ceate a ecod using fomdata
'<code>
'pb.PrepareForm
'pb.SetFormFile("fileobj", fileObj)
'pb.SetFormField("username", "user1")
'dim m As map = BANano.Await(pb.CREATE_FORMDATA("fileobj"))
'dim id as String = m.get("id")
'dim url as String = m.get("fileurl")
'</code>
Sub CREATE_FORMDATA(sFileField As String) As ResumableSub
	Dim nfieldName As String = $"${sFileField}url"$
	fileFields.Put(sFileField, nfieldName)
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.CREATE_FORMDATA"$)
	End If
	If Schema.Size = 0 Then
		If B4XDaisyApp.DebugLogs Then Log($"B4XDaisyPocketBase.CREATE_FORMDATA: ${sTableName} - please execute SchemaAdd first to define your table schema!"$)
		Return Null
	End If
	For Each fld As String In Schema.keys
		Dim fldType As String = Schema.Get(fld)
		If fldType = DB_FILE Then
			FILE_FIELD(fld, $"${fld}url"$)
		End If
	Next
	Try
		If UseRawInsertForm Then
			Wait For (ExecuteRawInsertForm) Complete (j As Map)
		Else
			Wait For (ApiPostMultipart(RecordsURL, formFields, formFiles)) Complete (res As Map)
			Record = res
		End If
		If Record.ContainsKey("id") Then
			If fileFields.Size > 0 Then
				For Each fk As String In fileFields.keys
					Dim fv As String = fileFields.Get(fk)
					Dim fk1 As String = Record.Get(fk)
					Dim pk1 As String = Record.Get(PrimaryKey)
					fk1 = CStr(fk1).trim
					If fk1 <> "" Then
						Dim fk2 As String = $"${baseURL}/api/files/${sTableName}/${pk1}/${fk1}"$
						Record.Put(fv, fk2)
						If GetFiles Then
							Wait For (GetFileAsDataURL(fk2)) Complete (fdata As String)
							Dim bisBase64Image As Boolean = isBase64Image(fdata)
							If bisBase64Image Then
								Record.Put(fk, fdata)
							Else
								Record.Put(fk, "")
							End If
						End If
					End If
				Next
			End If
			Return Record
		Else
			Record = CreateMap()
			Return Record
		End If
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"CREATE_FORMDATA: ${LastException.message}"$)
		Record = CreateMap()
		Return Record
	End Try
End Sub

'<code>
'DEPRECATED - use FILE_FIELD(?, ?)
'create a new field to have a complete url path of the files
'the first field is the actual field name
'BANano.Await(pb.EstablishFileUrl("fileobj", "fileurl"))
'</code>
Sub EstablishFileUrl(sFileField As String, sUrlField As String)
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.EstablishFileUrl(${sFileField},${sUrlField})"$)
	End If
	Try
		Dim rTot As Int = result.Size - 1
		Dim rCnt As Int
		For rCnt = 0 To rTot
			Dim r As Map = result.Get(rCnt)
			Dim firstFilename As String = r.Get(sFileField)
			Dim pk1 As String = r.Get(PrimaryKey)
			firstFilename = CStr(firstFilename).trim
			If firstFilename <> "" Then
				Dim url As String = $"${baseURL}/api/files/${sTableName}/${pk1}/${firstFilename}"$
				r.Put(sUrlField, url)
				result.Set(rCnt, r)
			End If
		Next
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"EstablishFileUrl: ${LastException.message}"$)
	End Try
End Sub

'select existings fields to create a view
'<code>
'Do While pbComponents.NextRow
'Dim rec As Map = pbComponents.Record
'Dim sid As String = pbComponents.GetString("id")
'Loop
'</code>
Sub SELECT_VIEW(sViewName As String) As ResumableSub
	Try
		sTableName = sViewName
		Dim cfileFields As Map = MapDeepClone(fileFields)
		Reset
		CLEAR_WHERE
		skipTotal = False
		fileFields = MapDeepClone(cfileFields)
		Wait For (SELECT_ALL) Complete (res As List)
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"SELECT_VIEW: ${LastException.message}"$)
	End Try
End Sub

'return the value of the first "records" field
Sub GetRecordsCount As Int
	If RowCount > 0 Then
		MoveFirst
		Dim irecords As Int = GetInt("records")
		Return irecords
	Else
		Return 0
	End If
End Sub

'<code>
'create a new field to have a complete url path of the files
'the first field is the actual field name
'BANano.Await(pb.EstablishFileUrl1(rec, "fileobj", "fileurl"))
'</code>
Sub EstablishFileUrl1(mRec As Map, sFileField As String, sUrlField As String)
	Dim firstFilename As String = mRec.Get(sFileField)
	Dim opt As Map = CreateMap()
	opt.Put("cache", "no-store")
	If headers.Size <> 0 Then
		opt.Put("headers", headers)
	End If
	'Dim url As String = client.GetField("files").RunMethod("getUrl", Array(rec, firstFilename,opt)).result
	'rec.Put(urlField, url)
End Sub

Sub GetDocumentURL(sFileField As String) As String
	Dim firstFilename As String = Record.Get(sFileField)
	Dim opt As Map = CreateMap()
	opt.Put("cache", "no-store")
	If headers.Size <> 0 Then
		opt.Put("headers", headers)
	End If
	'Dim url As String = client.GetField("files").RunMethod("getUrl", Array(Record, firstFilename,opt)).result
	'Return url
End Sub

'<code>
'create a new field to have a complete url path of the files
'the first field is the actual field name
'BANano.Await(pb.GetFileURLTo(rec, "fileobj", "fileurl"))
'</code>
Sub getFileURLTo(mRec As Map, sFileField As String, sUrlField As String)
	Dim firstFilename As String = mRec.Get(sFileField)
	Dim opt As Map = CreateMap()
	opt.Put("cache", "no-store")
	If headers.Size <> 0 Then
		opt.Put("headers", headers)
	End If
	'Dim url As String = client.GetField("files").RunMethod("getUrl", Array(rec, firstFilename,opt)).result
	'rec.Put(urlField, url)
End Sub

'record is saved as json string
'returns the record id
'<code>
'pb.PrepareForm
'pb.SetFormFile("avatar", fileObj)
'pb.SetFormField("username", "user1")
'BANano.Await(pb.UPDATE_FORMDATA("10"))
'</code>
'Sub UPDATE_FORMDATA(sID As String) As ResumableSub
'	If ShowLog Then
'		Log($"B4XDaisyPocketBase.${sTableName}.UPDATE_FORMDATA"$)
'	End If
'	If Schema.Size = 0 Then
'		Log($"B4XDaisyPocketBase.UPDATE: ${sTableName} - please execute SchemaAdd first to define your table schema!"$)
'		Return ""
'	End If
'	For Each fld As String In Schema.keys
'		Dim fldType As String = Schema.Get(fld)
'		If fldType = DB_FILE Then
'			FILE_FIELD(fld, $"${fld}url"$)
'		End If
'	Next
'	Try
'		If UseRawUpdateForm Then
'			Wait For (ExecuteRawUpdateForm(sID)) Complete (j As Map)
'		Else
'			Wait For (ApiPatchMultipart(RecordURL(sID), formFields, formFiles)) Complete (res As Map)
'			Record = res
'		End If
'		If Record.ContainsKey(PrimaryKey) Then
'			If fileFields.Size > 0 Then
'				For Each fk As String In fileFields.keys
'					Dim fv As String = fileFields.Get(fk)
'					Dim fk1 As String = Record.Get(fk)
'					Dim pk1 As String = Record.Get(PrimaryKey)
'					fk1 = CStr(fk1).trim
'					If fk1 <> "" Then
'						Dim fk2 As String = $"${baseURL}/api/files/${sTableName}/${pk1}/${fk1}"$
'						Record.Put(fv, fk2)
'						If GetFiles Then
'							Wait For (GetFileAsDataURL(fk2)) Complete (fdata As String)
'							Dim bisBase64Image As Boolean = isBase64Image(fdata)
'							If bisBase64Image Then
'								Record.Put(fk, fdata)
'							Else
'								Record.Put(fk, "")
'							End If
'						End If
'					End If
'				Next
'			End If
'			Dim k As String = Record.Get("id")
'			Return k
'		Else
'			Record = CreateMap()
'			Return ""
'		End If
'	Catch
'		Log($"UPDATE_FORMDATA: ${LastException.message}"$)
'		Record = CreateMap()
'		Return ""
'	End Try
'End Sub

'get an id of a record using a unique field
Sub GET_ID_BY_FIELD(sFldName As String, sFldValue As String) As ResumableSub
	Wait For (GET_ID_BY_FIELD_FETCH(sFldName, sFldValue)) Complete (res As String)
	Return res
End Sub
Sub GET_ID_BY_FIELD_FETCH(sFldName As String, sFldValue As String) As ResumableSub
	CLEAR_WHERE
	ADD_FIELD("id")
	ADD_WHERE_STRING(sFldName, "=", sFldValue)
	Wait For (GetFirstListItemFetch(sTableName)) Complete (m As Map)
	Dim sid As String = m.GetDefault("id", "")
	Return sid
End Sub

'backward compatible with lowcode generator
Sub READ_ID_BY_FETCH(sFldName As String, sFldValue As String) As ResumableSub
	CLEAR_WHERE
	ADD_FIELD("id")
	ADD_WHERE_STRING(sFldName, "=", sFldValue)
	Wait For (GetFirstListItemFetch(sTableName)) Complete (m As Map)
	Dim sid As String = m.GetDefault("id", "")
	Return sid
End Sub
Sub UPDATE_BY_STRING(sFldName As String, sFldValue As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.UPDATE_BY_STRING(${sFldName},${sFldValue})"$)
	End If
	Wait For (READ_ID_BY_STRING(sFldName, sFldValue)) Complete (sid As String)
	If sid = "" Then Return ""
	Record.Put("id", sid)
	Wait For (UPDATE) Complete (nid As String)
	Return nid
End Sub
Sub UPDATE_BY(sFldName As String, sFldValue As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.UPDATE_BY(${sFldName},${sFldValue})"$)
	End If
	Wait For (READ_ID_BY_STRING(sFldName, sFldValue)) Complete (sid As String)
	If sid = "" Then Return ""
	Record.Put("id", sid)
	Wait For (UPDATE) Complete (nid As String)
	Return nid
End Sub

''record is saved as json string
''returns the record id
''<code>
''pb.PrepareRecord
''pb.SetField("id", 1)
''pb.SetField("username", "user1")
''BANano.Await(pb.UPDATE)
''</code>
'Sub UPDATE As ResumableSub
'	If ShowLog Then
'		Log($"B4XDaisyPocketBase.${sTableName}.UPDATE"$)
'	End If
'	If Schema.Size = 0 Then
'		Log($"B4XDaisyPocketBase.UPDATE: ${sTableName} - please execute SchemaAdd first to define your table schema!"$)
'		Return ""
'	End If
'	Try
'		Dim qflds As String = Join(",", flds)
'		Dim qexpand As String = Join(",", expand)
'
'		Dim qs As Map = CreateMap()
'		If qflds <> "" Then qs.Put("fields", qflds)
'		If qexpand <> "" Then qs.Put("expand", qexpand)
'		Dim id As String = Record.Get("id")
'		Dim url As String = RecordURL(id)
'		If qs.Size > 0 Then url = $"${url}?${Map2QueryString(qs)}"$
'		If ShowLog Then
'			Log($"B4XDaisyPocketBase.${sTableName}.UPDATE(${url})"$)
'		End If
'
'		Wait For (ApiPatch(url, Record)) Complete (res As Map)
'		Record = res
'		If res.ContainsKey("id") Then
'			Dim k As String = res.Get("id")
'			Return k
'		End If
'		Return ""
'	Catch
'		Log($"UPDATE: ${LastException.message}"$)
'		Return ""
'	End Try
'End Sub

Sub UPDATE_PER_FIELD As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.UPDATE_PER_FIELD"$)
	End If
	If Schema.Size = 0 Then
		If B4XDaisyApp.DebugLogs Then Log($"B4XDaisyPocketBase.UPDATE_PER_FIELD: ${sTableName} - please execute SchemaAdd first to define your table schema!"$)
		Return ""
	End If
	Dim msize As Int = 0
	Dim usize As Int = 0
	Dim currentRecord As Map = Record
	Dim currentID As String = currentRecord.Get("id")
	For Each k As String In currentRecord.Keys
		If k = "id" Then Continue
		msize = msize + 1
		'create a record with id and field to update
		Dim v As Object = currentRecord.Get(k)
		Dim nrec As Map = CreateMap()
		nrec.Put("id", currentID)
		nrec.Put(k, v)
		flds.Initialize
		flds.Add("id")
		expand.Initialize
		'
		Try
			Dim qflds As String = Join(",", flds)
			Dim qexpand As String = Join(",", expand)

			Dim qs As Map = CreateMap()
			If qflds <> "" Then qs.Put("fields", qflds)
			If qexpand <> "" Then qs.Put("expand", qexpand)
			Dim id As String = nrec.Get("id")
			Dim url As String = RecordURL(id)
			If qs.Size > 0 Then url = $"${url}?${Map2QueryString(qs)}"$
			If ShowLog Then
				Log($"B4XDaisyPocketBase.${sTableName}.UPDATE_PER_FIELD(${url})"$)
			End If

			Wait For (ApiPatch(url, nrec)) Complete (r As Map)
			If r.ContainsKey("id") Then
				Dim kk As String = r.Get("id")
				If kk = currentID Then
					usize = usize + 1
				End If
			End If
		Catch
			If B4XDaisyApp.DebugLogs Then Log($"UPDATE_PER_FIELD: ${LastException.message}"$)
		End Try
	Next
	If usize = msize Then
		Return currentID
	Else
		Return ""
	End If
End Sub


'get a value using key
'<code>
'Dim res As Map = BANano.Await(pb.READ("name"))
'</code>
Sub READ(sId As String) As ResumableSub
	Wait For (READ_FETCH(sId)) Complete (res As Map)
	Return res
End Sub

'<code>
'read a record by a unique field and return listed fields
'Dim result As Map = BANano.Await(pbComponents.READ_FIELDS("xxx", array("id", "name")))
'</code>
Sub READ_FIELDS(sId As String, lstFields As List) As ResumableSub
	Wait For (READ_FIELDS_FETCH(sId, lstFields)) Complete (res As Map)
	Return res
End Sub


'get a value using key
'<code>
'Dim res As Map = BANano.Await(pb.READ_USER("name"))
'</code>
Sub READ_USER(sId As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.READ_USER(${sId})"$)
	End If
	If Schema.Size = 0 Then
		If B4XDaisyApp.DebugLogs Then Log($"B4XDaisyPocketBase.READ_USER: ${sTableName} - please execute SchemaAdd first to define your table schema!"$)
		Return Null
	End If
	For Each fld As String In Schema.keys
		Dim fldType As String = Schema.Get(fld)
		If fldType = DB_FILE Then
			FILE_FIELD(fld, $"${fld}url"$)
		End If
	Next
	Try
		Dim qflds As String = Join(",", flds)
		Dim qexpand As String = Join(",", expand)

		Dim qs As Map = CreateMap()
		If qflds <> "" Then qs.Put("fields", qflds)
		If qexpand <> "" Then qs.Put("expand", qexpand)
		Dim url As String = $"${baseURL}/api/collections/${UsersCollectionName}/records/${sId}"$
		If qs.Size > 0 Then url = $"${url}?${Map2QueryString(qs)}"$
		If ShowLog Then
			Log($"B4XDaisyPocketBase.${sTableName}.READ_USER(${url})"$)
		End If
		Wait For (ApiGet(url)) Complete (res As Map)
		Record = res
		If fileFields.Size > 0 Then
			For Each fk As String In fileFields.keys
				Dim fv As String = fileFields.Get(fk)
				Dim fk1 As String = Record.Get(fk)
				Dim pk1 As String = Record.Get(PrimaryKey)
				fk1 = CStr(fk1).trim
				If fk1 <> "" Then
					Dim fk2 As String = $"${baseURL}/api/files/${UsersCollectionName}/${pk1}/${fk1}"$
					Record.Put(fv, fk2)
				End If
			Next
		End If
		Return Record
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"READ_USER: ${LastException.message}"$)
		Record = CreateMap()
		Return Record
	End Try
End Sub

'get a value using key
'<code>
'Dim res As Map = BANano.Await(pb.READ_ADMIN("name"))
'</code>
Sub READ_ADMIN(sId As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.READ_ADMIN(${sId})"$)
	End If
	If Schema.Size = 0 Then
		If B4XDaisyApp.DebugLogs Then Log($"B4XDaisyPocketBase.READ_ADMIN: ${sTableName} - please execute SchemaAdd first to define your table schema!"$)
		Return Null
	End If
	For Each fld As String In Schema.keys
		Dim fldType As String = Schema.Get(fld)
		If fldType = DB_FILE Then
			FILE_FIELD(fld, $"${fld}url"$)
		End If
	Next
	Dim m As Map = CreateMap()
	Try
		Dim qflds As String = Join(",", flds)
		Dim qexpand As String = Join(",", expand)

		Dim qs As Map = CreateMap()
		If qflds <> "" Then qs.Put("fields", qflds)
		If qexpand <> "" Then qs.Put("expand", qexpand)
		Dim xtablename As String
		Dim url As String
		If Upgrade Then
			xtablename = "_superusers"
			url = $"${baseURL}/api/collections/_superusers/records/${sId}"$
		Else
			xtablename = "admins"
			url = $"${baseURL}/api/admins/${sId}"$
		End If
		If qs.Size > 0 Then url = $"${url}?${Map2QueryString(qs)}"$
		Wait For (ApiGet(url)) Complete (res As Map)
		m = res
		Record = m
		If fileFields.Size > 0 Then
			For Each fk As String In fileFields.keys
				Dim fv As String = fileFields.Get(fk)
				Dim fk1 As String = Record.Get(fk)
				Dim pk1 As String = Record.Get(PrimaryKey)
				fk1 = CStr(fk1).trim
				If fk1 <> "" Then
					Dim fk2 As String = $"${baseURL}/api/files/${xtablename}/${pk1}/${fk1}"$
					Record.Put(fv, fk2)
					m.Put(fv, fk2)
				End If
			Next
		End If
		Return m
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"READ_ADMIN: ${LastException.message}"$)
		Record = m
		Return m
	End Try
End Sub

'get a value using key
'<code>
'Dim res As Map = BANano.Await(pb.READ_COLLECTION("name"))
'</code>
Sub READ_COLLECTION(sId As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.READ_COLLECTION(${sId})"$)
	End If
	Dim m As Map = CreateMap()
	Try
		SetAuthorizationBearerToken(UserToken)
		Dim opt As Map = CreateMap()
		opt.Put("cache", "no-store")
		If headers.Size <> 0 Then
			opt.Put("headers", headers)
		End If
		Wait For (ApiGet($"/api/collections/${sId}"$)) Complete (res As Map)
		m = res
		Record = m
		Return m
	Catch
		Record = m
		Return m
	End Try
End Sub

'<code>
'read a record using a unique field
'pbComponents.FILE_FIELD("fileobj", "fileurl")
'Dim result As Map = BANano.Await(pbComponents.READ_BY_STRING("name", "xxx"))
'</code>
Sub READ_BY_STRING(sFldName As String, sFldValue As String) As ResumableSub
	Wait For (READ_BY_STRING_FETCH(sFldName, sFldValue)) Complete (res As Map)
	Return res
End Sub
Sub READ_ID_WHERE(mWhereIs As Map) As ResumableSub
	If Schema.Size = 0 Then
		If B4XDaisyApp.DebugLogs Then Log($"B4XDaisyPocketBase.READ_ID_WHERE: '${sTableName}' schema is not set!"$)
	End If
	CLEAR_WHERE
	For Each k As String In mWhereIs.keys
		Dim v As String = mWhereIs.Get(k)
		ADD_WHERE_STRING(k, "=", v)
	Next
	ADD_FIELD("id")
	Wait For (SELECT_WHERE_FETCH) Complete (res As List)
	If res.size = 0 Then
		Return ""
	Else
		Dim rec As Map = res.Get(0)
		Dim sid As String = rec.GetDefault("id", "")
		Return sid
	End If
End Sub


'<code>
'Dim result As Map = BANano.Await(pbComponents.READ_BY_STRING_FETCH("name", "xxx"))
'</code>
Sub READ_BY_STRING_FETCH(sFldName As String, oFldValue As Object) As ResumableSub
	CLEAR_WHERE
	ADD_WHERE_STRING(sFldName, "=", oFldValue)
	Wait For (GetFirstListItemFetch(sTableName)) Complete (m As Map)
	Return m
End Sub

'<code>
'read a record using a unique field and return listed fields
'pbComponents.FILE_FIELD("fileobj", "fileurl")
'Dim result As Map = BANano.Await(pbComponents.READ_BY_STRING_FIELDS("name", "xxx", array("id", "name"))))
'</code>
Sub READ_BY_STRING_FIELDS(sFldName As String, sFldValue As String, lstFields As List) As ResumableSub
	Wait For (READ_BY_STRING_FIELDS_FETCH(sFldName, sFldValue, lstFields)) Complete (res As Map)
	Return res
End Sub

'<code>
''use fetch to read specified fields from a collection
'Dim result As Map = BANano.Await(pbComponents.READ_BY_STRING_FIELDS_FETCH("name", "xxx", array("id", "name"))))
'</code>
Sub READ_BY_STRING_FIELDS_FETCH(sFldName As String, oFldValue As Object, lstTheseFlds As List) As ResumableSub
	CLEAR_WHERE
	ADD_FIELDS(lstTheseFlds)
	ADD_WHERE_STRING(sFldName, "=", oFldValue)
	Wait For (GetFirstListItemFetch(sTableName)) Complete (m As Map)
	Return m
End Sub

'get a value using key
'<code>
'Dim res As Map = BANano.Await(pb.READ_FETCH("name"))
'</code>
Sub READ_FETCH(sId As String) As ResumableSub
	whereEqual("id", sId)
	Wait For (GetFirstListItemFetch(sTableName)) Complete (mRecord As Map)
	Return mRecord
End Sub

'<code>
''use fetch to read specified fields from a collection
'Dim result As Map = BANano.Await(pbComponents.READ_FIELDS_FETCH("id", array("id", "name"))))
'</code>
Sub READ_FIELDS_FETCH(oFldValue As Object, lstTheseFlds As List) As ResumableSub
	CLEAR_WHERE
	ADD_FIELDS(lstTheseFlds)
	whereEqual("id", oFldValue)
	Wait For (GetFirstListItemFetch(sTableName)) Complete (mRecord As Map)
	Return mRecord
End Sub


'<code>
'read a record using a unique field and return listed fields
'pbComponents.FILE_FIELD("fileobj", "fileurl")
'Dim result As Map = BANano.Await(pbComponents.READ_BY_STRING_FIELDS1("name", "xxx")))
'</code>
Sub READ_BY_STRING_FIELDS1(sFldName As String, oFldValue As Object) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.READ_BY_STRING(${sFldName},${oFldValue})"$)
	End If
	Dim cf As List = MapDeepClone(flds)
	CLEAR_WHERE
	ADD_FIELDS(cf)
	ADD_WHERE_STRING(sFldName, "=", oFldValue)
	For Each fld As String In Schema.keys
		Dim fldType As String = Schema.Get(fld)
		If fldType = DB_FILE Then
			FILE_FIELD(fld, $"${fld}url"$)
		End If
	Next
	Wait For (GetFirstListItem(sTableName)) Complete (m As Map)
	Return m
End Sub

'return an id of a record by reading a unique string field
'backward compatibility with low code generator
Sub READ_ID_BY(sFldName As String, oFldValue As Object) As ResumableSub
	Wait For (READ_ID_BY_FETCH(sFldName, oFldValue)) Complete (res As String)
	Return res
End Sub

'return an id of a record by reading a unique string field
Sub READ_ID_BY_STRING(sFldName As String, sFldValue As String) As ResumableSub
	Wait For (READ_ID_BY_STRING_FETCH(sFldName, sFldValue)) Complete (res As String)
	Return res
End Sub

'return an id of a record by reading a unique string field
Sub READ_ID_BY_STRING_FETCH(sFldName As String, sFldValue As String) As ResumableSub
	CLEAR_WHERE
	ADD_FIELD("id")
	ADD_WHERE_STRING(sFldName, "=", sFldValue)
	Wait For (GetFirstListItemFetch(sTableName)) Complete (m As Map)
	Dim sid As String = m.GetDefault("id", "")
	Return sid
End Sub

'<code>
'read a record by a unique field
'pbComponents.FILE_FIELD("fileobj", "fileurl")
'Dim result As Map = BANano.Await(pbComponents.READ_BY("name", "xxx"))
'</code>
Sub READ_BY(sFldName As String, oFldValue As Object) As ResumableSub
	Wait For (READ_BY_FETCH(sFldName, oFldValue)) Complete (res As Map)
	Return res
End Sub

'<code>
'read a record by a unique field
'Dim result As Map = BANano.Await(pbComponents.READ_BY_FETCH("name", "xxx"))
'</code>
Sub READ_BY_FETCH(sFldName As String, oFldValue As Object) As ResumableSub
	CLEAR_WHERE
	ADD_WHERE(sFldName, "=", oFldValue)
	Wait For (GetFirstListItemFetch(sTableName)) Complete (m As Map)
	Return m
End Sub

'<code>
'read a record by a unique field and return listed fields
'pbComponents.FILE_FIELD("fileobj", "fileurl")
'Dim result As Map = BANano.Await(pbComponents.READ_BY_FIELDS("name", "xxx", array("id", "name")))
'</code>
Sub READ_BY_FIELDS(sFldName As String, oFldValue As Object, lstFields As List) As ResumableSub
	Wait For (READ_BY_FIELDS_FETCH(sFldName, oFldValue, lstFields)) Complete (res As Map)
	Return res
End Sub

'<code>
'Dim result As Map = BANano.Await(pbComponents.READ_BY_FIELDS_FETCH("name", "xxx", array("id", "name")))
'</code>
Sub READ_BY_FIELDS_FETCH(sFldName As String, oFldValue As Object, lstTheseFlds As List) As ResumableSub
	CLEAR_WHERE
	ADD_FIELDS(lstTheseFlds)
	ADD_WHERE(sFldName, "=", oFldValue)
	Wait For (GetFirstListItemFetch(sTableName)) Complete (m As Map)
	Return m
End Sub


'Tests whether a key is available in the store.
'<code>
'Dim res as boolean = BANano.Await(pb.ContainsKey("a"))
'</code>
Sub ContainsKey(sId As String) As ResumableSub
	Wait For (ContainsKeyFetch(sId)) Complete (res As Boolean)
	Return res
End Sub

'Tests whether a key is available in the store.
'<code>
'Dim res as boolean = BANano.Await(pb.ContainsKeyFetch("a"))
'</code>
Sub ContainsKeyFetch(sId As String) As ResumableSub
	If Schema.Size = 0 Then
		If B4XDaisyApp.DebugLogs Then Log($"B4XDaisyPocketBase.ContainsKeyFetch: ${sTableName} - please execute SchemaAdd first to define your table schema!"$)
		Return False
	End If
	CLEAR_WHERE
	ADD_FIELD("id")
	ADD_WHERE("id", "=", $"'${sId}'"$)
	Wait For (GetFirstListItemFetch(sTableName)) Complete (m As Map)
	If m.Size = 0 Then
		Return False
	Else
		Return True
	End If
End Sub
Sub ContainsField(sFldName As String, oFldValue As Object) As ResumableSub
	Wait For (ContainsFieldFetch(sFldName, oFldValue)) Complete (res As Boolean)
	Return res
End Sub
Sub ContainsFieldFetch(sFldName As String, sId As String) As ResumableSub
	If Schema.Size = 0 Then
		If B4XDaisyApp.DebugLogs Then Log($"B4XDaisyPocketBase.ContainsFieldFetch: ${sTableName} - please execute SchemaAdd first to define your table schema!"$)
		Return False
	End If
	CLEAR_WHERE
	ADD_FIELD(sFldName)
	ADD_WHERE(sFldName, "=", $"'${sId}'"$)
	Wait For (GetFirstListItemFetch(sTableName)) Complete (m As Map)
	If m.Size = 0 Then
		Return False
	Else
		Return True
	End If
End Sub


'Returns a list with all the keys.
'<code>
'Dim res As List = BANano.Await(pb.ListKeys)
'</code>
Public Sub ListKeys As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.ListKeys"$)
	End If
	If Schema.Size = 0 Then
		If B4XDaisyApp.DebugLogs Then Log($"B4XDaisyPocketBase.ListKeys: ${sTableName} - please execute SchemaAdd first to define your table schema!"$)
		Return Null
	End If
	CLEAR_WHERE
	ADD_FIELD("id")
	Wait For (SELECT_WHERE) Complete (lst As List)
	result = lst
	Dim res As List
	res.Initialize
	For Each rec As Map In result
		Dim k As String = rec.GetDefault("id", "")
		k = CStr(k)
		res.Add(k)
	Next
	Return res
End Sub

Sub DELETE_ALL As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.DELETE_ALL"$)
	End If
	Try
		Wait For (ListKeys) Complete (keys As List)
		If keys.IsInitialized = False Or keys.Size = 0 Then Return
		For Each k As String In keys
			Wait For (ApiDelete(RecordURL(k))) Complete (ok As Boolean)
		Next
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"DELETE_ALL: ${LastException.message}"$)
	End Try
End Sub

'get keyvalues for combos etc
'<code>
'Dim mExpenseCategories As Map = banano.Await(pbExpenseCategories.GetKeyValues(True, "id", "name"))
'</code>
Sub GetKeyValues(bHasNothing As Boolean, sK As String, sV As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.GetKeyValues(${bHasNothing},${sK},${sV})"$)
	End If

	Dim mx As Map = CreateMap()
	If bHasNothing Then
		mx.Put("", "-- Nothing Selected --")
	End If
	CLEAR_WHERE
	ADD_FIELD(sK)
	ADD_FIELD(sV)
	ADD_ORDER_BY(sV)
	Wait For (SELECT_WHERE) Complete (lst As List)
	result = lst
	For Each row As Map In result
		Dim f1 As String = row.get(sK)
		Dim f2 As String = row.get(sV)
		mx.Put(f1, f2)
	Next
	Return mx
End Sub

'get keyvalues for combos etc
'<code>
'Dim mExpenseCategories As Map = banano.Await(pbExpenseCategories.GetKeyValuesFromList(lst, True, "id", "name"))
'</code>
Sub GetKeyValuesFromList(lstSource As List, bHasNothing As Boolean, sK As String, sV As String) As Map
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.GetKeyValuesFromList()"$)
	End If
	Dim mx As Map = CreateMap()
	If bHasNothing Then
		mx.Put("", "-- Nothing Selected --")
	End If
	For Each row As Map In lstSource
		Dim f1 As String = row.get(sK)
		Dim f2 As String = row.get(sV)
		mx.Put(f1, f2)
	Next
	Return mx
End Sub


'Removes the key and value mapped to this key.
'<code>
'Dim b As Boolean = BANano.Await(pb.DELETE("a"))
'</code>
Sub DELETE(sId As String) As ResumableSub
	Wait For (DELETE_FETCH(sId)) Complete (res As Boolean)
	Return res
End Sub

'Removes the key and value mapped to this key.
'<code>
'Dim b As Boolean = BANano.Await(pb.DELETE_MULTIPLE(array("a")))
'</code>
Sub DELETE_MULTIPLE(lstItems As List) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.DELETE_MULTIPLE()"$)
	End If
	If Schema.Size = 0 Then
		If B4XDaisyApp.DebugLogs Then Log($"B4XDaisyPocketBase.DELETE_MULTIPLE: ${sTableName} - please execute SchemaAdd first to define your table schema!"$)
		Return False
	End If
	Try
		For Each delID As String In lstItems
			Wait For (ApiDelete(RecordURL(delID))) Complete (ok As Boolean)
		Next
		Return True
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"DELETE_MULTIPLE: ${LastException.message}"$)
		Return False
	End Try
End Sub

'to delete the file set the fldValue = null
Sub SetField(sFldName As String, oFldValue As Object) As B4XDaisyPocketBase
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.SetField(${sFldName}, ${oFldValue})"$)
	End If
	If Schema.ContainsKey(sFldName) Then
		Dim dt As String = Schema.Get(sFldName)
		Select Case dt
			Case DB_BOOL
				oFldValue = CBool(oFldValue)
			Case DB_INT
				oFldValue = CInt(oFldValue)
			Case DB_STRING
				oFldValue = CStr(oFldValue)
			Case DB_REAL
				oFldValue = CDbl(oFldValue)
			Case DB_FLOAT
				oFldValue = CDbl(oFldValue)
			Case DB_INTEGER
				oFldValue = CInt(oFldValue)
			Case DB_TEXT, DB_LONGTEXT
				oFldValue = CStr(oFldValue)
			Case DB_DOUBLE
				oFldValue = CDbl(oFldValue)
		End Select
	End If
	Record.Put(sFldName, oFldValue)
	Return Me
End Sub


'double
private Sub CDbl(sO As String) As Double
	Dim s As String = Val(sO)
	If IsNumber(s) Then
		Dim d As Double = s
		Return d
	Else
		Return 0
	End If
End Sub

'convert to int
private Sub CInt(oO As Object) As Int
	Dim s As String = Val(oO)
	If IsNumber(s) Then
		Dim i As Int = s
		Return i
	Else
		Return 0
	End If
End Sub

'check if value isNaN
private Sub isNaN(oObj As Object) As Boolean
	If oObj = Null Then Return True
	Dim s As String = oObj
	Return IsNumber(s.Trim) = False
End Sub


private Sub Val(sValue As String) As String
	sValue = CStr(sValue)
	sValue = sValue.Trim
	If sValue = "" Then sValue = "0"
	Try
		Dim sout As String = ""
		Dim mout As String = ""
		Dim slen As Int = sValue.Length
		Dim i As Int = 0
		For i = 0 To slen - 1
			mout = sValue.CharAt(i)
			If InStr("0123456789.-", mout) <> -1 Then
				sout = sout & mout
			End If
		Next
		Return sout
	Catch
		Return sValue
	End Try
End Sub

private Sub InStr(sText As String, sFind As String) As Int
	Return sText.tolowercase.IndexOf(sFind.tolowercase)
End Sub

'parseBool
private Sub CBool(oV As Object) As Boolean
	If oV = Null Then Return False
	If GetType(oV) = "java.lang.Boolean" Or GetType(oV) = "boolean" Then
		Return oV
	End If
	Dim s As String = CStr(oV).toLowerCase.trim
	If s = "" Or s = "false" Or s = "0" Or s = "n" Or s = "no" Or s = "off" Then Return False
	If s = "true" Or s = "1" Or s = "y" Or s = "yes" Or s = "on" Then Return True
	Return False
End Sub

Sub RecordFromMap(mSm As Map)
	Record.Initialize
	For Each k As String In mSm.Keys
		Dim v As Object = mSm.Get(k)
		Record.Put(k, v)
	Next
End Sub

Sub FirstRecord As Map
	Dim rec As Map = result.Get(0)
	Return rec
End Sub

'clear where clause
Sub CLEAR_WHERE As B4XDaisyPocketBase
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.CLEAR_WHERE"$)
	End If
	whereField.Initialize
	ops.Initialize
	expand.Initialize
	orderByL.Initialize
	flds.Initialize
	combineL.Initialize
	skipTotal = True
	headers.Initialize
	fileFields.Initialize
	CountRecords = False
	grpBy.Initialize
	Return Me
End Sub

Sub ADD_GROUP_BY(lstGrpBys As List)
	grpBy.AddAll(lstGrpBys)
End Sub

Sub Reset As B4XDaisyPocketBase
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.Reset"$)
	End If
	whereField.Initialize
	ops.Initialize
	expand.Initialize
	orderByL.Initialize
	flds.Initialize
	combineL.Initialize
	RowCount = 0
	lastPosition = -1
	Record.Initialize
	result.Initialize
	Success = False
	Tag = Null
	Schema.Initialize
	DisplayField = ""
	Singular = ""
	Plural = ""
	DisplayValue = ""
	UserProfile.Initialize
	UserProfile.size = 0
	fileFields.Initialize
	IsAuthenticated = False
	CountRecords = False
	Upgrade = False
	SchemaAddText1("id")
	Return Me
End Sub

Sub ADD_FIELD(sFld As String) As B4XDaisyPocketBase
	flds.Add(sFld)
	Return Me
End Sub

Sub getFields As List
	Return flds
End Sub

Sub setFields(lstTflds As List)
	flds.Clear
	For Each k As String In lstTflds
		flds.Add(k)
	Next
End Sub

'add a file field and its url counterpart
Sub FILE_FIELD(sFld As String, sFldUrl As String) As B4XDaisyPocketBase
	fileFields.Put(sFld, sFldUrl)
	Return Me
End Sub

Sub ADD_FILE_FIELD(sFld As String, sFldURL As String) As B4XDaisyPocketBase
	FILE_FIELD(sFld, sFldURL)
	Return Me
End Sub

Sub ADD_FIELDS(lstFields As List) As B4XDaisyPocketBase
	For Each fld As String In lstFields
		ADD_FIELD(fld)
	Next
	Return Me
End Sub

Sub ADD_EXPAND(sSexpand As String) As B4XDaisyPocketBase
	sSexpand = sSexpand.trim
	If sSexpand <> "" Then
		expand.Add(sSexpand)
	End If
	Return Me
End Sub

'add a where clause for your select where
'for same fields, suffix them with .1, .2 etc
'LIKE
Sub ADD_WHERE(sFld As String, sOperator As String, oValue As Object) As B4XDaisyPocketBase
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.ADD_WHERE(${sFld},${sOperator},${oValue})"$)
	End If
	Select Case sOperator
		Case "<>"
			sOperator = "!="
		Case "like"
			sOperator = "~"
	End Select
	whereField.Put(sFld, oValue)
	ops.Add(sOperator)
	combineL.Add("&&")
	Return Me
End Sub

'add a where clause for your select where
'for same fields, suffix them with .1, .2 etc
Sub ADD_WHERE_STRING(sFld As String, sOperator As String, oValue As Object) As B4XDaisyPocketBase
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.ADD_WHERE_STRING(${sFld},${sOperator},${oValue})"$)
	End If
	ADD_WHERE(sFld, sOperator, $"'${oValue}'"$)
	Return Me
End Sub

Sub ADD_OR_WHERE_STRING(sFld As String, sOperator As String, oValue As Object) As B4XDaisyPocketBase
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.ADD_OR_WHERE_STRING(${sFld},${sOperator},${oValue})"$)
	End If
	Dim combineLen As Int = combineL.Size - 1
	WHERE_OR(combineLen)
	ADD_WHERE(sFld, sOperator, $"'${oValue}'"$)
	Return Me
End Sub

Sub ADD_OR_WHERE(sFld As String, sOperator As String, oValue As Object) As B4XDaisyPocketBase
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.ADD_OR_WHERE(${sFld},${sOperator},${oValue})"$)
	End If
	Dim combineLen As Int = combineL.Size - 1
	WHERE_OR(combineLen)
	ADD_WHERE(sFld, sOperator, oValue)
	Return Me
End Sub

'change the selection at position from AND to OR
Sub WHERE_OR(iPos As Int) As B4XDaisyPocketBase
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.WHERE_OR(${iPos})"$)
	End If
	combineL.Set(iPos, "||")
	Return Me
End Sub

'change the selection at position to AND
Sub WHERE_AND(iPos As Int) As B4XDaisyPocketBase
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.WHERE_AND(${iPos})"$)
	End If
	combineL.Set(iPos, "&&")
	Return Me
End Sub

'add a sort field
Sub ADD_ORDER_BY(sFld As String) As B4XDaisyPocketBase
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.ADD_ORDER_BY(${sFld})"$)
	End If
	orderByL.Add(sFld)
	Return Me
End Sub

Sub ADD_ORDER_BY_DESC(sFld As String) As B4XDaisyPocketBase
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.ADD_ORDER_BY_DESC(${sFld})"$)
	End If
	orderByL.Add($"-${sFld}"$)
	Return Me
End Sub

'<code>
'Do while rs.NextRow
'Loop
'</code>
Sub NextRow As Boolean
	lastPosition = lastPosition + 1
	Dim realSize As Int = RowCount - 1
	If lastPosition > realSize Then
		Return False
	Else
		setPosition(lastPosition)
		Return True
	End If
End Sub
Sub SetRecord(mRec As Map)
	Record.Initialize
	If MatchSchema Then
		For Each k As String In mRec.Keys
			Dim fldPos As Boolean = Schema.ContainsKey(k)
			If fldPos = False Then mRec.Remove(k)
		Next
	End If
	For Each k As String In mRec.Keys
		Dim v As Object = mRec.GetDefault(k, "")
		Dim dt As String = Schema.Get(k)
		Select Case dt
			Case DB_BOOL
				v = CBool(v)
			Case DB_INT
				v = CInt(v)
			Case DB_STRING
				v = CStr(v)
			Case DB_REAL
				v = CDbl(v)
			Case DB_FLOAT
				v = CDbl(v)
			Case DB_INTEGER
				v = CInt(v)
			Case DB_TEXT, DB_LONGTEXT
				v = CStr(v)
			Case DB_DOUBLE
				v = CDbl(v)
			End Select
		Record.Put(k, v)
	Next
	DisplayValue = Record.GetDefault(DisplayField, "")
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.SetRecord(${Map2Json(Record)})"$)
	End If
End Sub

'prepare a new record
Sub PrepareRecord
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.PrepareRecord"$)
	End If
	CLEAR_WHERE
	AddHeader("Content-Type",  "application/json")
	Record.Initialize
End Sub

'prepare FormData
'to subfile file
Sub PrepareForm
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.PrepareForm"$)
	End If
	CLEAR_WHERE
	Record.Initialize
	'formData.Initialize2("FormData", Null)
End Sub

'set a field for file, this appends to fomData
'to delete the file set the fldValue = null
Sub SetFormFile(sFldName As String, oFldValue As Object) As B4XDaisyPocketBase
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.SetFormFile(${sFldName}, ${oFldValue})"$)
	End If
	Dim dt As String = Schema.Get(sFldName)
	Select Case dt
		Case DB_BOOL
			oFldValue = CBool(oFldValue)
		Case DB_INT
			oFldValue = CInt(oFldValue)
		Case DB_STRING
			oFldValue = CStr(oFldValue)
		Case DB_REAL
			oFldValue = CDbl(oFldValue)
		Case DB_FLOAT
			oFldValue = CDbl(oFldValue)
		Case DB_INTEGER
			oFldValue = CInt(oFldValue)
		Case DB_TEXT, DB_LONGTEXT
			oFldValue = CStr(oFldValue)
		Case DB_DOUBLE
			oFldValue = CDbl(oFldValue)
	End Select
	'formData.RunMethod("set", Array(fldName, fldValue))
	Return Me
End Sub

'set form values from a map
Sub SetForm(mMap As Map)
	For Each k As String In mMap.Keys
		Dim v As Object = mMap.Get(k)
		SetFormField(k, v)
	Next
End Sub

'set a field for form
'to delete the file set the fileObj = null
Sub SetFormField(sFldName As String, oFldValue As Object) As B4XDaisyPocketBase
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.SetFormField(${sFldName}, ${oFldValue})"$)
	End If
	Dim dt As String = Schema.Get(sFldName)
	Select Case dt
		Case DB_BOOL
			oFldValue = CBool(oFldValue)
		Case DB_INT
			oFldValue = CInt(oFldValue)
		Case DB_STRING
			oFldValue = CStr(oFldValue)
		Case DB_REAL
			oFldValue = CDbl(oFldValue)
		Case DB_FLOAT
			oFldValue = CDbl(oFldValue)
		Case DB_INTEGER
			oFldValue = CInt(oFldValue)
		Case DB_TEXT, DB_LONGTEXT
			oFldValue = CStr(oFldValue)
		Case DB_DOUBLE
			oFldValue = CDbl(oFldValue)
	End Select
	'formData.RunMethod("set", Array(fldName, fldValue))
	Return Me
End Sub

'set the position of the current record
Sub setPosition(iPos As Int)
	If result.Size > iPos Then
		Record = result.Get(iPos)
		lastPosition = iPos
	Else
		lastPosition = -1
		Record.Initialize
	End If
End Sub

Sub SetRecordAt(iPos As Int, mRec As Map)
	result.Set(iPos, mRec)
End Sub

Sub getPosition As Int
	Return lastPosition
End Sub

'get an integer from the current record
Sub GetInt(sFld As String) As Int
	sFld = sFld.tolowercase
	If Record.IsInitialized = False Then Return 0
	If Record.ContainsKey(sFld) Then
		Dim obj As Int = Record.GetDefault(sFld, 0)
		obj = CInt(obj)
		Return obj
	Else
		Return 0
	End If
End Sub

'get a long from the current record
Sub GetLong(sFld As String) As Long
	Return GetInt(sFld)
End Sub

'get a string from the current record
Sub GetString(sFld As String) As String
	sFld = sFld.tolowercase
	If Record.IsInitialized = False Then Return ""
	If Record.ContainsKey(sFld) Then
		Dim obj As String = Record.GetDefault(sFld, "")
		obj = CStr(obj)
		Return obj
	Else
		Return ""
	End If
End Sub

'returns a placeholder if there is no image
Sub GetImage(sFld As String) As String
	Dim simage As String = GetString(sFld)
	If simage = "" Then Return "./assets/placeholderimg.jpg"
	Return simage
End Sub

'get a boolean from the current record
Sub GetBoolean(sFld As String) As Boolean
	sFld = sFld.tolowercase
	If Record.IsInitialized = False Then Return False
	If Record.ContainsKey(sFld) Then
		Dim obj As Boolean = Record.GetDefault(sFld, False)
		obj = CBool(obj)
		Return obj
	Else
		Return False
	End If
End Sub

'get a double from the current record
Sub GetDouble(sFld As String) As Double
	sFld = sFld.tolowercase
	If Record.ContainsKey(sFld) Then
		Dim obj As Double = Record.GetDefault(sFld, 0)
		obj = CDbl(obj)
		Return obj
	Else
		Return 0
	End If
End Sub

'get record at position
Sub GetRecord(iPos As Int) As Map
	Dim rec As Map = result.Get(iPos)
	Return rec
End Sub

'movefirst
'<code>
'rs.MoveFirst
'Do while rs.NextRow
'Loop
'</code>
Sub MoveFirst
	setPosition(0)
End Sub

'movelast
'<code>
'rs.MoveLast
'Do while rs.NextRow
'Loop
'</code>
Sub MoveLast
	setPosition(RowCount - 1)
End Sub

'moveprevious
Sub MovePrevious
	lastPosition = lastPosition - 1
	If lastPosition < 0 Then
		lastPosition = 0
	End If
	setPosition(lastPosition)
End Sub

'movenext
Sub MoveNext
	lastPosition = lastPosition + 1
	If lastPosition > RowCount Then
		lastPosition = RowCount - 1
	End If
	setPosition(lastPosition)
End Sub
Sub findWhereOrderBy(mWhereMap As Map, lstWhereOps As List, lstOrderByx As List) As ResumableSub
	Wait For (findWhereOrderByFetch(mWhereMap, lstWhereOps, lstOrderByx)) Complete (res As List)
	Return res
End Sub



'mvfield sub
private Sub MvField(sValue As String, iPosition As Int, sDelimiter As String) As String
	If sValue.Length = 0 Then Return ""
	Dim xPos As Int = sValue.IndexOf(sDelimiter)
	If xPos = -1 Then Return sValue
	Dim mValues As List = StrParse(sDelimiter,sValue)
	Dim tValues As Int
	tValues = mValues.size -1
	Select Case iPosition
		Case -1
			Return mValues.get(tValues)
		Case -2
			Return mValues.get(tValues - 1)
		Case -3
			Dim sb As StringBuilder
			sb.Initialize
			Dim startcnt As Int
			sb.Append(mValues.Get(1))
			For startcnt = 2 To tValues
				sb.Append(sDelimiter)
				sb.Append(mValues.get(startcnt))
			Next
			Dim sout As String = sb.ToString
			sb.Initialize
			Return sout
		Case Else
			iPosition = iPosition - 1
			If iPosition <= -1 Then
				Return mValues.get(tValues)
			End If
			If iPosition > tValues Then
				Return ""
			End If
			Return mValues.get(iPosition)
	End Select
End Sub

'parse a string
private Sub StrParse(sDelim As String, sInputString As String) As List
	Dim nl As List
	nl.Initialize
	Try
		sInputString = CStr(sInputString)
		If sInputString = "" Then Return nl
		If sInputString.IndexOf(sDelim) = -1 Then
			nl.Add(sInputString)
		Else	
			Dim parts() As String = Regex.Split(sDelim, sInputString)
			For Each p As String In parts
				nl.Add(p)
			Next
		End If
		Return nl
	Catch
		Return nl
	End Try
End Sub

private Sub RemDelim(sValue As String, sDelim As String) As String
	Dim sw As Boolean = sValue.EndsWith(sDelim)
	If sw Then
		Dim lDelim As Int = sDelim.Length
		Dim nValue As String = sValue
		sw = nValue.EndsWith(sDelim)
		If sw Then
			nValue = nValue.SubString2(0, nValue.Length-lDelim)
		End If
		Return nValue
	Else
		Return sValue
	End If
End Sub


'Execute a where clause on the records
'The result is a list with the values.
'<code>
'Dim WhereRecords As List = BANano.Await(pb.findWhereOR(m, array("="))
'</code>
Sub findWhere(mWhereMap As Map, lstWhereOps As List) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.findWhere(${Map2Json(mWhereMap)},${lstWhereOps})"$)
	End If
	Wait For (findWhereOrderBy(mWhereMap, lstWhereOps, Null)) Complete (res As List)
	Return res
End Sub

'Execute a where clause on the records
'The result is a list with the values.
'<code>
'Dim WhereRecords As List = BANano.Await(pb.findWhereOR(m, array("="))
'</code>
Sub findWhereFetch(mWhereMap As Map, lstWhereOps As List) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.findWhereFetch(${Map2Json(mWhereMap)},${lstWhereOps})"$)
	End If
	Wait For (findWhereOrderByFetch(mWhereMap, lstWhereOps, Null)) Complete (res As List)
	Return res
End Sub

'<code>
'BANano.Await(pb.DELETE_BY(1))
'</code>
Sub DELETE_BY(sFldName As String, sFldValue As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.DELETE_BY(${sFldName},${sFldValue})"$)
	End If
	CLEAR_WHERE
	ADD_WHERE(sFldName, "=", sFldValue)
	ADD_FIELD("id")
	ADD_FIELD(sFldName)
	Wait For (deleteWhere("id", whereField, ops)) Complete (b As Boolean)
	Return b
End Sub

'<code>
'BANano.Await(pb.DELETE_BY_STRING("a"))
'</code>
Sub DELETE_BY_STRING(sFldName As String, sFldValue As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.DELETE_BY_STRING(${sFldName},${sFldValue})"$)
	End If
	CLEAR_WHERE
	ADD_WHERE_STRING(sFldName, "=", sFldValue)
	ADD_FIELD("id")
	ADD_FIELD(sFldName)
	Wait For (deleteWhere("id", whereField, ops)) Complete (b As Boolean)
	Return b
End Sub

'Execute a delete clause on the records
'<code>
'BANano.Await(pb.deleteWhere("id", m, array("=")))
'</code>
Sub deleteWhere(sPriKey As String, mWhereMap As Map, lstWhereOps As List) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.deleteWhere(${sPriKey},${Map2Json(mWhereMap)},${lstWhereOps})"$)
	End If
	If Schema.Size = 0 Then
		If B4XDaisyApp.DebugLogs Then Log($"B4XDaisyPocketBase.deleteWhere: ${sTableName} - please execute SchemaAdd first to define your table schema!"$)
		Return False
	End If
	'get all the records
	Wait For (findWhere(mWhereMap, lstWhereOps)) Complete (recs As List)
	If recs.IsInitialized = False Or recs.Size = 0 Then Return False
	'
	For Each rec As Map In recs
		Dim pvalue As String = rec.Get(sPriKey)
		Wait For (DELETE(pvalue)) Complete (ok As Boolean)
	Next
	Return True
End Sub

'<code>
'pb.CLEAR_WHERE
'pb.ADD_WHERE_STRING("name", "=", "123")
'pb.ADD_WHERE("id", "=", 3)
'BANano.Await(pb.DELETE_WHERE)
'</code>
Sub DELETE_WHERE As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTableName}.DELETE_WHERE"$)
	End If
	Wait For (deleteWhere("id", whereField, ops)) Complete (ok As Boolean)
End Sub

'<code>
'Dim result As Boolean = BANano.Await(pbComponents.ExistsByString("name", "xxx"))
'</code>
Sub ExistsByString(sFldName As String, oFldValue As Object) As ResumableSub
	Wait For (ExistsByStringFetch(sFldName, oFldValue)) Complete (res As Boolean)
	Return res
End Sub

'<code>
'Dim result As Boolean = BANano.Await(pbComponents.ExistsByStringFetch("name", "xxx"))
'</code>
Sub ExistsByStringFetch(sFldName As String, oFldValue As Object) As ResumableSub
	CLEAR_WHERE
	ADD_FIELD(sFldName)
	ADD_WHERE_STRING(sFldName, "=", oFldValue)
	Wait For (GetFirstListItemFetch(sTableName)) Complete (m As Map)
	If m.size = 0 Then
		Return False
	Else
		Return True
	End If
End Sub

'<code>
'Dim result As Boolean = BANano.Await(pbComponents.Exists("id", 1))
'</code>
Sub Exists(sFldName As String, oFldValue As Object) As ResumableSub
	Wait For (ExistsFetch(sFldName, oFldValue)) Complete (res As Boolean)
	Return res
End Sub

'<code>
'Dim result As Boolean = BANano.Await(pbComponents.ExistsFetch("id", 1))
'</code>
Sub ExistsFetch(sFldName As String, oFldValue As Object) As ResumableSub
	CLEAR_WHERE
	ADD_FIELD(sFldName)
	ADD_WHERE_STRING(sFldName, "=", oFldValue)
	Wait For (GetFirstListItemFetch(sTableName)) Complete (m As Map)
	If m.size = 0 Then
		Return False
	Else
		Return True
	End If
End Sub

'<code>
'Dim result As Boolean = BANano.Await(pbComponents.ExistsWhere(CreateMap("id": "1")))
'</code>
Sub ExistsWhere(mWhere As Map) As ResumableSub
	Wait For (ExistsWhereFetch(mWhere)) Complete (res As Boolean)
	Return res
End Sub

'<code>
'Dim result As Boolean = BANano.Await(pbComponents.ExistsWhereFetch(CreateMap("id": "1")))
'</code>
Sub ExistsWhereFetch(mWhere As Map) As ResumableSub
	CLEAR_WHERE
	ADD_FIELD("id")
	For Each k As String In mWhere.Keys
		Dim v As String = mWhere.Get(k)
		ADD_WHERE_STRING(k, "=", v)
	Next
	Wait For (GetFirstListItemFetch(sTableName)) Complete (m As Map)
	If m.size = 0 Then
		Return False
	Else
		Return True
	End If
End Sub

Sub COUNT_ALL As ResumableSub
	Wait For (SELECT_RAW($"select count(*) as records from ${sTableName}"$)) Complete (lst As List)
	Dim rec As Int = GetRecordsCount
	Return rec
End Sub

'<code>
'pbComponents.CLEAR_WHERE
'pbComponents.ADD_WHERE_STRING("attractive", "=", "true")
'pbComponents.ADD_ORDER_BY("attrname")
'pbComponents.FILE_FIELD("fileobj", "fileurl")
'Dim result As List = BANano.Await(pbComponents.SELECT_WHERE)
'For Each record As Map In result
'Dim sid As String = record.Get("id")
'Next
'</code>
Sub SELECT_WHERE As ResumableSub
	Wait For (SELECT_WHERE_FETCH) Complete (res As List)
	Return res
End Sub

'<code>
'pbComponents.CLEAR_WHERE
'pbComponents.ADD_WHERE_STRING("attractive", "=", "true")
'pbComponents.ADD_ORDER_BY("attrname")
'pbComponents.FILE_FIELD("fileobj", "fileurl")
'Dim result As List = BANano.Await(pbComponents.SELECT_WHERE_FETCH)
'For Each record As Map In result
'Dim sid As String = record.Get("id")
'Next
'</code>
Sub SELECT_WHERE_FETCH As ResumableSub
	Wait For (findWhereOrderByFetch(whereField, ops, orderByL)) Complete (res As List)
	Return res
End Sub

'get the first item that matches your filter
Sub GetFirstListItem(sTable As String) As ResumableSub
	Wait For (GetFirstListItemFetch(sTable)) Complete (res As Map)
	Return res
End Sub

'get the first item that matches your filter
Sub GetFirstListItemFetch(sTable As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${sTable}.GetFirstListItemFetch"$)
	End If
	If Schema.Size = 0 Then
		If B4XDaisyApp.DebugLogs Then Log($"B4XDaisyPocketBase.GetFirstListItemFetch: ${sTable} - please execute SchemaAdd first to define your table schema!"$)
		Return Null
	End If
	Dim sb As StringBuilder
	sb.Initialize
	Dim i As Int
	Dim iWhere As Int = whereField.Size - 1
	For i = 0 To iWhere
		Dim col As String = whereField.GetKeyAt(i)
		col = MvField(col, 1, ".").Replace("&", "")
		Dim xVal As String = whereField.GetValueAt(i)
		Dim opr As String = ops.Get(i)
		Dim com As String = combineL.Get(i)
		sb.Append(col).Append(opr).Append(xVal).Append(com)
	Next
	Dim qfilter As String = RemDelim(sb.ToString, com).Trim
	If qfilter = "" Then
		Dim m As Map = CreateMap()
		Return m
	End If
	Dim qsort As String = Join(",", orderByL)
	Dim qflds As String = Join(",", flds)
	RowCount = 0
	lastPosition = -1
	result.Initialize
	Try
		Dim finalURL As String = $"/api/getlist"$
		Dim body As Map = CreateMap()
		body.Put("collection", sTable)
		body.Put("perPage", "1")
		body.Put("page", "1")
		body.Put("getFiles", GetFiles)
		body.Put("filter", qfilter)
		body.Put("sort", qsort)
		body.Put("fields", qflds)
		body.Put("skipTotal", True)
		Wait For (ApiPost(finalURL, body)) Complete (m As Map)
		result = m.Get("items")
		If result.IsInitialized = False Then result.Initialize
		RowCount = result.Size
		Dim mx As Map = CreateMap()
		If result.Size = 1 Then mx = result.Get(0)
		Return mx
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"GetFirstListItemFetch: ${LastException.message}"$)
		Dim mx As Map = CreateMap()
		Return mx
	End Try
End Sub

'<code>
'pbComponents.CLEAR_WHERE
'pbComponents.ADD_WHERE_STRING("attractive", "=", "true")
'pbComponents.ADD_ORDER_BY("attrname")
'pbComponents.FILE_FIELD("fileobj", "fileurl")
'BANano.Await(pbComponents.SELECT_WHERE1)
'Do While pbComponents.NextRow
'Dim rec As Map = pbComponents.Record
'Dim sid As String = pbComponents.GetString("id")
'Loop
'</code>
Sub SELECT_WHERE1 As ResumableSub
	Wait For (SELECT_WHERE1_FETCH) Complete (res As List)
	Return res
End Sub

'<code>
'pbComponents.CLEAR_WHERE
'pbComponents.ADD_WHERE_STRING("attractive", "=", "true")
'pbComponents.ADD_ORDER_BY("attrname")
'pbComponents.FILE_FIELD("fileobj", "fileurl")
'BANano.Await(pbComponents.SELECT_WHERE1_FETCH)
'Do While pbComponents.NextRow
'Dim rec As Map = pbComponents.Record
'Dim sid As String = pbComponents.GetString("id")
'Loop
'</code>
Sub SELECT_WHERE1_FETCH As ResumableSub
	Wait For (findWhereOrderByFetch(whereField, ops, orderByL)) Complete (res As List)
	result = res
	RowCount = result.Size
	lastPosition = -1
	Return result
End Sub

Sub SetRecords(lstItems As List)
	lastPosition = -1
	RowCount = lstItems.Size
	result = lstItems
End Sub

'get own unique key with 15 chars alphabets only
'this is a controlled id
Sub NextID As String
	Dim ni As String = guidAlphaApp(15)
	Return ni
End Sub

private Sub guidAlphaApp(iGlen As Int) As String
	Dim chars As String = "abcdefghijklmnopqrstuvwxyz"
	Dim sb As StringBuilder
	sb.Initialize
	For i = 1 To iGlen
		sb.Append(chars.CharAt(Rnd(0, 26)))
	Next
	Return sb.ToString
End Sub

'define the real record from the db record
'using the schema defined fields
Sub AssignRealRecord(mDbRecord As Map)
	Record.Initialize
	For Each k As String In Schema.Keys
		Dim v As Object = mDbRecord.Get(k)
		Record.Put(k, v)
	Next
	Record.Remove("collectionId")
	Record.Remove("collectionName")
	DisplayValue = Record.GetDEfault(DisplayField, "")
End Sub

'remove collectionId,collectionName,created,updated
Sub GetRealRecord(mDbRecord As Map) As Map
	mDbRecord.Remove("collectionId")
	mDbRecord.Remove("collectionName")
	mDbRecord.Remove("created")
	mDbRecord.Remove("updated")
	Return mDbRecord
End Sub

'check compulsory fields
public Sub IsRecordValid(mMap As Map, lstProps As List) As Boolean
	Dim pTot As Int = lstProps.Size
	Dim cTot As Int = 0
	For Each p As String In lstProps
		Dim v As String = CStr(mMap.Get(p))
		v = v.Trim
		If v <> "" Then
			cTot = cTot + 1
		End If
	Next
	If cTot = pTot Then
		Return True
	Else
		Return False
	End If
End Sub

'<code>
''THIS SHOULD MATCH
''this returns a new profile on success
'dim user As Map = CreateMap()
'user.put("email", "")
'user.put("password", "")
'user.put("passwordConfirm", "")
'user.put("name", "")
'user.put("avatar", "")
'user.put("username", "")
'user.put("emailVisibility", True)
'BANano.Await(pb.CREATE_USER(user))
'dim up As profileType = pb.UserProfile
'if up.size = 0 then
'else
'end if
'</code>
Sub CREATE_USER(mProfile As Map) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${UsersCollectionName}.CREATE_USER(${Map2Json(mProfile)})"$)
	End If
	UserProfile.Initialize
	UserProfile.size = 0
	Try
		Dim fOK As Int = 0
		If mProfile.ContainsKey("email") = False Then fOK = fOK + 1
		If mProfile.ContainsKey("password") = False Then fOK = fOK + 1
		If mProfile.ContainsKey("passwordConfirm") = False Then fOK = fOK + 1
		'
		If fOK <> 0 Then Return Null

		Dim qflds As String = Join(",", flds)
		Dim qexpand As String = Join(",", expand)

		Dim qs As Map = CreateMap()
		If qflds <> "" Then qs.Put("fields", qflds)
		If qexpand <> "" Then qs.Put("expand", qexpand)
		Dim url As String = $"${baseURL}/api/collections/${UsersCollectionName}/records"$
		If qs.Size > 0 Then url = $"${url}?${Map2QueryString(qs)}"$
		If ShowLog Then
			Log($"B4XDaisyPocketBase.${UsersCollectionName}.CREATE_USER(${url})"$)
		End If
		Wait For (ApiPost(url, mProfile)) Complete (res As Map)
		If res.ContainsKey("id") Then
			UserProfile.id = res.GetDefault("id", "")
			UserProfile.email = res.GetDefault("email","")
			UserProfile.avatar = res.GetDefault("avatar","")
			UserProfile.name = res.GetDefault("name","")
			UserProfile.verified = res.GetDefault("verified",False)
			UserProfile.username = res.GetDefault("username","")
			UserProfile.idnumber = res.GetDefault("idnumber", "")
			UserProfile.size = 7
			Return res
		Else
			Return Null
		End If
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"CREATE_USER: ${LastException.message}"$)
		Return Null
	End Try
End Sub
Sub CREATE_USER_FORM As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${UsersCollectionName}.CREATE_USER_FORM"$)
	End If
	UserProfile.Initialize
	UserProfile.size = 0
	Try
		Dim qflds As String = Join(",", flds)
		Dim qexpand As String = Join(",", expand)
		Dim opt As Map = CreateMap()
		opt.Put("cache", "no-store")
		If headers.Size <> 0 Then
			opt.Put("headers", headers)
		End If
		If qflds <> "" Then opt.Put("fields", qflds)
		If qexpand <> "" Then opt.Put("expand", qexpand)
		Wait For (ApiPostMultipart(baseURL & "/api/collections/" & UsersCollectionName & "/records", formFields, formFiles)) Complete (res As Map)
		If res.ContainsKey("id") Then
			UserProfile.id = res.GetDefault("id", "")
			UserProfile.email = res.GetDefault("email","")
			UserProfile.avatar = res.GetDefault("avatar","")
			UserProfile.name = res.GetDefault("name","")
			UserProfile.verified = res.GetDefault("verified",False)
			UserProfile.username = res.GetDefault("username","")
			UserProfile.idnumber = res.GetDefault("idnumber", "")
			UserProfile.size = 7
			Return res
		Else
			Return Null
		End If
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"CREATE_USER_FORM: ${LastException.message}"$)
		Return Null
	End Try
End Sub

'<code>
'dim uprofile As Map = BANano.Await(pb.CHANGE_USER_PASSWORD(pid, "newPassword", "confirmPassword"))
'</code>
Sub CHANGE_USER_PASSWORD(sUEmail As String, sNewPassword As String, sConfirmPassword As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${UsersCollectionName}.CHANGE_USER_PASSWORD(${sUEmail})"$)
	End If
	Try
		setTableName(UsersCollectionName)
		Wait For (READ_ID_BY_STRING("email", sUEmail)) Complete (uID As String)
		If uID = "" Then Return Null
		Dim uProfile As Map = CreateMap()
		uProfile.put("password", sNewPassword)
		uProfile.put("passwordConfirm", sConfirmPassword)
		Dim url As String = $"${baseURL}/api/collections/${UsersCollectionName}/records/${uID}"$
		If ShowLog Then
			Log($"B4XDaisyPocketBase.${UsersCollectionName}.CHANGE_USER_PASSWORD(${url})"$)
		End If
		Wait For (ApiPatch(url, uProfile)) Complete (res As Map)
		Return res
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"CHANGE_USER_PASSWORD: ${LastException.message}"$)
		Return Null
	End Try
End Sub


'<code>
''THIS SHOULD MATCH
''this returns a new profile on success
'dim user As Map = CreateMap()
'user.put("email", "")
'user.put("password", "")
'user.put("passwordConfirm", "")
'user.put("emailVisibility", True)
'Dim profile As Map = BANano.Await(pb.CREATE_ADMIN(user))
'	If (profile = Null) Then
'		app.ShowSwalError("The admin profile could no be created!")
'		Return
'	End If
'	'auth via email - before you can update the profile
'	Dim vAuthorized As Map = BANano.await(pb.ADMIN_AUTH_WITH_PASSWORD(email.value, password.value))
'	If (vAuthorized = Null) Then
'		app.ShowSwalError("The credentials could not be authorised!")
'		Return
'	End If
'	app.ShowSwalSuccessToast("Administrator signed up!",1000)
'</code>
Sub CREATE_ADMIN(mProfile As Map) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.CREATE_ADMIN(${Map2Json(mProfile)})"$)
	End If
	UserProfile.Initialize
	UserProfile.size = 0
	Try
		Dim fOK As Int = 0
		If mProfile.ContainsKey("email") = False Then fOK = fOK + 1
		If mProfile.ContainsKey("password") = False Then fOK = fOK + 1
		If mProfile.ContainsKey("passwordConfirm") = False Then fOK = fOK + 1
		'
		If fOK <> 0 Then Return Null
		Dim qflds As String = Join(",", flds)
		Dim qexpand As String = Join(",", expand)

		Dim qs As Map = CreateMap()
		If qflds <> "" Then qs.Put("fields", qflds)
		If qexpand <> "" Then qs.Put("expand", qexpand)
		Dim url As String
		If Upgrade Then
			url = $"${baseURL}/api/collections/_superusers/records"$
		Else
			url = $"${baseURL}/api/admins"$
		End If
		If qs.Size > 0 Then url = $"${url}?${Map2QueryString(qs)}"$
		Wait For (ApiPost(url, mProfile)) Complete (res As Map)
		If res.ContainsKey("id") Then
			UserProfile.id = res.GetDefault("id", "")
			UserProfile.email = res.GetDefault("email","")
			UserProfile.avatar = res.GetDefault("avatar","")
			UserProfile.name = res.GetDefault("name","")
			UserProfile.verified = res.GetDefault("verified",False)
			UserProfile.username = res.GetDefault("username","")
			UserProfile.idnumber = res.GetDefault("idnumber", "")
			UserProfile.size = 7
			Return res
		Else
			Return Null
		End If
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"CREATE_ADMIN: ${LastException.message}"$)
		Return Null
	End Try
End Sub

'<code>
'dim profile As Map = BANano.Await(pb.CREATE_COLLECTION("people", "base", schema))
'</code>
Sub CREATE_COLLECTION(sNameOf As String, sColType As String, lstColSchema As List) As ResumableSub
	Wait For (CREATE_COLLECTION2(sNameOf, sColType, lstColSchema, "", "", "", "", "", Null, Null)) Complete (res As Map)
	Return res
End Sub

'<code>
'dim profile As Map = BANano.Await(pb.Schema_CreateCollection("people", "base", schema))
'</code>
Sub Schema_CreateCollection(sNameOf As String, sColType As String, mOptions As Map) As ResumableSub
	Wait For (CREATE_COLLECTION2(sNameOf, sColType, Null, "", "", "", "", "", Null, mOptions)) Complete (res As Map)
	Return res
End Sub

private Sub JoinIndexNames(sIdx As String) As String
	Dim lst As List = StrParse(",", sIdx)
	Dim lTot As Int = lst.Size - 1
	Dim lCnt As Int
	For lCnt = 0 To lTot
		Dim lItem As String = lst.Get(lCnt)
		lItem = lItem.Replace("`", "")
		lItem = $"`${lItem}`"$
		lst.Set(lCnt, lItem)
	Next
	Dim sout As String = Join(",", lst)
	Return sout
End Sub

'<code>
'dim profile As Map = BANano.Await(pb.CREATE_COLLECTION1("people", schema, "", "", "", "", ""))
'</code>
Sub CREATE_COLLECTION1(sNameOf As String, lstColSchema As List, sScreateRule As String, sSupdateRule As String, sSdeleteRule As String, sSlistRule As String, sSviewRule As String) As ResumableSub
	Wait For (CREATE_COLLECTION2(sNameOf, "base", lstColSchema, sScreateRule, sSupdateRule, sSdeleteRule, sSlistRule, sSviewRule, Null, Null)) Complete (res As Map)
	Return res
End Sub
Sub CREATE_COLLECTION2(sNameOf As String, sTypeOf As String, lstColSchema As List, sScreateRule As String, sSupdateRule As String, sSdeleteRule As String, sSlistRule As String, sSviewRule As String, lstIndexes As List, mOptions As Map) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.CREATE_COLLECTION2(${sNameOf})"$)
	End If
	Try
		SetAuthorizationBearerToken(UserToken)
		Dim col As Map = CreateMap()
		col.Put("name", sNameOf)
		col.Put("type", sTypeOf)
		col.Put("system", False)
		col.Put("createRule", sScreateRule)
		col.Put("updateRule", sSupdateRule)
		col.Put("deleteRule", sSdeleteRule)
		col.Put("listRule", sSlistRule)
		col.Put("viewRule", sSviewRule)
		If lstColSchema <> Null And lstColSchema.IsInitialized Then col.Put("schema", lstColSchema)
		If lstIndexes <> Null And lstIndexes.IsInitialized Then col.Put("indexes", lstIndexes)
		If mOptions <> Null And mOptions.IsInitialized Then col.Put("options", mOptions)
		Wait For (ApiPost("/api/collections", col)) Complete (res As Map)
		Return res
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"CREATE_COLLECTION2: ${LastException.message}"$)
		Return Null
	End Try
End Sub
'
Sub CREATE_COLLECTION_ORIGINAL(mCol As Map) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.CREATE_COLLECTION_ORIGINAL"$)
	End If
	Try
		SetAuthorizationBearerToken(UserToken)
		Wait For (ApiPost("/api/collections", mCol)) Complete (res As Map)
		Return res
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"CREATE_COLLECTION_ORIGINAL: ${LastException.message}"$)
		Return Null
	End Try
End Sub


'<code>
'dim uprofile As Map = BANano.Await(pb.UPDATE_COLLECTION("people", schema))
'</code>
Sub UPDATE_COLLECTION(sColName As String, mColSchema As Map) As ResumableSub
	Wait For (UPDATE_COLLECTION2(sColName, "base", mColSchema, "", "", "", "", "", Null, Null)) Complete (res As Map)
	Return res
End Sub

'<code>
'dim uprofile As Map = BANano.Await(pb.UPDATE_COLLECTION_ORIGINAL(schema))
'</code>
Sub UPDATE_COLLECTION_ORIGINAL(mCol As Map) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.UPDATE_COLLECTION_ORIGINAL"$)
	End If
	Try
		SetAuthorizationBearerToken(UserToken)
		Dim colName As String = mCol.Get("name")
		Wait For (ApiPatch($"/api/collections/${colName}"$, mCol)) Complete (res As Map)
		Return res
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"UPDATE_COLLECTION_ORIGINAL: ${LastException.message}"$)
		Return Null
	End Try
End Sub

'<code>
'dim profile As Map = BANano.Await(pb.UPDATE_COLLECTION1("people", schema, "", "", "", "", ""))
'</code>
Sub UPDATE_COLLECTION1(sNameOf As String, lstColSchema As List, sScreateRule As String, sSupdateRule As String, sSdeleteRule As String, sSlistRule As String, sSviewRule As String) As ResumableSub
	Wait For (UPDATE_COLLECTION2(sNameOf, "base", lstColSchema, sScreateRule, sSupdateRule, sSdeleteRule, sSlistRule, sSviewRule, Null, Null)) Complete (res As Map)
	Return res
End Sub
Sub UPDATE_COLLECTION2(sColName As String, sTypeOf As String, lstColSchema As List, sScreateRule As String, sSupdateRule As String, sSdeleteRule As String, sSlistRule As String, sSviewRule As String, lstIndexes As List, mOptions As Map) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.UPDATE_COLLECTION2(${sColName})"$)
	End If
	Try
		SetAuthorizationBearerToken(UserToken)
		Dim col As Map = CreateMap()
		col.Put("name", sColName)
		col.Put("type", sTypeOf)
		col.Put("system", False)
		col.Put("createRule", sScreateRule)
		col.Put("updateRule", sSupdateRule)
		col.Put("deleteRule", sSdeleteRule)
		col.Put("listRule", sSlistRule)
		col.Put("viewRule", sSviewRule)
		If lstColSchema <> Null And lstColSchema.IsInitialized Then col.Put("schema", lstColSchema)
		If lstIndexes <> Null And lstIndexes.IsInitialized Then col.Put("indexes", lstIndexes)
		If mOptions <> Null And mOptions.IsInitialized Then col.Put("options", mOptions)
		Wait For (ApiPatch($"/api/collections/${sColName}"$, col)) Complete (res As Map)
		Return res
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"UPDATE_COLLECTION2: ${LastException.message}"$)
		Return Null
	End Try
End Sub


'<code>
'dim pid As string = pb.UserProfile.id
'dim uuser As Map = CreateMap()
'uuser.put("name", "")
'dim uprofile As Map = BANano.Await(pb.UPDATE_USER(pid, uuser))
'</code>
Sub UPDATE_USER(sId As String, mProfile As Map) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${UsersCollectionName}.UPDATE_USER(${sId})"$)
	End If
	Try
		Dim qflds As String = Join(",", flds)
		Dim qexpand As String = Join(",", expand)

		Dim qs As Map = CreateMap()
		If qflds <> "" Then qs.Put("fields", qflds)
		If qexpand <> "" Then qs.Put("expand", qexpand)
		Dim url As String = $"${baseURL}/api/collections/${UsersCollectionName}/records/${sId}"$
		If qs.Size > 0 Then url = $"${url}?${Map2QueryString(qs)}"$
		If ShowLog Then
			Log($"B4XDaisyPocketBase.UPDATE_USER(${url})"$)
		End If
		Wait For (ApiPatch(url, mProfile)) Complete (res As Map)
		Return res
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"UPDATE_USER: ${LastException.message}"$)
		Return Null
	End Try
End Sub
'
'<code>
'dim pid As string = pb.UserProfile.id
'dim uuser As Map = CreateMap()
'uuser.put("name", "")
'dim uprofile As Map = BANano.Await(pb.UPDATE_USER(pid, uuser))
'</code>
'Sub UPDATE_USER_FORM(id As String) As ResumableSub
'	If ShowLog Then
'		Log($"B4XDaisyPocketBase.${UsersCollectionName}.UPDATE_USER_FORM(${id})"$)
'	End If
'	Try
'		Dim url As String = $"${baseURL}/api/collections/${UsersCollectionName}/records/${id}"$
'		Wait For (ApiPatchMultipart(url, formFields, formFiles)) Complete (res As Map)
'		Return res
'	Catch
'		Log($"UPDATE_USER_FORM: ${LastException.message}"$)
'		Return Null
'	End Try
'End Sub

'<code>
'dim pid As string = pb.UserProfile.id
'dim uuser As Map = CreateMap()
'uuser.put("name", "")
'dim uprofile As Map = BANano.Await(pb.UPDATE_ADMIN(pid, uuser))
'</code>
Sub UPDATE_ADMIN(sId As String, mProfile As Map) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.UPDATE_ADMIN(${sId})"$)
	End If
	Try
		Dim qflds As String = Join(",", flds)
		Dim qexpand As String = Join(",", expand)

		Dim qs As Map = CreateMap()
		If qflds <> "" Then qs.Put("fields", qflds)
		If qexpand <> "" Then qs.Put("expand", qexpand)
		Dim url As String
		If Upgrade Then
			url = $"${baseURL}/api/collections/_superusers/records/${sId}"$
		Else
			url = $"${baseURL}/api/admins/${sId}"$
		End If
		If qs.Size > 0 Then url = $"${url}?${Map2QueryString(qs)}"$
		Wait For (ApiPatch(url, mProfile)) Complete (res As Map)
		Return res
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"UPDATE_ADMIN: ${LastException.message}"$)
		Return Null
	End Try
End Sub



'Removes the key and value mapped to this key.
'<code>
'Dim b As Boolean = BANano.Await(pb.DELETE_USER("a"))
'</code>
Sub DELETE_USER(sId As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${UsersCollectionName}.DELETE_USER(${sId})"$)
	End If
	If Schema.Size = 0 Then
		If B4XDaisyApp.DebugLogs Then Log($"B4XDaisyPocketBase.DELETE_USER: ${sTableName} - please execute SchemaAdd first to define your table schema!"$)
		Return False
	End If
	Try
		Wait For (ApiDelete($"${baseURL}/api/collections/${UsersCollectionName}/records/${sId}"$)) Complete (r As Boolean)
		Return r
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"DELETE_USER: ${LastException.message}"$)
		Return False
	End Try
End Sub

'Removes the key and value mapped to this key.
'<code>
'Dim b As Boolean = BANano.Await(pb.DELETE_ADMIN("a"))
'</code>
Sub DELETE_ADMIN(sId As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.DELETE_ADMIN(${sId})"$)
	End If
	If Schema.Size = 0 Then
		If B4XDaisyApp.DebugLogs Then Log($"B4XDaisyPocketBase.DELETE_ADMIN: ${sTableName} - please execute SchemaAdd first to define your table schema!"$)
		Return False
	End If
	Try
		Dim url As String
		If Upgrade Then
			url = $"${baseURL}/api/collections/_superusers/records/${sId}"$
		Else
			url = $"${baseURL}/api/admins/${sId}"$
		End If
		Wait For (ApiDelete(url)) Complete (r As Boolean)
		Return r
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"DELETE_ADMIN: ${LastException.message}"$)
		Return False
	End Try
End Sub

'Removes the key and value mapped to this key.
'<code>
'Dim b As Boolean = BANano.Await(pb.DELETE_COLLECTION("a"))
'</code>
Sub DELETE_COLLECTION(sColName As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.DELETE_COLLECTION(${sColName})"$)
	End If
	Try
		SetAuthorizationBearerToken(UserToken)
		Dim url As String = $"/api/collections/${sColName}"$
		Wait For (ApiDelete(url)) Complete (r As Boolean)
		Return r
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"DELETE_COLLECTION: ${LastException.message}"$)
		Return False
	End Try
End Sub

'<code>
'dim pemail As string = pb.UserProfile.email
'dim vEmail as Map = banano.await(pb.USER_REQUEST_VERIFICATION(pemail))
'</code>
Sub USER_REQUEST_VERIFICATION(sEmail As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${UsersCollectionName}.USER_REQUEST_VERIFICATION(${sEmail})"$)
	End If
	Try
		Dim body As Map = CreateMap()
		body.Put("email", sEmail)
		Dim url As String = $"${baseURL}/api/collections/${UsersCollectionName}/request-verification"$
		Wait For (ApiPost(url, body)) Complete (res As Map)
		Return res
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"USER_REQUEST_VERIFICATION: ${LastException.message}"$)
		Return Null
	End Try
End Sub

'<code>
'dim pemail As string = pb.UserProfile.email
'dim vEmail as Boolean = banano.await(pb.USER_REQUEST_PASSWORD_RESET(pemail))
'If vEmail = False Then
'	app.ShowSwalErrorToast("Password reset could not be requested!",1000)
'	Return
'End If
'app.ShowSwalSuccessToast("Password reset request sent!",1000)
'</code>
Sub USER_REQUEST_PASSWORD_RESET(sEmail As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${UsersCollectionName}.USER_REQUEST_PASSWORD_RESET(${sEmail})"$)
	End If

	Try
		Dim body As Map = CreateMap()
		body.Put("email", sEmail)
		Dim url As String = $"${baseURL}/api/collections/${UsersCollectionName}/request-password-reset"$
		Wait For (ApiPost(url, body)) Complete (res As Map)
		Return res.IsInitialized And res.ContainsKey("error") = False
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"USER_REQUEST_PASSWORD_RESET: ${LastException.message}"$)
		Return False
	End Try
End Sub

'<code>
'dim pemail As string = pb.UserProfile.email
'dim vEmail as Map = banano.await(pb.USER_REQUEST_EMAIL_CHANGE(pemail))
'</code>
Sub USER_REQUEST_EMAIL_CHANGE(sEmail As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${UsersCollectionName}.USER_REQUEST_EMAIL_CHANGE(${sEmail})"$)
	End If
	Try
		Dim body As Map = CreateMap()
		body.Put("newEmail", sEmail)
		Dim url As String = $"${baseURL}/api/collections/${UsersCollectionName}/request-email-change"$
		Wait For (ApiPost(url, body)) Complete (res As Map)
		Return res
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"USER_REQUEST_EMAIL_CHANGE: ${LastException.message}"$)
		Return Null
	End Try
End Sub

'<code>
'dim vEmail as Map = banano.await(pb.USER_CONFIRM_EMAIL_CHANGE(pToken, pEmail))
'</code>
Sub USER_CONFIRM_EMAIL_CHANGE(sToken As String, sEmail As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${UsersCollectionName}.USER_CONFIRM_EMAIL_CHANGE(${sEmail})"$)
	End If

	Try
		Dim body As Map = CreateMap()
		body.Put("token", sToken)
		body.Put("email", sEmail)
		Dim url As String = $"${baseURL}/api/collections/${UsersCollectionName}/confirm-email-change"$
		Wait For (ApiPost(url, body)) Complete (res As Map)
		Return res
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"USER_CONFIRM_EMAIL_CHANGE: ${LastException.message}"$)
		Return Null
	End Try
End Sub


'<code>
'dim pToken As string = "xxx"
'dim vEmail as Map = banano.await(pb.USER_CONFIRM_VERIFICATION(pToken))
'</code>
Sub USER_CONFIRM_VERIFICATION(sToken As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${UsersCollectionName}.USER_CONFIRM_VERIFICATION"$)
	End If
	Try
		Dim body As Map = CreateMap()
		body.Put("token", sToken)
		Dim url As String = $"${baseURL}/api/collections/${UsersCollectionName}/confirm-verification"$
		Wait For (ApiPost(url, body)) Complete (res As Map)
		Return res
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"USER_CONFIRM_VERIFICATION: ${LastException.message}"$)
		Return Null
	End Try
End Sub

'<code>
'dim vEmail as Map = banano.await(pb.USER_CONFIRM_PASSWORD_RESET(pToken, pPass, pConfirmPass))
'</code>
Sub USER_CONFIRM_PASSWORD_RESET(sToken As String, sNewPassword As String, sConfimPassword As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${UsersCollectionName}.USER_CONFIRM_PASSWORD_RESET"$)
	End If
	Try
		Dim body As Map = CreateMap()
		body.Put("token", sToken)
		body.Put("password", sNewPassword)
		body.Put("confirmPassword", sConfimPassword)
		Dim url As String = $"${baseURL}/api/collections/${UsersCollectionName}/confirm-password-reset"$
		Wait For (ApiPost(url, body)) Complete (res As Map)
		Return res
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"USER_CONFIRM_PASSWORD_RESET: ${LastException.message}"$)
		Return Null
	End Try
End Sub

'<code>
'banano.await(pb.USER_AUTH_WITH_PASSWORD(pemail, pwd))
'Dim up As profileType = pb.UserProfile
'If up.Size = 0 then
'Else
'End if 
'</code>
Sub USER_AUTH_WITH_PASSWORD(sEmail As String, sPwd As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${UsersCollectionName}.USER_AUTH_WITH_PASSWORD(${sEmail})"$)
	End If
	UserProfile.Initialize
	UserProfile.size = 0
	IsAuthenticated = False
	UserRecord = CreateMap()
	UserToken = ""
	UserModel = CreateMap()
	UserValid = False
	Try
		Dim body As Map = CreateMap()
		body.Put("identity", sEmail)
		body.Put("password", sPwd)
		Dim url As String = $"${baseURL}/api/collections/${UsersCollectionName}/auth-with-password"$
		Wait For (ApiPost(url, body)) Complete (res As Map)
		UserToken = res.GetDefault("token", "")
		UserProfile.token = UserToken
		If res.ContainsKey("record") Then
			UserRecord = res.Get("record")
			UserModel = UserRecord
			UserValid = True
			IsAuthenticated = True
			UserProfile.id = GetRecursive(res, "record.id")
			UserProfile.email = GetRecursive(res, "record.email")
			UserProfile.avatar = GetRecursive(res, "record.avatar")
			UserProfile.name = GetRecursive(res, "record.name")
			UserProfile.verified = GetRecursive(res, "record.verified")
			UserProfile.username = GetRecursive(res, "record.username")
			UserProfile.idnumber = GetRecursive(res, "record.idnumber")
			UserProfile.size = 7
		End If
		Return res
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"USER_AUTH_WITH_PASSWORD: ${LastException.message}"$)
		Return Null
	End Try
End Sub

'<code>
'banano.await(pb.USER_AUTH_REFRESH(pemail, pwd))
'dim up As profileType = pb.UserProfile
'if up.size = 0 then
'else
'end if
'</code>
Sub USER_AUTH_REFRESH As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${UsersCollectionName}.USER_AUTH_REFRESH"$)
	End If
	UserProfile.Initialize
	UserProfile.size = 0
	Try
		Dim url As String = $"${baseURL}/api/collections/${UsersCollectionName}/auth-refresh"$
		Wait For (ApiPost(url, CreateMap())) Complete (res As Map)
		UserToken = res.GetDefault("token", UserToken)
		UserProfile.token = UserToken
		If res.ContainsKey("record") Then
			UserRecord = res.Get("record")
			UserModel = UserRecord
			UserValid = True
			IsAuthenticated = True
			UserProfile.id = GetRecursive(res, "record.id")
			UserProfile.email = GetRecursive(res, "record.email")
			UserProfile.avatar = GetRecursive(res, "record.avatar")
			UserProfile.name = GetRecursive(res, "record.name")
			UserProfile.verified = GetRecursive(res, "record.verified")
			UserProfile.username = GetRecursive(res, "record.username")
			UserProfile.idnumber = GetRecursive(res, "record.idnumber")
			UserProfile.size = 7
		End If
		Return res
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"USER_AUTH_REFRESH: ${LastException.message}"$)
		Return Null
	End Try
End Sub


'<code>
'banano.await(pb.ADMIN_AUTH_WITH_PASSWORD(pemail, pwd))
'Dim up As profileType = pb.UserProfile
'If up.Size = 0 then
'Else
'End if 
'</code>
Sub ADMIN_AUTH_WITH_PASSWORD(sEmail As String, sPwd As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.ADMIN_AUTH_WITH_PASSWORD(${sEmail})"$)
	End If
	UserProfile.Initialize
	UserProfile.size = 0
	IsAuthenticated = False
	UserToken =  ""
	UserModel = CreateMap()
	UserValid = False
	Try
		Dim body As Map = CreateMap()
		body.Put("identity", sEmail)
		body.Put("password", sPwd)
		Dim url As String = $"${baseURL}/api/admins/auth-with-password"$
		Wait For (ApiPost(url, body)) Complete (res As Map)
		UserToken = res.GetDefault("token", "")
		UserProfile.token = UserToken
		SetAuthorizationBearerToken(UserToken)
		Dim recKey As String
		If Upgrade Then
			recKey = "record"
		Else
			recKey = "admin"
		End If
		If res.ContainsKey(recKey) Then
			UserRecord = res.Get(recKey)
			UserModel = UserRecord
			UserValid = True
			IsAuthenticated = True
			UserProfile.id = GetRecursive(res, $"{recKey}.id"$)
			UserProfile.email = GetRecursive(res, $"{recKey}.email"$)
			UserProfile.avatar = GetRecursive(res, $"{recKey}.avatar"$)
			UserProfile.name = GetRecursive(res, $"{recKey}.name"$)
			UserProfile.verified = GetRecursive(res, $"{recKey}.verified"$)
			UserProfile.username = GetRecursive(res, $"{recKey}.username"$)
			UserProfile.idnumber = GetRecursive(res, $"{recKey}.idnumber"$)
			UserProfile.size = 7
		End If
		Return res
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"ADMIN_AUTH_WITH_PASSWORD: ${LastException.message}"$)
		Return Null
	End Try
End Sub

'<code>
'dim pemail As string = pb.UserProfile.email
'dim vEmail as Boolean = banano.await(pb.ADMIN_REQUEST_PASSWORD_RESET(pemail))
'If vEmail = False Then
'	app.ShowSwalErrorToast("Password reset could not be requested!",1000)
'	Return
'End If
'app.ShowSwalSuccessToast("Password reset request sent!",1000)
'</code>
Sub ADMIN_REQUEST_PASSWORD_RESET(sEmail As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.ADMIN_REQUEST_PASSWORD_RESET(${sEmail})"$)
	End If
	Try
		Dim body As Map = CreateMap()
		body.Put("email", sEmail)
		Dim url As String
		If Upgrade Then
			url = $"${baseURL}/api/collections/_superusers/request-password-reset"$
		Else
			url = $"${baseURL}/api/admins/request-password-reset"$
		End If
		Wait For (ApiPost(url, body)) Complete (res As Map)
		Return res.IsInitialized And res.ContainsKey("error") = False
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"ADMIN_REQUEST_PASSWORD_RESET: ${LastException.message}"$)
		Return False
	End Try
End Sub

'<code>
'dim vEmail as Map = banano.await(pb.USER_CONFIRM_PASSWORD_RESET(pToken, pPass, pConfirmPass))
'</code>
Sub ADMIN_CONFIRM_PASSWORD_RESET(sToken As String, sNewPassword As String, sConfimPassword As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.ADMIN_CONFIRM_PASSWORD_RESET"$)
	End If
	Try
		Dim body As Map = CreateMap()
		body.Put("token", sToken)
		body.Put("password", sNewPassword)
		body.Put("confirmPassword", sConfimPassword)
		Dim url As String
		If Upgrade Then
			url = $"${baseURL}/api/collections/_superusers/confirm-password-reset"$
		Else
			url = $"${baseURL}/api/admins/confirm-password-reset"$
		End If
		Wait For (ApiPost(url, body)) Complete (res As Map)
		Return res
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"ADMIN_CONFIRM_PASSWORD_RESET: ${LastException.message}"$)
		Return Null
	End Try
End Sub


'<code>
'banano.await(pb.ADMIN_AUTH_REFRESH(pemail, pwd))
'Dim up As profileType = pb.UserProfile
'if up.size = 0 then
'else
'end if
'</code>
Sub ADMIN_AUTH_REFRESH As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.ADMIN_AUTH_REFRESH"$)
	End If
	UserProfile.Initialize
	UserProfile.size = 0
	UserModel = CreateMap()
	UserValid = False
	Try
		Dim url As String = $"${baseURL}/api/admins/auth-refresh"$
		Wait For (ApiPost(url, CreateMap())) Complete (res As Map)
		UserToken = res.GetDefault("token", UserToken)
		UserProfile.token = UserToken
		SetAuthorizationBearerToken(UserToken)
		Dim recKey As String
		If Upgrade Then
			recKey = "record"
		Else
			recKey = "admin"
		End If
		If res.ContainsKey(recKey) Then
			UserRecord = res.Get(recKey)
			UserModel = UserRecord
			UserValid = True
			IsAuthenticated = True
			UserProfile.id = GetRecursive(res, $"{recKey}.id"$)
			UserProfile.email = GetRecursive(res, $"{recKey}.email"$)
			UserProfile.avatar = GetRecursive(res, $"{recKey}.avatar"$)
			UserProfile.name = GetRecursive(res, $"{recKey}.name"$)
			UserProfile.verified = GetRecursive(res, $"{recKey}.verified"$)
			UserProfile.username = GetRecursive(res, $"{recKey}.username"$)
			UserProfile.idnumber = GetRecursive(res, $"{recKey}.idnumber"$)
			UserProfile.size = 7
		End If
		Return res
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"ADMIN_AUTH_REFRESH: ${LastException.message}"$)
		Return Null
	End Try
End Sub

'create the batch instance (requires shim batch endpoint; set UseBatch=True after deploying)
Sub BATCH_CREATE
	If ShowLog Then
		Log($"B4XDaisyPocketBase.BATCH_CREATE"$)
	End If
	batchRequests.Initialize
End Sub

'send the batch (requires shim batch endpoint; set UseBatch=True after deploying)
Sub BATCH_SEND As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.BATCH_SEND"$)
	End If
	If Not(UseBatch) Then
		If B4XDaisyApp.DebugLogs Then Log("B4XDaisyPocketBase.BATCH_SEND: skipped (UseBatch=False, /api/batch not available)")
		Return CreateMap("skipped": True, "reason": "UseBatch=False")
	End If
	Dim body As Map = CreateMap("requests": batchRequests)
	Wait For (ApiPost("/api/batch", body)) Complete (res As Map)
	Return res
End Sub

'add a create command to the batch
Sub BATCH_ADD_CREATE
	If ShowLog Then
		Log($"B4XDaisyPocketBase.BATCH_ADD_CREATE"$)
	End If
	If Not(UseBatch) Then Return
	Dim req As Map = CreateMap()
	req.Put("method", "POST")
	req.Put("url", $"/api/collections/${sTableName}/records"$)
	req.Put("body", MapDeepClone(Record))
	batchRequests.Add(req)
End Sub
'
'add an upsert command to the batch
Sub BATCH_ADD_UPSERT
	If ShowLog Then
		Log($"B4XDaisyPocketBase.BATCH_ADD_UPSERT"$)
	End If
	If Not(UseBatch) Then Return
	Dim sid As String = Record.GetDefault("id", "")
	Dim req As Map = CreateMap()
	If sid <> "" Then
		req.Put("method", "PUT")
		req.Put("url", $"/api/collections/${sTableName}/records/${sid}"$)
	Else
		req.Put("method", "POST")
		req.Put("url", $"/api/collections/${sTableName}/records"$)
	End If
	req.Put("body", MapDeepClone(Record))
	batchRequests.Add(req)
End Sub

'add an update call to the batch
Sub BATCH_ADD_UPDATE
	If ShowLog Then
		Log($"B4XDaisyPocketBase.BATCH_ADD_UPDATE"$)
	End If
	If Not(UseBatch) Then Return
	Dim sid As String = Record.Get(PrimaryKey)
	Dim req As Map = CreateMap()
	req.Put("method", "PATCH")
	req.Put("url", $"/api/collections/${sTableName}/records/${sid}"$)
	req.Put("body", MapDeepClone(Record))
	batchRequests.Add(req)
End Sub

'add a delete command to the batch
Sub BATCH_ADD_DELETE
	If ShowLog Then
		Log($"B4XDaisyPocketBase.BATCH_ADD_DELETE"$)
	End If
	If Not(UseBatch) Then Return
	Dim sid As String = Record.Get(PrimaryKey)
	Dim req As Map = CreateMap()
	req.Put("method", "DELETE")
	req.Put("url", $"/api/collections/${sTableName}/records/${sid}"$)
	batchRequests.Add(req)
End Sub


Sub USER_SIGNOUT
	If ShowLog Then
		Log($"B4XDaisyPocketBase.USER_SIGNOUT"$)
	End If
	'Native: clear local auth state (no server call).
	UserProfile.Initialize
	UserProfile.size = 0
	UserToken = ""
	UserModel = CreateMap()
	UserValid = False
	UserRecord = CreateMap()
	IsAuthenticated = False
End Sub

Sub USER_TOKEN As String
	If ShowLog Then
		Log($"B4XDaisyPocketBase.USER_TOKEN"$)
	End If
	Return UserToken
End Sub

Sub USER_MODEL As String
	If ShowLog Then
		Log($"B4XDaisyPocketBase.USER_MODEL"$)
	End If
	Return Map2Json(UserModel)
End Sub

Sub USER_ISVALID As Boolean
	If ShowLog Then
		Log($"B4XDaisyPocketBase.USER_ISVALID"$)
	End If
	Return UserValid
End Sub

'convert schema to pocketbase like schema
Sub SchemaToPocketBase As Map
	Dim nl As List
	nl.Initialize
	For Each k As String In Schema.Keys
		Dim v As String = Schema.Get(k)
		Select Case v
			Case DB_BOOL
				nl.Add(CreateMap("name":k, "type":"bool"))
			Case DB_INT, DB_REAL, DB_REAL, DB_FLOAT, DB_INTEGER, DB_DOUBLE, DB_NUMBER
				nl.Add(CreateMap("name":k, "type":"number"))
			Case DB_FILE, DB_BLOB
				nl.Add(CreateMap("name":k, "type":"file"))
			Case DB_STRING, DB_TEXT, DB_LONGTEXT
				nl.Add(CreateMap("name":k, "type":"text"))
			Case DB_RELATION
				nl.Add(CreateMap("name":k, "type":"relation"))
			Case DB_JSON
				nl.Add(CreateMap("name":k, "type":"json"))
			Case DB_DATE
				nl.Add(CreateMap("name":k, "type":"date"))
			Case Else
				nl.Add(CreateMap("name":k, "type":"text"))
		End Select
	Next
	Return nl
End Sub

'<code>
'Dim dbSchema As B4XDaisyPocketBase
'dbSchema.Initialize(Me, "dbSchema", "http://127.0.0.1:8090", "")
'Dim bres As Boolean = BANano.Await(dbSchema.SchemaRestoreFromAsset("./assets/minicrm_schema.json", "adminemail", "adminpassword"))
'</code>
Sub SchemaRestoreFromAsset(sSassetFile As String, sSemail As String, sSpassword As String) As ResumableSub
	Try
		Dim jsonStr As String = File.ReadString(File.DirAssets, sSassetFile)
		Dim collections As List = Json2List(jsonStr)
		Wait For (SchemaRestore(baseURL, sSemail, sSpassword, collections)) Complete (bres As Boolean)
		Return bres
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"SchemaRestoreFromAsset: ${LastException.message}"$)
		Return False
	End Try
End Sub

'<code>
'Dim dbSchema As B4XDaisyPocketBase
'dbSchema.Initialize(Me, "dbSchema", "http://127.0.0.1:8090", "")
'Dim bres As Boolean = BANano.Await(dbSchema.SchemaAddFromAsset("./assets/update_schema.json", "adminemail", "adminpassword"))
'</code>
Sub SchemaAddFromAsset(sSassetFile As String, sSemail As String, sSpassword As String) As ResumableSub
	Try
		Dim jsonStr As String = File.ReadString(File.DirAssets, sSassetFile)
		Dim collections As List = Json2List(jsonStr)
		Wait For (SchemaAdd(baseURL, sSemail, sSpassword, collections)) Complete (bres As Boolean)
		Return bres
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"SchemaAddFromAsset: ${LastException.message}"$)
		Return False
	End Try
End Sub

'<code>
'Dim dbSchema As B4XDaisyPocketBase
'dbSchema.Initialize(Me, "sourceDB", surl, "")
'Dim bres As Boolean = BANano.Await(dbSchema.SchemaRestore(surl, semail, spassword, collections))
'</code>		
Sub SchemaRestore(sSurl As String, sSemail As String, sSpassword As String, lstCollections As List) As ResumableSub
	Try
		baseURL = sSurl
		Wait For (ADMIN_AUTH_WITH_PASSWORD(sSemail, sSpassword)) Complete (authRes As Map)
		Wait For (SELECT_ALL_COLLECTIONS_NAMES(sSemail, sSpassword)) Complete (tblNames As List)
		For Each collection As Map In lstCollections
			Dim sname As String = collection.Get("name")
			Dim stype As String = collection.Get("type")
			Dim lschema As List = collection.Get("schema")
			Dim screateRule As String = collection.Get("createRule")
			Dim supdateRule As String = collection.Get("updateRule")
			Dim sdeleteRule As String = collection.Get("deleteRule")
			Dim slistRule As String = collection.Get("listRule")
			Dim sviewRule As String = collection.Get("viewRule")
			Dim indexes As List = collection.Get("indexes")
			Dim options As Map = collection.Get("options")
			If tblNames.IndexOf(sname) = -1 Then
				Wait For (CREATE_COLLECTION2(sname, stype, lschema, screateRule, supdateRule, sdeleteRule, slistRule, sviewRule, indexes, options)) Complete (m1 As Map)
			Else
				Wait For (UPDATE_COLLECTION2(sname, stype, lschema, screateRule, supdateRule, sdeleteRule, slistRule, sviewRule, indexes, options)) Complete (m2 As Map)
			End If
		Next
		Return True
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"SchemaRestore: ${LastException.message}"$)
		Return False
	End Try
End Sub
'
'<code>
'Dim dbSchema As B4XDaisyPocketBase
'dbSchema.Initialize(Me, "sourceDB", surl, "")
'Dim bres As Boolean = BANano.Await(dbSchema.SchemaAdd(surl, semail, spassword, collections))
'</code>		
Sub SchemaAdd(sSurl As String, sSemail As String, sSpassword As String, lstCollections As List) As ResumableSub
	Try
		baseURL = sSurl
		Wait For (ADMIN_AUTH_WITH_PASSWORD(sSemail, sSpassword)) Complete (authRes As Map)
		Wait For (SELECT_ALL_COLLECTIONS_NAMES(sSemail, sSpassword)) Complete (tblNames As List)
		For Each collection As Map In lstCollections
			Dim sname As String = collection.Get("name")
			If tblNames.IndexOf(sname) = -1 Then
				Wait For (CREATE_COLLECTION_ORIGINAL(collection)) Complete (m As Map)
			End If
		Next
		Return True
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"SchemaAdd: ${LastException.message}"$)
		Return False
	End Try
End Sub
'
'<code>
'Dim dbSchema As B4XDaisyPocketBase
'dbSchema.Initialize(Me, "sourceDB", surl, "")
'Dim bres As Boolean = BANano.Await(dbSchema.SchemaUpdate(surl, semail, spassword, collections))
'</code>		
Sub SchemaUpdate(sSurl As String, sSemail As String, sSpassword As String, lstCollections As List) As ResumableSub
	Try
		baseURL = sSurl
		Wait For (ADMIN_AUTH_WITH_PASSWORD(sSemail, sSpassword)) Complete (authRes As Map)
		Wait For (SELECT_ALL_COLLECTIONS_NAMES(sSemail, sSpassword)) Complete (tblNames As List)
		For Each collection As Map In lstCollections
			Dim sname As String = collection.Get("name")
			If tblNames.IndexOf(sname) <> -1 Then
				Wait For (UPDATE_COLLECTION_ORIGINAL(collection)) Complete (m As Map)
			End If
		Next
		Return True
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"SchemaUpdate: ${LastException.message}"$)
		Return False
	End Try
End Sub


'<code>
'Dim dbSchema As B4XDaisyPocketBase
'dbSchema.Initialize(Me, "dbSchema", modSDPB.ServerLocation, "")
'Dim bres As Boolean = BANano.Await(dbSchema.SchemaBackUp(sname, surl, semail, spassword))
'</code>
Sub SchemaBackUp(sPrjName As String, sSurl As String, sSemail As String, sSpassword As String) As ResumableSub
	Try
		baseURL = sSurl
		Wait For (ADMIN_AUTH_WITH_PASSWORD(sSemail, sSpassword)) Complete (authRes As Map)
		Wait For (SELECT_ALL_COLLECTIONS(sSemail, sSpassword)) Complete (tblNames As List)
		Dim prjTables As Map = CreateMap()
		prjTables.Put("name", sPrjName)
		prjTables.Put("collections", tblNames)
		Dim prjTablesJSON As String = Map2Json(prjTables)
		Download(prjTablesJSON, sPrjName & "_schema.json")
		Return True
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"SchemaBackUp: ${LastException.message}"$)
		Return False
	End Try
End Sub
'
Sub Download (sContent As String, sFileName As String)
	If B4XDaisyApp.DebugLogs Then Log("Download: " & sFileName)
	Try
		File.WriteString(File.DirInternal, sFileName, sContent)
	Catch
		If B4XDaisyApp.DebugLogs Then Log("Download error: " & LastException.message)
	End Try
End Sub
Sub SetRecordAsIs(mRec As Map)
	Record.Initialize
	For Each k As String In mRec.Keys
		Dim v As Object = mRec.get(k)
		Record.put(k, v)
	Next
	DisplayValue = Record.GetDefault(DisplayField, "")
	If ShowLog Then
		Log($"B4XDaisyPocketBase.SetRecordAsIs(${Map2Json(Record)})"$)
	End If
End Sub


'<code>
'Dim dbSchema As B4XDaisyPocketBase
'dbSchema.Initialize(Me, "dbSchema", modSDPB.ServerLocation, "")
'Dim schema As List = BANano.Await(dbSchema.SchemaGet(sname, surl, semail, spassword))
'</code>
Sub SchemaGet(sPrjName As String, sSurl As String, sSemail As String, sSpassword As String) As ResumableSub
	Dim allCols As List
	allCols.Initialize
	Try
		baseURL = sSurl
		Wait For (ADMIN_AUTH_WITH_PASSWORD(sSemail, sSpassword)) Complete (authRes As Map)
		Wait For (SELECT_ALL_COLLECTIONS(sSemail, sSpassword)) Complete (tblNames As List)
		Return tblNames
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"SchemaGet: ${LastException.message}"$)
		Return allCols
	End Try
End Sub
Sub SchemaTableGet(sFtblName As String, sSurl As String, sSemail As String, sSpassword As String) As ResumableSub
	Dim emptyMap As Map = CreateMap()
	Try
		baseURL = sSurl
		Wait For (ADMIN_AUTH_WITH_PASSWORD(sSemail, sSpassword)) Complete (authRes As Map)
		Wait For (SELECT_ALL_COLLECTIONS(sSemail, sSpassword)) Complete (tblNames As List)
		For Each tbl As Map In tblNames
			Dim sname As String = tbl.Get("name")
			If sname = sFtblName Then Return tbl
		Next
		Return emptyMap
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"SchemaTableGet: ${LastException.message}"$)
		Return emptyMap
	End Try
End Sub

'moveStart
'<code>
'rs.MoveStart
'Do while rs.NextRow
'Loop
'</code>
Sub MoveStart
	lastPosition = -1
End Sub

Sub SetNextID
	Dim nid As String = NextID
	SetField("id", nid)
End Sub

Sub ADD_ORDER_BY_UPDATED_AT As B4XDaisyPocketBase
	ADD_ORDER_BY("updated")
	Return Me
End Sub

Sub ADD_ORDER_BY_CREATED_AT As B4XDaisyPocketBase
	ADD_ORDER_BY("created")
	Return Me
End Sub

Sub USER_REVOKE_GOOGLE_TOKEN
	' OAuth2 Google token revoke not supported in native B4A v1 (needs custom-tabs redirect handler).
	If B4XDaisyApp.DebugLogs Then Log("B4XDaisyPocketBase.USER_REVOKE_GOOGLE_TOKEN: not supported in native B4A v1.")
End Sub


'<code>
'Dim authData As Map = Banano.Await(pb.USERS_AUTH_WITH_GOOGLE)
'</code>
Sub USER_AUTH_WITH_GOOGLE As ProfileType
	' OAuth2 Google auth not supported in native B4A v1 (needs custom-tabs redirect handler).
	If ShowLog Then
		Log($"B4XDaisyPocketBase.${UsersCollectionName}.USER_AUTH_WITH_GOOGLE: not supported in native B4A v1."$)
	End If
	UserProfile.Initialize
	UserProfile.size = 0
	IsAuthenticated = False
	Return UserProfile
End Sub

Sub SchemaClear
	Schema.initialize
End Sub

Sub RemoveField(sFldName As String)
	If Record.ContainsKey(sFldName) Then
		Record.Remove(sFldName)
	End If
End Sub

'<code>
'pbComponents.SELECT_TO_VIEW("viewname")
'pbComponents.SELECT_VIEW("viewname")
'Do While pbComponents.NextRow
'Dim rec As Map = pbComponents.Record
'Dim sid As String = pbComponents.GetString("id")
'Loop
'</code>
Sub SELECT_TO_VIEW(sNameOf As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.SELECT_TO_VIEW(${sNameOf})"$)
	End If
	Try
		SetAuthorizationBearerToken(UserToken)
		Dim sb As StringBuilder
		sb.Initialize
		sb.Append("SELECT ")
		Dim fldm As Map = CreateMap()
		If flds.Size > 0 Then
			For Each k As String In flds
				Dim v As String = Schema.GetDefault(k, "STRING")
				fldm.Put(k, v)
			Next
		Else
			fldm = MapDeepClone(Schema)
		End If
		Dim bHasID As Boolean = False
		Dim fldnames As List
		fldnames.Initialize
		For Each k As String In fldm.Keys
			fldnames.Add(k)
			If k = "id" Then bHasID = True
		Next
		If bHasID = False Then
			sb.Append("id,")
		End If
		sb.Append(Join(",", fldnames))
		If CountRecords Then
			sb.Append($", count(*) as records"$)
		End If
		sb.Append($" FROM ${sTableName}"$)
		Dim iWhere As Int = whereField.Size - 1
		If iWhere >= 0 Then
			sb.Append(" WHERE ")
			Dim whr As List
			whr.Initialize
			Dim i As Int
			For i = 0 To iWhere
				Dim colx As String = whereField.GetKeyAt(i)
				colx = MvField(colx, 1,".")
				colx = colx.replace("&","")
				Dim xVal As String = whereField.GetValueAt(i)
				Dim opr As String = ops.Get(i)
				Dim com As String = combineL.Get(i)
				If com = "&&" Then com = "AND"
				If com = "||" Then com = "OR"
				If opr = "!=" Then opr = "<>"
				If opr = "~" Then opr = "like"
				whr.Add($"${colx} ${opr} ${xVal} ${com}"$)
			Next
			Dim swhere As String = Join(" ", whr)
			swhere = RemDelim(swhere, com).trim
			sb.Append(swhere)
		End If
		If grpBy.Size > 0 Then
			Dim sgroup As String = Join(",", grpBy)
			sb.Append($" group by ${sgroup}"$)
		End If
		If orderByL.Size > 0 Then
			Dim lorder As List
			lorder.Initialize
			For Each k As String In orderByL
				If k.StartsWith("-") Then
					k = k.Replace("-", "")
					lorder.Add($"${k} desc"$)
				Else
					lorder.Add(k)
				End If
			Next
			Dim sorder As String = Join(",", lorder)
			sb.Append($" order by ${sorder}"$)
		End If
		Dim sout As String = sb.tostring
		Dim col As Map = CreateMap()
		col.Put("name", sNameOf)
		col.Put("type", "view")
		col.Put("system", False)
		col.Put("listRule", "")
		col.Put("viewRule", "")
		col.Put("createRule", Null)
		col.Put("updateRule", Null)
		col.Put("deleteRule", Null)
		PutRecursive(col, "options.query", sout)
		Dim opt As Map = CreateMap()
		If headers.Size > 0 Then opt.Put("headers", headers)
		Wait For (ApiPost("/api/collections", col)) Complete (res As Map)
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"SELECT_TO_VIEW: ${LastException.message}"$)
		Return
	End Try
End Sub

'<code>
'pbComponents.SELECT_TO_VIEW_ONLY("viewname")
'pbComponents.SELECT_VIEW("viewname")
'</code>
Sub SELECT_TO_VIEW_ONLY(sNameOf As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.SELECT_TO_VIEW_ONLY(${sNameOf})"$)
	End If
	Wait For (DELETE_COLLECTION(sNameOf)) Complete (rDel As Boolean)
	Try
		SetAuthorizationBearerToken(UserToken)
		Dim sb As StringBuilder
		sb.Initialize
		sb.Append("SELECT ")
		Dim fldm As Map = CreateMap()
		If flds.Size > 0 Then
			For Each k As String In flds
				Dim v As String = Schema.GetDefault(k, "STRING")
				fldm.Put(k, v)
			Next
		Else
			fldm = MapDeepClone(Schema)
		End If
		Dim bHasID As Boolean = False
		Dim fldnames As List
		fldnames.Initialize
		For Each k As String In fldm.Keys
			fldnames.Add(k)
			If k = "id" Then bHasID = True
		Next
		If bHasID = False Then
			sb.Append("id,")
		End If
		sb.Append(Join(",", fldnames))
		If CountRecords Then
			sb.Append($", count(*) as records"$)
		End If
		sb.Append($" FROM ${sTableName}"$)
		Dim iWhere As Int = whereField.Size - 1
		If iWhere >= 0 Then
			sb.Append(" WHERE ")
			Dim whr As List
			whr.Initialize
			Dim i As Int
			For i = 0 To iWhere
				Dim colx As String = whereField.GetKeyAt(i)
				colx = MvField(colx, 1,".")
				colx = colx.replace("&","")
				Dim xVal As String = whereField.GetValueAt(i)
				Dim opr As String = ops.Get(i)
				Dim com As String = combineL.Get(i)
				If com = "&&" Then com = "AND"
				If com = "||" Then com = "OR"
				If opr = "!=" Then opr = "<>"
				If opr = "~" Then opr = "like"
				whr.Add($"${colx} ${opr} ${xVal} ${com}"$)
			Next
			Dim swhere As String = Join(" ", whr)
			swhere = RemDelim(swhere, com).trim
			sb.Append(swhere)
		End If
		If grpBy.Size > 0 Then
			Dim sgroup As String = Join(",", grpBy)
			sb.Append($" group by ${sgroup}"$)
		End If
		If orderByL.Size > 0 Then
			Dim lorder As List
			lorder.Initialize
			For Each k As String In orderByL
				If k.StartsWith("-") Then
					k = k.Replace("-", "")
					lorder.Add($"${k} desc"$)
				Else
					lorder.Add(k)
				End If
			Next
			Dim sorder As String = Join(",", lorder)
			sb.Append($" order by ${sorder}"$)
		End If
		Dim sout As String = sb.tostring
		Dim col As Map = CreateMap()
		col.Put("name", sNameOf)
		col.Put("type", "view")
		col.Put("system", False)
		col.Put("listRule", "")
		col.Put("viewRule", "")
		col.Put("createRule", Null)
		col.Put("updateRule", Null)
		col.Put("deleteRule", Null)
		PutRecursive(col, "options.query", sout)
		Dim opt As Map = CreateMap()
		If headers.Size > 0 Then opt.Put("headers", headers)
		Wait For (ApiPost("/api/collections", col)) Complete (res As Map)
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"SELECT_TO_VIEW_ONLY: ${LastException.message}"$)
		Return
	End Try
End Sub

Sub orderBy(lstFldNames As List) As B4XDaisyPocketBase
	For Each k As String In lstFldNames
		ADD_ORDER_BY(k)
	Next
	Return Me
End Sub

Sub groupBy(lstFldNames As List) As B4XDaisyPocketBase
	ADD_GROUP_BY(lstFldNames)
	Return Me
End Sub

Sub orderByDesc(lstFldNames As List) As B4XDaisyPocketBase
	For Each k As String In lstFldNames
		ADD_ORDER_BY_DESC(k)
	Next
	Return Me
End Sub

'this executes a clear_where first
Sub selectFields(lstFldNames As List) As B4XDaisyPocketBase
	CLEAR_WHERE
	ADD_FIELDS(lstFldNames)
	Return Me
End Sub

Sub whereEqual(sFldName As String, oFldValue As Object) As B4XDaisyPocketBase
	ADD_WHERE_STRING(sFldName, "=", oFldValue)
	Return Me
End Sub

Sub OrWhereEqual(sFldName As String, oFldValue As Object) As B4XDaisyPocketBase
	ADD_OR_WHERE_STRING(sFldName, "=", oFldValue)
	Return Me
End Sub

Sub whereGreaterThan(sFldName As String, oFldValue As Object) As B4XDaisyPocketBase
	ADD_WHERE_STRING(sFldName, ">", oFldValue)
	Return Me
End Sub

Sub OrWhereGreaterThan(sFldName As String, oFldValue As Object) As B4XDaisyPocketBase
	ADD_OR_WHERE_STRING(sFldName, ">", oFldValue)
	Return Me
End Sub

Sub whereGreaterThanEqualTo(sFldName As String, oFldValue As Object) As B4XDaisyPocketBase
	ADD_WHERE_STRING(sFldName, ">=", oFldValue)
	Return Me
End Sub

Sub OrWhereGreaterThanEqualTo(sFldName As String, oFldValue As Object) As B4XDaisyPocketBase
	ADD_OR_WHERE_STRING(sFldName, ">=", oFldValue)
	Return Me
End Sub

Sub whereLike(sFldName As String, oFldValue As Object) As B4XDaisyPocketBase
	ADD_WHERE_STRING(sFldName, "~", oFldValue)
	Return Me
End Sub

Sub OrWhereLike(sFldName As String, oFldValue As Object) As B4XDaisyPocketBase
	ADD_OR_WHERE_STRING(sFldName, "~", oFldValue)
	Return Me
End Sub

Sub whereNotLike(sFldName As String, oFldValue As Object) As B4XDaisyPocketBase
	ADD_WHERE_STRING(sFldName, "!~", oFldValue)
	Return Me
End Sub

Sub OrWhereNotLike(sFldName As String, oFldValue As Object) As B4XDaisyPocketBase
	ADD_OR_WHERE_STRING(sFldName, "!~", oFldValue)
	Return Me
End Sub

Sub whereLessThanEqualTo(sFldName As String, oFldValue As Object) As B4XDaisyPocketBase
	ADD_WHERE_STRING(sFldName, "<=", oFldValue)
	Return Me
End Sub

Sub OrWhereLessThanEqualTo(sFldName As String, oFldValue As Object) As B4XDaisyPocketBase
	ADD_OR_WHERE_STRING(sFldName, "<=", oFldValue)
	Return Me
End Sub

Sub whereLessThan(sFldName As String, oFldValue As Object) As B4XDaisyPocketBase
	ADD_WHERE_STRING(sFldName, "<", oFldValue)
	Return Me
End Sub

Sub OrWhereLessThan(sFldName As String, oFldValue As Object) As B4XDaisyPocketBase
	ADD_OR_WHERE_STRING(sFldName, "<", oFldValue)
	Return Me
End Sub

Sub whereBetween(sFldName As String, oFldStart As Object, oFldEnd As Object) As B4XDaisyPocketBase
	ADD_WHERE_STRING($"${sFldName}.start"$, ">=", oFldStart)
	ADD_WHERE_STRING($"${sFldName}.end"$, "<=", oFldEnd)
	Return Me
End Sub

Sub whereNotEqual(sFldName As String, oFldValue As Object) As B4XDaisyPocketBase
	ADD_WHERE_STRING(sFldName, "<>", oFldValue)
	Return Me
End Sub

Sub OrWhereNotEqual(sFldName As String, oFldValue As Object) As B4XDaisyPocketBase
	ADD_OR_WHERE_STRING(sFldName, "<>", oFldValue)
	Return Me
End Sub

Sub SetAuthorizationBearerToken(sToken As String)
	sToken = sToken.Trim
	If sToken = "" Then
		headers.remove("Authorization")
		Return
	End If
	AddHeader("Authorization", $"Bearer ${sToken}"$)
End Sub

'<code>
'pbComponents.CREATE_VIEW("viewname", "select id, name from...")
'pbComponents.SELECT_VIEW("viewname")
'Do While pbComponents.NextRow
'Dim rec As Map = pbComponents.Record
'Dim sid As String = pbComponents.GetString("id")
'Loop
'</code>
Sub CREATE_VIEW(sNameOf As String, sQry As String) As ResumableSub
	If ShowLog Then
		Log($"B4XDaisyPocketBase.CREATE_VIEW(${sNameOf})"$)
	End If
	Try
		SetAuthorizationBearerToken(UserToken)
		Dim col As Map = CreateMap()
		col.Put("name", sNameOf)
		col.Put("type", "view")
		col.Put("system", False)
		col.Put("listRule", "")
		col.Put("viewRule", "")
		col.Put("createRule", Null)
		col.Put("updateRule", Null)
		col.Put("deleteRule", Null)
		PutRecursive(col, "options.query", sQry)
		Dim opt As Map = CreateMap()
		If headers.Size > 0 Then opt.Put("headers", headers)
		Wait For (ApiPost("/api/collections", col)) Complete (res As Map)
	Catch
		If B4XDaisyApp.DebugLogs Then Log($"CREATE_VIEW: ${LastException.message}"$)
	End Try
End Sub
'--- Native Deep Cloning & Multipart Upload Helpers ---

Private Sub MapDeepClone(mMap As Map) As Map
	Dim out As Map
	out.Initialize
	If mMap.IsInitialized = False Then Return out
	For Each k As Object In mMap.Keys
		Dim v As Object = mMap.Get(k)
		If v Is Map Then
			out.Put(k, MapDeepClone(v))
		Else If v Is List Then
			out.Put(k, ListDeepClone(v))
		Else
			out.Put(k, v)
		End If
	Next
	Return out
End Sub

Private Sub ListDeepClone(lstItems As List) As List
	Dim out As List
	out.Initialize
	If lstItems.IsInitialized = False Then Return out
	For Each v As Object In lstItems
		If v Is Map Then
			out.Add(MapDeepClone(v))
		Else If v Is List Then
			out.Add(ListDeepClone(v))
		Else
			out.Add(v)
		End If
	Next
	Return out
End Sub

Private Sub ApiPostMultipart(sUrl As String, mFields As Map, lstFiles As List) As ResumableSub
	Dim j As HttpJob
	j.Initialize("pb", Me)
	Dim mpFiles As List
	mpFiles.Initialize
	If lstFiles.IsInitialized Then
		For Each fd As Map In lstFiles
			Dim mpfd As MultipartFileData
			mpfd.Initialize
			mpfd.Dir = fd.Get("Dir")
			mpfd.FileName = fd.Get("FileName")
			mpfd.KeyName = fd.Get("KeyName")
			mpfd.ContentType = fd.Get("ContentType")
			mpFiles.Add(mpfd)
		Next
	End If
	j.PostMultipart(sUrl, mFields, mpFiles)
	ApplyHeaders(j)
	Wait For (j) JobDone(j As HttpJob)
	Dim out As Map = CreateMap()
	If j.Success Then
		out = Json2Map(j.GetString)
	Else
		out = Json2Map(j.ErrorMessage)
		If out.IsInitialized = False Or out.Size = 0 Then out.Put("error", j.ErrorMessage)
		If ShowLog Then Log($"ApiPostMultipart ${sUrl} failed: ${j.ErrorMessage}"$)
	End If
	j.Release
	Return out
End Sub

Private Sub GetFileAsDataURL(sUrl As String) As ResumableSub
	Dim j As HttpJob
	j.Initialize("", Me)
	j.Download(sUrl)
	Wait For (j) JobDone(j As HttpJob)
	Dim res As String = ""
	If j.Success Then
		Try
			Dim out As OutputStream
			out.InitializeToBytesArray(0)
			File.Copy2(j.GetInputStream, out)
			Dim bytes() As Byte = out.ToBytesArray
			Dim su As StringUtils
			Dim base64 As String = su.EncodeBase64(bytes)
			res = "data:image/png;base64," & base64
		Catch
			If B4XDaisyApp.DebugLogs Then Log("GetFileAsDataURL conversion error: " & LastException.message)
		End Try
	End If
	j.Release
	Return res
End Sub

'Decode JWT token payload locally without a network call.
'Returns a Map of the claims: id, type, exp, collectionId, collectionName, etc.
'Useful to check token expiry ("exp" is Unix seconds) before making an API call.
'Ported from PocketBaseOther (Pocketbase_InternFunctions).
Public Sub GetJWTPayload(sToken As String) As Map
	Dim mresult As Map
	mresult.Initialize
	If sToken = "" Then Return mresult
	Try
		Dim parts() As String = Regex.Split("\.", sToken)
		If parts.Length < 2 Then Return result
		Dim encoded As String = parts(1)
		'Add base64 padding if needed
		Select encoded.Length Mod 4
			Case 2
				encoded = encoded & "=="
			Case 3
				encoded = encoded & "="
		End Select
		Dim su As StringUtils
		Dim b() As Byte = su.DecodeBase64(encoded)
		Dim payload As String = BytesToString(b, 0, b.Length, "UTF-8")
		Dim jp As JSONParser
		jp.Initialize(payload)
		mresult = jp.NextObject
	Catch
		If ShowLog Then Log("GetJWTPayload error: " & LastException.Message)
	End Try
	Return mresult
End Sub
