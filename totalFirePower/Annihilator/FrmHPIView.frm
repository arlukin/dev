VERSION 5.00
Begin VB.Form FrmHPIView 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Load from HPI"
   ClientHeight    =   2880
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   3915
   Icon            =   "FrmHPIView.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2880
   ScaleWidth      =   3915
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.ListBox LstHPI 
      Height          =   1620
      Left            =   180
      TabIndex        =   3
      Top             =   540
      Width           =   3555
   End
   Begin VB.CommandButton CmdCancel 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   2640
      TabIndex        =   2
      Top             =   2340
      Width           =   1095
   End
   Begin VB.CommandButton CmdOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   1440
      TabIndex        =   1
      Top             =   2340
      Width           =   1095
   End
   Begin VB.Label Label1 
      Caption         =   "Select a map to load"
      Height          =   255
      Left            =   180
      TabIndex        =   0
      Top             =   180
      Width           =   1635
   End
End
Attribute VB_Name = "FrmHPIView"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public HPIFilename As String

' HPI variables '
Dim HPI As Long

Dim OriginalParenthWnd As Long

Private Sub CmdCancel_Click()
    Unload Me
End Sub

Private Sub CmdOK_Click()
    Dim rc As Long
    
    ' Initialize. '
    On Error Resume Next
    If LstHPI.ListIndex = -1 Then Exit Sub
    CmdOK.Enabled = False
    CmdCancel.Enabled = False
        
    ' Load the map. '
    If LoadMap(LstHPI.List(LstHPI.ListIndex), HPI, HPIFilename) Then
        InterfaceUpdate
    Else
        MsgBox "There was an error loading the map file you selected.", vbExclamation, "Open"
    End If

    rc = HPIClose(HPI)
    On Error GoTo 0
    Unload Me
End Sub

Private Sub Form_Load()
    OriginalParenthWnd = SetWindowLong(Me.hwnd, GWW_HWNDPARENT, FrmAnnihilator.hwnd)
    If HPIFilename = "" Then Unload Me
    
    HPI = HPIOpen(HPIFilename)
    If HPI = 0 Then
        MsgBox "There was an error opening the HPI file " & HPIFilename & ".", vbExclamation, "Load HPI"
        Unload Me
    End If
    Me.Caption = HPIFilename
    FillList
    If LstHPI.ListCount = 0 Then
        MsgBox "There were no maps found in the HPI file you selected.", vbInformation, "Load HPI"
        Unload Me
    Else
        LstHPI.ListIndex = 0
        If LstHPI.ListCount = 1 Then CmdOK_Click
    End If
End Sub

Sub FillList()
    Dim NextFile As Long
    Dim FileName As String
    Dim FileType As Long
    Dim FileSize As Long

    NextFile = 0

    FileName = Space$(255)
    NextFile = HPIGetFiles(HPI, NextFile, FileName, FileType, FileSize)
    Do While NextFile <> 0
        FileName = modHPI.StripNull(FileName)
        If LCase(Right(FileName, 3)) = "tnt" Then
            LstHPI.AddItem FileName
            LstHPI.ItemData(LstHPI.NewIndex) = FileType
        End If
        FileName = Space(255)
        NextFile = HPIGetFiles(HPI, NextFile, FileName, FileType, FileSize)
        DoEvents
    Loop
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Dim rc As Long
    
    If OriginalParenthWnd <> 0 Then
        rc = SetWindowLong(hwnd, GWW_HWNDPARENT, OriginalParenthWnd)
    End If
End Sub

Private Sub LstHPI_DblClick()
    CmdOK_Click
End Sub
