VERSION 5.00
Begin VB.Form FrmStartup 
   BorderStyle     =   3  'Fixed Dialog
   ClientHeight    =   3000
   ClientLeft      =   45
   ClientTop       =   45
   ClientWidth     =   6000
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Picture         =   "FrmStartup.frx":0000
   ScaleHeight     =   3000
   ScaleWidth      =   6000
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.Timer TmrLoad 
      Interval        =   1500
      Left            =   60
      Top             =   120
   End
End
Attribute VB_Name = "FrmStartup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
    Screen.MousePointer = vbHourglass
    DoEvents
End Sub

Private Sub TmrLoad_Timer()
    Screen.MousePointer = vbNormal
    Unload Me
End Sub
