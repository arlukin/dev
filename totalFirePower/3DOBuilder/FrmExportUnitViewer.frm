VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.1#0"; "COMDLG32.OCX"
Begin VB.Form FrmExportUnitViewer 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Export to Unit Viewer"
   ClientHeight    =   2475
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   4905
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2475
   ScaleWidth      =   4905
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin MSComDlg.CommonDialog CommonDialog 
      Left            =   4260
      Top             =   1260
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   327681
      CancelError     =   -1  'True
   End
   Begin VB.CommandButton CmdClose 
      Caption         =   "&Close"
      Height          =   375
      Left            =   3780
      TabIndex        =   8
      Top             =   720
      Width           =   975
   End
   Begin VB.CommandButton CmdLaunch 
      Caption         =   "&Launch"
      Default         =   -1  'True
      Height          =   375
      Left            =   3780
      TabIndex        =   7
      Top             =   240
      Width           =   975
   End
   Begin VB.Frame Frame1 
      Height          =   2235
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   3495
      Begin VB.CommandButton CmdBrowseFBI 
         Caption         =   "..."
         Height          =   315
         Left            =   3000
         TabIndex        =   6
         Top             =   1740
         Width           =   315
      End
      Begin VB.TextBox TxtFBI 
         Height          =   315
         Left            =   300
         TabIndex        =   5
         Top             =   1740
         Width           =   2595
      End
      Begin VB.CommandButton CmdBrowseCOB 
         Caption         =   "..."
         Height          =   315
         Left            =   3000
         TabIndex        =   3
         Top             =   540
         Width           =   315
      End
      Begin VB.TextBox TxtCOB 
         Height          =   315
         Left            =   300
         TabIndex        =   2
         Top             =   540
         Width           =   2595
      End
      Begin VB.Label Label3 
         Caption         =   "Make sure ObjectName is set to arm3DOBUILDERUNIT in your FBI file."
         Height          =   435
         Left            =   300
         TabIndex        =   9
         Top             =   1260
         Width           =   3015
      End
      Begin VB.Label Label2 
         Caption         =   "FBI file"
         Height          =   195
         Left            =   180
         TabIndex        =   4
         Top             =   1020
         Width           =   915
      End
      Begin VB.Label Label1 
         Caption         =   "COB file"
         Height          =   195
         Left            =   180
         TabIndex        =   1
         Top             =   240
         Width           =   855
      End
   End
End
Attribute VB_Name = "FrmExportUnitViewer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim OriginalParenthWnd As Long

Private Sub CmdBrowseCOB_Click()
    On Error Resume Next
    CommonDialog.Filter = "COB files (*.cob)|*.cob"
    CommonDialog.FileName = ""
    CommonDialog.InitDir = OpenCobDir
    CommonDialog.ShowOpen
    If (CommonDialog.FileName <> "") And (Not Err) Then
        OpenCobDir = GetDirectory(CommonDialog.FileName)
        Screen.MousePointer = vbHourglass
        TxtCOB = CommonDialog.FileName
        OpenCobFile = TxtCOB
        Screen.MousePointer = vbNormal
    End If
End Sub

Private Sub CmdBrowseFBI_Click()
    On Error Resume Next
    CommonDialog.Filter = "FBI files (*.fbi)|*.fbi"
    CommonDialog.FileName = ""
    CommonDialog.InitDir = OpenFbiDir
    CommonDialog.ShowOpen
    If (CommonDialog.FileName <> "") And (Not Err) Then
        OpenFbiDir = GetDirectory(CommonDialog.FileName)
        Screen.MousePointer = vbHourglass
        TxtFBI = CommonDialog.FileName
        OpenFbiFile = TxtFBI
        Screen.MousePointer = vbNormal
    End If
End Sub

Private Sub CmdClose_Click()
    Unload Me
End Sub

Private Sub CmdLaunch_Click()
    Dim rc As Long
    
    On Error Resume Next
    
    Screen.MousePointer = vbHourglass
    Kill App.Path & "\arm3doBuilderUnit.ufo"
    Kill App.Path & "\cor3doBuilderUnit.ufo"
    If Not SaveTestHPI(App.Path & "\cor3doBuilderUnit.ufo", "cor", TxtCOB, TxtFBI) Then Exit Sub
    If Not SaveTestHPI(App.Path & "\arm3doBuilderUnit.ufo", "arm", TxtCOB, TxtFBI) Then Exit Sub
        
    ChDir App.Path
    rc = ShellExecute(0, "open", App.Path & "\unitview.exe", "", App.Path, SW_SHOWDEFAULT)
    
    Screen.MousePointer = vbNormal
End Sub

Private Sub Form_Load()
    OriginalParenthWnd = SetWindowLong(Me.hwnd, GWW_HWNDPARENT, Frm3do.hwnd)
    TxtCOB = OpenCobFile
    TxtFBI = OpenFbiFile
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Dim rc As Long
    
    If OriginalParenthWnd <> 0 Then
        rc = SetWindowLong(Me.hwnd, GWW_HWNDPARENT, OriginalParenthWnd)
    End If
End Sub
