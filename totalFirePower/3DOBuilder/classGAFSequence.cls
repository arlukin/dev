VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "classGAFSequence"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' GAF sequence class. '

Option Explicit

Public Used As Boolean

Public Frames As Integer
Private Unknown1 As Integer ' 1 '
Private Unknown2 As Long ' 0 '
Public EntryName As String

Private GAFFramePtrs() As GAFFramePtr
Private GAFFrames() As New classGAFFrame

Public Sub SaveBMP(File As Integer, FileName As String)
    Dim Buffer As Byte, LongBuffer As Long
    Dim Index As Integer
    Dim AnimName As String
    
    Frames = 1
    Put File, , Frames
    Unknown1 = 1
    Put File, , Unknown1
    Unknown2 = 0
    Put File, , Unknown2
    
    AnimName = Left(GetFilename(FileName), Len(GetFilename(FileName)) - 4)
    For Index = 1 To 32
        If Index <= Len(AnimName) Then
            Buffer = Asc(Mid(AnimName, Index, 1))
        Else
            Buffer = 0
        End If
        Put File, , Buffer
    Next
    
    LongBuffer = Seek(File) + 7
    Put File, , LongBuffer
    LongBuffer = 0 '10
    Put File, , LongBuffer
    
    ReDim GAFFrames(0)
    GAFFrames(0).SaveBMP File, FileName
End Sub
