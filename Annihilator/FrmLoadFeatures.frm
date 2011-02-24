VERSION 5.00
Begin VB.Form FrmLoadFeatures 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Load Features"
   ClientHeight    =   2355
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5250
   Icon            =   "FrmLoadFeatures.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2355
   ScaleWidth      =   5250
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton CmdSelectAll 
      Caption         =   "Select All"
      Height          =   375
      Left            =   3960
      TabIndex        =   4
      Top             =   660
      Width           =   1095
   End
   Begin VB.CommandButton CmdOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   3960
      TabIndex        =   2
      Top             =   180
      Width           =   1095
   End
   Begin VB.CommandButton CmdCancel 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   3960
      TabIndex        =   1
      Top             =   1140
      Width           =   1095
   End
   Begin VB.ListBox LstHPI 
      Height          =   1635
      Left            =   180
      Style           =   1  'Checkbox
      TabIndex        =   0
      Top             =   540
      Width           =   3555
   End
   Begin VB.Label Label1 
      Caption         =   "Select the categories to load from this archive."
      Height          =   255
      Left            =   180
      TabIndex        =   3
      Top             =   180
      Width           =   3495
   End
End
Attribute VB_Name = "FrmLoadFeatures"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public HPIFilename As String

Dim hHPI As Long
Dim OriginalParenthWnd  As Long

Private Sub CmdCancel_Click()
    Unload Me
End Sub

Private Sub CmdOK_Click()
    Dim Index As Integer
    
    On Error GoTo Error
    
    Screen.MousePointer = vbHourglass
    CmdOK.Enabled = False
    CmdCancel.Enabled = False
    CmdSelectAll.Enabled = False
    ReDim IgnoreWorlds(0)
    For Index = 0 To LstHPI.ListCount - 1
        If Not LstHPI.Selected(Index) Then
            ReDim Preserve IgnoreWorlds(UBound(IgnoreWorlds) + 1)
            IgnoreWorlds(UBound(IgnoreWorlds)) = LstHPI.List(Index)
        End If
    Next
    
    HPI.Initialize
    HPI.LoadHPI HPIFilename
    LoadTAFeatures
    Features.CreateTabs
Error:
    ReDim IgnoreWorlds(0)
    Screen.MousePointer = vbNormal
    Unload Me
End Sub

Private Sub CmdSelectAll_Click()
    Dim Index As Long
    
    On Error GoTo Error
    For Index = 0 To LstHPI.ListCount - 1
        LstHPI.Selected(Index) = True
    Next
Error:
End Sub

Private Sub Form_Load()
    Dim rc As Long
    
    On Error GoTo Error
    OriginalParenthWnd = SetWindowLong(Me.hwnd, GWW_HWNDPARENT, FrmAnnihilator.hwnd)
    If HPIFilename = "" Then Unload Me
    Show
    Screen.MousePointer = vbHourglass
    
    hHPI = HPIOpen(HPIFilename)
    CmdOK.Enabled = False
    If hHPI = 0 Then
        MsgBox "There was an error opening the HPI file " & HPIFilename & ".", vbExclamation, "Load Features"
        GoTo Error
    End If
    FillList
    If LstHPI.ListCount = 0 Then
        MsgBox "No features were found in " & HPIFilename & ".", vbExclamation, "Load Features"
        GoTo Error
    Else
        LstHPI.ListIndex = 0
    End If
    rc = HPIClose(hHPI)
    Screen.MousePointer = vbNormal
    CmdOK.Enabled = True
    Exit Sub
Error:
    rc = HPIClose(hHPI)
    Screen.MousePointer = vbNormal
    Unload Me
End Sub

Sub FillList()
    Dim NextFile As Long
    Dim Filename As String
    Dim FileType As Long
    Dim FileSize As Long
    Dim FeatureWorld As String
    Dim Index As Integer
    Dim Flag As Boolean
    
    NextFile = 0

    Filename = Space$(255)
    NextFile = HPIGetFiles(hHPI, NextFile, Filename, FileType, FileSize)
    Do While NextFile <> 0
        Filename = modHPI.StripNull(Filename)
        FeatureWorld = Filename
        If LCase(Left(FeatureWorld, 9)) = "features\" Then
            FeatureWorld = Right(FeatureWorld, Len(FeatureWorld) - 9)
            FeatureWorld = ParseDirName(FeatureWorld)
            Flag = False
            For Index = 0 To LstHPI.ListCount - 1
                If LCase(LstHPI.List(Index)) = LCase(FeatureWorld) Then
                    Flag = True
                End If
            Next
            If Not Flag Then
                LstHPI.AddItem FeatureWorld
            End If
        End If
        Filename = Space(255)
        NextFile = HPIGetFiles(hHPI, NextFile, Filename, FileType, FileSize)
        DoEvents
    Loop
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Dim rc As Long
    
    If OriginalParenthWnd <> 0 Then
        rc = SetWindowLong(hwnd, GWW_HWNDPARENT, OriginalParenthWnd)
    End If
End Sub
