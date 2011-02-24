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

Private HPIGroups(3) As New classHPIGroup

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
    Dim Buffer As String, i As Integer, Flag As Boolean
    Dim Index As Integer
    
    NextFile = 0

    Filename = Space$(255)
    NextFile = HPIGetFiles(HPI, NextFile, Filename, FileType, FileSize)
    Do While NextFile <> 0
        Filename = modHPI.StripNull(Filename)
        If LCase(Left(Filename, 8)) = "sections" Then
            If InStr(1, Filename, ".") > 0 Then
                HPIGroups(HPISections).AddEntry HPIFilename, Filename
            End If
        ElseIf LCase(Left(Filename, 8)) = "features" Then
            If InStr(1, Filename, ".") > 0 Then
                Flag = False
                For Index = 0 To UBound(IgnoreWorlds)
                    If IgnoreWorlds(Index) <> "" Then
                        If InStr(1, LCase(Filename), LCase("\" & IgnoreWorlds(Index)) & "\") <> 0 Then
                            Flag = True
                            Exit For
                        End If
                    End If
                Next
                If Not Flag Then
                    HPIGroups(HPIFeatures).AddEntry HPIFilename, Filename
                End If
            End If
        ElseIf LCase(Left(Filename, 5)) = "anims" Then
            If InStr(1, Filename, ".") > 0 Then
                HPIGroups(HPIAnims).AddEntry HPIFilename, Filename
            End If
        ElseIf LCase(Left(Filename, 9)) = "objects3d" Then
            If InStr(1, Filename, ".") > 0 Then
                HPIGroups(HPIObjects).AddEntry HPIFilename, Filename
            End If
        ElseIf LCase(Left(Filename, 2)) = "ai" Then
            If InStr(1, Filename, ".") > 0 Then
                Flag = False
                Buffer = Left(Right(Filename, Len(Filename) - 3), Len(Filename) - 7)
                For i = 0 To UBound(AITypes)
                    If LCase(AITypes(i)) = LCase(Buffer) Then
                        Flag = True
                    End If
                Next
                If Not Flag Then
                    ReDim Preserve AITypes(UBound(AITypes) + 1)
                    AITypes(UBound(AITypes)) = Buffer
                End If
            End If
        End If
        
        Filename = Space(255)
        NextFile = HPIGetFiles(HPI, NextFile, Filename, FileType, FileSize)
        DoEvents
    Loop
End Sub

Public Sub CopyArrays(HPIGroup As Integer, ByRef HPIDest() As String, ByRef FilesDest() As String)
    HPIGroups(HPIGroup).CopyArrays HPIDest(), FilesDest()
End Sub

Public Sub FindFile(HPIGroup As Integer, SearchFile As String, HPIFile As String, Filename As String)
    HPIGroups(HPIGroup).FindFile SearchFile, HPIFile, Filename
End Sub
