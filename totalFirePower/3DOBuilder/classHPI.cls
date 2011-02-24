VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "classHPI"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private HPIGroups(0) As New classHPIGroup

Public Sub Initialize()
    Dim Index As Long
    
    For Index = 0 To UBound(HPIGroups)
        HPIGroups(Index).Initialize
    Next
End Sub

' Load the HPI file. '
Public Sub LoadHPI(Filename As String)
    Dim HPI As Long
    
    HPI = HPIOpen(Filename)
    If HPI = 0 Then
        Exit Sub
    End If
    
    CreateList HPI, Filename
    HPI = HPIClose(HPI)
End Sub

' Create a file list for the specified HPI file. '
Private Sub CreateList(HPI As Long, HPIFilename As String)
    Dim NextFile As Long
    Dim Filename As String
    Dim FileType As Long
    Dim FileSize As Long

    NextFile = 0

    Filename = Space$(255)
    NextFile = HPIDir(HPI, NextFile, "textures", Filename, FileType, FileSize)
    Do While NextFile <> 0
        Filename = modHPI.StripNull(Filename)
        If InStr(1, Filename, ".") > 0 Then
            HPIGroups(HPITextures).AddEntry HPIFilename, "textures\" & Filename
        End If
        
        Filename = Space(255)
        NextFile = HPIDir(HPI, NextFile, "textures", Filename, FileType, FileSize)
        DoEvents
    Loop
End Sub

Public Sub CopyArrays(HPIGroup As Integer, ByRef HPIDest() As String, ByRef FilesDest() As String)
    HPIGroups(HPIGroup).CopyArrays HPIDest(), FilesDest()
End Sub

Public Sub FindFile(HPIGroup As Integer, SearchFile As String, HPIFile As String, Filename As String)
    HPIGroups(HPIGroup).FindFile SearchFile, HPIFile, Filename
End Sub
