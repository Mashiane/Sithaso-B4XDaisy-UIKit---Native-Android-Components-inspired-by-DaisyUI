B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.4
@EndOfDesignText@
#IgnoreWarnings:12,9

#Region App
' Shared app-related content will live here.
Sub Process_Globals
    Private SvgTextCache As Map
    Private SvgBitmapCache As Map
    ' ponytail: FIFO cap, upgrade to access-order LRU if cache churn measured high.
    ' Bounds bitmap/text memory across long sessions. 64 entries is generous for the
    ' current SVG path set; eviction is oldest-first (Map preserves insertion order).
    Private SVG_CACHE_CAP As Int = 64
	Public DebugLogs As Boolean = False
End Sub

Private Sub EnsureSvgTextCache
    If SvgTextCache.IsInitialized = False Then SvgTextCache.Initialize
    If SvgBitmapCache.IsInitialized = False Then SvgBitmapCache.Initialize
End Sub

Public Sub ClearSvgTextCache
    EnsureSvgTextCache
    SvgTextCache.Clear
    SvgBitmapCache.Clear
End Sub

Public Sub GetCachedSvgBitmap(sKey As String) As B4XBitmap
    EnsureSvgTextCache
    If SvgBitmapCache.ContainsKey(sKey) Then
        #If DEBUG
        If DebugLogs Then Log("DaisySvgCache: bitmap hit " & sKey)
        #End If
        Return SvgBitmapCache.Get(sKey)
    End If
    #If DEBUG
    If DebugLogs Then Log("DaisySvgCache: bitmap miss " & sKey)
    #End If
    Dim nullBmp As B4XBitmap
    Return nullBmp
End Sub

Public Sub PutCachedSvgBitmap(sKey As String, bmpBmp As B4XBitmap)
    If sKey.Length = 0 Or bmpBmp.IsInitialized = False Then Return
    EnsureSvgTextCache
    SvgBitmapCache.Put(sKey, bmpBmp)
    EvictCache(SvgBitmapCache, SVG_CACHE_CAP)
End Sub

Public Sub GetCachedSvgText(sPath As String, sDefaultText As String) As String
    Dim key As String = NormalizeSvgCacheKey(sPath)
    If key.Length = 0 Then Return sDefaultText
    EnsureSvgTextCache
    If SvgTextCache.ContainsKey(key) Then
        #If DEBUG
        If DebugLogs Then Log("DaisySvgCache: text hit " & key)
        #End If
        Return SvgTextCache.Get(key)
    End If
    #If DEBUG
    If DebugLogs Then Log("DaisySvgCache: text miss " & key)
    #End If
    Dim raw As String = ReadSvgText(sPath)
    If raw.Length = 0 Then Return sDefaultText
    SvgTextCache.Put(key, raw)
    EvictCache(SvgTextCache, SVG_CACHE_CAP)
    Return raw
End Sub

' EvictCache: drops oldest entries (insertion order) until Map.Size <= Cap.
' FIFO, not true LRU. Sufficient to bound memory; revisit if a hot working set
' larger than Cap causes thrash.
Private Sub EvictCache(mCache As Map, iCap As Int)
    Do While mCache.Size > iCap
        Dim keys As List = mCache.Keys
        mCache.Remove(keys.Get(0))
    Loop
End Sub

Private Sub NormalizeSvgCacheKey(sPath As String) As String
    If sPath = Null Then Return ""
    Return sPath.Trim
End Sub

Private Sub ReadSvgText(sPath As String) As String
    If sPath = Null Then Return ""
    Dim p As String = sPath.Trim
    If p.Length = 0 Then Return ""

    Try
        Dim slash1 As Int = p.LastIndexOf("/")
        Dim slash2 As Int = p.LastIndexOf("\")
        Dim slash As Int = Max(slash1, slash2)
        Dim fn As String = p
        If slash >= 0 Then
            Dim dir As String = p.SubString2(0, slash)
            fn = p.SubString(slash + 1)
            If dir.Length > 0 And fn.Length > 0 And File.Exists(dir, fn) Then
                Return File.ReadString(dir, fn)
            End If
        End If
        If File.Exists(File.DirAssets, p) Then 
            Return File.ReadString(File.DirAssets, p)
        Else If File.Exists(File.DirAssets, fn) Then
            Return File.ReadString(File.DirAssets, fn)
        End If
    Catch
        If DebugLogs Then Log("B4XDaisyApp.ReadSvgText: " & LastException.Message)
    End Try
    Return ""
End Sub
#End Region
