VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "class3do"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' TA 3d object class. '

Option Explicit

Public Name As String

Private Header As Object3d
Private Vertexes() As Point3d
Private LoadPrimitives() As LoadPrimitive3d
Private Primitives() As Primitive3d

Private Child As New class3do
Private Sibling As New class3do

Public Sub Load(File As Integer)
    ' Load the object header. '
    Get File, , Header
    LoadCount = LoadCount + 52
    
    ' Load the object name. '
    LoadObjectName File
    
    ' Load the vertexes. '
    If Header.NumberOfVertexes > 0 Then
        ReDim Vertexes(Header.NumberOfVertexes - 1)
        Seek File, Header.OffsetToVertexArray + 1
        Get File, , Vertexes()
        LoadCount = LoadCount + Header.NumberOfVertexes * 12
    End If
    
    ' Load the primitives. '
    Load3doPrimitives File
    
    ' Load sibling object. '
    If Header.OffsetToSiblingObject <> 0 Then
        Seek File, Header.OffsetToSiblingObject + 1
        Sibling.Load File
    End If
    
    ' Load child object. '
    If Header.OffsetToChildObject <> 0 Then
        Seek File, Header.OffsetToChildObject + 1
        Child.Load File
    End If
End Sub

Private Sub LoadObjectName(File As Integer)
    Dim Buffer As Byte
    
    Name = ""
    Seek File, Header.OffsetToObjectName + 1
    Get File, , Buffer
    LoadCount = LoadCount + 1
    Do While Buffer <> 0
        Name = Name & Chr(Buffer)
        Get File, , Buffer
        LoadCount = LoadCount + 1
    Loop
End Sub

Private Sub Load3doPrimitives(File As Integer)
    Dim i As Integer, index As Integer
    Dim Buffer As Byte
    Dim TempCount As Long
    Dim Flag As Boolean ' Found texture name? '
    
    On Error GoTo Error
    If Header.NumberOfPrimitives = 0 Then Exit Sub
    ReDim LoadPrimitives(Header.NumberOfPrimitives - 1)
    ReDim Primitives(Header.NumberOfPrimitives - 1)
    Seek File, Header.OffsetToPrimitiveArray + 1
    Get File, , LoadPrimitives()
    LoadCount = LoadCount + Header.NumberOfPrimitives * 32
    
    For i = 0 To UBound(LoadPrimitives)
        Seek File, LoadPrimitives(i).OffsetToVertexIndexArray + 1
        ReDim Primitives(i).Vertexes(LoadPrimitives(i).NumberOfVertexIndexes - 1)
        Get File, , Primitives(i).Vertexes()
        LoadCount = LoadCount + LoadPrimitives(i).NumberOfVertexIndexes * 2
        
        If LoadPrimitives(i).OffsetToTextureName <> 0 Then
            Seek File, LoadPrimitives(i).OffsetToTextureName + 1
            Get File, , Buffer
            TempCount = TempCount + 1
            Do While Buffer <> 0
                Primitives(i).Texture = Primitives(i).Texture & Chr(Buffer)
                Get File, , Buffer
                TempCount = TempCount + 1
            Loop
            Flag = False
            For index = 0 To UBound(Textures)
                If LCase(Textures(index)) = LCase(Primitives(i).Texture) Then
                    Flag = True
                    Exit For
                End If
            Next
            If Not Flag Then
                ReDim Preserve Textures(UBound(Textures) + 1)
                Textures(UBound(Textures)) = Primitives(i).Texture
                LoadCount = LoadCount + TempCount
            End If
        End If
    Next
Error:
End Sub

Public Sub CreateTree(Relative As String, Relationship As Integer)
    With Frm3doview
    If Relative = "" Then
        .Tree3do.Nodes.Add , , Name, Name
    Else
        .Tree3do.Nodes.Add Relative, Relationship, Name, Name
    End If
    If Child.Name <> "" Then
        Child.CreateTree Name, tvwChild
    End If
    If Sibling.Name <> "" Then
        Sibling.CreateTree Name, tvwNext
    End If
    End With
End Sub

Public Function ShowInfo(Selected As String) As Boolean
    Dim rc As Boolean
    
    ShowInfo = False
    If Name = "" Then Exit Function
    If LCase(Selected) = LCase(Name) Then
        ShowInfo = True
        DisplayInfo
    Else
        If Not Sibling.ShowInfo(Selected) Then
            rc = Child.ShowInfo(Selected)
        End If
    End If
End Function

Public Sub DisplayInfo()
    Dim i As Integer, index As Integer
    
    With Frm3doview
    .LstInfo.Clear
    Select Case .TabObject.SelectedItem.Key
        Case "header"
            .LstInfo.AddItem "VersionSignature: " & Header.VersionSignature
            .LstInfo.AddItem "NumberOfVertexes: " & Header.NumberOfVertexes
            .LstInfo.AddItem "NumberOfPrimitives: " & Header.NumberOfPrimitives
            .LstInfo.AddItem "BasePrimitive: " & Header.UnknownFlag
            .LstInfo.AddItem "XFromParent: " & CInt(Header.XFromParent / 65536)
            .LstInfo.AddItem "YFromParent: " & CInt(Header.YFromParent / 65536)
            .LstInfo.AddItem "ZFromParent: " & CInt(Header.ZFromParent / 65536)
            .LstInfo.AddItem "OffsetToObjectName: " & Header.OffsetToObjectName
            .LstInfo.AddItem "Always_0: " & Header.Always_0
            .LstInfo.AddItem "OffsetToVertexArray: " & Header.OffsetToVertexArray
            .LstInfo.AddItem "OffsetToPrimitiveArray: " & Header.OffsetToPrimitiveArray
            .LstInfo.AddItem "OffsetToSiblingObject: " & Header.OffsetToSiblingObject
            .LstInfo.AddItem "OffsetToChildObject: " & Header.OffsetToChildObject
        Case "vertex"
            For i = 0 To UBound(Vertexes)
                .LstInfo.AddItem CStr(i) & ": (" & Format(Vertexes(i).x / 65536, "0.00") & ", " & Format(Vertexes(i).y / 65536, "0.00") & ", " & Format(Vertexes(i).z / 65536, "0.00") & ")"
            Next
        Case "primitive"
            For i = 0 To UBound(LoadPrimitives)
                .LstInfo.AddItem "Primitive #: " & CStr(i)
                .LstInfo.AddItem "Color: " & LoadPrimitives(i).Unknown0
                .LstInfo.AddItem "NumberOfVertexIndexes: " & LoadPrimitives(i).NumberOfVertexIndexes
                .LstInfo.AddItem "Always0: " & LoadPrimitives(i).Always0
                .LstInfo.AddItem "OffsetToVertexIndexArray: " & LoadPrimitives(i).OffsetToVertexIndexArray
                .LstInfo.AddItem "OffsetToTextureName: " & LoadPrimitives(i).OffsetToTextureName
                .LstInfo.AddItem "Unknown1: " & LoadPrimitives(i).Unknown1
                .LstInfo.AddItem "Unknown2: " & LoadPrimitives(i).Unknown2
                .LstInfo.AddItem "Unknown3: " & LoadPrimitives(i).Unknown3
                .LstInfo.AddItem "Texture: " & Primitives(i).Texture
                .LstInfo.AddItem "VertexIndexes:"
                For index = 0 To UBound(Primitives(i).Vertexes)
                    .LstInfo.AddItem "  " & Primitives(i).Vertexes(index)
                Next
                .LstInfo.AddItem ""
            Next
    End Select
    End With
End Sub
