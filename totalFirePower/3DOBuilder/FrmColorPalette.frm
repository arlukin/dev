VERSION 5.00
Begin VB.Form FrmColorPalette 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Color Palette"
   ClientHeight    =   2220
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   2220
   Icon            =   "FrmColorPalette.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2220
   ScaleWidth      =   2220
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.PictureBox Colors 
      AutoRedraw      =   -1  'True
      BackColor       =   &H00FFFFFF&
      Height          =   2220
      Left            =   0
      ScaleHeight     =   144
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   144
      TabIndex        =   0
      Top             =   0
      Width           =   2220
   End
End
Attribute VB_Name = "FrmColorPalette"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Sub CreateColorPalette()
    Dim xIndex As Integer, yIndex As Integer
    Dim x As Integer, y As Integer
    Dim Color As Integer
    
    For yIndex = 1 To 144 Step 9
        For xIndex = 1 To 144 Step 9
            For x = 0 To 7
                For y = 0 To 7
                    Colors.PSet (xIndex + x, yIndex + y), RGB(TAPalette(Color).rgbRed, TAPalette(Color).rgbGreen, TAPalette(Color).rgbBlue)
                Next
            Next
            Color = Color + 1
        Next
    Next
End Sub

Private Sub Colors_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    SelectedColor = Int(y / 9) * 16 + Int(x / 9)
    Unload Me
End Sub

Private Sub Form_Load()
    SelectedColor = -1
    Screen.MousePointer = vbHourglass
    CreateColorPalette
    Screen.MousePointer = vbNormal
End Sub

