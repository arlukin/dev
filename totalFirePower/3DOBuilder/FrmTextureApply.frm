VERSION 5.00
Object = "{FE0065C0-1B7B-11CF-9D53-00AA003C9CB6}#1.0#0"; "COMCT232.OCX"
Begin VB.Form FrmTextureApply 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Apply Texture to Range"
   ClientHeight    =   1980
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5235
   Icon            =   "FrmTextureApply.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1980
   ScaleWidth      =   5235
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.Frame FrameTexture 
      Caption         =   "Texture"
      Height          =   1635
      Left            =   120
      TabIndex        =   9
      Top             =   180
      Width           =   1395
      Begin VB.PictureBox PicTexture 
         AutoRedraw      =   -1  'True
         Height          =   1155
         Left            =   120
         ScaleHeight     =   73
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   73
         TabIndex        =   11
         Top             =   300
         Width           =   1155
      End
   End
   Begin VB.CommandButton CmdCancel 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   4020
      TabIndex        =   8
      Top             =   1440
      Width           =   1035
   End
   Begin VB.CommandButton CmdOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   2820
      TabIndex        =   7
      Top             =   1440
      Width           =   1035
   End
   Begin VB.Frame Frame1 
      Caption         =   "Faces"
      Height          =   1095
      Left            =   1680
      TabIndex        =   0
      Top             =   180
      Width           =   3375
      Begin VB.CheckBox ChkApplyToObject 
         Caption         =   "&Apply to entire Object"
         Height          =   255
         Left            =   600
         TabIndex        =   10
         Top             =   720
         Width           =   2115
      End
      Begin ComCtl2.UpDown ScrollTo 
         Height          =   315
         Left            =   2940
         TabIndex        =   6
         Top             =   300
         Width           =   240
         _ExtentX        =   423
         _ExtentY        =   556
         _Version        =   327681
         Enabled         =   -1  'True
      End
      Begin ComCtl2.UpDown ScrollFrom 
         Height          =   315
         Left            =   1380
         TabIndex        =   5
         Top             =   300
         Width           =   240
         _ExtentX        =   423
         _ExtentY        =   556
         _Version        =   327681
         Enabled         =   -1  'True
      End
      Begin VB.TextBox TxtTo 
         Height          =   315
         Left            =   2160
         TabIndex        =   4
         Top             =   300
         Width           =   735
      End
      Begin VB.TextBox TxtFrom 
         Height          =   315
         Left            =   600
         TabIndex        =   3
         Top             =   300
         Width           =   735
      End
      Begin VB.Label LblFrom 
         Caption         =   "From"
         Height          =   255
         Left            =   120
         TabIndex        =   2
         Top             =   360
         Width           =   435
      End
      Begin VB.Label LblTo 
         Caption         =   "To"
         Height          =   255
         Left            =   1860
         TabIndex        =   1
         Top             =   360
         Width           =   255
      End
   End
End
Attribute VB_Name = "FrmTextureApply"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private SetColor As Integer
Private SetTexture As String

Private Sub ChkApplyToObject_Click()
    If ChkApplyToObject.Value = vbChecked Then
        ScrollFrom.Enabled = False
        ScrollTo.Enabled = False
        TxtFrom.Enabled = False
        TxtTo.Enabled = False
        LblFrom.Enabled = False
        LblTo.Enabled = False
    Else
        ScrollFrom.Enabled = True
        ScrollTo.Enabled = True
        TxtFrom.Enabled = True
        TxtTo.Enabled = True
        LblFrom.Enabled = True
        LblTo.Enabled = True
    End If
End Sub

Private Sub CmdCancel_Click()
    Unload Me
End Sub

Private Sub CmdOK_Click()
    On Error Resume Next
    If ChkApplyToObject.Value = vbChecked Then
        SelectedObject.ApplyTextures 0, ScrollTo.Max, SetTexture
        SelectedObject.ApplyColor 0, ScrollTo.Max, SetColor
    Else
        If ScrollFrom.Value <= ScrollTo.Value Then
            SelectedObject.ApplyTextures ScrollFrom.Value, ScrollTo.Value, SetTexture
            SelectedObject.ApplyColor 0, ScrollTo.Max, SetColor
        End If
    End If
    Unload Me
End Sub

Private Sub Form_Load()
    On Error Resume Next
    SetTexture = ""
    SetColor = -1
    ScrollFrom.Min = 0
    ScrollFrom.Max = SelectedObject.PrimitiveCount - 1
    ScrollTo.Min = 0
    ScrollTo.Max = SelectedObject.PrimitiveCount - 1
    ScrollTo.Value = 0
    ScrollFrom.Value = 0
    SetTexture = SelectedObject.GetTextureName(SelectedPrimitive)
    SetColor = SelectedObject.GetColor(SelectedPrimitive)
    If SetTexture = "" And SelectedObject.GetColor(SelectedPrimitive) > -1 Then
        PicTexture.BackColor = Frm3do.PicTexture.BackColor
    Else
        PicTexture.Picture = Frm3do.PicTexture.Image
    End If
End Sub

Private Sub ScrollFrom_Change()
    TxtFrom = CStr(ScrollFrom.Value) & ":" & CStr(ScrollFrom.Max)
End Sub

Private Sub ScrollTo_Change()
    TxtTo = CStr(ScrollTo.Value) & ":" & CStr(ScrollTo.Max)
End Sub

Private Sub TxtFrom_LostFocus()
    Dim Value As Long
    
    On Error Resume Next
    Value = Val(TxtFrom)
    If Value > ScrollFrom.Max Then Value = ScrollFrom.Max
    If Value < ScrollFrom.Min Then Value = ScrollFrom.Min
    ScrollFrom.Value = Value
End Sub

Private Sub TxtTo_LostFocus()
    Dim Value As Long
    
    On Error Resume Next
    Value = Val(TxtTo)
    If Value > ScrollTo.Max Then Value = ScrollTo.Max
    If Value < ScrollTo.Min Then Value = ScrollTo.Min
    ScrollTo.Value = Value
End Sub
