VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "class3do"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' TA 3d object class. '

Option Explicit

Public Name As String

Private Header As ObjectHeader
Private Offset As New class3dVertex
Private Vertexes() As New class3dVertex
Private Primitives() As New class3dPrimitive

Private GLVertexes() As Vertex3D
Private GLFaces() As Face3D
Private GLIndex As Long

' Child, sibling objects for this object. '
Public Objects As New Collection

Private mCenter As New class3dVertex

Public Sub Initialize()
    Name = ""
    
    Set Objects = New Collection
    ReDim Vertexes(0)
    ReDim Primitives(0)
    Primitives(0).Initialize
    
    Offset.SetVertex 0, 0, 0
    Header.VersionSignature = 1
    Header.Always_0 = 0
    Header.BaseObject = -1
    Header.NumberOfVertexes = 0
    Header.NumberOfPrimitives = 0
    Header.OffsetToChildObject = 0
    Header.OffsetToSiblingObject = 0
    Header.XFromParent = 0
    Header.YFromParent = 0
    Header.ZFromParent = 0
End Sub

' Load an object from a 3do file. '
Public Function Load(File As Integer) As Long
    Dim Index As Long, Ptr As Long
    Dim NewObject As New class3do
    
    On Error GoTo Error
    
    Initialize
    
    ' Load the object header. '
    LoadHeader File
    If Header.VersionSignature <> 1 Then
        Initialize
        Exit Function
    End If
    
    ' Load the object name. '
    LoadObjectName File
    
    ' Load the vertexes. '
    LoadVertexes File
    
    ' Load the primitives. '
    LoadPrimitives File
        
    ' Load child object. '
    If Header.OffsetToChildObject <> 0 Then
        Ptr = Header.OffsetToChildObject + 1
        Do While Ptr <> 0
            Set NewObject = New class3do
            Seek File, Ptr
            Ptr = NewObject.Load(File)
            Objects.Add NewObject, NewObject.Name
        Loop
    End If
    
    ' Load sibling object. '
    If Header.OffsetToSiblingObject <> 0 Then
        Load = Header.OffsetToSiblingObject + 1
    End If
    
Error:
End Function

' Load the header for this object. '
Private Sub LoadHeader(File As Integer)
    Get File, , Header
    Offset.x = Header.XFromParent / 65536
    Offset.y = Header.YFromParent / 65536
    Offset.z = Header.ZFromParent / 65536
End Sub

' Load the name for this object. '
Private Sub LoadObjectName(File As Integer)
    Dim Buffer As Byte
    
    Name = ""
    Seek File, Header.OffsetToObjectName + 1
    Get File, , Buffer
    Do While Buffer <> 0
        Name = Name & Chr(Buffer)
        Get File, , Buffer
    Loop
End Sub

' Load the vertexes for this object. '
Private Sub LoadVertexes(File As Integer)
    Dim TempVertexes() As LoadPoint3d
    Dim Index As Integer
    
    On Error GoTo Error
    ReDim Vertexes(Header.NumberOfVertexes - 1)
    ReDim TempVertexes(Header.NumberOfVertexes - 1)
    Seek File, Header.OffsetToVertexArray + 1
    Get File, , TempVertexes()
    
    For Index = 0 To UBound(Vertexes)
        Vertexes(Index).x = TempVertexes(Index).x / 65536
        Vertexes(Index).y = TempVertexes(Index).y / 65536
        Vertexes(Index).z = TempVertexes(Index).z / 65536
    Next
Error:
End Sub

' Load the primitives for this object. '
Private Sub LoadPrimitives(File As Integer)
    Dim TempPrimitives() As LoadPrimitive3d
    Dim Index As Integer
    Dim Buffer As Byte
    
    On Error GoTo Error
    If Header.NumberOfPrimitives = 0 Then Exit Sub
    ReDim Primitives(Header.NumberOfPrimitives - 1)
    ReDim TempPrimitives(Header.NumberOfPrimitives - 1)
    Seek File, Header.OffsetToPrimitiveArray + 1
    Get File, , TempPrimitives()
    
    For Index = 0 To UBound(TempPrimitives)
        Seek File, TempPrimitives(Index).OffsetToVertexIndexArray + 1
        Primitives(Index).Initialize
        Primitives(Index).LoadVertexes File, TempPrimitives(Index).NumberOfVertexIndexes
        
        If TempPrimitives(Index).OffsetToTextureName <> 0 Then
            Seek File, TempPrimitives(Index).OffsetToTextureName + 1
            Get File, , Buffer
            Do While Buffer <> 0
                Primitives(Index).TextureName = Primitives(Index).TextureName & Chr(Buffer)
                Get File, , Buffer
            Loop
            Primitives(Index).LoadPrimitiveTexture
        End If
        If TempPrimitives(Index).Color > 0 And TempPrimitives(Index).Color < 256 Then
            Primitives(Index).Color = TempPrimitives(Index).Color
        End If
    Next
    Exit Sub
Error:
    MsgBox "there was an error."
    Resume
End Sub

' Save the object to a 3do file. '
Public Sub Save(File As Integer, Optional Sibling As Long = 0)
    Dim Position As Long, Offset As Long, NewOffset As Long
    Dim Siblings() As Long
    Dim Index As Integer
    
    ' Write the header. '
    On Error Resume Next
    Position = Seek(File)
    SaveHeader File
    
    ' Write the object name. '
    SaveObjectName File
    
    ' Write the vertexes. '
    SaveVertexes File
    
    ' Write the primitives. '
    SavePrimitives File
    
    ' Write child objects. '
    Offset = 0
    Err.Clear
    For Index = Objects.Count To 1 Step -1
        If Err.Number <> 0 Then
            Err.Clear
            Exit For
        End If
        If Objects(Index).Name <> "" Then
            NewOffset = Seek(File) - 1
            Objects(Index).Save File, Offset
            Offset = NewOffset
        End If
    Next
        
    Header.OffsetToChildObject = Offset
    Header.OffsetToSiblingObject = Sibling
        
    ' Re-write the updated header. '
    Offset = Seek(File)
    Seek File, Position
    SaveHeader File
    Seek File, Offset
    Exit Sub
End Sub

' Save the header to disk. '
Public Sub SaveHeader(File As Integer)
    On Error Resume Next
    Header.NumberOfVertexes = 0
    Header.NumberOfPrimitives = 0
    Header.VersionSignature = 1
    Header.Always_0 = 0
    Header.NumberOfVertexes = UBound(Vertexes) + 1
    Header.NumberOfPrimitives = UBound(Primitives) + 1
    Header.XFromParent = Offset.x * 65536
    Header.YFromParent = Offset.y * 65536
    Header.ZFromParent = Offset.z * 65536
    Put File, , Header
End Sub

' Save the object name to disk. '
Public Sub SaveObjectName(File As Integer)
    Dim Index As Integer
    Dim Buffer As Byte
    
    Header.OffsetToObjectName = Seek(File) - 1
    For Index = 1 To Len(Name)
        Buffer = Asc(Mid(Name, Index, 1))
        Put File, , Buffer
    Next
    Buffer = 0
    Put File, , Buffer
End Sub

' Save the vertexes to disk. '
Public Sub SaveVertexes(File As Integer)
    Dim Index As Integer
    Dim Buffer As Long
    
    Header.OffsetToVertexArray = Seek(File) - 1
    For Index = 0 To UBound(Vertexes)
        Buffer = Vertexes(Index).x * 65536
        Put File, , Buffer
        Buffer = Vertexes(Index).y * 65536
        Put File, , Buffer
        Buffer = Vertexes(Index).z * 65536
        Put File, , Buffer
    Next
End Sub

' Save the primitives to disk. '
Public Sub SavePrimitives(File As Integer)
    Dim Index As Integer, i As Integer
    Dim ByteBuffer As Byte, LongBuffer As Long
    Dim Offset As Long
    
    On Error GoTo Error
    Offset = (UBound(Primitives) + 1) * 32 + Seek(File) - 1
    Header.OffsetToPrimitiveArray = Seek(File) - 1
    For Index = 0 To UBound(Primitives)
        ' Write the primitive header. '
        If Primitives(Index).Color > -1 Then
            LongBuffer = Primitives(Index).Color
        Else
            LongBuffer = 0
        End If
        Put File, , LongBuffer ' Color. '
        Put File, , Primitives(Index).VertexCount ' NumberOfVertexIndexes. '
        LongBuffer = 0
        Put File, , LongBuffer ' Always0. '
        LongBuffer = Offset
        Offset = Offset + Primitives(Index).VertexCount * 2
        Put File, , LongBuffer ' OffsetToVertexIndexArray. '
        If Primitives(Index).TextureName <> "" Then
            LongBuffer = Offset
            Offset = Offset + Len(Primitives(Index).TextureName) + 1
        Else
            LongBuffer = 0
        End If
        Put File, , LongBuffer ' OffsetToTextureName. '
        LongBuffer = 0
        Put File, , LongBuffer ' Unknown1. '
        Put File, , LongBuffer ' Unknown2. '
        If Primitives(Index).Color > -1 Then
            LongBuffer = 1
        End If
        Put File, , LongBuffer ' Unknown3. '
    Next
    
    For Index = 0 To UBound(Primitives)
        ' Write the primitive vertex list. '
        Primitives(Index).SaveVertexes File
        
        ' Write the primitive texture name. '
        If Primitives(Index).TextureName <> "" Then
            For i = 1 To Len(Primitives(Index).TextureName)
                ByteBuffer = Asc(Mid(Primitives(Index).TextureName, i, 1))
                Put File, , ByteBuffer
            Next
            ByteBuffer = 0
            Put File, , ByteBuffer
        End If
    Next
Error:
End Sub

Public Sub CreateTree(Relative As String, Relationship As Integer)
    Dim Index As Long
    
    On Error GoTo Error
    
    With Frm3do
    If Relative = "" Then
        .Tree3do.Nodes.Add , , Name, Name
    Else
        .Tree3do.Nodes.Add Relative, Relationship, Name, Name
    End If
    
    For Index = 1 To Objects.Count
        If Objects(Index).Name <> "" Then
            Objects(Index).CreateTree Name, tvwChild
        End If
    Next
    End With
Error:
End Sub

' Render object and child objects to the screen. '
Public Sub Render(Optional Recurse As Boolean = True, Optional OffsetX As Single = 0, Optional OffsetY As Single = 0, Optional OffsetZ As Single = 0)
    Dim Index As Integer
    Dim Verteces2d() As New Point2D
    
    On Error GoTo Error
    
'   Projection Code. '
'    ReDim Verteces2d(UBound(Vertexes))
'    For Index = 0 To UBound(Verteces2d)
'        Verteces2d(Index).x = 0
'    Next
'    Project Vertexes(), Verteces2d(), OffsetX + Offset.x, OffsetY + Offset.y, OffsetZ + Offset.z

    If SelectedObject.Name = Name Then
        RenderOffsetX = OffsetX
        RenderOffsetY = OffsetY
        RenderOffsetZ = OffsetZ
    End If
    
    If SelectedObject.Name = Name And Not Recurse Then
        For Index = 0 To UBound(Primitives)
            Primitives(Index).Draw Vertexes(), Verteces2d(), ColorObject, OffsetX + Offset.x, OffsetY + Offset.y, OffsetZ + Offset.z
        Next
        Primitives(SelectedPrimitive).Draw Vertexes(), Verteces2d(), ColorFace, OffsetX + Offset.x, OffsetY + Offset.y, OffsetZ + Offset.z
    Else
        For Index = 0 To UBound(Primitives)
            Primitives(Index).Draw Vertexes(), Verteces2d(), , OffsetX + Offset.x, OffsetY + Offset.y, OffsetZ + Offset.z
        Next
    End If
    If Header.BaseObject > -1 And Header.BaseObject <= UBound(Primitives) Then
        Primitives(Header.BaseObject).Draw Vertexes(), Verteces2d(), , OffsetX + Offset.x, OffsetY + Offset.y, OffsetZ + Offset.z, True
    End If
    
    If Recurse Then
        For Index = 1 To Objects.Count
            If Objects(Index).Name <> "" Then
                Objects(Index).Render , OffsetX + Offset.x, OffsetY + Offset.y, OffsetZ + Offset.z
            End If
        Next
    End If
    Exit Sub
Error:
End Sub

' Create the OpenGL model. '
Public Sub GLCreateModel(Optional Recurse As Boolean = True, Optional OffsetX As Single = 0, Optional OffsetY As Single = 0, Optional OffsetZ As Single = 0)
    Dim Index As Long, i As Long, Value As Long
    Dim Buffer() As Integer
    Dim VertexIndexes() As Integer
    Dim GLIndex As Long
    
    On Error GoTo Error
    ReDim GLVertexes(UBound(Vertexes))
    For Index = 0 To UBound(Vertexes)
        GLVertexes(Index).x = Vertexes(Index).x
        GLVertexes(Index).y = Vertexes(Index).y
        GLVertexes(Index).z = Vertexes(Index).z
    Next

    ReDim GLFaces(UBound(Primitives))
    ReDim VertexIndexes(0)
    For Index = 0 To UBound(Primitives)
        Primitives(Index).GetVertexes Buffer()
        If UBound(VertexIndexes) = 0 Then
            ReDim VertexIndexes(UBound(Buffer))
            If Header.BaseObject <> Index Then
                For i = 0 To UBound(Buffer)
                    VertexIndexes(i) = Buffer(i)
                Next
            End If
            Value = -1
        Else
            Value = UBound(VertexIndexes)
            ReDim Preserve VertexIndexes(Value + UBound(Buffer) + 1)
            If Header.BaseObject <> Index Then
                For i = Value + 1 To UBound(VertexIndexes)
                    VertexIndexes(i) = Buffer(i - Value - 1)
                Next
            End If
        End If

        Primitives(Index).SetPrimitive GLFaces(Index).Vertexes, GLFaces(Index).Color, GLFaces(Index).PTRTexture, GLFaces(Index).TextureWidth, GLFaces(Index).TextureHeight
        GLFaces(Index).Hilighted = 0
        GLFaces(Index).StartVertsIndices = Value + 1
    Next

    If UBound(GLFaces) > 0 And UBound(GLVertexes) > 0 And UBound(VertexIndexes) > 0 Then
        'GLIndex = Add3DObject(GLFaces(), GLVertexes(), VertexIndexes(), 0, 0, 0)
        GLIndex = Add3DObject(GLFaces(), GLVertexes(), VertexIndexes(), OffsetX + Offset.x, OffsetY + Offset.y, OffsetZ + Offset.z)
    End If

    If Recurse Then
        For Index = 1 To Objects.Count
            Objects(Index).GLCreateModel , OffsetX + Offset.x, OffsetY + Offset.y, OffsetZ + Offset.z
        Next
        'If Header.OffsetToSiblingObject <> 0 Then
        '    Sibling.GLCreateModel , OffsetX, OffsetY, OffsetZ
        'End If
        'I'f Header.OffsetToChildObject <> 0 Then
         '   Child.GLCreateModel , OffsetX + Offset.X, OffsetY + Offset.Y, OffsetZ + Offset.Z
        'End If
    End If

    DrawView
    'DrawFront
    'DrawTop
    'DrawRight
    Exit Sub
Error:
'    MsgBox "There was an error creating the model image for the object: " & Name
End Sub

' Import a DXF file as this object. '
Public Sub ImportDXF(Filename As String)
    Dim File As Integer
    Dim Buffer As String
    Dim Index As Long, i As Long, Flag As Boolean
    Dim NewFace As Boolean
    Dim VertexAt As Integer
    Dim LoadVertexes() As New class3dVertex
    Dim VertexOffset As Long, FaceOffset As Long
    Dim Face() As Integer
    
    ' Initialize. '
    On Error Resume Next
    ReDim Vertexes(0)
    ReDim Primitives(0)
    Offset.SetVertex 0, 0, 0
    File = FreeFile
    Open Filename For Input As File
    
    VertexAt = 0
    NewFace = False
    VertexOffset = 0
    FaceOffset = 0
    ReDim LoadVertexes(0)
    Do While Not EOF(File)
        Line Input #File, Buffer
        Buffer = Trim(Buffer)
        Select Case LCase(Buffer)
            Case "3dface"
                If NewFace Then  ' Store the loaded face into the object. '
                    ReDim Face(UBound(LoadVertexes) - 1)
                    For Index = 0 To UBound(LoadVertexes) - 1
                        Flag = False
                        For i = 0 To UBound(Vertexes)
                            If (LoadVertexes(Index).x = Vertexes(i).x) And (LoadVertexes(Index).y = Vertexes(i).y) And (LoadVertexes(Index).z = Vertexes(i).z) Then
                                Face(Index) = i
                                Flag = True
                                Exit For
                            End If
                        Next
                        If Not Flag Then
                            ReDim Preserve Vertexes(VertexOffset)
                            Vertexes(VertexOffset).x = LoadVertexes(Index).x
                            Vertexes(VertexOffset).y = LoadVertexes(Index).y
                            Vertexes(VertexOffset).z = LoadVertexes(Index).z
                            Face(Index) = VertexOffset
                            VertexOffset = VertexOffset + 1
                        End If
                    Next
                    ReDim Preserve Primitives(FaceOffset)
                    Primitives(FaceOffset).Initialize
                    Primitives(FaceOffset).SetVertexes Face()
                    FaceOffset = FaceOffset + 1
                End If
                VertexAt = 0
                ReDim LoadVertexes(0)
                NewFace = True
            Case "1" & CStr(VertexAt)
                If NewFace Then
                    Line Input #File, Buffer
                    LoadVertexes(VertexAt).x = ScaleConstant * Val(Trim(Buffer))
                End If
            Case "2" & CStr(VertexAt)
                If NewFace Then
                    Line Input #File, Buffer
                    LoadVertexes(VertexAt).y = ScaleConstant * Val(Trim(Buffer))
                End If
            Case "3" & CStr(VertexAt)
                If NewFace Then
                    Line Input #File, Buffer
                    LoadVertexes(VertexAt).z = ScaleConstant * Val(Trim(Buffer))
                    VertexAt = VertexAt + 1
                    ReDim Preserve LoadVertexes(VertexAt)
                End If
        End Select
    Loop
    If NewFace Then  ' Store the loaded face into the object. '
        ReDim Face(UBound(LoadVertexes) - 1)
        For Index = 0 To UBound(LoadVertexes) - 1
            Flag = False
            For i = 0 To UBound(Vertexes)
                If (LoadVertexes(Index).x = Vertexes(i).x) And (LoadVertexes(Index).y = Vertexes(i).y) And (LoadVertexes(Index).z = Vertexes(i).z) Then
                    Face(Index) = i
                    Flag = True
                    Exit For
                End If
            Next
            If Not Flag Then
                ReDim Preserve Vertexes(VertexOffset)
                Vertexes(VertexOffset).x = LoadVertexes(Index).x
                Vertexes(VertexOffset).y = LoadVertexes(Index).y
                Vertexes(VertexOffset).z = LoadVertexes(Index).z
                Face(Index) = VertexOffset
                VertexOffset = VertexOffset + 1
            End If
        Next
        ReDim Preserve Primitives(FaceOffset)
        Primitives(FaceOffset).SetVertexes Face()
        FaceOffset = FaceOffset + 1
    End If
    
    Header.NumberOfVertexes = UBound(Vertexes) + 1
    Header.NumberOfPrimitives = UBound(Primitives) + 1
    Close File
    Render
End Sub

' Import a LWO file as this object. '
Public Sub ImportLWO(Filename As String)
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
    Dim VertexOffset As Long, FaceOffset As Long
    Dim Face() As Integer
        
    ' Initialize. '
    On Error GoTo Error
    ReDim Vertexes(0)
    ReDim Primitives(0)
    Offset.SetVertex 0, 0, 0
    
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
    
    Get File, , Chunk
    If Chunk = "PNTS" Then
        ' Get points. '
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
    ElseIf Chunk = "SRFS" Then
        ' Get faces. '
        Get File, , Value()
        Size = ReverseLong(Value)
        For i = 0 To Size - 1
            Get File, , Buffer
            If Buffer = 0 Then
                Count = Count + 1
            End If
        Next
        NumFaces = Int(Count / 2)
    
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
    Else
        Exit Sub
    End If
    
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
        ReDim Preserve Primitives(FaceOffset)
        Primitives(FaceOffset).Initialize
        Primitives(FaceOffset).SetVertexes Face()
        FaceOffset = FaceOffset + 1
        
        Get File, , Value()
        Get File, , Chunk
        If Chunk = "SURF" Then Exit Do
        Seek File, Seek(File) - 4
        Get File, , Value()
        NumVerts = ReverseInt(Value)
    Loop
    
    Close File
        
    Header.NumberOfVertexes = UBound(Vertexes) + 1
    Header.NumberOfPrimitives = UBound(Primitives) + 1
    Render
    Exit Sub
Error:
    MsgBox Err.Description
    Resume
End Sub

' Import an OBJ file as this object. '
Public Sub ImportOBJ(Filename As String)
    Dim File As Integer
    Dim Value1 As Integer, Value2 As Integer
    Dim Buffer As String
    Dim Value As String
    Dim i As Integer
    Dim Count As Integer
    Dim VertexOffset As Long, FaceOffset As Long
    Dim Face() As Integer
    Dim NewObject As New class3do
    Dim TempVertexes() As New class3dVertex, TempPrimitives() As New class3dPrimitive
    Dim ObjectName As String
    Dim VertexCount As Long
    
    ' Initialize. '
    On Error GoTo Error
    'Offset.SetVertex 0, 0, 0
    File = FreeFile
    Open Filename For Binary As File
    
    Do While Not EOF(File)
        On Error Resume Next
        Line Input #File, Buffer
        On Error GoTo Error
        Buffer = Trim(Buffer)
        Select Case LCase(Left(Buffer, 1))
            Case "g"
                If Len(Buffer) = 1 Then
                    If ObjectName <> "" Then
                        If LCase(ObjectName) = "base" Then
                            SetVertexes TempVertexes()
                            SetPrimitives TempPrimitives()
                            Name = ObjectName
                        Else
                            NewObject.Initialize
                            NewObject.SetVertexes TempVertexes()
                            NewObject.SetPrimitives TempPrimitives()
                            NewObject.Name = ObjectName
                            Objects.Add NewObject, NewObject.Name
                        End If
                    End If
                    ObjectName = ""
                    VertexCount = VertexCount + VertexOffset
                    FaceOffset = 0
                    VertexOffset = 0
                    ReDim TempVertexes(0)
                    ReDim TempPrimitives(0)
                    Set NewObject = New class3do
                Else
                    ObjectName = Right(Buffer, Len(Buffer) - 2)
                End If
            Case "v"
                ReDim Preserve TempVertexes(VertexOffset)
                Buffer = Right(Buffer, Len(Buffer) - 2)
                Value1 = InStr(1, Buffer, " ")
                Value2 = InStr(Value1 + 1, Buffer, " ")
                If Value1 <> 0 And Value2 <> 0 Then
                    TempVertexes(VertexOffset).x = Val(Left(Buffer, Value1))
                    TempVertexes(VertexOffset).y = Val(Mid(Buffer, Value1 + 1, Value2 - Value1))
                    TempVertexes(VertexOffset).z = Val(Right(Buffer, Len(Buffer) - Value2))
                End If
                VertexOffset = VertexOffset + 1
            Case "f"
                ReDim Preserve TempPrimitives(FaceOffset)
                Buffer = Right(Buffer, Len(Buffer) - 2) & " "
                Count = 0
                Value = ""
                For i = 1 To Len(Buffer)
                    If Mid(Buffer, i, 1) <> " " Then
                        Value = Value & Mid(Buffer, i, 1)
                    Else
                        If Value <> "" Then
                            ReDim Preserve Face(Count)
                            Face(Count) = Val(Value) - VertexCount - 1
                        End If
                        Value = ""
                        Count = Count + 1
                    End If
                Next
                TempPrimitives(FaceOffset).SetVertexes Face()
                FaceOffset = FaceOffset + 1
        End Select
    Loop
    If ObjectName <> "" Then
        If LCase(ObjectName) = "base" Then
            SetVertexes TempVertexes()
            SetPrimitives TempPrimitives()
            Name = ObjectName
        Else
            NewObject.Initialize
            NewObject.SetVertexes TempVertexes()
            NewObject.SetPrimitives TempPrimitives()
            NewObject.Name = ObjectName
            Objects.Add NewObject
        End If
    End If
    
Error:
    Close File
    CreateInterface
    Set SelectedObject = File3do
    UpdateInterface
'    MsgBox Err.Description
'    Resume
End Sub

Public Sub SetVertexes(VertexList() As class3dVertex)
    Dim Index As Long
    
    On Error GoTo Error
    ReDim Vertexes(UBound(VertexList))
    For Index = 0 To UBound(VertexList)
        Vertexes(Index).x = VertexList(Index).x
        Vertexes(Index).y = VertexList(Index).y
        Vertexes(Index).z = VertexList(Index).z
    Next
    
Error:
End Sub

Public Sub SetPrimitives(FaceList() As class3dPrimitive)
    Dim Index As Long
    Dim Face() As Integer
    
    On Error GoTo Error
    ReDim Primitives(UBound(FaceList))
    For Index = 0 To UBound(FaceList)
        FaceList(Index).GetVertexes Face()
        Primitives(Index).Initialize
        Primitives(Index).SetVertexes Face()
    Next
    
Error:
End Sub

' Export the object to a file. '
Public Sub ExportDXF(File As Integer, Optional Recurse As Boolean = False, Optional OffsetX As Single = 0, Optional OffsetY As Single = 0, Optional OffsetZ As Single = 0)
    Dim Index As Integer
    Dim VertexCount As Integer
    Dim Face() As Integer
    
    On Error GoTo Error
    For Index = 0 To UBound(Primitives)
        ReDim Face(0)
        Primitives(Index).GetVertexes Face()
        If UBound(Face) >= 2 Then
            Print #File, "  0"
            Print #File, "3DFACE"
            For VertexCount = 0 To UBound(Face)
                Print #File, " 1" & CStr(VertexCount)
                Print #File, CStr(Vertexes(Face(VertexCount)).x + OffsetX + Offset.x)
                Print #File, " 2" & CStr(VertexCount)
                Print #File, CStr(Vertexes(Face(VertexCount)).y + OffsetY + Offset.y)
                Print #File, " 3" & CStr(VertexCount)
                Print #File, CStr(Vertexes(Face(VertexCount)).z + OffsetZ + Offset.z)
            Next
        End If
    Next
    
    If Recurse Then
        For Index = 1 To Objects.Count
            Objects(Index).ExportDXF File, True, Offset.x + OffsetX, Offset.y + OffsetY, Offset.z + OffsetZ
        Next
    End If
Error:
End Sub

' Export the object to a file. '
Public Sub SaveDXF(Optional Recurse As Boolean = False, Optional OffsetX As Single = 0, Optional OffsetY As Single = 0, Optional OffsetZ As Single = 0)
    Dim Index As Integer
    Dim VertexCount As Integer
    Dim Face() As Integer
    Dim File As Integer
    
    On Error GoTo Error
    If Name = "" Then Exit Sub
    File = FreeFile
    Open SaveDxfDir & "\" & Name & ".dxf" For Output As File

    ' Write the DXF header. '
    WriteDXFHeader File

    On Error GoTo Error
    For Index = 0 To UBound(Primitives)
        Primitives(Index).GetVertexes Face()
        If UBound(Face) >= 2 Then
            Print #File, "  0"
            Print #File, "3DFACE"
            For VertexCount = 0 To UBound(Face)
                Print #File, " 1" & CStr(VertexCount)
                Print #File, CStr(Vertexes(Face(VertexCount)).x + OffsetX + Offset.x)
                Print #File, " 2" & CStr(VertexCount)
                Print #File, CStr(Vertexes(Face(VertexCount)).y + OffsetY + Offset.y)
                Print #File, " 3" & CStr(VertexCount)
                Print #File, CStr(Vertexes(Face(VertexCount)).z + OffsetZ + Offset.z)
            Next
        End If
    Next
    
    Print #File, " 0" & CRLF & "ENDSEC"
    Print #File, " 0" & CRLF & "EOF"
    Close File

    If Recurse Then
        For Index = 1 To Objects.Count
            Objects(Index).SaveDXF True, Offset.x + OffsetX, Offset.y + OffsetY, Offset.z + OffsetZ
        Next
    End If
Error:
End Sub

Public Sub SelectObject(ObjectName As String)
    Dim Index As Long
    
    On Error GoTo Error
    If LCase(ObjectName) = LCase(Name) Then
        Set SelectedObject = Me
    Else
        For Index = 1 To Objects.Count
            If Objects(Index).Name <> "" Then
                Objects(Index).SelectObject ObjectName
            End If
        Next
    End If
Error:
End Sub

Public Function PrimitiveCount() As Long
    On Error Resume Next
    PrimitiveCount = UBound(Primitives) + 1
End Function

Public Function GetTextureName(Index As Long) As String
    On Error Resume Next
    GetTextureName = Primitives(Index).TextureName
End Function

Public Sub SetTextureName(Index As Long, Texture As String)
    On Error Resume Next
    Primitives(Index).TextureName = Texture
End Sub

' Create a child object. '
Public Sub CreateChild(NewName As String)
    Dim NewObject As New class3do
    
    On Error GoTo Error
    NewObject.Initialize
    NewObject.Name = NewName
    Objects.Add NewObject, NewObject.Name
    CreateInterface
    Set SelectedObject = NewObject
    UpdateInterface
Error:
End Sub

Public Sub SetOffset(NewOffset As class3dVertex)
    Offset.x = NewOffset.x
    Offset.y = NewOffset.y
    Offset.z = NewOffset.z
End Sub

Public Sub GetOffset(NewOffset As class3dVertex)
    NewOffset.x = Offset.x
    NewOffset.y = Offset.y
    NewOffset.z = Offset.z
End Sub

Public Sub ScaleObject(Value As Single)
    Dim Index As Integer
    
    On Error GoTo Error
    For Index = 0 To UBound(Vertexes)
        Vertexes(Index).x = Vertexes(Index).x * Value
        Vertexes(Index).y = Vertexes(Index).y * Value
        Vertexes(Index).z = Vertexes(Index).z * Value
    Next
Error:
End Sub

Public Sub ApplyTextures(Lower As Long, Upper As Long, Texture As String)
    Dim Index As Integer
    
    On Error GoTo Error
    For Index = Lower To Upper
        Primitives(Index).TextureName = Texture
    Next
Error:
End Sub

Public Sub ApplyColor(Lower As Long, Upper As Long, Color As Integer)
    Dim Index As Integer
    
    On Error GoTo Error
    For Index = Lower To Upper
        Primitives(Index).Color = Color
    Next
Error:
End Sub

Public Function GetColor(Index As Long) As Integer
    On Error Resume Next
    GetColor = Primitives(Index).Color
End Function

Public Sub SetColor(Index As Long, ByVal Color As Integer)
    On Error Resume Next
    Primitives(Index).Color = Color
End Sub

Public Function GetAngle(Index As Long) As Integer
    On Error Resume Next
    GetAngle = Primitives(Index).Angle
End Function

Public Sub SetAngle(Index As Long, Angle As Integer)
    On Error Resume Next
    Primitives(Index).Angle = Angle
End Sub

Public Sub InverseFaces(Optional Recurse As Boolean = False)
    Dim Index As Integer
    
    On Error GoTo Error
    For Index = 0 To UBound(Primitives)
        Primitives(Index).Inverse
    Next
    
    If Recurse Then
        For Index = 1 To Objects.Count
            Objects(Index).InverseFaces True
        Next
    End If
Error:
End Sub

Public Sub InverseFace(Index As Long)
    On Error GoTo Error
    Primitives(Index).Inverse
Error:
End Sub

Public Sub InitializeBase()
    Dim Indexes(3) As Integer
    
    Header.BaseObject = 0
    Indexes(0) = 0
    Indexes(1) = 1
    Indexes(2) = 2
    Indexes(3) = 3
    ReDim Vertexes(3)
    ReDim Primitives(0)
    Primitives(0).Initialize
    Primitives(0).SetVertexes Indexes()
End Sub

Public Sub SetBase(Index As Long)
    If Primitives(Index).VertexCount <> 4 Then
        MsgBox "The base must have 4 verteces.", vbInformation
        Exit Sub
    End If
    Header.BaseObject = Index
End Sub

Public Sub SetBaseSize(ByVal Width As Long, ByVal Height As Long)
    Dim Indexes() As Integer
    
    On Error Resume Next
    Primitives(Header.BaseObject).GetVertexes Indexes()
    If UBound(Indexes) <> 3 Then Exit Sub
    Vertexes(Indexes(0)).x = -(Width / 2)
    Vertexes(Indexes(0)).y = 0
    Vertexes(Indexes(0)).z = -(Height / 2)
    Vertexes(Indexes(1)).x = -(Width / 2)
    Vertexes(Indexes(1)).y = 0
    Vertexes(Indexes(1)).z = Height / 2
    Vertexes(Indexes(2)).x = Width / 2
    Vertexes(Indexes(2)).y = 0
    Vertexes(Indexes(2)).z = Height / 2
    Vertexes(Indexes(3)).x = Width / 2
    Vertexes(Indexes(3)).y = 0
    Vertexes(Indexes(3)).z = -(Height / 2)
End Sub

Public Sub RemoveObject(ObjectName As String)
    Dim Index As Integer
    
    On Error GoTo Error
    For Index = 1 To Objects.Count
        If Objects(Index).Name = ObjectName Then
            Objects.Remove Index
            Exit For
        End If
        Objects(Index).RemoveObject ObjectName
    Next
Error:
End Sub

Public Sub CreateBase()
    Dim Indexes() As Integer
    Dim Offset As Long
    
    ReDim Preserve Primitives(UBound(Primitives) + 1)
    Offset = UBound(Vertexes) + 1
    ReDim Preserve Vertexes(UBound(Vertexes) + 4)
    
    ReDim Indexes(3)
    Indexes(0) = Offset
    Indexes(1) = Offset + 1
    Indexes(2) = Offset + 2
    Indexes(3) = Offset + 3
    Primitives(UBound(Primitives)).Initialize
    Primitives(UBound(Primitives)).SetVertexes Indexes()
    
    Header.BaseObject = UBound(Primitives)
    SetBaseSize 32, 32
End Sub

Public Sub GetCenter()
    Dim Index As Integer
    Dim MinX As Single, MinY As Single, MinZ As Single
    Dim MaxX As Single, MaxY As Single, MaxZ As Single
    
    On Error GoTo Error
    MinX = 1000
    MinY = 1000
    MinZ = 1000
    MaxX = -1000
    MaxY = -1000
    MaxZ = -1000
    'GetModelCenter MinX, MinY, MinZ, MaxX, MaxY, MaxZ, 0, 0, 0
    
    For Index = 0 To UBound(Vertexes)
        If Vertexes(Index).x < MinX Then
            MinX = Vertexes(Index).x
        End If
        If Vertexes(Index).y < MinY Then
            MinY = Vertexes(Index).y
        End If
        If Vertexes(Index).z < MinZ Then
            MinZ = Vertexes(Index).z
        End If
        If Vertexes(Index).x > MaxX Then
            MaxX = Vertexes(Index).x
        End If
        If Vertexes(Index).y > MaxY Then
            MaxY = Vertexes(Index).y
        End If
        If Vertexes(Index).z > MaxZ Then
            MaxZ = Vertexes(Index).z
        End If
    Next
    
    mCenter.x = MinX + Abs(MaxX - MinX) / 2
    mCenter.y = MinY + Abs(MaxY - MinY) / 2
    mCenter.z = MinZ + Abs(MaxZ - MinZ) / 2
Error:
End Sub

Public Sub GetModelCenter(MinX As Single, MinY As Single, MinZ As Single, MaxX As Single, MaxY As Single, MaxZ As Single, OffsetX As Single, OffsetY As Single, OffsetZ As Single)
    Dim Index As Integer
    
    On Error GoTo Error
    For Index = 0 To UBound(Vertexes)
        If (Vertexes(Index).x + OffsetX + Offset.x) < MinX Then
            MinX = (Vertexes(Index).x + OffsetX + Offset.x)
        End If
        If (Vertexes(Index).y + OffsetY + Offset.y) < MinY Then
            MinY = (Vertexes(Index).y + OffsetY + Offset.y)
        End If
        If (Vertexes(Index).z + OffsetZ + Offset.z) < MinZ Then
            MinZ = (Vertexes(Index).z + OffsetZ + Offset.z)
        End If
        If (Vertexes(Index).x + OffsetX + Offset.x) > MaxX Then
            MaxX = (Vertexes(Index).x + OffsetX + Offset.x)
        End If
        If (Vertexes(Index).y + OffsetY + Offset.y) > MaxY Then
            MaxY = (Vertexes(Index).y + OffsetY + Offset.y)
        End If
        If (Vertexes(Index).z + OffsetZ + Offset.z) > MaxZ Then
            MaxZ = (Vertexes(Index).z + OffsetZ + Offset.z)
        End If
    Next
    
    For Index = 1 To Objects.Count
        Objects(Index).GetModelCenter MinX, MinY, MinZ, MaxX, MaxY, MaxZ, OffsetX + Offset.x, OffsetY + Offset.y, OffsetZ + Offset.z
    Next
Error:
End Sub

Public Sub ChangeOffset(ObjectName As String, ByVal x As Single, ByVal y As Single, ByVal z As Single, OffsetX As Single, OffsetY As Single, OffsetZ As Single)
    Dim CenterX As Long, CenterY As Long
    Dim NewX As Long, NewY As Long
    Dim Index As Integer
        
    On Error GoTo Error
    
    If Name <> ObjectName Then
        For Index = 1 To Objects.Count
            If Objects(Index).Name <> "" Then
                Objects(Index).ChangeOffset ObjectName, x, y, z, OffsetX + Offset.x, OffsetY + Offset.y, OffsetZ + Offset.z
            End If
        Next
    Else
        GetCenter
        CenterX = Frm3do.PicFront.ScaleWidth / 2
        CenterY = Frm3do.PicFront.ScaleHeight / 2
        If z = -1 Then ' Front
            CenterX = CenterX + ZoomFactor * (OffsetX + Offset.x - Center.x - mCenter.x)
            CenterY = CenterY - ZoomFactor * (OffsetY + Offset.y - Center.y + mCenter.y)
            NewX = x - CenterX
            NewY = -(y - CenterY)
            NewX = NewX / ZoomFactor
            NewY = NewY / ZoomFactor
            Offset.x = Offset.x + NewX
            Offset.y = Offset.y + NewY
        ElseIf y = -1 Then ' Top
            CenterX = CenterX + ZoomFactor * (OffsetX + Offset.x - Center.x - mCenter.x)
            CenterY = CenterY + ZoomFactor * (OffsetZ + Offset.z - Center.z + mCenter.z)
            NewX = x - CenterX
            NewY = (z - CenterY)
            NewX = NewX / ZoomFactor
            NewY = NewY / ZoomFactor
            Offset.x = Offset.x + NewX
            Offset.z = Offset.z + NewY
        ElseIf x = -1 Then ' Side
            CenterX = CenterX + ZoomFactor * (OffsetZ + Offset.z - Center.z - mCenter.z)
            CenterY = CenterY - ZoomFactor * (OffsetY + Offset.y - Center.y + mCenter.y)
            NewX = z - CenterX
            NewY = -(y - CenterY)
            NewX = NewX / ZoomFactor
            NewY = NewY / ZoomFactor
            Offset.z = Offset.z + NewX
            Offset.y = Offset.y + NewY
        End If
    End If

Error:
End Sub

Public Sub ScaleAll(Value As Single)
    Dim Index As Integer
    
    On Error GoTo Error
    Offset.x = Offset.x * Value
    Offset.y = Offset.y * Value
    Offset.z = Offset.z * Value
    For Index = 0 To UBound(Vertexes)
        Vertexes(Index).x = Vertexes(Index).x * Value
        Vertexes(Index).y = Vertexes(Index).y * Value
        Vertexes(Index).z = Vertexes(Index).z * Value
    Next
    
    For Index = 1 To Objects.Count
        Objects(Index).ScaleAll Value
    Next
Error:
End Sub

Public Sub MoveObject(ParentName As String, ChildName As String)
    Dim pParent As New class3do, pChild As New class3do, pOldParent As New class3do
        
    On Error GoTo Error
    If Not FindObject(ParentName, pParent) Then GoTo Error
    If Not FindObject(ChildName, pChild, pOldParent) Then GoTo Error
    If pParent.Name <> "" And pChild.Name <> "" And pOldParent.Name <> "" Then
        pParent.Objects.Add pChild, pChild.Name
        pOldParent.Objects.Remove pChild.Name
    End If
Error:
    CreateInterface
    Set SelectedObject = File3do
    UpdateInterface
End Sub

Public Function FindObject(ObjectName As String, pObject As class3do, Optional pOldParent As class3do = Nothing) As Boolean
    Dim Index As Integer
    
    On Error Resume Next
    If ObjectName = Name Then
        Set pObject = Me
        FindObject = True
    Else
        For Index = 1 To Objects.Count
            If Objects(Index).FindObject(ObjectName, pObject, pOldParent) Then
                If pOldParent.Name <> "" Then
                    FindObject = True
                    Exit For
                Else
                    FindObject = True
                    Set pOldParent = Me
                    Exit For
                End If
            End If
        Next
    End If
End Function
