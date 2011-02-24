VERSION 5.00
Begin VB.Form FrmSaveChanges 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Annihilator"
   ClientHeight    =   3405
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5280
   Icon            =   "FrmSaveChanges.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3405
   ScaleWidth      =   5280
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton CmdCancel 
      Caption         =   "&Cancel"
      Height          =   375
      Left            =   3960
      TabIndex        =   4
      Top             =   1080
      Width           =   1155
   End
   Begin VB.CommandButton CmdNo 
      Caption         =   "&No"
      Height          =   375
      Left            =   3960
      TabIndex        =   3
      Top             =   600
      Width           =   1155
   End
   Begin VB.CommandButton CmdYes 
      Caption         =   "&Yes"
      Height          =   375
      Left            =   3960
      TabIndex        =   2
      Top             =   120
      Width           =   1155
   End
   Begin VB.ListBox LstFiles 
      Height          =   2790
      Left            =   120
      MultiSelect     =   1  'Simple
      TabIndex        =   1
      Top             =   480
      Width           =   3615
   End
   Begin VB.Label Label1 
      Caption         =   "Save changes to the following maps?"
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   2775
   End
End
Attribute VB_Name = "FrmSaveChanges"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public MapIndex As Long

Dim OriginalParenthWnd As Long

Private Sub CmdCancel_Click()
    FrmAnnihilator.Flag = 2
    Unload Me
End Sub

Private Sub CmdNo_Click()
    FrmAnnihilator.Flag = True
    Unload Me
End Sub

Private Sub CmdYes_Click()
    Dim Index As Integer
    
    On Error GoTo Error
    For Index = 0 To LstFiles.ListCount
        If LstFiles.Selected(Index) Then
            SelectedMap = Index
            FrmAnnihilator.mnuFileSave_Click
        End If
    Next
Error:
    FrmAnnihilator.Flag = True
    Unload Me
End Sub

Private Sub Form_Load()
    Dim Index As Integer
    
    On Error GoTo Error
    
    OriginalParenthWnd = SetWindowLong(Me.hwnd, GWW_HWNDPARENT, FrmAnnihilator.hwnd)
    
    If MapIndex = -1 Then
        For Index = 0 To UBound(Maps)
            If Maps(Index).MapLoaded Then
                If Maps(Index).MapFilename = "" Then
                    LstFiles.AddItem "Untitled" & CStr(Index + 1) & ".ufo"
                    LstFiles.ItemData(LstFiles.NewIndex) = Index
                Else
                    LstFiles.AddItem Maps(Index).MapFilename & ".ufo"
                    LstFiles.ItemData(LstFiles.NewIndex) = Index
                End If
                LstFiles.Selected(LstFiles.NewIndex) = True
            End If
        Next
    Else
        Index = MapIndex
        If Maps(Index).MapFilename = "" Then
            LstFiles.AddItem "Untitled" & CStr(Index + 1) & ".ufo"
            LstFiles.ItemData(LstFiles.NewIndex) = Index
        Else
            LstFiles.AddItem Maps(Index).MapFilename & ".ufo"
            LstFiles.ItemData(LstFiles.NewIndex) = Index
        End If
        LstFiles.Selected(LstFiles.NewIndex) = True
    End If
    
Error:
    If LstFiles.ListCount = 0 Then Unload Me
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Dim rc As Long
    
    If OriginalParenthWnd <> 0 Then
        rc = SetWindowLong(hwnd, GWW_HWNDPARENT, OriginalParenthWnd)
    End If
    
    If FrmAnnihilator.Flag = False Then FrmAnnihilator.Flag = True
End Sub
