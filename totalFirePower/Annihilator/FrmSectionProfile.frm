VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.1#0"; "COMDLG32.OCX"
Begin VB.Form FrmSectionProfile 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Create Section Profile"
   ClientHeight    =   4230
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   5025
   Icon            =   "FrmSectionProfile.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4230
   ScaleWidth      =   5025
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin MSComDlg.CommonDialog CommonDialog 
      Left            =   2640
      Top             =   3660
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   327681
      CancelError     =   -1  'True
   End
   Begin VB.CommandButton CmdSave 
      Caption         =   "&Save..."
      Height          =   375
      Left            =   1380
      TabIndex        =   7
      Top             =   3660
      Width           =   975
   End
   Begin VB.CommandButton CmdOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   240
      TabIndex        =   6
      Top             =   3660
      Width           =   975
   End
   Begin VB.CommandButton CmdRemove 
      Caption         =   "&Remove"
      Height          =   375
      Left            =   3780
      TabIndex        =   5
      Top             =   3660
      Width           =   975
   End
   Begin VB.ListBox LstSections 
      Height          =   2400
      Left            =   2640
      TabIndex        =   2
      Top             =   1140
      Width           =   2115
   End
   Begin VB.ListBox LstGroups 
      Height          =   2400
      Left            =   240
      TabIndex        =   0
      Top             =   1140
      Width           =   2115
   End
   Begin VB.Label Label3 
      Caption         =   "Select a group, then click on a section in Annihilator's section palette to add it to the group.  All sections must be 512x512."
      Height          =   435
      Left            =   240
      TabIndex        =   4
      Top             =   240
      Width           =   4515
   End
   Begin VB.Label Label2 
      Caption         =   "Sections"
      Height          =   255
      Left            =   2640
      TabIndex        =   3
      Top             =   840
      Width           =   795
   End
   Begin VB.Label Label1 
      Caption         =   "Groups"
      Height          =   255
      Left            =   240
      TabIndex        =   1
      Top             =   840
      Width           =   735
   End
End
Attribute VB_Name = "FrmSectionProfile"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub CmdOK_Click()
    Unload Me
End Sub

Private Sub Form_Load()
    LstGroups.AddItem "Land"
    LstGroups.AddItem "Water"
    LstGroups.AddItem "Hills"
    LstGroups.AddItem "Coast north interior"
    LstGroups.AddItem "Coast north east interior"
    LstGroups.AddItem "Coast east interior"
    LstGroups.AddItem "Coast south east interior"
    LstGroups.AddItem "Coast south interior"
    LstGroups.AddItem "Coast south west interior"
    LstGroups.AddItem "Coast west interior"
    LstGroups.AddItem "Coast north west interior"
    LstGroups.AddItem "Coast north exterior"
    LstGroups.AddItem "Coast north east exterior"
    LstGroups.AddItem "Coast east exterior"
    LstGroups.AddItem "Coast south east exterior"
    LstGroups.AddItem "Coast south exterior"
    LstGroups.AddItem "Coast south west exterior"
    LstGroups.AddItem "Coast west exterior"
    LstGroups.AddItem "Coast north west exterior"
End Sub
