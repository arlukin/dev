VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.1#0"; "COMDLG32.OCX"
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.2#0"; "COMCTL32.OCX"
Object = "{FE0065C0-1B7B-11CF-9D53-00AA003C9CB6}#1.0#0"; "COMCT232.OCX"
Begin VB.Form FrmNew 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "New Map"
   ClientHeight    =   2550
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4440
   Icon            =   "FrmNew.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2550
   ScaleWidth      =   4440
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.Frame FrameMap 
      Height          =   1215
      Left            =   300
      TabIndex        =   9
      Top             =   540
      Width           =   3855
      Begin VB.Frame Frame1 
         Height          =   855
         Left            =   2640
         TabIndex        =   20
         Top             =   180
         Width           =   1035
         Begin VB.Label LblMapSize 
            Alignment       =   1  'Right Justify
            Caption         =   "2 x 2"
            Height          =   255
            Left            =   60
            TabIndex        =   22
            Top             =   480
            Width           =   855
         End
         Begin VB.Label Label1 
            Alignment       =   1  'Right Justify
            Caption         =   "Size:"
            Height          =   255
            Left            =   60
            TabIndex        =   21
            Top             =   180
            Width           =   855
         End
      End
      Begin VB.TextBox TxtHeight 
         Height          =   315
         Left            =   1140
         TabIndex        =   11
         Text            =   "64"
         Top             =   720
         Width           =   795
      End
      Begin VB.TextBox TxtWidth 
         Height          =   315
         Left            =   1140
         TabIndex        =   10
         Text            =   "64"
         Top             =   240
         Width           =   795
      End
      Begin ComCtl2.UpDown Scroll 
         Height          =   315
         Index           =   0
         Left            =   1980
         TabIndex        =   12
         Top             =   240
         Width           =   240
         _ExtentX        =   423
         _ExtentY        =   556
         _Version        =   327681
         Value           =   64
         Max             =   4096
         Min             =   16
         Enabled         =   -1  'True
      End
      Begin ComCtl2.UpDown Scroll 
         Height          =   315
         Index           =   1
         Left            =   1980
         TabIndex        =   14
         Top             =   720
         Width           =   240
         _ExtentX        =   423
         _ExtentY        =   556
         _Version        =   327681
         Value           =   64
         Max             =   4096
         Min             =   16
         Enabled         =   -1  'True
      End
      Begin VB.Label LblLandType 
         Height          =   255
         Left            =   1740
         TabIndex        =   19
         Top             =   3720
         Width           =   3915
      End
      Begin VB.Label LblArchiveDescription 
         Height          =   255
         Left            =   1740
         TabIndex        =   18
         Top             =   3420
         Width           =   3915
      End
      Begin VB.Label Label15 
         Alignment       =   1  'Right Justify
         Caption         =   "Height (tiles)"
         Height          =   255
         Left            =   60
         TabIndex        =   17
         Top             =   780
         Width           =   975
      End
      Begin VB.Label Label14 
         Alignment       =   1  'Right Justify
         Caption         =   "Width (tiles)"
         Height          =   255
         Left            =   120
         TabIndex        =   16
         Top             =   300
         Width           =   915
      End
   End
   Begin VB.Frame FrameBitmap 
      Height          =   1215
      Left            =   300
      TabIndex        =   2
      Top             =   540
      Visible         =   0   'False
      Width           =   3855
      Begin VB.CommandButton CmdBrowse 
         Caption         =   "..."
         Height          =   315
         Index           =   0
         Left            =   3360
         TabIndex        =   6
         Tag             =   "Windows Bitmap (*.bmp)|*.bmp"
         Top             =   240
         Width           =   315
      End
      Begin VB.TextBox TxtExtractBMP 
         Height          =   315
         Left            =   1080
         TabIndex        =   5
         Top             =   240
         Width           =   2175
      End
      Begin VB.TextBox TxtHeightMap 
         Height          =   315
         Left            =   1080
         TabIndex        =   4
         Top             =   720
         Width           =   2175
      End
      Begin VB.CommandButton CmdBrowse 
         Caption         =   "..."
         Height          =   315
         Index           =   1
         Left            =   3360
         TabIndex        =   3
         Tag             =   "Windows Bitmap (*.bmp)|*.bmp"
         Top             =   720
         Width           =   315
      End
      Begin VB.Label Label6 
         Alignment       =   1  'Right Justify
         Caption         =   "Bitmap"
         Height          =   255
         Left            =   120
         TabIndex        =   8
         Top             =   300
         Width           =   855
      End
      Begin VB.Label Label7 
         Alignment       =   1  'Right Justify
         Caption         =   "Height Map"
         Height          =   255
         Left            =   120
         TabIndex        =   7
         Top             =   780
         Width           =   855
      End
   End
   Begin ComctlLib.TabStrip TabNewMap 
      Height          =   1695
      Left            =   180
      TabIndex        =   1
      Top             =   180
      Width           =   4095
      _ExtentX        =   7223
      _ExtentY        =   2990
      _Version        =   327682
      BeginProperty Tabs {0713E432-850A-101B-AFC0-4210102A8DA7} 
         NumTabs         =   2
         BeginProperty Tab1 {0713F341-850A-101B-AFC0-4210102A8DA7} 
            Caption         =   "Map"
            Key             =   "map"
            Object.Tag             =   ""
            ImageVarType    =   2
         EndProperty
         BeginProperty Tab2 {0713F341-850A-101B-AFC0-4210102A8DA7} 
            Caption         =   "Bitmap"
            Key             =   "bmp"
            Object.Tag             =   ""
            ImageVarType    =   2
         EndProperty
      EndProperty
   End
   Begin VB.CommandButton BtnCancel 
      Caption         =   "&Cancel"
      Height          =   375
      Left            =   3240
      TabIndex        =   15
      Top             =   2040
      Width           =   1035
   End
   Begin VB.CommandButton BtnOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   2100
      TabIndex        =   13
      Top             =   2040
      Width           =   1035
   End
   Begin MSComDlg.CommonDialog CommonDialog 
      Left            =   180
      Top             =   1980
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   327681
      CancelError     =   -1  'True
   End
   Begin VB.Label Status 
      Height          =   255
      Left            =   180
      TabIndex        =   0
      Top             =   2100
      Width           =   1815
   End
End
Attribute VB_Name = "FrmNew"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim OriginalParenthWnd As Long

Private Sub BtnCancel_Click()
    Unload Me
End Sub

Private Sub BtnOK_Click()
    Dim Response As Integer
    
    On Error Resume Next
    Screen.MousePointer = vbHourglass
    If TabNewMap.SelectedItem.Index = 1 Then
        CreateMap Val(TxtWidth), Val(TxtHeight)
    ElseIf TabNewMap.SelectedItem.Index = 2 Then ' Bitmap extraction. '
        EnableControls False
        On Error GoTo 0
        Status.Visible = True
        Screen.MousePointer = vbHourglass
        Status = "Loading BMP file..."
        DoEvents
        If Not LoadBMPFile(TxtExtractBMP) Then
            MsgBox "The bitmap must be in 256 color mode.  Use the 256 Total Annihilation color palette included in Tapalette.bmp to save your image.", vbCritical
            Screen.MousePointer = vbNormal
            Unload Me
        End If
        Status = "Creating map graphics..."
        DoEvents
        CreateMapFromBMP TxtHeightMap
    End If
    Screen.MousePointer = vbNormal
    Unload Me
End Sub

Private Sub CmdBrowse_Click(Index As Integer)
    On Error GoTo Error
    CommonDialog.DefaultExt = "bmp"
    CommonDialog.Filter = "Bitmap files (*.bmp)|*.bmp"
    CommonDialog.Filename = ""
    CommonDialog.ShowSave
    If (CommonDialog.Filename <> "") And (Err.Number <> cdlCancel) Then
        If Index = 0 Then
            TxtExtractBMP = CommonDialog.Filename
        ElseIf Index = 1 Then
            TxtHeightMap = CommonDialog.Filename
        End If
    End If
Error:
End Sub

Private Sub Form_Load()
    ' Initialize. '
    On Error Resume Next
    OriginalParenthWnd = SetWindowLong(Me.hwnd, GWW_HWNDPARENT, FrmAnnihilator.hwnd)
    CalculateMapSize
    Show
    TxtWidth.SetFocus
End Sub

Private Sub CalculateMapSize()
    Dim Width As Long
    Dim Height As Long
    
    Width = Val(TxtWidth) * 32
    Height = Val(TxtHeight) * 32
    Width = Int(Width / 512)
    Height = Int(Height / 512)
    If ((Val(TxtWidth) * 32) Mod 512) <> 0 Then Width = Width + 1
    If ((Val(TxtHeight) * 32) Mod 512) <> 0 Then Height = Height + 1
    LblMapSize = CStr(Width) & " x " & CStr(Height)
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Dim rc As Long
    
    If OriginalParenthWnd <> 0 Then
        rc = SetWindowLong(hwnd, GWW_HWNDPARENT, OriginalParenthWnd)
    End If
End Sub

Private Sub Scroll_Change(Index As Integer)
    Select Case Index
        Case 0
            TxtWidth = CStr(Scroll(Index).Value)
        Case 1
            TxtHeight = CStr(Scroll(Index).Value)
    End Select
    CalculateMapSize
End Sub

Private Sub TabNewMap_Click()
    If TabNewMap.SelectedItem.Key = "map" Then
        FrameMap.Visible = True
        FrameBitmap.Visible = False
    ElseIf TabNewMap.SelectedItem.Key = "bmp" Then
        FrameBitmap.Visible = True
        FrameMap.Visible = False
    End If
End Sub

Private Sub TxtExtractBMP_KeyPress(KeyAscii As Integer)
    KeyAscii = 0
End Sub

Private Sub TxtHeight_GotFocus()
    TxtHeight.SelStart = 0
    TxtHeight.SelLength = Len(TxtHeight)
End Sub

Private Sub TxtHeight_KeyPress(KeyAscii As Integer)
    If (KeyAscii < Asc("0") Or KeyAscii > Asc("9")) And (KeyAscii <> 8) Then
        KeyAscii = 0
    End If
End Sub

Private Sub TxtHeight_LostFocus()
    If Val(TxtHeight) < Scroll(1).Min Then
        Scroll(1).Value = Scroll(1).Min
    ElseIf Val(TxtHeight) > Scroll(1).Max Then
        Scroll(1).Value = Scroll(1).Max
    Else
        Scroll(1).Value = Val(TxtHeight)
    End If
    CalculateMapSize
End Sub

Private Sub TxtHeightMap_KeyPress(KeyAscii As Integer)
    KeyAscii = 0
End Sub

Private Sub TxtWidth_GotFocus()
    TxtWidth.SelStart = 0
    TxtWidth.SelLength = Len(TxtWidth)
End Sub

Private Sub TxtWidth_KeyPress(KeyAscii As Integer)
    If (KeyAscii < Asc("0") Or KeyAscii > Asc("9")) And (KeyAscii <> 8) Then
        KeyAscii = 0
    End If
End Sub

Private Sub TxtWidth_LostFocus()
    If Val(TxtWidth) < Scroll(0).Min Then
        Scroll(0).Value = Scroll(0).Min
    ElseIf Val(TxtWidth) > Scroll(0).Max Then
        Scroll(0).Value = Scroll(0).Max
    Else
        Scroll(0).Value = Val(TxtWidth)
    End If
    CalculateMapSize
End Sub
