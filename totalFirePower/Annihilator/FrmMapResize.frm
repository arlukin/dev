VERSION 5.00
Object = "{FE0065C0-1B7B-11CF-9D53-00AA003C9CB6}#1.0#0"; "COMCT232.OCX"
Begin VB.Form FrmMapResize 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Resize Map"
   ClientHeight    =   1605
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4110
   Icon            =   "FrmMapResize.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1605
   ScaleWidth      =   4110
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.Frame Frame4 
      Height          =   795
      Left            =   2880
      TabIndex        =   14
      Top             =   120
      Width           =   1035
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Size:"
         Height          =   255
         Left            =   60
         TabIndex        =   16
         Top             =   180
         Width           =   855
      End
      Begin VB.Label LblMapSize 
         Alignment       =   1  'Right Justify
         Caption         =   "2 x 2"
         Height          =   255
         Left            =   60
         TabIndex        =   15
         Top             =   480
         Width           =   855
      End
   End
   Begin VB.Frame Frame3 
      Height          =   795
      Left            =   180
      TabIndex        =   11
      Top             =   120
      Width           =   2535
      Begin VB.TextBox TxtWidth 
         Height          =   315
         Left            =   120
         TabIndex        =   0
         Text            =   "64"
         Top             =   300
         Width           =   735
      End
      Begin VB.TextBox TxtHeight 
         Height          =   315
         Left            =   1380
         TabIndex        =   1
         Text            =   "64"
         Top             =   300
         Width           =   735
      End
      Begin ComCtl2.UpDown Scroll 
         Height          =   315
         Index           =   0
         Left            =   900
         TabIndex        =   12
         Top             =   300
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
         Left            =   2160
         TabIndex        =   13
         Top             =   300
         Width           =   240
         _ExtentX        =   423
         _ExtentY        =   556
         _Version        =   327681
         Value           =   64
         Max             =   4096
         Min             =   16
         Enabled         =   -1  'True
      End
   End
   Begin VB.CommandButton CmdOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   1680
      TabIndex        =   7
      Top             =   1080
      Width           =   1035
   End
   Begin VB.CommandButton CmdCancel 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   2880
      TabIndex        =   8
      Top             =   1080
      Width           =   1035
   End
   Begin VB.Frame Frame2 
      Caption         =   "Alignment"
      Height          =   675
      Left            =   180
      TabIndex        =   10
      Top             =   1620
      Visible         =   0   'False
      Width           =   2535
      Begin VB.OptionButton OptCenter 
         Caption         =   "&Center"
         Height          =   255
         Left            =   1560
         TabIndex        =   6
         Top             =   300
         Width           =   795
      End
      Begin VB.OptionButton OptRight 
         Caption         =   "&Right"
         Height          =   255
         Left            =   780
         TabIndex        =   5
         Top             =   300
         Width           =   735
      End
      Begin VB.OptionButton OptLeft 
         Caption         =   "&Left"
         Height          =   255
         Left            =   120
         TabIndex        =   4
         Top             =   300
         Value           =   -1  'True
         Width           =   615
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "Fill Options"
      Height          =   675
      Left            =   180
      TabIndex        =   9
      Top             =   2460
      Visible         =   0   'False
      Width           =   2535
      Begin VB.OptionButton OptFill 
         Caption         =   "&Default"
         Height          =   255
         Left            =   120
         TabIndex        =   2
         Top             =   300
         Value           =   -1  'True
         Width           =   915
      End
      Begin VB.OptionButton OptTile 
         Caption         =   "&Tile map"
         Height          =   255
         Left            =   1080
         TabIndex        =   3
         Top             =   300
         Width           =   915
      End
   End
End
Attribute VB_Name = "FrmMapResize"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

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

Private Sub CmdCancel_Click()
    Unload Me
End Sub

Private Sub cmdOK_Click()
    Dim Align As Integer
    
    If OptLeft.Value Then
        Align = 0
    ElseIf OptCenter.Value Then
        Align = 1
    ElseIf OptRight.Value Then
        Align = 2
    End If
    
    On Error GoTo Error
    Screen.MousePointer = vbHourglass
    Maps(SelectedMap).ResizeMap Val(TxtWidth), Val(TxtHeight), Align, OptTile.Value
Error:
    Screen.MousePointer = vbNormal
    Unload Me
End Sub

Private Sub Form_Load()
    On Error Resume Next
    If Not MapLoaded Then Unload Me
    Scroll(0).Value = Maps(SelectedMap).Width / 2
    Scroll(1).Value = Maps(SelectedMap).Height / 2
    CalculateMapSize
End Sub

Private Sub Scroll_Change(Index As Integer)
    On Error Resume Next
    Select Case Index
        Case 0
            TxtWidth = CStr(Scroll(Index).Value)
        Case 1
            TxtHeight = CStr(Scroll(Index).Value)
    End Select
    CalculateMapSize
End Sub

Private Sub TxtHeight_LostFocus()
    On Error Resume Next
    If Val(TxtHeight) < Scroll(1).Min Then
        Scroll(1).Value = Scroll(1).Min
    ElseIf Val(TxtHeight) > Scroll(1).Max Then
        Scroll(1).Value = Scroll(1).Max
    Else
        Scroll(1).Value = Val(TxtHeight)
    End If
End Sub

Private Sub TxtWidth_LostFocus()
    On Error Resume Next
    If Val(TxtWidth) < Scroll(0).Min Then
        Scroll(0).Value = Scroll(0).Min
    ElseIf Val(TxtWidth) > Scroll(0).Max Then
        Scroll(0).Value = Scroll(0).Max
    Else
        Scroll(0).Value = Val(TxtWidth)
    End If
End Sub
