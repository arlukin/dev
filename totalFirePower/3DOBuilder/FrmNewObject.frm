VERSION 5.00
Begin VB.Form FrmNewObject 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Create New Object"
   ClientHeight    =   2400
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   2535
   Icon            =   "FrmNewObject.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2400
   ScaleWidth      =   2535
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.Frame Frame2 
      Caption         =   "Object Name"
      Height          =   735
      Left            =   240
      TabIndex        =   6
      Top             =   960
      Width           =   2115
      Begin VB.TextBox TxtName 
         Height          =   315
         Left            =   120
         TabIndex        =   2
         Text            =   "Untitled"
         Top             =   300
         Width           =   1875
      End
   End
   Begin VB.CommandButton CmdCancel 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   1440
      TabIndex        =   4
      Top             =   1860
      Width           =   915
   End
   Begin VB.CommandButton CmdOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   420
      TabIndex        =   3
      Top             =   1860
      Width           =   915
   End
   Begin VB.Frame Frame1 
      Caption         =   "Object Type"
      Height          =   675
      Left            =   180
      TabIndex        =   5
      Top             =   180
      Width           =   2175
      Begin VB.OptionButton OptSibling 
         Caption         =   "&Sibling"
         Height          =   255
         Left            =   1140
         TabIndex        =   1
         Top             =   300
         Width           =   855
      End
      Begin VB.OptionButton OptChild 
         Caption         =   "&Child"
         Height          =   255
         Left            =   180
         TabIndex        =   0
         Top             =   300
         Value           =   -1  'True
         Width           =   1035
      End
   End
End
Attribute VB_Name = "FrmNewObject"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub CmdCancel_Click()
    Unload Me
End Sub

Private Sub CmdOK_Click()
    Dim Buffer As String
    
    On Error Resume Next
    Buffer = TxtName
    If OptChild.Value Then
        If Buffer <> "" Then
            SelectedObject.CreateChild Buffer
            'CreateInterface
        End If
    ElseIf OptSibling.Value Then
        If Buffer <> "" Then
            SelectedObject.CreateSibling Buffer
            'CreateInterface
        End If
    End If
    Unload Me
End Sub

Private Sub TxtName_GotFocus()
    TxtName.SelLength = Len(TxtName)
End Sub
