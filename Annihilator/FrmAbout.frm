VERSION 5.00
Begin VB.Form FrmAbout 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "About Map Annihilator"
   ClientHeight    =   3495
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   5160
   Icon            =   "FrmAbout.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   233
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   344
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.TextBox TxtInfo 
      BackColor       =   &H8000000F&
      Height          =   1815
      Left            =   900
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   1
      Text            =   "FrmAbout.frx":000C
      Top             =   720
      Width           =   3975
   End
   Begin VB.CommandButton BtnOK 
      Caption         =   "OK"
      Default         =   -1  'True
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   350
      Index           =   1
      Left            =   4080
      TabIndex        =   0
      Top             =   2880
      Width           =   855
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   180
      Picture         =   "FrmAbout.frx":01F0
      Top             =   120
      Width           =   480
   End
   Begin VB.Label Label6 
      Caption         =   "Annihilator 1.5"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   900
      TabIndex        =   5
      Top             =   120
      Width           =   3495
   End
   Begin VB.Label Label7 
      Caption         =   "Copyright (C) 1998 Kinboat"
      Height          =   255
      Left            =   900
      TabIndex        =   4
      Top             =   360
      Width           =   3495
   End
   Begin VB.Label LblHomePage 
      AutoSize        =   -1  'True
      Caption         =   "TADD: Total Annihilation Design Division"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   -1  'True
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   195
      Left            =   900
      MouseIcon       =   "FrmAbout.frx":0632
      MousePointer    =   99  'Custom
      TabIndex        =   3
      Top             =   2700
      Width           =   2850
   End
   Begin VB.Label LblEmail 
      AutoSize        =   -1  'True
      Caption         =   "mailto: hotlizard@annihilated.org"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   -1  'True
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   195
      Left            =   900
      MouseIcon       =   "FrmAbout.frx":093C
      MousePointer    =   99  'Custom
      TabIndex        =   2
      Top             =   3060
      Width           =   2370
   End
End
Attribute VB_Name = "FrmAbout"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub BtnOK_Click(Index As Integer)
    Unload Me
End Sub

Private Sub LblEMail_Click()
    Dim rc As Long
    
    rc = ShellExecute(hwnd, "open", "mailto:hotlizard@annihilated.org", vbNullString, vbNullString, SW_NORMAL)
End Sub

Private Sub LblHomePage_Click()
    Dim rc As Long
    
    rc = ShellExecute(hwnd, "open", "http://tadd.annihilated.org/", vbNullString, vbNullString, SW_NORMAL)
End Sub

Private Sub TxtCredits_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = vbKeyDelete Then KeyCode = 0
End Sub

Private Sub TxtCredits_KeyPress(KeyAscii As Integer)
    KeyAscii = 0
End Sub

