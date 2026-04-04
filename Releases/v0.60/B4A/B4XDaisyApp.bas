B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.4
@EndOfDesignText@

#Region App
' Shared app-related content will live here.
Sub Process_Globals
    Private SvgTextCache As Map
End Sub

Private Sub EnsureSvgTextCache
    If SvgTextCache.IsInitialized = False Then SvgTextCache.Initialize
End Sub

Public Sub ClearSvgTextCache
    EnsureSvgTextCache
    SvgTextCache.Clear
End Sub

Public Sub GetCachedSvgText(Path As String, DefaultText As String) As String
    Dim key As String = NormalizeSvgCacheKey(Path)
    If key.Length = 0 Then Return DefaultText
    EnsureSvgTextCache
    If SvgTextCache.ContainsKey(key) Then Return SvgTextCache.Get(key)
    Dim raw As String = ReadSvgText(Path)
    If raw.Length = 0 Then Return DefaultText
    SvgTextCache.Put(key, raw)
    Return raw
End Sub

Private Sub NormalizeSvgCacheKey(Path As String) As String
    If Path = Null Then Return ""
    Return Path.Trim
End Sub

Private Sub ReadSvgText(Path As String) As String
    If Path = Null Then Return ""
    Dim p As String = Path.Trim
    If p.Length = 0 Then Return ""

    Try
        Dim slash1 As Int = p.LastIndexOf("/")
        Dim slash2 As Int = p.LastIndexOf("\")
        Dim slash As Int = Max(slash1, slash2)
        If slash >= 0 Then
            Dim dir As String = p.SubString2(0, slash)
            Dim fn As String = p.SubString(slash + 1)
            If dir.Length > 0 And fn.Length > 0 And File.Exists(dir, fn) Then
                Return File.ReadString(dir, fn)
            End If
        End If
        If File.Exists(File.DirAssets, p) Then Return File.ReadString(File.DirAssets, p)
    Catch
    End Try
    Return ""
End Sub
#End Region
