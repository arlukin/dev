Attribute VB_Name = "modLWO"
' Light-wave format module. '

Option Explicit

Public Sub LoadLWO(Filename As String, Vertexes() As class3dVertex, Faces() As class3dPrimitive)
    Dim File As Integer
    Dim Chunk As String * 4
    Dim Size As Long
    Dim NumPoints As Long
    Dim NumFaces As Long
    Dim NumVerts As Integer
    Dim Value() As Byte
    Dim Buffer As Byte
    Dim i As Integer
    Dim Count As Integer
    Dim Offset As Long
    Dim VertexOffset As Long, FaceOffset As Long
    Dim Face() As Integer
    
    On Error GoTo Error
    File = FreeFile
    Open Filename For Binary As File
    
    ' Get header. '
    Get File, , Chunk
    If Chunk <> "FORM" Then Exit Sub
    ReDim Value(3)
    Get File, , Value()
    Size = ReverseLong(Value)
    Get File, , Chunk
    If Chunk <> "LWOB" Then Exit Sub
    
    ' Get points. '
    Get File, , Chunk
    If Chunk <> "PNTS" Then Exit Sub
    Get File, , Value()
    NumPoints = ReverseLong(Value)
    NumPoints = NumPoints / 12
    ReDim Vertexes(NumPoints - 1)
    For i = 0 To UBound(Vertexes)
        Get File, , Value()
        Vertexes(i).x = ReverseSingle(Value) * ScaleConstant
        Get File, , Value()
        Vertexes(i).y = ReverseSingle(Value) * ScaleConstant
        Get File, , Value()
        Vertexes(i).z = ReverseSingle(Value) * ScaleConstant
    Next
    
    ' Get faces. '
    Get File, , Chunk
    If Chunk <> "SRFS" Then Exit Sub
    Get File, , Value()
    Size = ReverseLong(Value)
    For i = 0 To Size - 1
        Get File, , Buffer
        If Buffer = 0 Then
            Count = Count + 1
        End If
    Next
    NumFaces = Int(Count / 2)
    
    ' Get polys. '
    Get File, , Chunk
    If Chunk <> "POLS" Then Exit Sub
    Get File, , Value()
    Size = ReverseLong(Value)
    
    FaceOffset = 0
    ReDim Value(1)
    Get File, , Value()
    NumVerts = ReverseInt(Value)
    Do While NumVerts <> 0
        ReDim Face(NumVerts - 1)
        For i = 0 To NumVerts - 1
            Get File, , Value()
            Face(i) = ReverseInt(Value)
        Next
        ReDim Preserve Faces(FaceOffset)
        Faces(FaceOffset).Initialize
        Faces(FaceOffset).SetVertexes Face()
        FaceOffset = FaceOffset + 1
        
        Get File, , Value()
        Get File, , Chunk
        If Chunk = "SURF" Then Exit Do
        Seek File, Seek(File) - 4
        Get File, , Value()
        NumVerts = ReverseInt(Value)
    Loop
    
    Close File
    Exit Sub
Error:
    MsgBox Err.Description
    Resume
End Sub

Public Function ReverseLong(Value() As Byte) As Long
    Dim File As Integer
    Dim i As Integer
    Dim Buffer As Long
    
    File = FreeFile
    Open "temp.bin" For Binary As File
    For i = UBound(Value) To 0 Step -1
        Put File, , Value(i)
    Next
    Seek File, 1
    Get File, , Buffer
    ReverseLong = Buffer
    
    Close File
    Kill "temp.bin"
End Function

Public Function ReverseInt(Value() As Byte) As Integer
    Dim File As Integer
    Dim i As Integer
    Dim Buffer As Integer
    
    File = FreeFile
    Open "temp.bin" For Binary As File
    For i = UBound(Value) To 0 Step -1
        Put File, , Value(i)
    Next
    Seek File, 1
    Get File, , Buffer
    ReverseInt = Buffer
    
    Close File
    Kill "temp.bin"
End Function

Public Function ReverseSingle(Value() As Byte) As Single
    Dim File As Integer
    Dim i As Integer
    Dim Buffer As Single
    
    File = FreeFile
    Open "temp.bin" For Binary As File
    For i = UBound(Value) To 0 Step -1
        Put File, , Value(i)
    Next
    Seek File, 1
    Get File, , Buffer
    ReverseSingle = Buffer
    
    Close File
    Kill "temp.bin"
End Function

