VERSION 5.00
Object = "{FE0065C0-1B7B-11CF-9D53-00AA003C9CB6}#1.0#0"; "COMCT232.OCX"
Begin VB.Form FrmFeatureFill 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Feature Filters"
   ClientHeight    =   1635
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5820
   Icon            =   "FrmFeatureFill.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1635
   ScaleWidth      =   5820
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.Frame Frame1 
      Height          =   855
      Left            =   120
      TabIndex        =   7
      Top             =   120
      Width           =   5535
      Begin ComCtl2.UpDown ScrollPadding 
         Height          =   315
         Left            =   5100
         TabIndex        =   13
         Top             =   300
         Width           =   240
         _ExtentX        =   423
         _ExtentY        =   556
         _Version        =   327681
         Max             =   16
      End
      Begin VB.TextBox TxtPadding 
         Height          =   315
         Left            =   4560
         TabIndex        =   2
         Text            =   "0"
         Top             =   300
         Width           =   495
      End
      Begin VB.TextBox TxtMaxHeight 
         Height          =   315
         Left            =   2880
         TabIndex        =   1
         Text            =   "255"
         Top             =   300
         Width           =   495
      End
      Begin ComCtl2.UpDown ScrollMinHeight 
         Height          =   315
         Left            =   1560
         TabIndex        =   9
         Top             =   300
         Width           =   240
         _ExtentX        =   423
         _ExtentY        =   556
         _Version        =   327681
         Max             =   255
         Enabled         =   -1  'True
      End
      Begin VB.TextBox TxtMinHeight 
         Height          =   315
         Left            =   1020
         TabIndex        =   0
         Text            =   "0"
         Top             =   300
         Width           =   495
      End
      Begin ComCtl2.UpDown ScrollMaxHeight 
         Height          =   315
         Left            =   3420
         TabIndex        =   11
         Top             =   300
         Width           =   240
         _ExtentX        =   423
         _ExtentY        =   556
         _Version        =   327681
         Value           =   255
         Max             =   255
         Enabled         =   -1  'True
      End
      Begin VB.Label Label3 
         Caption         =   "Padding"
         Height          =   255
         Left            =   3900
         TabIndex        =   12
         Top             =   360
         Width           =   615
      End
      Begin VB.Label Label2 
         Caption         =   "Max Height"
         Height          =   255
         Left            =   1980
         TabIndex        =   10
         Top             =   360
         Width           =   855
      End
      Begin VB.Label Label1 
         Caption         =   "Min Height"
         Height          =   255
         Left            =   120
         TabIndex        =   8
         Top             =   360
         Width           =   855
      End
   End
   Begin VB.CommandButton CmdOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   3540
      TabIndex        =   3
      Top             =   1140
      Width           =   975
   End
   Begin VB.TextBox TxtSealevel 
      BackColor       =   &H8000000F&
      BorderStyle     =   0  'None
      Height          =   195
      Left            =   1020
      Locked          =   -1  'True
      TabIndex        =   6
      Text            =   "0"
      Top             =   1200
      Width           =   435
   End
   Begin VB.CommandButton CmdCancel 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   4680
      TabIndex        =   4
      Top             =   1140
      Width           =   975
   End
   Begin VB.Label Label4 
      Caption         =   "Sea Level"
      Height          =   255
      Left            =   120
      TabIndex        =   5
      Top             =   1200
      Width           =   795
   End
End
Attribute VB_Name = "FrmFeatureFill"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub CmdCancel_Click()
    Unload Me
End Sub

Private Sub CmdOK_Click()
    FeatureMinHeight = ScrollMinHeight.Value
    FeatureMaxHeight = ScrollMaxHeight.Value
    FeaturePadding = ScrollPadding.Value
    Unload Me
End Sub

Private Sub Form_Load()
    Dim Value As Long
    
    On Error Resume Next
    Value = Maps(SelectedMap).GetSealevel
    TxtSealevel = CStr(Value)
    
    ScrollMinHeight.Value = FeatureMinHeight
    ScrollMaxHeight.Value = FeatureMaxHeight
    ScrollPadding.Value = FeaturePadding
End Sub

Private Sub ScrollMaxHeight_Change()
    TxtMaxHeight = CStr(ScrollMaxHeight.Value)
End Sub

Private Sub ScrollMinHeight_Change()
    TxtMinHeight = CStr(ScrollMinHeight.Value)
End Sub

Private Sub ScrollPadding_Change()
    TxtPadding = CStr(ScrollPadding.Value)
End Sub

Private Sub TxtMaxHeight_LostFocus()
    On Error Resume Next
    If Val(TxtMaxHeight) < ScrollMaxHeight.Min Then
        ScrollMaxHeight.Value = ScrollMaxHeight.Min
    ElseIf Val(TxtMaxHeight) > ScrollMaxHeight.Max Then
        ScrollMaxHeight.Value = ScrollMaxHeight.Max
    Else
        ScrollMaxHeight.Value = Val(TxtMaxHeight)
    End If
End Sub

Private Sub TxtMinHeight_LostFocus()
    On Error Resume Next
    If Val(TxtMinHeight) < ScrollMinHeight.Min Then
        ScrollMinHeight.Value = ScrollMinHeight.Min
    ElseIf Val(TxtMinHeight) > ScrollMinHeight.Max Then
        ScrollMinHeight.Value = ScrollMinHeight.Max
    Else
        ScrollMinHeight.Value = Val(TxtMinHeight)
    End If
End Sub

Private Sub TxtPadding_LostFocus()
    On Error Resume Next
    If Val(TxtPadding) < ScrollPadding.Min Then
        ScrollPadding.Value = ScrollPadding.Min
    ElseIf Val(TxtPadding) > ScrollPadding.Max Then
        ScrollPadding.Value = ScrollPadding.Max
    Else
        ScrollPadding.Value = Val(TxtPadding)
    End If
End Sub
