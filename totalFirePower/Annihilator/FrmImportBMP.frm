VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.1#0"; "COMDLG32.OCX"
Begin VB.Form FrmImportBMP 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Import BMP"
   ClientHeight    =   2550
   ClientLeft      =   45
   ClientTop       =   345
   ClientWidth     =   4125
   Icon            =   "FrmImportBMP.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2550
   ScaleWidth      =   4125
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin MSComDlg.CommonDialog CommonDialog 
      Left            =   840
      Top             =   1980
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   327681
      CancelError     =   -1  'True
   End
   Begin VB.CommandButton CmdCancel 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   3000
      TabIndex        =   1
      Top             =   2040
      Width           =   975
   End
   Begin VB.CommandButton CmdOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   1860
      TabIndex        =   0
      Top             =   2040
      Width           =   975
   End
   Begin VB.Frame FrameBitmap 
      Height          =   1755
      Left            =   120
      TabIndex        =   4
      Top             =   120
      Width           =   3855
      Begin VB.CommandButton CmdBrowse 
         Caption         =   "..."
         Height          =   315
         Index           =   1
         Left            =   3360
         TabIndex        =   3
         Tag             =   "Windows Bitmap (*.bmp)|*.bmp"
         Top             =   1260
         Width           =   315
      End
      Begin VB.TextBox TxtFilename 
         Height          =   315
         Index           =   1
         Left            =   180
         TabIndex        =   6
         Top             =   1260
         Width           =   3075
      End
      Begin VB.TextBox TxtFilename 
         Height          =   315
         Index           =   0
         Left            =   180
         TabIndex        =   5
         Top             =   540
         Width           =   3075
      End
      Begin VB.CommandButton CmdBrowse 
         Caption         =   "..."
         Height          =   315
         Index           =   0
         Left            =   3360
         TabIndex        =   2
         Tag             =   "Windows Bitmap (*.bmp)|*.bmp"
         Top             =   540
         Width           =   315
      End
      Begin VB.Label Label7 
         Caption         =   "Height Map"
         Height          =   255
         Left            =   180
         TabIndex        =   8
         Top             =   960
         Width           =   915
      End
      Begin VB.Label Label6 
         Caption         =   "Bitmap"
         Height          =   255
         Left            =   180
         TabIndex        =   7
         Top             =   240
         Width           =   555
      End
   End
End
Attribute VB_Name = "FrmImportBMP"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public Sub CheckEnableOK()
    If TxtFilename(0).Text <> "" Then
        CmdOK.Enabled = True
    Else
        CmdOK.Enabled = False
    End If
End Sub

Private Sub CmdBrowse_Click(Index As Integer)
    Dim rc As Long
    Dim BitmapInfo As BITMAPINFOHEADER
    Static Width As Long
    Static Height As Long
    
    On Error GoTo Error
    CommonDialog.Filter = "Bitmap files (*.bmp)|*.bmp"
    CommonDialog.Filename = ""
    CommonDialog.ShowOpen
    If (CommonDialog.Filename <> "") And (Err.Number <> cdlCancel) Then
        rc = BMPInfo(CommonDialog.Filename, 0, BitmapInfo)
        If BitmapInfo.biBitCount <> 8 Then rc = 0
        If rc = 0 Then
            MsgBox "The bitmap file you selected was an invalid format.  Imported bitmaps must be 256 colors.", vbInformation, "Import BMP"
            Exit Sub
        End If
        If Index = 1 Then
            If BitmapInfo.biWidth <> (Width * 2) Or BitmapInfo.biHeight <> (Height * 2) Then
                MsgBox "The height map must be exactly 1/16 the size of the bitmap you are importing.  The height map for the selected bitmap should have these dimensions:  Width: " & CStr(Width * 2) & "  Height: " & CStr(Height * 2), vbInformation
                Exit Sub
            End If
        ElseIf Index = 0 Then
            Width = Int(BitmapInfo.biWidth / 32)
            Height = Int(BitmapInfo.biHeight / 32)
            TxtFilename(1).Text = ""
        End If
        TxtFilename(Index).Text = CommonDialog.Filename
    End If
    CheckEnableOK
Error:
End Sub

Private Sub CmdCancel_Click()
    Unload Me
End Sub

Private Sub CmdOK_Click()
    Screen.MousePointer = vbHourglass
    CmdOK.Enabled = False
    CmdCancel.Enabled = False
    Sections.ImportBMP TxtFilename(0), TxtFilename(1)
    Screen.MousePointer = vbNormal
    Unload Me
End Sub

Private Sub TxtFilename_KeyDown(Index As Integer, KeyCode As Integer, Shift As Integer)
    If KeyCode = vbKeyDelete Then KeyCode = 0
End Sub

Private Sub TxtFilename_KeyPress(Index As Integer, KeyAscii As Integer)
    KeyAscii = 0
End Sub
