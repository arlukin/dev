VERSION 5.00
Begin VB.Form FrmAbout 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "About"
   ClientHeight    =   3660
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5175
   Icon            =   "FrmAbout.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3660
   ScaleWidth      =   5175
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.TextBox TxtInfo 
      BackColor       =   &H8000000F&
      Height          =   1815
      Left            =   960
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   4
      Text            =   "FrmAbout.frx":000C
      Top             =   1080
      Width           =   4035
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
      Index           =   0
      Left            =   4080
      TabIndex        =   0
      Top             =   3120
      Width           =   855
   End
   Begin VB.Label Label2 
      Caption         =   "Feature improvement by Marco."
      Height          =   255
      Left            =   960
      TabIndex        =   6
      Top             =   720
      Width           =   3855
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      BackColor       =   &H00FFFFFF&
      BackStyle       =   0  'Transparent
      Caption         =   "mailto:hotlizard@annihilated.org"
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
      MouseIcon       =   "FrmAbout.frx":00DF
      MousePointer    =   99  'Custom
      TabIndex        =   5
      Top             =   3360
      Width           =   2325
   End
   Begin VB.Label Label6 
      Caption         =   "3DO Builder 1.1m"
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
      TabIndex        =   3
      Top             =   120
      Width           =   3495
   End
   Begin VB.Label Label7 
      Caption         =   "Copyright (C) 1998 by Kinboat."
      Height          =   255
      Left            =   900
      TabIndex        =   2
      Top             =   360
      Width           =   3495
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   180
      Picture         =   "FrmAbout.frx":03E9
      Top             =   120
      Width           =   480
   End
   Begin VB.Label LblHomePage 
      AutoSize        =   -1  'True
      BackColor       =   &H00FFFFFF&
      BackStyle       =   0  'Transparent
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
      MouseIcon       =   "FrmAbout.frx":06F3
      MousePointer    =   99  'Custom
      TabIndex        =   1
      Top             =   3060
      Width           =   2850
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

Private Sub Label1_Click()
    Dim rc As Long
    
    rc = ShellExecute(hwnd, "open", "mailto:hotlizard@annihilated.org", vbNullString, vbNullString, SW_NORMAL)
End Sub

Private Sub LblHomePage_Click()
    Dim rc As Long
    
    rc = ShellExecute(hwnd, "open", "http://tadd.annihilated.org", vbNullString, vbNullString, SW_NORMAL)
End Sub

Private Sub TxtInfo_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = vbKeyDelete Then KeyCode = 0
End Sub

Private Sub TxtInfo_KeyPress(KeyAscii As Integer)
    KeyAscii = 0
End Sub
