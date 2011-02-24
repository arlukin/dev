Attribute VB_Name = "mod3do"
' 3do feature render module. '

Option Explicit

' 3do file types. '
Private Type ObjectHeader
    VersionSignature As Long
    NumberOfVertexes As Long
    NumberOfPrimitives As Long
    GroundPlate As Long
    XFromParent As Long
    YFromParent As Long
    ZFromParent As Long
    OffsetToObjectName As Long
    Always_0 As Long
    OffsetToVertexArray As Long
    OffsetToPrimitiveArray As Long
    OffsetToSiblingObject As Long
    OffsetToChildObject As Long
End Type

Private Type LoadPoint3d
    x As Long
    y As Long
    Z As Long
End Type

Private Type LoadPrimitive3d
    Color As Long
    NumberOfVertexIndexes As Long
    Always0 As Long
    OffsetToVertexIndexArray As Long
    OffsetToTextureName As Long
    unknown1 As Long
    unknown2 As Long
    unknown3 As Long
End Type

Private Faces() As New class3DFace
Private Verteces() As New class3DVertex

Public Sub Load3doImage(HPIFile As String, Filename As String, Image() As Byte, Width As Integer, Height As Integer)
    Dim HPI As Long, rc As Long
    Dim File As Integer
    
    ' Load the HPI file. '
    On Error GoTo Error
    HPI = HPIOpen(HPIFile)
    If HPI = 0 Then Exit Sub
    
    ' Extract the GAF file. '
    On Error Resume Next
    Kill App.Path & "\temp.3do"
    On Error GoTo Error
    rc = HPIExtractFile(HPI, Filename, App.Path & "\temp.3do")
    If rc = 0 Then Exit Sub
    rc = HPIClose(HPI)
    
    ' Open the 3do file. '
    File = FreeFile
    Open App.Path & "\temp.3do" For Binary As File
    
    ReDim Faces(0)
    ReDim Verteces(0)
    Load3do File, 0, 0, 0, 0, 0
    
    Close File
    Kill App.Path & "\temp.3do"
    
    On Error GoTo Error
    RenderImage Image(), Width, Height
Error:
    'MsgBox Err.Description
End Sub

Private Sub Load3do(File As Integer, OffsetX As Single, OffsetY As Single, OffsetZ As Single, StartVertexIndex As Long, StartFaceIndex As Long)
    Dim Header As ObjectHeader
    Dim Offset As New class3DVertex
    Dim TempVerteces() As LoadPoint3d
    Dim TempPrimitives() As LoadPrimitive3d
    Dim Index As Integer
    Dim Buffer As Byte
    Dim SetVertex() As Integer
    
    ' Load header. '
    On Error GoTo Error
    Get File, , Header
    Offset.x = Header.XFromParent / 65536
    Offset.y = Header.YFromParent / 65536
    Offset.Z = Header.ZFromParent / 65536
    
    ' Load verteces. '
    ReDim Preserve Verteces(StartVertexIndex + Header.NumberOfVertexes - 1)
    ReDim TempVerteces(Header.NumberOfVertexes - 1)
    Seek File, Header.OffsetToVertexArray + 1
    Get File, , TempVerteces()
    
    For Index = 0 To UBound(TempVerteces)
        Verteces(StartVertexIndex + Index).x = TempVerteces(Index).x / 65536 + Offset.x + OffsetX
        Verteces(StartVertexIndex + Index).y = TempVerteces(Index).y / 65536 + Offset.y + OffsetY
        Verteces(StartVertexIndex + Index).Z = TempVerteces(Index).Z / 65536 + Offset.Z + OffsetZ
    Next

    ' Load faces. '
    If Header.NumberOfPrimitives > 0 Then
        ReDim Preserve Faces(StartFaceIndex + Header.NumberOfPrimitives - 1)
        ReDim TempPrimitives(Header.NumberOfPrimitives - 1)
        Seek File, Header.OffsetToPrimitiveArray + 1
        Get File, , TempPrimitives()
        
        For Index = 0 To UBound(TempPrimitives)
            If Index <> Header.GroundPlate Then
                Seek File, TempPrimitives(Index).OffsetToVertexIndexArray + 1
                Faces(StartFaceIndex + Index).LoadVertexes File, TempPrimitives(Index).NumberOfVertexIndexes, StartVertexIndex
            Else
                ReDim SetVertex(3)
                Faces(StartFaceIndex + Index).SetVertexes SetVertex()
            End If
        Next
    End If
    
    StartVertexIndex = UBound(Verteces) + 1
    StartFaceIndex = UBound(Faces) + 1
    
    ' Load sibling object. '
    If Header.OffsetToSiblingObject > 0 Then
        Seek File, Header.OffsetToSiblingObject + 1
        Load3do File, OffsetX, OffsetY, OffsetZ, StartVertexIndex, StartFaceIndex
    End If
    
    ' Load child object. '
    If Header.OffsetToChildObject > 0 Then
        Seek File, Header.OffsetToChildObject + 1
        Load3do File, OffsetX + Offset.x, OffsetY + Offset.y, OffsetZ + Offset.Z, StartVertexIndex, StartFaceIndex
    End If
    Exit Sub
Error:
    MsgBox Err.Description
End Sub

Private Sub RenderImage(Image() As Byte, Width As Integer, Height As Integer)
    Dim MinX As Long, MinZ As Long, MaxX As Long, MaxZ As Long
    Dim Index As Long, i As Long
    Dim Indexes() As Integer
    Dim OffsetX As Long, OffsetZ As Long
    
    On Error GoTo Error
    MinX = 128
    MinZ = 128
    For Index = 0 To UBound(Verteces)
        If CInt(Verteces(Index).x) < MinX Then
            MinX = CInt(Verteces(Index).x)
        End If
        If CInt(Verteces(Index).x) > MaxX Then
            MaxX = CInt(Verteces(Index).x)
        End If
        If CInt(Verteces(Index).Z) < MinZ Then
            MinZ = CInt(Verteces(Index).Z)
        End If
        If CInt(Verteces(Index).Z) > MaxZ Then
            MaxZ = CInt(Verteces(Index).Z)
        End If
    Next
    
    Width = MaxX - MinX + 1
    Height = MaxZ - MinZ + 1
    If Width < 0 Or Height < 0 Then
        Width = 0
        Height = 0
        Exit Sub
    End If
    
    ' Initialize image. '
    ReDim Preserve Image(Width * Height - 1)
    For Index = 0 To UBound(Image)
        Image(Index) = GAFMaskColor
    Next
    Screens(PaletteFeatures).TileDraw 0, 0, Width, Height, Image()
    
    ' Render the image. '
    If MinX < 0 Then
        OffsetX = Abs(MinX)
    ElseIf MinX > 0 Then
        OffsetX = -MinX
    End If
    If MinZ < 0 Then
        OffsetZ = Abs(MinZ)
    ElseIf MinZ > 0 Then
        OffsetZ = -MinZ
    End If
    
    For Index = 1 To UBound(Faces)
        Faces(Index).GetVertexes Indexes()
        For i = 0 To UBound(Indexes) - 1
            Screens(PaletteFeatures).LineDraw CInt(Verteces(Indexes(i)).x) + OffsetX, CInt(Verteces(Indexes(i)).Z) + OffsetZ, CInt(Verteces(Indexes(i + 1)).x) + OffsetX, CInt(Verteces(Indexes(i + 1)).Z) + OffsetZ, 0
        Next
        Screens(PaletteFeatures).LineDraw CInt(Verteces(Indexes(0)).x) + OffsetX, CInt(Verteces(Indexes(0)).Z) + OffsetZ, CInt(Verteces(Indexes(UBound(Indexes))).x) + OffsetX, CInt(Verteces(Indexes(UBound(Indexes))).Z) + OffsetZ, 0
    Next
Error:
    Screens(PaletteFeatures).GrabRegion 0, 0, Width, Height, Image()
End Sub
