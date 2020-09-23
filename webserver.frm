VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Begin VB.Form Form1 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Http Server"
   ClientHeight    =   4665
   ClientLeft      =   3795
   ClientTop       =   4275
   ClientWidth     =   8220
   ForeColor       =   &H8000000F&
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4665
   ScaleWidth      =   8220
   Begin VB.OptionButton SuperMode 
      Caption         =   "SuperMode "
      BeginProperty Font 
         Name            =   "News Gothic MT"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   -1  'True
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   330
      Left            =   4350
      TabIndex        =   6
      ToolTipText     =   "!WARNING! Disables all types of logging--High Perfomance Mode"
      Top             =   4290
      Width           =   1770
   End
   Begin VB.OptionButton Details 
      Caption         =   "Detailed Mode "
      BeginProperty Font 
         Name            =   "News Gothic MT"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   -1  'True
         Strikethrough   =   0   'False
      EndProperty
      Height          =   330
      Left            =   6135
      TabIndex        =   5
      ToolTipText     =   "Shows everything sent to the server"
      Top             =   4290
      Value           =   -1  'True
      Width           =   2085
   End
   Begin MSWinsockLib.Winsock Winsocka 
      Index           =   0
      Left            =   7455
      Top             =   900
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock Winsock 
      Left            =   7005
      Top             =   900
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.CommandButton Send 
      Caption         =   "Execute"
      Default         =   -1  'True
      Height          =   285
      Left            =   6960
      MaskColor       =   &H8000000C&
      TabIndex        =   2
      ToolTipText     =   "Invokes Commands"
      Top             =   480
      Width           =   1215
   End
   Begin VB.TextBox Text2 
      Height          =   3375
      Left            =   0
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   1
      ToolTipText     =   "Server Log"
      Top             =   840
      Width           =   8175
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Left            =   30
      TabIndex        =   0
      Text            =   "Command Line"
      Top             =   480
      Width           =   6855
   End
   Begin VB.Label Label2 
      Caption         =   "No Hits"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   105
      TabIndex        =   4
      Top             =   4290
      Width           =   8055
   End
   Begin VB.Label Label1 
      Caption         =   "Sunfire Online Web Server"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   14.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   105
      TabIndex        =   3
      Top             =   135
      Width           =   8055
   End
   Begin VB.Menu File 
      Caption         =   "&File"
      Begin VB.Menu mStats 
         Caption         =   "Status..."
         Shortcut        =   ^S
      End
      Begin VB.Menu mServerDir 
         Caption         =   "Change Server Directory..."
         Shortcut        =   ^D
      End
      Begin VB.Menu mStart 
         Caption         =   "Start Server"
         Shortcut        =   {F5}
      End
      Begin VB.Menu mStop 
         Caption         =   "Stop Server"
         Shortcut        =   {F4}
      End
      Begin VB.Menu ExitApp 
         Caption         =   "E&xit"
      End
   End
   Begin VB.Menu mPref 
      Caption         =   "&Preferences"
      Begin VB.Menu mChangeDefaultPage 
         Caption         =   "Change Default Page..."
      End
      Begin VB.Menu mSounds 
         Caption         =   "Alert Sounds(IDS)"
      End
      Begin VB.Menu mVisible 
         Caption         =   "Server Visible on Start"
      End
      Begin VB.Menu mWriteLog 
         Caption         =   "Keep Server Log"
      End
   End
   Begin VB.Menu RstFiles 
      Caption         =   "&Reset Files"
   End
   Begin VB.Menu About 
      Caption         =   "About"
      Begin VB.Menu mAbout 
         Caption         =   "About"
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'Sunfire Online is Owned by Cory Dambach'
''\-\-\-\\\...Sunfire Online Hyper X 5.0...///-/-/-/''
Option Explicit
'Global Variables
Public SrvPath As String
Public Hits As Long
Dim SpeedHits As Long
Public HackAttacks As Long
Public Errors As Long
Private CanSend(50) As Boolean
Private Log As String
Private Declare Function Beep Lib "kernel32" (ByVal dwFreq As Long, ByVal dwDuration As Long) As Long

Private Sub ExitApp_Click()
End
End Sub

Private Sub Form_Load()
On Error GoTo Eroo:
'Boot Process
Dim ServerPath As Boolean
Dim Phpconfig As Boolean
Dim FileHandle As Integer
Dim inSetting As String
If Dir(App.Path + "\dirsettings.txt") = "" Then
    FileHandle = FreeFile
    Open App.Path + "\dirsettings.txt" For Output As #FileHandle
    Print #FileHandle, App.Path
    Print #FileHandle, "index.html"
    Close FileHandle
End If
Dim i As Integer
Winsock.LocalPort = "80"
For i = 1 To 50
    Load Winsocka(i)
    Winsocka(i).LocalPort = 80 + i
Next i
    FileHandle = FreeFile
    mVisible.Checked = True
    Open App.Path + "\dirsettings.txt" For Input As #FileHandle
    Line Input #FileHandle, SrvPath
    Line Input #FileHandle, ServerFunctions.DefaultPage
    Do While Not EOF(FileHandle)
    Line Input #FileHandle, inSetting
    Select Case inSetting
        Case "hideserver"
        Form1.Visible = False
        Form1.mVisible.Checked = False
        Case "dosounds"
        mSounds.Checked = True
        Case "keeplog"
        mWriteLog.Checked = True
    End Select
    Loop
    Close #FileHandle
Text2.Text = "Server Initialized" + vbCrLf + _
                     "Serving on Port 80 PHP 4.2 Text and Binary Files," + vbCrLf + _
                     "Server Directory: " + SrvPath
Winsock.Listen 'Start Servin It Up
Hits = 0 'Initialize the hits variable
Text1.Text = "Command Line"
Label1.Caption = "Server Status: Green"
Exit Sub
Eroo:
Close #FileHandle
FileHandle = FreeFile
    Open App.Path + "\dirsettings.txt" For Output As #FileHandle
    Print #FileHandle, App.Path
    Print #FileHandle, "index.html"
Close #FileHandle
SrvPath = App.Path
ServerFunctions.DefaultPage = "index.html"
Text2.Text = Text2.Text + vbCrLf + "Error During Load"
Text2.Text = Text2.Text + vbCrLf + Err.Description
End Sub

Private Sub Form_Unload(Cancel As Integer)
On Error GoTo Ignore:
If mWriteLog.Checked = True Then
    Dim FileHandle As Integer
    FileHandle = FreeFile
    Open App.Path + "\log.txt" For Append As FileHandle
    Write #FileHandle, Log
    Close FileHandle
End If
ServerFunctions.SaveSettings 'Save the settings
End
Exit Sub
Ignore:
End
End Sub

Private Sub mAbout_Click()
MsgBox ("This Program was Created by Cory Dambach 2003") 'Leave This Code In
End Sub

Private Sub mChangeDefaultPage_Click()
Dim ret As String
ret = InputBox("Enter the name of the default page file", "Change Default File")
ret = Trim(ret)
If ret = "" Then Exit Sub
ServerFunctions.DefaultPage = ret
SaveSettings
End Sub

Private Sub mServerDir_Click()
SrvDir.Show (vbModal)
End Sub

Private Sub mSounds_Click()
If mSounds.Checked = True Then
mSounds.Checked = False
Else
mSounds.Checked = True
End If
ServerFunctions.SaveSettings ("IDS Alert Sounds")
End Sub

Private Sub mStart_Click()
If Winsock.State = sckClosed Then
    Winsock.Listen
    Label1.Caption = "Server Started"
End If
End Sub

Private Sub mStats_Click()
If Stats.Visible = False Then
    Stats.Show
    Stats.ShowStats
End If
End Sub

Private Sub mStop_Click()
If Winsock.State = sckListening Then
    Winsock.Close
    Label1.Caption = "Server Stopped"
End If
End Sub

Private Sub mVisible_Click()
With mVisible
If .Checked = True Then
.Checked = False
Else
.Checked = True
End If
End With
ServerFunctions.SaveSettings ("Visibility Options")
End Sub

Private Sub mWriteLog_Click()
With mWriteLog
If .Checked = True Then
.Checked = False
Else
.Checked = True
End If
ServerFunctions.SaveSettings ("Logging Options")
End With
End Sub

Private Sub RstFiles_Click()
Reset 'Warning This stops all files that are being sent at the moment of pressing this button causing an error to all connected clients
End Sub

Private Sub Send_Click()
Select Case Text1.Text 'Command Line Box
    
    Case "clear" 'clear log
        Text2.Text = vbNullString
        Text1.Text = ""
        Log = vbNullString
        Exit Sub
    
    Case "close" 'Close socket and do not resume listening for other connections
        Label1.Caption = "Not Listening"
        Winsock.Close
    
    Case "listen" 'resume listening for connections
        If Winsock.State = sckClosed Then
        Winsock.Listen
        Label1.Caption = "Resumed Listening"
        End If
    Case "resethits" 'reset the hit counter
        Hits = 0
        Label2.Caption = "No Hits"
        
    Case "hide" 'hide the server form does not hide statistics form
        Form1.Visible = False
End Select
End Sub

Private Sub Text2_Change()
Text2.SelStart = Len(Text2.Text)
End Sub

Private Sub Winsock_ConnectionRequest(ByVal requestID As Long)
Dim i As Integer
For i = 0 To 50
    If Winsocka(i).State = 0 Then
        Winsocka(i).Accept (requestID)
        Hits = Hits + 1
        SpeedHits = SpeedHits + 1
            If Stats.Visible = True Then
                Stats.ShowStats
            End If
        Label2.Caption = "Hit Count: " + Str(Hits)
        Exit Sub 'exit the sub
    End If
Next i
End Sub

Private Sub Winsocka_Close(Index As Integer)
Winsocka(Index).Close
End Sub

Private Sub Winsocka_DataArrival(Index As Integer, ByVal bytesTotal As Long)
Dim Data As String
On Error GoTo Err:
Winsocka(Index).GetData Data
'Debug.Print "Data Recieved: " + Data
Parse_Headers Index, Data
Exit Sub
Err:
If mSounds.Checked = True Then Beep 500, 1
If Stats.Visible = True Then
    Stats.ShowStats
End If
HackAttacks = HackAttacks + 1
If HackAttacks > 10 Then
    Label1.Caption = "Status: Yellow"
    Label1.ToolTipText = "Server has been attacked recently"
    Stats.ShowStats
End If
End Sub


Private Sub Parse_Headers(Windex As Integer, Data As String)
On Error GoTo 404:
Dim fData As PRData
Dim FileName As String
fData = ServerFunctions.ParseRequest(Data)
FileName = fData.File

If Details = True Then
Text2.Text = Text2.Text + vbCrLf + Winsocka(Windex).RemoteHostIP + "//" + Data
End If
If mWriteLog.Checked = True Then
End If

'The Hacker Dissapointer
'This One Block of Code Made the Server Invulnerable against all hacking attempts I know
'This block checks for an excess in dots for a slashdot attack
Dim CheckArray() As String
CheckArray() = Split(FileName, ".")
If UBound(CheckArray) > 2 Then
    If mSounds.Checked = True Then Beep 500, 1
    HackAttacks = HackAttacks + 1
    GoTo 404:
End If
   
'File Variable Declarations
    Dim theFilePath As String
    Dim theInfo As FileInfo
    Dim FileData As String
    Dim strFileBuffer As String
    Dim FileBuffer As String
    Dim FileHandle As Integer
    Dim ProcResult As Long
    Dim TheHeaders As String
    Dim WholeChibang As String

theInfo = ServerFunctions.GetFileInfo(FileName, SrvPath) 'Retrieving Data About Our File
theFilePath = SrvPath + FileName

If theInfo.bParsedFile = True And fData.POST = False Then 'This is where the call goes if the request was a GET verb
    FileData = GetPHP(FileName, fData.COOKIE, fData.CookieData, SrvPath)
    Finish theFilePath, FileData, theInfo.strFileType, True, Windex, True
    Exit Sub
End If

If theInfo.bParsedFile = True And fData.POST = True Then 'This is where the call goes if the request was a POST verb
    FileData = PostPHP(fData.POSTDATA, FileName, fData.COOKIE, fData.CookieData, SrvPath)
    Finish theFilePath, FileData, theInfo.strFileType, True, Windex, True
    Exit Sub
End If

If Dir(SrvPath + FileName) = vbNullString Then GoTo 404: 'Checks for the existence of non php files

FileHandle = FreeFile
If theInfo.bTextFile = True Then
'This if block reads the text from text and html files
    Open theFilePath For Input As #FileHandle
    Do While Not EOF(FileHandle)
        Line Input #FileHandle, strFileBuffer
        FileData = FileData + vbCrLf + strFileBuffer
        DoEvents
    Loop
ElseIf theInfo.bTextFile = False Then
'This elseif block reads information from binary files and sends them streaming in 1000 byte blocks
    TheHeaders = "HTTP/1.1 200 OK"
    TheHeaders = TheHeaders & vbCrLf & "Server: Sunfire OHX"
    TheHeaders = TheHeaders & vbCrLf & "Date:" & Format(Date, "Medium Date", vbMonday, vbFirstJan1)
    TheHeaders = TheHeaders & vbCrLf & "Last-Modified: " & FileDateTime(theFilePath)
    TheHeaders = TheHeaders & vbCrLf & "Accept-Ranges: bytes"
    TheHeaders = TheHeaders & vbCrLf & "Content-Length: " & FileLen(theFilePath)
    TheHeaders = TheHeaders & vbCrLf & "Connection: Close"
    TheHeaders = TheHeaders & vbCrLf & "Content-Type: " & theInfo.strFileType
    TheHeaders = TheHeaders & vbCrLf & ""
    TheHeaders = TheHeaders & vbCrLf
   Winsocka(Windex).Tag = "1" 'Tell the server not to close the socket after 1 send
   Winsocka(Windex).SendData (TheHeaders)
   Open theFilePath For Binary Access Read As #FileHandle
   CanSend(Windex) = True
   Do While Not EOF(FileHandle) 'The Binary Loop
      FileBuffer = Space$(1000)
        Get #FileHandle, , FileBuffer 'Getting the data
        Do While Not CanSend(Windex) = True
        DoEvents
        Loop
        Winsocka(Windex).SendData (FileBuffer)
        DoEvents
      Loop
StopIt:
        Close #FileHandle
        Winsocka(Windex).Tag = "0"
        Winsocka_SendComplete (Windex)
        Exit Sub
End If
Close #FileHandle
Finish theFilePath, FileData, theInfo.strFileType, fData.HTTP11, Windex
Text2.Text = Text2.Text + " Good Request, File Found"
Exit Sub

404: 'Parser Error Handler
Winsocka(Windex).Tag = "0"
If Details = True Then Text2.Text = Text2.Text + " 404 " + "Bad Request: " + Err.Description
If mWriteLog = True Then Log = Log + " 404 " + "Error: " + Err.Description
    TheHeaders = "HTTP/1.1 200 Object Not Found"
    TheHeaders = TheHeaders & vbCrLf & "Server: Sunfire OHX"
    TheHeaders = TheHeaders & vbCrLf & "Date:" & Format(Date, "Medium Date", vbMonday, vbFirstJan1)
    TheHeaders = TheHeaders & vbCrLf & "Content-Length: " & Len("<html><h1>404 File Not Found</h1></html>")
    TheHeaders = TheHeaders & vbCrLf & "Connection: Close"
    TheHeaders = TheHeaders & vbCrLf & "Content-Type: text/html"
    TheHeaders = TheHeaders & vbCrLf & ""
    TheHeaders = TheHeaders & vbCrLf & "<html><h1>404 File Not Found</h1></html>" & vbCrLf 'Insert your own error message here
    Winsocka(Windex).SendData (TheHeaders)
If FileHandle > 0 Then
    Close #FileHandle
End If
Err.Clear
Errors = Errors + 1
If Stats.Visible = True Then
Stats.ShowStats 'Update the statistics
End If
End Sub

Private Sub Winsocka_Error(Index As Integer, ByVal Number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)
Winsocka(Index).Tag = "0"
Errors = Errors + 1
If mSounds.Checked = True Then Beep 500, 1
If Winsocka(Index).State = sckConnected Then
    Winsocka_SendComplete (Index)
End If
If Stats.Visible = True Then
    Stats.ShowStats
End If
End Sub

Private Sub Winsocka_SendComplete(Index As Integer)
If Winsocka(Index).Tag = "1" Then
    CanSend(Index) = True
Exit Sub
End If
Winsocka(Index).Close
If mWriteLog.Checked = True Then
    SpeedHits = SpeedHits + 1
    If SpeedHits > 50 Then
        Dim FH As Integer
        FH = FreeFile
        Open App.Path + "\ServerLog.txt" For Append As FH
        Print #FH, Log
        Log = vbNullString
        Close #FH
        SpeedHits = 0
    End If
End If
End Sub
