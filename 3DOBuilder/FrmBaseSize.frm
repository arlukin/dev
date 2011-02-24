VERSION 5.00
Object = "{FE0065C0-1B7B-11CF-9D53-00AA003C9CB6}#1.0#0"; "COMCT232.OCX"
Begin VB.Form FrmBaseSize 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Set Base Size"
   ClientHeight    =   1380
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   2685
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1380
   ScaleWidth      =   2685
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton CmdClose 
      Caption         =   "&Close"
      Height          =   375
      Left            =   1620
      TabIndex        =   6
      Top             =   780
      Width           =   915
   End
   Begin VB.Frame Frame1 
      Height          =   1155
      Left            =   120
      TabIndex        =   3
      Top             =   60
      Width           =   1335
      Begin VB.TextBox TxtWidth 
         Height          =   315
         Left            =   180
         TabIndex        =   0
         Text            =   "32"
         Top             =   240
         Width           =   675
      End
      Begin VB.TextBox TxtHeight 
         Height          =   315
         Left            =   180
         TabIndex        =   1
         Text            =   "32"
         Top             =   720
         Width           =   675
      End
      Begin ComCtl2.UpDown ScrollWidth 
         Height          =   315
         Left            =   960
         TabIndex        =   4
         Top             =   240
         Width           =   240
         _ExtentX        =   423
         _ExtentY        =   556
         _Version        =   327681
         Value           =   32
         Max             =   256
         Min             =   1
         Enabled         =   -1  'True
      End
      Begin ComCtl2.UpDown ScrollHeight 
         Height          =   315
         Left            =   960
         TabIndex        =   5
         Top             =   720
         Width           =   240
         _ExtentX        =   423
         _ExtentY        =   556
         _Version        =   327681
         Value           =   32
         Max             =   255
         Min             =   1
         Enabled         =   -1  'True
      End
   End
   Begin VB.CommandButton CmdApply 
      Caption         =   "&Apply"
      Default         =   -1  'True
      Height          =   375
      Left            =   1620
      TabIndex        =   2
      Top             =   240
      Width           =   915
   End
End
Attribute VB_Name = "FrmBaseSize"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim OriginalParenthWnd As Long

Private Sub CmdApply_Click()
    File3DO.SetBaseSize ScrollWidth.Value, ScrollHeight.Value
    GetCenterModel
    Render
End Sub

Private Sub CmdClose_Click()
    Unload Me
End Sub

Private Sub Form_Load()
    OriginalParenthWnd = SetWindowLong(Me.hwnd, GWW_HWNDPARENT, Frm3do.hwnd)
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Dim rc As Long
    
    If OriginalParenthWnd <> 0 Then
        rc = SetWindowLong(Me.hwnd, GWW_HWNDPARENT, OriginalParenthWnd)
    End If
End Sub

Private Sub ScrollHeight_Change()
    TxtHeight = CStr(ScrollHeight.Value)
End Sub

Private Sub ScrollWidth_Change()
    TxtWidth = CStr(ScrollWidth.Value)
End Sub

Private Sub TxtHeight_LostFocus()
    On Error Resume Next
    ScrollHeight.Value = Val(TxtHeight)
    TxtHeight = CStr(ScrollHeight.Value)
End Sub

Private Sub TxtWidth_LostFocus()
    On Error Resume Next
    ScrollWidth.Value = Val(TxtWidth)
    TxtWidth = CStr(ScrollWidth.Value)
End Sub
