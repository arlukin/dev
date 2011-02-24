VERSION 5.00
Begin VB.Form FrmLogo 
   BorderStyle     =   3  'Fixed Dialog
   ClientHeight    =   3045
   ClientLeft      =   45
   ClientTop       =   45
   ClientWidth     =   6030
   ControlBox      =   0   'False
   Icon            =   "FrmLogo.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3045
   ScaleWidth      =   6030
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.PictureBox Picture1 
      Height          =   3030
      Left            =   0
      Picture         =   "FrmLogo.frx":000C
      ScaleHeight     =   2970
      ScaleWidth      =   5970
      TabIndex        =   0
      Top             =   0
      Width           =   6030
      Begin VB.Timer TmrUnload 
         Interval        =   1500
         Left            =   60
         Top             =   60
      End
   End
End
Attribute VB_Name = "FrmLogo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
    Screen.MousePointer = vbHourglass
End Sub

Private Sub TmrUnload_Timer()
    Screen.MousePointer = vbNormal
    Unload Me
End Sub
