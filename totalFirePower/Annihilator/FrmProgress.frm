VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.2#0"; "COMCTL32.OCX"
Begin VB.Form FrmProgress 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Progress"
   ClientHeight    =   930
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   3855
   ControlBox      =   0   'False
   Icon            =   "FrmProgress.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   MousePointer    =   1  'Arrow
   ScaleHeight     =   930
   ScaleWidth      =   3855
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton CmdCancel 
      Caption         =   "&Cancel"
      Default         =   -1  'True
      Height          =   375
      Left            =   1440
      TabIndex        =   2
      Top             =   900
      Visible         =   0   'False
      Width           =   1155
   End
   Begin ComctlLib.ProgressBar Progress 
      Height          =   255
      Left            =   120
      TabIndex        =   1
      Top             =   480
      Width           =   3615
      _ExtentX        =   6376
      _ExtentY        =   450
      _Version        =   327682
      Appearance      =   1
   End
   Begin VB.Label Status 
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   3615
   End
End
Attribute VB_Name = "FrmProgress"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public ShowCancel As Boolean
Public Canceled As Boolean

Dim OriginalParenthWnd As Long

Public Sub Captions(Optional LblStatus As String = "", Optional FormCaption As String = "")
    If LblStatus <> "" Then
        Status = LblStatus
    End If
    If FormCaption <> "" Then
        Caption = FormCaption
    End If
    DoEvents
End Sub

Public Sub Update(Optional Value As Long = 0, Optional Max As Long = 1)
    Dim Buffer As Single
    
    If Max = 0 Then Max = 1
    Buffer = 100 * (Value / Max)
    Progress.Value = CInt(Buffer)
    DoEvents
End Sub

Private Sub CmdCancel_Click()
    Canceled = True
End Sub

Private Sub Form_Load()
    OriginalParenthWnd = SetWindowLong(Me.hwnd, GWW_HWNDPARENT, FrmAnnihilator.hwnd)
    
    Canceled = False
    If ShowCancel Then
        CmdCancel.Visible = True
        Me.Height = Me.Height + 475
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Dim rc As Long
    
    If OriginalParenthWnd <> 0 Then
        rc = SetWindowLong(hwnd, GWW_HWNDPARENT, OriginalParenthWnd)
    End If
End Sub
