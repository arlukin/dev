VERSION 5.00
Begin VB.Form FrmGridSize 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Grid Size"
   ClientHeight    =   1605
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   1995
   Icon            =   "FrmGridSize.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1605
   ScaleWidth      =   1995
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.Frame Frame1 
      Height          =   975
      Left            =   120
      TabIndex        =   1
      Top             =   60
      Width           =   1755
      Begin VB.TextBox TxtX 
         Height          =   315
         Left            =   120
         TabIndex        =   3
         Text            =   "32"
         Top             =   480
         Width           =   675
      End
      Begin VB.TextBox TxtY 
         Height          =   315
         Left            =   960
         TabIndex        =   2
         Text            =   "32"
         Top             =   480
         Width           =   675
      End
      Begin VB.Label Label1 
         Caption         =   "Width"
         Height          =   255
         Left            =   120
         TabIndex        =   5
         Top             =   240
         Width           =   675
      End
      Begin VB.Label Label2 
         Caption         =   "Height"
         Height          =   255
         Left            =   960
         TabIndex        =   4
         Top             =   240
         Width           =   675
      End
   End
   Begin VB.CommandButton CmdOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   600
      TabIndex        =   0
      Top             =   1140
      Width           =   855
   End
End
Attribute VB_Name = "FrmGridSize"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub CmdOK_Click()
    On Error Resume Next
    GridSizeX = Val(TxtX)
    GridSizeY = Val(TxtY)
    If GridSizeX < 32 Then GridSizeX = 32
    If GridSizeY < 32 Then GridSizeY = 32
    Unload Me
End Sub

