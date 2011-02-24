VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.1#0"; "COMDLG32.OCX"
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.2#0"; "COMCTL32.OCX"
Begin VB.Form Frm3doview 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "3do Format Viewer"
   ClientHeight    =   4935
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7275
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   4935
   ScaleWidth      =   7275
   StartUpPosition =   2  'CenterScreen
   Begin ComctlLib.TreeView Tree3do 
      Height          =   3855
      Left            =   120
      TabIndex        =   6
      Top             =   540
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   6800
      _Version        =   327682
      Indentation     =   353
      LabelEdit       =   1
      LineStyle       =   1
      Style           =   7
      Appearance      =   1
   End
   Begin VB.PictureBox Frame 
      Height          =   3855
      Left            =   3000
      ScaleHeight     =   3795
      ScaleWidth      =   4095
      TabIndex        =   2
      Top             =   540
      Width           =   4155
      Begin VB.ListBox LstInfo 
         Height          =   3375
         Left            =   60
         TabIndex        =   8
         Top             =   360
         Width           =   3975
      End
      Begin ComctlLib.TabStrip TabObject 
         Height          =   3795
         Left            =   0
         TabIndex        =   3
         Top             =   0
         Width           =   4095
         _ExtentX        =   7223
         _ExtentY        =   6694
         _Version        =   327682
         BeginProperty Tabs {0713E432-850A-101B-AFC0-4210102A8DA7} 
            NumTabs         =   3
            BeginProperty Tab1 {0713F341-850A-101B-AFC0-4210102A8DA7} 
               Caption         =   "Header"
               Key             =   "header"
               Object.Tag             =   ""
               ImageVarType    =   2
            EndProperty
            BeginProperty Tab2 {0713F341-850A-101B-AFC0-4210102A8DA7} 
               Caption         =   "Vertexes"
               Key             =   "vertex"
               Object.Tag             =   ""
               ImageVarType    =   2
            EndProperty
            BeginProperty Tab3 {0713F341-850A-101B-AFC0-4210102A8DA7} 
               Caption         =   "Primitives"
               Key             =   "primitive"
               Object.Tag             =   ""
               ImageVarType    =   2
            EndProperty
         EndProperty
      End
   End
   Begin MSComDlg.CommonDialog CommonDialog 
      Left            =   6240
      Top             =   0
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   327681
      CancelError     =   -1  'True
   End
   Begin VB.CommandButton CmdBrowse 
      Caption         =   "..."
      Height          =   315
      Left            =   6840
      TabIndex        =   1
      Top             =   120
      Width           =   315
   End
   Begin VB.TextBox TxtFilename 
      Height          =   315
      Left            =   900
      TabIndex        =   0
      Top             =   120
      Width           =   5835
   End
   Begin VB.Label Label2 
      Caption         =   "Filename"
      Height          =   255
      Left            =   120
      TabIndex        =   7
      Top             =   180
      Width           =   675
   End
   Begin VB.Label Status 
      Height          =   255
      Left            =   120
      TabIndex        =   5
      Top             =   4620
      Width           =   4935
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "Written by Kinboat, 1998."
      Height          =   255
      Left            =   5220
      TabIndex        =   4
      Top             =   4620
      Width           =   1935
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   120
      X2              =   7140
      Y1              =   4515
      Y2              =   4515
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   120
      X2              =   7140
      Y1              =   4500
      Y2              =   4500
   End
End
Attribute VB_Name = "Frm3doview"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub CmdBrowse_Click()
    On Error Resume Next
    CommonDialog.Filter = "3do files (*.3do)|*.3do"
    CommonDialog.ShowOpen
    If (CommonDialog.Filename <> "") And (Not Err) Then
        Screen.MousePointer = vbHourglass
        TxtFilename = CommonDialog.Filename
        Load3do CommonDialog.Filename
        Screen.MousePointer = vbNormal
    End If
End Sub

Private Sub TabObject_Click()
    Dim rc As Boolean
    
    On Error Resume Next
    rc = File3do.ShowInfo(SelObj)
End Sub

Private Sub Tree3do_Click()
    Dim rc As Boolean
    
    On Error Resume Next
    SelObj = Tree3do.SelectedItem.Text
    rc = File3do.ShowInfo(SelObj)
End Sub

Private Sub TxtFilename_KeyPress(KeyAscii As Integer)
    KeyAscii = 0
End Sub
