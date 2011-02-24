VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.2#0"; "COMCTL32.OCX"
Begin VB.Form FrmOptions 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Annihilator Options"
   ClientHeight    =   4905
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4650
   Icon            =   "FrmOptions.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4905
   ScaleWidth      =   4650
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.PictureBox PicStartup 
      BorderStyle     =   0  'None
      Height          =   3675
      Left            =   180
      ScaleHeight     =   3675
      ScaleWidth      =   4275
      TabIndex        =   3
      Top             =   480
      Width           =   4275
      Begin VB.Frame Frame1 
         Caption         =   "General options"
         Height          =   1275
         Left            =   120
         TabIndex        =   8
         Top             =   120
         Width           =   4035
         Begin VB.CheckBox ChkFeatures 
            Caption         =   "Auto-load features on startup"
            Height          =   255
            Left            =   180
            TabIndex        =   11
            Top             =   600
            Width           =   2475
         End
         Begin VB.CheckBox ChkSections 
            Caption         =   "Auto-load sections on startup"
            Height          =   255
            Left            =   180
            TabIndex        =   10
            Top             =   300
            Width           =   2535
         End
         Begin VB.CheckBox ChkRetainFeatures 
            Caption         =   "Retain features once loaded"
            Height          =   255
            Left            =   180
            TabIndex        =   9
            Top             =   900
            Width           =   2415
         End
      End
      Begin VB.Frame Frame4 
         Caption         =   "Startup file search locations"
         Height          =   1995
         Left            =   120
         TabIndex        =   4
         Top             =   1560
         Width           =   4035
         Begin VB.CommandButton CmdRemove 
            Caption         =   "&Remove"
            Height          =   375
            Left            =   2940
            TabIndex        =   7
            Top             =   1440
            Width           =   915
         End
         Begin VB.CommandButton CmdAdd 
            Caption         =   "&Add..."
            Height          =   375
            Left            =   1860
            TabIndex        =   6
            Top             =   1440
            Width           =   915
         End
         Begin VB.ListBox LstLocations 
            Height          =   1035
            Left            =   180
            TabIndex        =   5
            Top             =   300
            Width           =   3675
         End
      End
   End
   Begin VB.CommandButton CmdCancel 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   3420
      TabIndex        =   2
      Top             =   4380
      Width           =   1095
   End
   Begin VB.CommandButton CmdOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   2160
      TabIndex        =   1
      Top             =   4380
      Width           =   1095
   End
   Begin ComctlLib.TabStrip TabOptions 
      Height          =   4095
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   4395
      _ExtentX        =   7752
      _ExtentY        =   7223
      _Version        =   327682
      BeginProperty Tabs {0713E432-850A-101B-AFC0-4210102A8DA7} 
         NumTabs         =   1
         BeginProperty Tab1 {0713F341-850A-101B-AFC0-4210102A8DA7} 
            Caption         =   "General"
            Key             =   ""
            Object.Tag             =   ""
            ImageVarType    =   2
         EndProperty
      EndProperty
   End
End
Attribute VB_Name = "FrmOptions"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub CmdAdd_Click()
    Dim Index As Integer
    
    FrmDirectory.Show 1
    If DirectoryReturn <> "" Then
        For Index = 0 To LstLocations.ListCount
            If LCase(DirectoryReturn) <> LCase(LstLocations.List(Index)) Then
                LstLocations.AddItem DirectoryReturn
            End If
        Next
    End If
End Sub

Private Sub CmdCancel_Click()
    Unload Me
End Sub

Private Sub CmdOK_Click()
    Dim Index As Integer
    
    ReDim Preserve StartupLocations(1)
    For Index = 0 To LstLocations.ListCount
        ReDim Preserve StartupLocations(2 + Index)
        StartupLocations(2 + Index) = LstLocations.List(Index)
    Next
    
    SaveSetting ProgramName, "Startup", "LoadFeatures", ChkFeatures.Value
    SaveSetting ProgramName, "Startup", "LoadSections", ChkSections.Value
    RetainFeatures = (ChkRetainFeatures.Value = vbChecked)
    Unload Me
End Sub

Private Sub CmdRemove_Click()
    If LstLocations.ListIndex > -1 Then
        LstLocations.RemoveItem LstLocations.ListIndex
    End If
End Sub

Private Sub Form_Load()
    Dim Index As Integer
    
    LstLocations.Clear
    For Index = 2 To UBound(StartupLocations)
        LstLocations.AddItem StartupLocations(Index)
    Next
    
    ChkFeatures.Value = Val(GetSetting(ProgramName, "Startup", "LoadFeatures", vbChecked))
    ChkSections.Value = Val(GetSetting(ProgramName, "Startup", "LoadSections", vbChecked))
    If RetainFeatures Then
        ChkRetainFeatures.Value = vbChecked
    Else
        ChkRetainFeatures.Value = vbUnchecked
    End If
End Sub

