VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.2#0"; "COMCTL32.OCX"
Begin VB.Form FrmProgress 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "3DO Builder"
   ClientHeight    =   1020
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4200
   ControlBox      =   0   'False
   Icon            =   "FrmProgress.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1020
   ScaleWidth      =   4200
   StartUpPosition =   2  'CenterScreen
   Begin ComctlLib.ProgressBar Progress 
      Height          =   315
      Left            =   120
      TabIndex        =   1
      Top             =   540
      Width           =   3975
      _ExtentX        =   7011
      _ExtentY        =   556
      _Version        =   327682
      Appearance      =   1
   End
   Begin VB.Label Status 
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   180
      Width           =   3975
   End
End
Attribute VB_Name = "FrmProgress"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public Sub Update(ByVal Value As Long, ByVal Max As Long)
    Dim Buffer As Single
    
    On Error Resume Next
    Buffer = 100 * (Value / Max)
    Progress.Value = CInt(Buffer)
    DoEvents
End Sub

