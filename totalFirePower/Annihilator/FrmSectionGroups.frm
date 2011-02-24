VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.2#0"; "COMCTL32.OCX"
Begin VB.Form FrmSectionGroups 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Edit Sections"
   ClientHeight    =   4020
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5010
   Icon            =   "FrmSectionGroups.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4020
   ScaleWidth      =   5010
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton CmdOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   3720
      TabIndex        =   4
      Top             =   3540
      Width           =   1155
   End
   Begin VB.CommandButton CmdAddCategory 
      Caption         =   "Add &Category"
      Height          =   375
      Left            =   3720
      TabIndex        =   3
      Top             =   600
      Width           =   1155
   End
   Begin VB.CommandButton CmdAddGroup 
      Caption         =   "Add &Group"
      Height          =   375
      Left            =   3720
      TabIndex        =   2
      Top             =   120
      Width           =   1155
   End
   Begin VB.CommandButton CmdRemove 
      Caption         =   "&Remove"
      Height          =   375
      Left            =   3720
      TabIndex        =   1
      Top             =   1080
      Width           =   1155
   End
   Begin ComctlLib.TreeView TreeSections 
      Height          =   3795
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   3435
      _ExtentX        =   6059
      _ExtentY        =   6694
      _Version        =   327682
      Indentation     =   529
      LineStyle       =   1
      Style           =   7
      ImageList       =   "ImgTree"
      Appearance      =   1
   End
   Begin ComctlLib.ImageList ImgTree 
      Left            =   3720
      Top             =   1560
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   15
      MaskColor       =   65280
      _Version        =   327682
      BeginProperty Images {0713E8C2-850A-101B-AFC0-4210102A8DA7} 
         NumListImages   =   3
         BeginProperty ListImage1 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmSectionGroups.frx":000C
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmSectionGroups.frx":0116
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmSectionGroups.frx":0228
            Key             =   ""
         EndProperty
      EndProperty
   End
End
Attribute VB_Name = "FrmSectionGroups"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public Function GetWorld(Key As String) As Long
    Dim Index As Integer
    Dim Buffer As String
    
    GetWorld = -1
    For Index = 2 To Len(Key)
        If Mid(Key, Index, 1) = "c" Then Exit For
        Buffer = Buffer & Mid(Key, Index, 1)
    Next
    If Buffer <> "" Then GetWorld = Val(Buffer)
End Function

Public Function GetCategory(Key As String) As Long
    Dim Index As Integer
    Dim Buffer As String
    Dim Flag As Boolean
    
    Flag = False
    GetCategory = -1
    For Index = 1 To Len(Key)
        If Flag Then
            Buffer = Buffer & Mid(Key, Index, 1)
        End If
        If Mid(Key, Index, 1) = "c" Then
            Flag = True
        ElseIf Mid(Key, Index, 1) = "s" Then
            Exit For
        End If
    Next
    If Buffer <> "" Then GetCategory = Val(Buffer)
End Function

Public Function GetSection(Key As String) As Long
    Dim Index As Integer
    Dim Buffer As String
    Dim Flag As Boolean
    
    Flag = False
    GetSection = -1
    For Index = 1 To Len(Key)
        If Flag Then
            Buffer = Buffer & Mid(Key, Index, 1)
        End If
        If Mid(Key, Index, 1) = "s" Then
            Flag = True
        End If
    Next
    If Buffer <> "" Then GetSection = Val(Buffer)
End Function

Private Sub CmdAddCategory_Click()
    Dim wIndex As Integer, cIndex As Integer
    
    wIndex = GetWorld(TreeSections.SelectedItem.Key)
    If wIndex = -1 Then Exit Sub
    
    cIndex = Sections.AddCategory("Untitled", wIndex)
    TreeSections.Nodes.Add "w" & CStr(wIndex), tvwChild, "w" & CStr(wIndex) & "c" & CStr(cIndex), "Untitiled", 1, 2
    TreeSections.Nodes("w" & CStr(wIndex) & "c" & CStr(cIndex)).EnsureVisible
    Set TreeSections.SelectedItem = TreeSections.Nodes("w" & CStr(wIndex) & "c" & CStr(cIndex))
    TreeSections.StartLabelEdit
End Sub

Private Sub CmdAddGroup_Click()
    Dim Index As Long
    
    Index = Sections.AddWorld("Untitled")
    TreeSections.Nodes.Add , , "w" & CStr(Index), "Untitiled", 1, 2
    TreeSections.Nodes("w" & CStr(Index)).EnsureVisible
    Set TreeSections.SelectedItem = TreeSections.Nodes("w" & CStr(Index))
    TreeSections.StartLabelEdit
End Sub

Private Sub CmdOK_Click()
    Unload Me
End Sub

Private Sub CmdRemove_Click()
    Dim wIndex As Integer, cIndex As Integer, sIndex As Integer
    
    wIndex = GetWorld(TreeSections.SelectedItem.Key)
    cIndex = GetCategory(TreeSections.SelectedItem.Key)
    sIndex = GetSection(TreeSections.SelectedItem.Key)
    
    If (wIndex > -1) And (cIndex < 0) And (sIndex < 0) Then
        Sections.RemoveWorld wIndex
    ElseIf (wIndex > -1) And (cIndex > -1) And (sIndex < 0) Then
        Sections.RemoveCategory wIndex, cIndex
    ElseIf (wIndex > -1) And (cIndex > -1) And (sIndex > -1) Then
        Sections.RemoveSection wIndex, cIndex, sIndex
    End If
    TreeSections.Nodes.Remove TreeSections.SelectedItem.Key
End Sub

Private Sub Form_Load()
    Screen.MousePointer = vbHourglass
    DoEvents
    Sections.CreateTree TreeSections
    Screen.MousePointer = vbNormal
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Set SelectedSection = New classSection
    Sections.CreateTabs
End Sub

Private Sub TreeSections_AfterLabelEdit(Cancel As Integer, NewString As String)
    Dim wIndex As Integer, cIndex As Integer, sIndex As Integer
    
    wIndex = GetWorld(TreeSections.SelectedItem.Key)
    cIndex = GetCategory(TreeSections.SelectedItem.Key)
    sIndex = GetSection(TreeSections.SelectedItem.Key)
    
    If (wIndex > -1) And (cIndex < 0) And (sIndex < 0) Then
        Sections.RenameWorld wIndex, NewString
    ElseIf (wIndex > -1) And (cIndex > -1) And (sIndex < 0) Then
        Sections.RenameCategory wIndex, cIndex, NewString
    ElseIf (wIndex > -1) And (cIndex > -1) And (sIndex > -1) Then
        Sections.RenameSection wIndex, cIndex, sIndex, NewString
    End If
End Sub

