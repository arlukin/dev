VERSION 5.00
Begin VB.Form FrmDirectory 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Select a location"
   ClientHeight    =   2895
   ClientLeft      =   30
   ClientTop       =   315
   ClientWidth     =   4455
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2895
   ScaleWidth      =   4455
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton CmdMakeDir 
      Caption         =   "&Create..."
      Height          =   375
      Left            =   3360
      TabIndex        =   5
      Top             =   1440
      Width           =   975
   End
   Begin VB.CommandButton CmdCancel 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   3360
      TabIndex        =   4
      Top             =   960
      Width           =   975
   End
   Begin VB.CommandButton CmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   3360
      TabIndex        =   3
      Top             =   480
      Width           =   975
   End
   Begin VB.DirListBox Dir 
      Height          =   1890
      Left            =   120
      TabIndex        =   2
      Top             =   480
      Width           =   3135
   End
   Begin VB.DriveListBox Drive 
      Height          =   315
      Left            =   120
      TabIndex        =   1
      Top             =   2460
      Width           =   3135
   End
   Begin VB.Label LblPath 
      Caption         =   "c:\"
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   3135
   End
End
Attribute VB_Name = "FrmDirectory"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub CmdCancel_Click()
    DirectoryReturn = ""
    Unload Me
End Sub

Private Sub CmdMakeDir_Click()
    On Error Resume Next
    Dim NewDir As String
    Dim CurPath As String

    NewDir = InputBox("Enter the name of a new directory", "New Dir")
    If NewDir = "" Then Exit Sub
    CurPath = Dir.Path
    If Right(CurPath, 1) <> "\" Then CurPath = CurPath & "\"
    If Not GetAttr(CurPath & NewDir) = vbDirectory Then
        MkDir CurPath & NewDir
        Dir.Path = CurPath & NewDir
        Dir.Refresh
    Else
        MsgBox "Directory already exists.", , "Dir Error"
    End If
End Sub

Private Sub CmdOK_Click()
    If Len(LblPath.Caption) > 0 Then
        DirectoryReturn = LblPath.Caption
        If Right(DirectoryReturn, 1) <> "\" Then
            DirectoryReturn = DirectoryReturn & "\"
        End If
        Unload Me
    End If
End Sub

Private Sub Dir_Change()
    LblPath.Caption = Dir.Path
End Sub

Private Sub Drive_Change()
    Dir.Path = Drive.Drive
End Sub

Private Sub Form_Load()
    DirectoryReturn = ""
    Dir.Path = Drive.Drive
    LblPath.Caption = Dir.Path
End Sub


