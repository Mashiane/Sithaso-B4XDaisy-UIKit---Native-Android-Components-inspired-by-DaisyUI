B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

'================================================================
' B4XFileLogger
' Simple file-based logger for capturing crash diagnostics
'================================================================

#IgnoreWarnings:12
Sub Class_Globals
    Private xui As XUI
    Private LogFilePath As String
    Private LogFileName As String = "crash_log.txt"
    Private mIsInitialized As Boolean = False
End Sub

Public Sub Initialize
    LogFilePath = File.DirInternal
    ' Clear previous log file
    If File.Exists(LogFilePath, LogFileName) Then
        File.Delete(LogFilePath, LogFileName)
    End If
    mIsInitialized = True
    WriteLog("=== B4XFileLogger initialized ===")
    WriteLog("Log path: " & LogFilePath & "/" & LogFileName)
End Sub

Public Sub WriteLog(Message As String)
    Try
        Dim timestamp As String = DateTime.Date(DateTime.Now) & " " & DateTime.Time(DateTime.Now)
        Dim logLine As String = timestamp & " - " & Message
        File.WriteString(LogFilePath, LogFileName, logLine & CRLF)
        Log("FILELOG: " & Message)
    Catch
        Log("ERROR: FileLogger.WriteLog failed: " & LastException.Message)
    End Try
End Sub

Public Sub WriteError(Message As String, Err As Exception)
    Try
        Dim timestamp As String = DateTime.Date(DateTime.Now) & " " & DateTime.Time(DateTime.Now)
        Dim logLine As String = timestamp & " - ERROR: " & Message
        If Err <> Null Then
            logLine = logLine & " | Exception: " & Err.Message
        End If
        File.WriteString(LogFilePath, LogFileName, logLine & CRLF)
        Log("FILELOG ERROR: " & Message)
    Catch
        Log("ERROR: FileLogger.WriteError failed: " & LastException.Message)
    End Try
End Sub

Public Sub GetLogFilePath As String
    Return LogFilePath & "/" & LogFileName
End Sub

Public Sub getIsInitialized As Boolean
    Return mIsInitialized
End Sub

Public Sub ReadLogFile As String
    Try
        If File.Exists(LogFilePath, LogFileName) Then
            Return File.ReadString(LogFilePath, LogFileName)
        End If
        Return "Log file not found"
    Catch
        Return "Error reading log: " & LastException.Message
    End Try
End Sub
