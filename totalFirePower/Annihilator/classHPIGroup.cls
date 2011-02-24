VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "classHPIGroup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private Files() As String ' The filenames. '
Private HPI() As String ' The HPI file for the filenames. '

Public Sub Initialize()
    ReDim Files(0)
    ReDim HPI(0)
End Sub

Public Sub AddEntry(HPIName As String, Filename As String)
    Dim Index As Long
    Dim Flag As Boolean
    
    Flag = False
    For Index = 0 To UBound(Files)
        If Trim(Files(Index)) = "" Then
            Flag = True
            Files(Index) = Filename
            HPI(Index) = HPIName
        End If
    Next
    
    If Not Flag Then
        ReDim Preserve Files(UBound(Files) + 1)
        ReDim Preserve HPI(UBound(Files))
        Files(UBound(Files)) = Filename
        HPI(UBound(HPI)) = HPIName
    End If
End Sub

Public Sub CopyArrays(ByRef HPIDest() As String, ByRef FilesDest() As String)
    Dim Index As Long
    
    ReDim FilesDest(UBound(Files))
    ReDim HPIDest(UBound(HPI))
    For Index = 0 To UBound(Files)
        FilesDest(Index) = Files(Index)
        HPIDest(Index) = HPI(Index)
    Next
End Sub

Public Sub FindFile(SearchFile As String, HPIFile As String, Filename As String)
    Dim Index As Long
    Dim Flag As Boolean
    
    Flag = False
    For Index = 0 To UBound(Files)
        If LCase(Right(Files(Index), Len(SearchFile))) = LCase(SearchFile) Then
            Flag = True
            Exit For
        End If
    Next
    If Flag Then
        HPIFile = HPI(Index)
        Filename = Files(Index)
    End If
End Sub
