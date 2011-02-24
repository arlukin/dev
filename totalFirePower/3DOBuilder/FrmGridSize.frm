VERSION 5.00
Object = "{FE0065C0-1B7B-11CF-9D53-00AA003C9CB6}#1.0#0"; "COMCT232.OCX"
Begin VB.Form FrmGridSize 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Grid Size"
   ClientHeight    =   1170
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   2235
   Icon            =   "FrmGridSize.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1170
   ScaleWidth      =   2235
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.Frame Frame1 
      Height          =   795
      Left            =   120
      TabIndex        =   1
      Top             =   180
      Width           =   1095
      Begin VB.TextBox TxtGridSize 
         Height          =   315
         Left            =   120
         Locked          =   -1  'True
         TabIndex        =   2
         Text            =   "5"
         Top             =   300
         Width           =   555
      End
      Begin ComCtl2.UpDown ScrollGridSize 
         Height          =   315
         Left            =   720
         TabIndex        =   3
         Top             =   300
         Width           =   240
         _ExtentX        =   423
         _ExtentY        =   556
         _Version        =   327681
         Value           =   1
         Max             =   32
         Min             =   1
         Enabled         =   -1  'True
      End
   End
   Begin VB.CommandButton CmdOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   1440
      TabIndex        =   0
      Top             =   420
      Width           =   615
   End
End
Attribute VB_Name = "FrmGridSize"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub CmdOK_Click()
    GridInterval = ScrollGridSize.Value
    Unload Me
End Sub

Private Sub Form_Load()
    ScrollGridSize.Value = GridInterval
End Sub

Private Sub ScrollGridSize_Change()
    TxtGridSize = CStr(ScrollGridSize.Value)
End Sub
