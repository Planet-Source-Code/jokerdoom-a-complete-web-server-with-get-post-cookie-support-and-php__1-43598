VERSION 5.00
Begin VB.Form SrvDir 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Change Server Directory"
   ClientHeight    =   3720
   ClientLeft      =   2310
   ClientTop       =   570
   ClientWidth     =   4665
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3720
   ScaleWidth      =   4665
   Begin VB.CommandButton IDCANCEL 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Height          =   435
      Left            =   30
      TabIndex        =   4
      Top             =   3225
      Width           =   1980
   End
   Begin VB.CommandButton IDOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   435
      Left            =   2640
      TabIndex        =   3
      Top             =   3225
      Width           =   1980
   End
   Begin VB.DirListBox Folders 
      Height          =   2790
      Left            =   15
      TabIndex        =   1
      Top             =   360
      Width           =   4635
   End
   Begin VB.DriveListBox Drives 
      Height          =   315
      Left            =   15
      TabIndex        =   0
      Top             =   15
      Width           =   1350
   End
   Begin VB.Label Static 
      Caption         =   "Choose Your Server Directory"
      Height          =   180
      Left            =   1395
      TabIndex        =   2
      Top             =   75
      Width           =   3240
   End
End
Attribute VB_Name = "SrvDir"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim FileServerPath As String

Private Sub Drives_Change()
On Error GoTo CBF:
Folders.Path = Drives.Drive
Exit Sub
CBF:
MsgBox "Cannot Read From Device", vbOKOnly, "Error Reading Device"
End Sub

Private Sub Form_Load()
On Error GoTo Brea:
Dim FileHandle As Integer
FileHandle = FreeFile
Open App.Path + "\dirsettings.txt" For Input As #FileHandle
'FileServerPath is the path to the servers directory at load time
    
    Line Input #FileHandle, FileServerPath
    Close #FileHandle

If InStr(1, FileServerPath, "C:\") Then
    Drives.Drive = "C:"
    Folders.Path = FileServerPath
ElseIf InStr(1, FileServerPath, "D:\") Then
    Drives.Drive = "D:"
    Folders.Path = FileServerPath
    
End If

Exit Sub
Brea:
FileHandle = FreeFile
Open App.Path + "\dirsettings.txt" For Output As #FileHandle
Print #FileHandle, App.Path
Close #FileHandle
Folders.Path = App.Path
Form1.SrvPath = App.Path
End Sub

Private Sub IDCANCEL_Click()
Form1.SrvPath = FileServerPath
Unload SrvDir
End Sub

Private Sub IDOK_Click()
Form1.SrvPath = Folders.Path
ServerFunctions.SaveSettings ("Server Directory")
Unload SrvDir
End Sub
