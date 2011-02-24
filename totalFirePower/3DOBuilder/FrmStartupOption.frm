VERSION 5.00
Begin VB.Form FrmStartupOption 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "3DO Builder"
   ClientHeight    =   2025
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   3915
   Icon            =   "FrmStartupOption.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2025
   ScaleWidth      =   3915
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton CmdOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   1560
      TabIndex        =   3
      Top             =   1500
      Width           =   795
   End
   Begin VB.OptionButton optUnitView 
      Caption         =   "Fast export to the Unit Viewer"
      Height          =   255
      Left            =   300
      TabIndex        =   2
      Top             =   1080
      Width           =   2475
   End
   Begin VB.OptionButton optBuilder 
      Caption         =   "Launch 3DO Builder and load the model"
      Height          =   255
      Left            =   300
      TabIndex        =   1
      Top             =   780
      Value           =   -1  'True
      Width           =   3195
   End
   Begin VB.Label Label1 
      Caption         =   "Select the action you want 3DO Builder to perform when opened from Explorer."
      Height          =   495
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   3675
   End
End
Attribute VB_Name = "FrmStartupOption"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub CmdOK_Click()
    Launch = LaunchBuilder
    If optUnitView.Value Then
        Launch = LaunchViewer
    End If
    Unload Me
End Sub

Private Sub Form_Load()
    If Launch = LaunchViewer Then
        optUnitView.Value = True
    End If
End Sub
