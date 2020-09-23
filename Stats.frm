VERSION 5.00
Begin VB.Form Stats 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Server Status"
   ClientHeight    =   2970
   ClientLeft      =   7785
   ClientTop       =   6210
   ClientWidth     =   7575
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2970
   ScaleWidth      =   7575
   Begin VB.CommandButton Command1 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   480
      Left            =   5760
      TabIndex        =   0
      Top             =   195
      Width           =   1635
   End
   Begin VB.Label StatsLabel 
      AutoSize        =   -1  'True
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Left            =   45
      TabIndex        =   2
      Top             =   630
      Width           =   60
   End
   Begin VB.Label Static1 
      Caption         =   "Server Status..."
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   15.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   345
      Left            =   45
      TabIndex        =   1
      Top             =   105
      Width           =   2250
   End
End
Attribute VB_Name = "Stats"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
Stats.Enabled = False
Stats.Visible = False
Unload Stats
End Sub

Public Sub ShowStats()
StatsLabel.Caption = "Hits: " + Str(Form1.Hits) + vbCrLf + "Web Pages Sent: " + Str(Form1.Hits - Form1.Errors) + vbCrLf + "Hacker Attempts: " + Str(Form1.HackAttacks) + vbCrLf + "Errors: " + Str(Form1.Errors) + vbCrLf + vbCrLf + "Current Server Directory: " + vbCrLf + Form1.SrvPath
End Sub

Private Sub Form_Load()
ShowStats
End Sub
