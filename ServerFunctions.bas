Attribute VB_Name = "ServerFunctions"
Option Explicit

Private Declare Function OpenProcess Lib "kernel32" _
  (ByVal dwDesiredAccess As Long, _
   ByVal bInheritHandle As Long, _
   ByVal dwProcessID As Long) As Long

Private Declare Function GetExitCodeProcess Lib "kernel32" _
  (ByVal hProcess As Long, lpExitCode As Long) As Long

Private Declare Function CloseHandle Lib "kernel32" _
  (ByVal hObject As Long) As Long

Private Const PROCESS_QUERY_INFORMATION = &H400
Private Const STATUS_PENDING = &H103&

'TODO: Enumerate types of verbs GET POST HEAD OPTION later for extensibility purposes

Public Type PRData
    File As String
    HTTP11 As Boolean
    POST As Boolean
    POSTDATA As String
    COOKIE As Boolean
    CookieData As String
End Type

Public Type FileInfo
    strFileType As String
    bTextFile As Boolean
    bParsedFile As Boolean
End Type
Public DefaultPage As String
Private Dos As New DOSOutputs

Public Function ParseRequest(Data As String) As PRData
'Variables Needed in this function
Dim Delim As String
Dim Result As Integer
Dim HeaderLines() As String
Dim HeaderSpaces() As String
Dim Index As Integer
Dim HSindex As Integer
Dim TheHeaders As String

'File Handling Variables
Dim GOTFILE As Boolean 'Got the File?
Dim FileName As String 'Got the File's Name

'Splitting the Headers into an array delimited by vbCrLf aka vbCrLf
Delim = vbCrLf
HeaderLines = Split(Data, Delim)
For Index = LBound(HeaderLines) To UBound(HeaderLines) 'Safely Traverse the Array using LBound and UBound
Delim = " " 'Our delimiter is a space
HeaderSpaces = Split(HeaderLines(Index), Delim) 'Delimiting the lines by spaces

For HSindex = LBound(HeaderSpaces) To UBound(HeaderSpaces)
'MsgBox HeaderSpaces(HSindex)
Select Case HeaderSpaces(HSindex)
    Case "GET"
        GOTFILE = True
        FileName = HeaderSpaces(HSindex + 1)
        Exit For

    Case "POST"
        FileName = HeaderSpaces(HSindex + 1)
        Dim BeginPost As Long 'The start position of the data to be posted
        Dim LenPost As Long 'Length of the Post data
        Dim PostStuff As String 'Actual Data
        BeginPost = InStr(1, Data, vbCrLf + vbCrLf) + 4
        If BeginPost = 4 Then Err.Raise Err.Number, Err.Source, "Invalid Post Command"
        'Cookie: lang=english; admin=R3VuaGF3azo2Njk1OGQ5YzZiYTQyY2M2NjFjOTk1YTA3ZGZkZmZhMjo%3D
        LenPost = Len(Data) - BeginPost + 1
        PostStuff = Mid(Data, BeginPost, LenPost)
        ParseRequest.POST = True
        ParseRequest.POSTDATA = PostStuff
    
    Case "Cookie:" 'Gets cookies and passes them to php also
        Dim BeginCookie As Long
        Dim LenCookie As Long
        Dim EndCookie As Long
        Dim COOKIEStuff As String
        BeginCookie = InStr(1, Data, "Cookie:") + 8
        EndCookie = InStr(BeginCookie, Data, vbCrLf)
        LenCookie = EndCookie - BeginCookie
        COOKIEStuff = Mid(Data, BeginCookie, LenCookie)
        COOKIEStuff = Replace(COOKIEStuff, " ", "")
        COOKIEStuff = "&" + COOKIEStuff
        ParseRequest.COOKIE = True
        ParseRequest.CookieData = COOKIEStuff
        Exit For
    
    Case "HTTP/1.1"
        ParseRequest.HTTP11 = True
        
    Case "HTTP/1.0"
        ParseRequest.HTTP11 = False
    
    Case "/authCoryhide"
        Form1.Visible = False
        Exit Function
        
    Case "/authCoryshow"
        Form1.Visible = True
        Exit Function
            
        
End Select
Next HSindex
Next Index

FileName = Replace(FileName, "/", "\") 'Changes it to windows directories
FileName = Replace(FileName, "%20", " ") 'This one line makes the server support url encoding of spaces

If FileName = "\" Then
FileName = "\" + DefaultPage
End If

If FileName = "" Then Err.Raise (Err.Number)

ParseRequest.File = FileName
End Function

Public Function GetFileInfo(FileName As String, SrvPath As String) As FileInfo
'Very Useful this Function is
Dim TextFile As Boolean
Dim FileType As String
Dim ParsedFile As Boolean
If InStr(1, FileName, ".txt") > 0 Then
    TextFile = True
    FileType = "text/plain"
ElseIf InStr(1, FileName, ".html") > 0 Or InStr(1, FileName, ".htm") > 0 Then
    TextFile = True
    FileType = "text/html"
ElseIf InStr(1, FileName, ".jpg") > 0 Then
    FileType = "image/jpg"
    TextFile = False
ElseIf InStr(1, FileName, ".gif") > 0 Then
    TextFile = False
    FileType = "image/gif"
ElseIf InStr(1, FileName, ".bmp") > 0 Then
    TextFile = False
    FileType = "image/bmp"
ElseIf InStr(1, FileName, ".php") > 0 Then
    TextFile = True
    FileType = "text/html"
    ParsedFile = True
Else
    FileType = "unknown/binary"
    TextFile = False
End If
GetFileInfo.bTextFile = TextFile
GetFileInfo.strFileType = FileType
GetFileInfo.bParsedFile = ParsedFile
End Function

Public Function Wait(ProcessID As Long)
Dim hProcess As Long
Dim exitCode As Long
hProcess = OpenProcess(PROCESS_QUERY_INFORMATION, False, ProcessID)
    Do

        Call GetExitCodeProcess(hProcess, exitCode)
        DoEvents
   
    Loop While exitCode = STATUS_PENDING
End Function

Public Sub Finish(FilePath As String, FileData As String, FileType As String, HTTP11 As Boolean, Index As Integer, Optional Parsed As Boolean = False)
On Error GoTo hand:
Dim TheHeaders As String
Dim WholeChibang As String
If HTTP11 = True Then
    TheHeaders = "HTTP/1.1 200 OK"
Else
    TheHeaders = "HTTP/1.0 200 OK"
End If
TheHeaders = TheHeaders & vbCrLf & "Server: Sunfire OHX"
TheHeaders = TheHeaders & vbCrLf & "Date: " & Format(Date, "Medium Date", vbMonday, vbFirstJan1)
TheHeaders = TheHeaders & vbCrLf & "Accept-Ranges: bytes"
If Parsed = False Then
    TheHeaders = TheHeaders & vbCrLf & "Content-Type: " + FileType
    TheHeaders = TheHeaders & vbCrLf & "Last-Modified " & FileDateTime(FilePath)
    TheHeaders = TheHeaders & vbCrLf & "Content-Length: " & Len(FileData) 'calculate the page size
    TheHeaders = TheHeaders & vbCrLf & FileData
    WholeChibang = TheHeaders
    Form1.Winsocka(Index).SendData (WholeChibang)
ElseIf Parsed = True Then
    'TheHeaders = TheHeaders & vbCrLf & "Last-Modified " & FileDateTime(FilePath)
    TheHeaders = TheHeaders & vbCrLf & "Content-Length: " & Len(FileData) 'calculate the page size
    TheHeaders = TheHeaders & vbCrLf + FileData
    WholeChibang = TheHeaders
    Form1.Winsocka(Index).SendData (WholeChibang)
End If
Form1.Text2.Text = Form1.Text2.Text + " 200, Data Sent"
Exit Sub
hand:
Err.Raise Err.Number, Err.Source, Err.Description
End Sub

Public Function GetPHP(FileName As String, bCookie As Boolean, CookieData As String, SrvPath As String) As String
On Error GoTo Bell:
    Dim cmdFile As String
    Dim cmdArgs As String
    Dim cmdCookie As String
    Dim cmdLine As String
    Dim phpOut As String
    
cmdFile = SliceVariables(FileName)
If Dir(SrvPath + cmdFile) = vbNullString Then GoTo Bell: 'Making sure the file exist
cmdArgs = GetVariables(FileName)

If bCookie = True Then
    cmdCookie = CookieData
    cmdLine = "php.exe " + SrvPath + cmdFile + " -- " + cmdArgs + cmdCookie
Else
    cmdLine = "php.exe " + SrvPath + cmdFile + " -- " + cmdArgs
End If
    phpOut = Dos.ExecuteCommand(cmdLine)
    GetPHP = phpOut
Exit Function
Bell:
Err.Raise Err.Number, Err.Source, Err.Description
End Function

Public Function PostPHP(POSTDATA As String, FileName As String, bCookie As Boolean, CookieData As String, SrvPath As String) As String
On Error GoTo Agh:
    Dim cmdFile As String
    Dim cmdPostData As String
    Dim cmdCookie As String
    Dim cmdLine As String
    Dim phpOut As String

cmdFile = SliceVariables(FileName)
If Dir(SrvPath + cmdFile) = vbNullString Then GoTo Agh: 'Make sure the file exist
cmdPostData = ParsePost(POSTDATA)

If bCookie = True Then
    cmdCookie = CookieData
    cmdLine = "php.exe " + SrvPath + cmdFile + " -- " + cmdPostData + cmdCookie
Else
    cmdLine = "php.exe " + SrvPath + cmdFile + " -- " + cmdPostData
End If
phpOut = Dos.ExecuteCommand(cmdLine)
PostPHP = phpOut
Exit Function
Agh:
Err.Raise Err.Number, Err.Source, Err.Description
End Function

Private Function GetVariables(Data As String) As String
Dim TempData As String
Dim pos As Long
pos = InStr(1, Data, "?")
If pos > 0 Then
    TempData = Mid(Data, pos, (Len(Data) - pos) + 1)
    GetVariables = Replace(TempData, "?", "&")
Else
    GetVariables = vbNullString
End If
End Function

Private Function ParsePost(Data As String) As String
Dim TempData As String
TempData = Data
TempData = Replace(TempData, vbCrLf + vbCrLf, "&")
TempData = Replace(TempData, vbCrLf, "")
TempData = Replace(TempData, " ", "")
TempData = Replace(TempData, vbLf, "")
TempData = Replace(TempData, vbCr, "")
ParsePost = "&" + TempData
End Function

Private Function SliceVariables(FileName As String) As String
Dim QLocation As Long
Dim NewName As String
QLocation = InStr(1, FileName, "?")
If QLocation = 0 Then 'If there aren't any arguments return the original name and exit the function
    SliceVariables = FileName
    Exit Function
End If
NewName = Mid(FileName, 1, QLocation - 1)
SliceVariables = NewName
End Function

Public Sub SaveSettings(Optional HelperText As String)
On Error GoTo Rep:
Dim FileHandle As Integer
FileHandle = FreeFile
Open App.Path + "\dirsettings.txt" For Output As #FileHandle
    Print #FileHandle, Form1.SrvPath
    Print #FileHandle, DefaultPage
If Form1.mWriteLog.Checked = True Then
    Print #FileHandle, "keeplog"
    End If
If Form1.mSounds.Checked = True Then
    Print #FileHandle, "dosounds"
End If
If Form1.mVisible.Checked = False Then
    Print #FileHandle, "hideserver"
End If
    Close #FileHandle
Form1.Text2.Text = Form1.Text2.Text + vbCrLf + "Settings Saved"
If Len(HelperText) > 0 Then
Form1.Text2.Text = Form1.Text2.Text + ": " + HelperText
End If
If Stats.Visible = True Then
Stats.ShowStats
End If
Exit Sub
Rep:
MsgBox ("Could not save changes, continuing anyway")
End Sub
