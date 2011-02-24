VERSION 5.00
Begin VB.Form FrmStartupOption 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Annihilator"
   ClientHeight    =   2025
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   3930
   Icon            =   "FrmStartupOption.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2025
   ScaleWidth      =   3930
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.OptionButton optQuickLoad 
      Caption         =   "Quick-load map"
      Height          =   255
      Left            =   300
      TabIndex        =   2
      Top             =   780
      Value           =   -1  'True
      Width           =   3195
   End
   Begin VB.OptionButton optCompleteLoad 
      Caption         =   "Complete load with sections and features"
      Height          =   255
      Left            =   300
      TabIndex        =   1
      Top             =   1080
      Width           =   3195
   End
   Begin VB.CommandButton CmdOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   1560
      TabIndex        =   0
      Top             =   1500
      Width           =   795
   End
   Begin VB.Label Label1 
      Caption         =   "Select the action you want Annihilator to perform when opened from Explorer."
      Height          =   495
      Left            =   120
      TabIndex        =   3
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
    If optQuickLoad.Value Then
        FrmAnnihilator.QuickLoad = True
    Else
        FrmAnnihilator.QuickLoad = False
    End If
    Unload Me
End Sub

Private Sub Form_Load()
    FrmAnnihilator.QuickLoad = True
End Sub
