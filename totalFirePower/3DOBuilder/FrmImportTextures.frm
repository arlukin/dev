VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.1#0"; "COMDLG32.OCX"
Begin VB.Form FrmImportTextures 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Import BMP Textures"
   ClientHeight    =   4410
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   6615
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4410
   ScaleWidth      =   6615
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin MSComDlg.CommonDialog CommonDialog 
      Left            =   3720
      Top             =   3840
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   327681
      CancelError     =   -1  'True
   End
   Begin VB.CommandButton CmdDelete 
      Caption         =   "<<"
      Height          =   435
      Left            =   3240
      TabIndex        =   10
      Top             =   2760
      Width           =   435
   End
   Begin VB.ListBox LstImport 
      Height          =   3180
      Left            =   3840
      MultiSelect     =   2  'Extended
      TabIndex        =   9
      Top             =   180
      Width           =   2535
   End
   Begin VB.CommandButton CmdCancel 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   5460
      TabIndex        =   8
      Top             =   3840
      Width           =   975
   End
   Begin VB.CommandButton CmdOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   4320
      TabIndex        =   7
      Top             =   3840
      Width           =   975
   End
   Begin VB.CommandButton CmdBrowse 
      Caption         =   "..."
      Height          =   315
      Left            =   2760
      TabIndex        =   6
      Top             =   3960
      Width           =   315
   End
   Begin VB.TextBox TxtFilename 
      Height          =   315
      Left            =   180
      Locked          =   -1  'True
      TabIndex        =   4
      Top             =   3960
      Width           =   2475
   End
   Begin VB.CommandButton CmdAdd 
      Caption         =   ">>"
      Height          =   435
      Left            =   3240
      TabIndex        =   3
      Top             =   2160
      Width           =   435
   End
   Begin VB.DirListBox Dirs 
      Height          =   1215
      Left            =   180
      TabIndex        =   2
      Top             =   600
      Width           =   2895
   End
   Begin VB.DriveListBox Drives 
      Height          =   315
      Left            =   180
      TabIndex        =   1
      Top             =   180
      Width           =   2895
   End
   Begin VB.FileListBox Files 
      Height          =   1455
      Left            =   180
      MultiSelect     =   2  'Extended
      Pattern         =   "*.bmp"
      TabIndex        =   0
      Top             =   1920
      Width           =   2895
   End
   Begin VB.Label Label1 
      Caption         =   "Texture Filename"
      Height          =   255
      Left            =   180
      TabIndex        =   5
      Top             =   3660
      Width           =   1395
   End
   Begin VB.Line Line5 
      BorderColor     =   &H80000010&
      X1              =   180
      X2              =   6420
      Y1              =   3540
      Y2              =   3540
   End
   Begin VB.Line Line6 
      BorderColor     =   &H80000014&
      X1              =   180
      X2              =   6420
      Y1              =   3555
      Y2              =   3555
   End
End
Attribute VB_Name = "FrmImportTextures"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim OriginalParenthWnd As Long

Private Sub CmdAdd_Click()
    Dim Index As Integer, i As Integer
    Dim Flag As Boolean
    
    On Error GoTo Error
    For Index = 0 To Files.ListCount - 1
        If Files.Selected(Index) Then
            Flag = False
            For i = 0 To LstImport.ListCount
                If LCase(LstImport.List(i)) = LCase(Files.Path & "\" & Files.List(Index)) Then
                    Flag = True
                    Exit For
                End If
            Next
            If Not Flag Then
                LstImport.AddItem Files.Path & "\" & Files.List(Index)
            End If
        End If
    Next
Error:
End Sub

Private Sub CmdBrowse_Click()
    On Error GoTo Error
    CommonDialog.Filter = "Texture files (*.ufo)|*.ufo"
    CommonDialog.DefaultExt = "ufo"
    CommonDialog.FileName = TALocation & "textures.ufo"
    CommonDialog.ShowSave
    If (CommonDialog.FileName <> "") And (Not Err) Then
        Screen.MousePointer = vbHourglass
        TxtFilename = CommonDialog.FileName
    End If
Error:
    Screen.MousePointer = vbNormal
End Sub

Private Sub CmdCancel_Click()
    Unload Me
End Sub

Private Sub CmdDelete_Click()
    Dim Index As Integer
    
    On Error GoTo Error
    For Index = LstImport.ListCount - 1 To 0 Step -1
        If LstImport.Selected(Index) Then
            LstImport.RemoveItem Index
        End If
    Next
Error:
End Sub

Private Sub CmdOK_Click()
    Dim rc As Long
    Dim FileHandle As Long
    Dim Buffer As String
    Dim Response As Integer
    Dim Index As Integer
    
    On Error GoTo Error
    If LstImport.ListCount = 0 Then
        MsgBox "You must choose at least one BMP to import.", vbInformation
        Exit Sub
    End If
    If TxtFilename = "" Then
        MsgBox "Choose a Texture filename.", vbInformation
        Exit Sub
    End If
    
    FileHandle = HPICreate(TxtFilename, FileHandle)
    If FileHandle = 0 Then Exit Sub
    
    Screen.MousePointer = vbHourglass
    GAF.SaveGAF CommonDialog.FileName & ".gaf"
    
    Buffer = "textures"
    rc = HPIAddFile(FileHandle, Buffer & "\" & Left(GetFilename(CommonDialog.FileName), Len(GetFilename(CommonDialog.FileName)) - 3) & "gaf", CommonDialog.FileName & ".gaf")
    If rc = 0 Then GoTo Error
    
    rc = HPIPackArchive(FileHandle, LZ77_COMPRESSION)
    Kill CommonDialog.FileName & ".gaf"
    
    Response = MsgBox("Do you want to add these textures to your 3DO Builder directory so they appear in the Unit Viewer?", vbYesNo, "Import Textures")
    If Response = vbYes Then
        Do While Dir(App.Path & "\texture_addon" & CStr(Index) & ".hpi") <> ""
            Index = Index + 1
        Loop
        FileHandle = 0
        FileHandle = HPICreate(App.Path & "\texture_addon" & CStr(Index) & ".hpi", FileHandle)
        If FileHandle = 0 Then GoTo Error
        
        Screen.MousePointer = vbHourglass
        GAF.SaveGAF CommonDialog.FileName & ".gaf"
        
        Buffer = "textures"
        rc = HPIAddFile(FileHandle, Buffer & "\" & Left(GetFilename(CommonDialog.FileName), Len(GetFilename(CommonDialog.FileName)) - 3) & "gaf", CommonDialog.FileName & ".gaf")
        If rc = 0 Then Exit Sub
        
        rc = HPIPackArchive(FileHandle, NO_COMPRESSION)
        Kill CommonDialog.FileName & ".gaf"
    End If
    
    AddTexture Buffer & "\" & Left(GetFilename(CommonDialog.FileName), Len(GetFilename(CommonDialog.FileName)) - 3) & "gaf", TxtFilename
Error:
    Screen.MousePointer = vbNormal
    Unload Me
End Sub

Private Sub Dirs_Change()
    Files.Path = Dirs.Path
End Sub

Private Sub Drives_Change()
    Dirs.Path = Drives.Drive
End Sub

Private Sub Files_DblClick()
    CmdAdd_Click
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
