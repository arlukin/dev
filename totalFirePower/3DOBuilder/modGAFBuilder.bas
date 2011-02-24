Attribute VB_Name = "modGAFBuilder"
' GAF builder module. '

Option Explicit

' GAF Header. '
Global Const GAFSignature = 0
Global Const GAFEntries = 1
Global Const GAFUnknown = 2 ' Always 0. '

' GAF file types. '
Type GAFFramePtr
    PTRFrame As Long
    Unknown1 As Long ' 03 = anim, 0A = fixed. '
End Type

' The GAF file. '
Public GAF As New classGAF

' Return the filename from path. '
Public Function GetFilename(Path As String) As String
    Dim rc As Long
    Dim i As Integer
    
    On Error Resume Next
    For i = 1 To Len(Path)
        If Mid(Path, i, 1) = "\" Then rc = i
    Next
    If rc > 0 Then
        GetFilename = Right(Path, Len(Path) - rc)
    Else
        GetFilename = Path
    End If
End Function

Public Function FixString(Buffer As String) As String
    Dim Result As String
    Dim Index As Long
    
    Result = ""
    For Index = 1 To Len(Buffer)
        If Asc(Mid(Buffer, Index, 1)) <> 0 Then
            Result = Result & Mid(Buffer, Index, 1)
        Else
            Exit For
        End If
    Next
    FixString = Result
End Function

