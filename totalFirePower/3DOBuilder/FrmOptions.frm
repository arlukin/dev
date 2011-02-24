VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.1#0"; "COMDLG32.OCX"
Begin VB.Form FrmOptions 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Display Options"
   ClientHeight    =   3240
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6015
   Icon            =   "FrmOptions.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3240
   ScaleWidth      =   6015
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CheckBox ChkOpenGL 
      Caption         =   "Disable OpenGL View"
      Height          =   255
      Left            =   180
      TabIndex        =   19
      Top             =   2760
      Width           =   1935
   End
   Begin VB.CommandButton CmdDefaults 
      Caption         =   "&Defaults"
      Height          =   375
      Left            =   3600
      TabIndex        =   16
      Top             =   2700
      Width           =   1035
   End
   Begin VB.CommandButton CmdCancel 
      Caption         =   "&Cancel"
      Height          =   375
      Left            =   4800
      TabIndex        =   15
      Top             =   2700
      Width           =   1035
   End
   Begin VB.Frame Frame2 
      Caption         =   "Object colors"
      Height          =   2355
      Left            =   3060
      TabIndex        =   8
      Top             =   180
      Width           =   2775
      Begin VB.CommandButton CmdColor 
         Caption         =   "Single vertex color..."
         Height          =   375
         Index           =   5
         Left            =   660
         TabIndex        =   18
         Top             =   1800
         Width           =   1995
      End
      Begin VB.PictureBox PicColor 
         Height          =   375
         Index           =   5
         Left            =   120
         ScaleHeight     =   315
         ScaleWidth      =   315
         TabIndex        =   17
         Top             =   1800
         Width           =   375
      End
      Begin VB.PictureBox PicColor 
         Height          =   375
         Index           =   2
         Left            =   120
         ScaleHeight     =   315
         ScaleWidth      =   315
         TabIndex        =   14
         Top             =   360
         Width           =   375
      End
      Begin VB.CommandButton CmdColor 
         Caption         =   "Wireframe color..."
         Height          =   375
         Index           =   2
         Left            =   660
         TabIndex        =   13
         Top             =   360
         Width           =   1995
      End
      Begin VB.PictureBox PicColor 
         Height          =   375
         Index           =   3
         Left            =   120
         ScaleHeight     =   315
         ScaleWidth      =   315
         TabIndex        =   12
         Top             =   840
         Width           =   375
      End
      Begin VB.CommandButton CmdColor 
         Caption         =   "Selected object color..."
         Height          =   375
         Index           =   3
         Left            =   660
         TabIndex        =   11
         Top             =   840
         Width           =   1995
      End
      Begin VB.PictureBox PicColor 
         Height          =   375
         Index           =   4
         Left            =   120
         ScaleHeight     =   315
         ScaleWidth      =   315
         TabIndex        =   10
         Top             =   1320
         Width           =   375
      End
      Begin VB.CommandButton CmdColor 
         Caption         =   "Selected face color..."
         Height          =   375
         Index           =   4
         Left            =   660
         TabIndex        =   9
         Top             =   1320
         Width           =   1995
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "Background colors"
      Height          =   2355
      Left            =   120
      TabIndex        =   1
      Top             =   180
      Width           =   2775
      Begin VB.CommandButton CmdOpenGLColor 
         Caption         =   "3D View Background..."
         Height          =   375
         Left            =   660
         TabIndex        =   7
         Top             =   1320
         Width           =   1995
      End
      Begin VB.PictureBox PicOpenGLColor 
         Height          =   375
         Left            =   120
         ScaleHeight     =   315
         ScaleWidth      =   315
         TabIndex        =   6
         Top             =   1320
         Width           =   375
      End
      Begin VB.PictureBox PicColor 
         Height          =   375
         Index           =   0
         Left            =   120
         ScaleHeight     =   315
         ScaleWidth      =   315
         TabIndex        =   5
         Top             =   360
         Width           =   375
      End
      Begin VB.CommandButton CmdColor 
         Caption         =   "Background color..."
         Height          =   375
         Index           =   0
         Left            =   660
         TabIndex        =   4
         Top             =   360
         Width           =   1995
      End
      Begin VB.PictureBox PicColor 
         Height          =   375
         Index           =   1
         Left            =   120
         ScaleHeight     =   315
         ScaleWidth      =   315
         TabIndex        =   3
         Top             =   840
         Width           =   375
      End
      Begin VB.CommandButton CmdColor 
         Caption         =   "Grid color..."
         Height          =   375
         Index           =   1
         Left            =   660
         TabIndex        =   2
         Top             =   840
         Width           =   1995
      End
   End
   Begin VB.CommandButton CmdOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   2400
      TabIndex        =   0
      Top             =   2700
      Width           =   1035
   End
   Begin MSComDlg.CommonDialog CommonDialog 
      Left            =   5400
      Top             =   2700
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   327681
      CancelError     =   -1  'True
   End
End
Attribute VB_Name = "FrmOptions"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private SetOpenGLColor As Integer
Private SetColors(5) As Long

Private Sub CmdCancel_Click()
    Unload Me
End Sub

Private Sub CmdColor_Click(Index As Integer)
    On Error GoTo Error
    CommonDialog.Color = PicColor(Index).BackColor
    CommonDialog.ShowColor
    PicColor(Index).BackColor = CommonDialog.Color
    SetColors(Index) = PicColor(Index).BackColor
Error:
End Sub

Private Sub CmdDefaults_Click()
    SetColors(ColorBack) = &HFFFFFF
    SetColors(ColorGrid) = &H808080
    SetColors(ColorModel) = RGB(0, 0, 0)
    SetColors(ColorObject) = RGB(0, 0, 255)
    SetColors(ColorFace) = RGB(255, 0, 0)
    SetColors(ColorPoint) = RGB(255, 0, 255)
    SetOpenGLColor = 255
    DisableGL = False
    DisplayColors
End Sub

Private Sub CmdOK_Click()
    Dim Index As Integer
    
    For Index = 0 To 5
        Colors(Index) = SetColors(Index)
    Next
    If ChkOpenGL.Value = vbChecked Then
        DisableGL = True
    Else
        DisableGL = False
    End If
    InterfaceSetColors
    OpenGLColor = SetOpenGLColor
    Set3DView OpenGLType, OpenGLColor
    DrawView
    Unload Me
End Sub

Private Sub CmdOpenGLColor_Click()
    FrmColorPalette.Show 1
    If SelectedColor <> -1 Then
        SetOpenGLColor = SelectedColor
        PicOpenGLColor.BackColor = RGB(TAPalette(SetOpenGLColor).rgbRed, TAPalette(SetOpenGLColor).rgbGreen, TAPalette(SetOpenGLColor).rgbBlue)
    End If
End Sub

Private Sub Form_Load()
    Dim Index As Integer
    
    For Index = 0 To 5
        SetColors(Index) = Colors(Index)
    Next
    SetOpenGLColor = OpenGLColor
    DisplayColors
End Sub

Sub DisplayColors()
    Dim Index As Integer
    
    For Index = 0 To 5
        PicColor(Index).BackColor = SetColors(Index)
    Next
    PicOpenGLColor.BackColor = RGB(TAPalette(SetOpenGLColor).rgbRed, TAPalette(SetOpenGLColor).rgbGreen, TAPalette(SetOpenGLColor).rgbBlue)
    If DisableGL Then
        ChkOpenGL.Value = vbChecked
    Else
        ChkOpenGL.Value = vbUnchecked
    End If
End Sub
