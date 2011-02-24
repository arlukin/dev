Attribute VB_Name = "mod3do"
Option Explicit

' 3do file types. '
Type ObjectHeader
    VersionSignature As Long
    NumberOfVertexes As Long
    NumberOfPrimitives As Long
    BaseObject As Long
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

Type LoadPoint3d
    x As Long
    y As Long
    z As Long
End Type

Type LoadPrimitive3d
    Color As Long
    NumberOfVertexIndexes As Long
    Always0 As Long
    OffsetToVertexIndexArray As Long
    OffsetToTextureName As Long
    Unknown1 As Long
    Unknown2 As Long
    Unknown3 As Long
End Type

' 3do file, and object list collection. '
Public File3do As New class3do

' Selected values. '
Public SelectedObject As New class3do
Public SelObj As Long
Public SelFace As Long
Public SelectedPrimitive As Long

' Offset and render values. '
Public RenderOffsetX As Single
Public RenderOffsetY As Single
Public RenderOffsetZ As Single
Public Center As New class3dVertex
Public ZoomFactor As Single

' Load a 3do file. '
Public Sub Load3do(Filename As String)
    Dim File As Integer
    
    ' Initialize. '
    On Error GoTo Error
    File = FreeFile
    Open Filename For Binary As File
    
    Set File3do = New class3do
    File3do.Load File
            
    ' Cleanup. '
    Close File
    OpenFile = Filename
    CreateInterface
    Exit Sub
Error:
    MsgBox "There was an error loading the 3do file you selected.", vbExclamation, "Load 3do"
End Sub

' Save a 3do file. '
Public Sub Save3do(Filename As String)
    Dim File As Integer
    
    ' Initialize. '
    On Error GoTo Error
    File = FreeFile
    Open Filename For Binary As File
    
    File3do.Save File
    
    ' Cleanup. '
    Close File
    'CreateInterface
    Exit Sub
Error:
End Sub

' Save a test hpi file. '
Public Function SaveTestHPI(Filename As String, Prefix As String, Optional COBFile As String = "", Optional FBIFile As String = "", Optional File3do As String = "") As Boolean
    Dim rc As Long
    Dim FileHandle As Long
    
    SaveTestHPI = False
    If File3do = "" Then
        Save3do App.Path & "\" & Prefix & "3doBuilderUnit.3do"
    End If

    ' Create an HPI file. '
    On Error GoTo Error
    Screen.MousePointer = vbHourglass
    DoEvents
    FileHandle = HPICreate(Filename, AddressOf HPICallBack)
    If FileHandle = 0 Then Exit Function
    
    If FBIFile = "" Then
        rc = HPIAddFile(FileHandle, "units\" & Prefix & "3doBuilderUnit.fbi", App.Path & "\" & Prefix & "3doBuilderUnit.fbi")
        If rc = 0 Then Exit Function
    Else
        rc = HPIAddFile(FileHandle, "units\" & Prefix & "3doBuilderUnit.fbi", FBIFile)
        If rc = 0 Then Exit Function
    End If
    If COBFile = "" Then
        rc = HPIAddFile(FileHandle, "scripts\" & Prefix & "3doBuilderUnit.cob", App.Path & "\" & Prefix & "3doBuilderUnit.cob")
        If rc = 0 Then Exit Function
    Else
        rc = HPIAddFile(FileHandle, "scripts\" & Prefix & "3doBuilderUnit.cob", COBFile)
        If rc = 0 Then Exit Function
    End If
    If File3do = "" Then
        rc = HPIAddFile(FileHandle, "objects3d\" & Prefix & "3doBuilderUnit.3do", App.Path & "\" & Prefix & "3doBuilderUnit.3do")
        If rc = 0 Then Exit Function
    Else
        rc = HPIAddFile(FileHandle, "objects3d\" & Prefix & "3doBuilderUnit.3do", File3do)
        If rc = 0 Then Exit Function
    End If
    
    If HPIPackArchive(FileHandle, NO_COMPRESSION) = 0 Then Exit Function

    SaveTestHPI = True
Error:
End Function

' Create a new 3do file. '
Public Sub New3do()
    Set File3do = New class3do
    File3do.Initialize
    File3do.InitializeBase
    File3do.SetBaseSize 32, 32
    File3do.Name = "base"
    Set SelectedObject = File3do
    OpenFile = "Untitled.3do"
    CreateInterface
End Sub

' Import a DXF as the selected object. '
Public Sub ImportDXF(Filename As String)
    On Error Resume Next
    SelectedObject.ImportDXF Filename
    UpdateInterface
End Sub

' Import a LWO as the selected object. '
Public Sub ImportLWO(Filename As String)
    On Error Resume Next
    SelectedObject.ImportLWO Filename
    UpdateInterface
End Sub

' Import an OBJ as the selected object. '
Public Sub ImportOBJ(Filename As String)
    On Error Resume Next
    SelectedObject.ImportOBJ Filename
    UpdateInterface
End Sub

' Export the selected object as a DXF. '
Public Sub ExportDXF(Filename As String)
    Dim File As Integer
    
    On Error GoTo Error
    File = FreeFile
    Open Filename For Output As File

    ' Write the DXF header. '
    WriteDXFHeader File
    
    ' Write the 3d data. '
    SelectedObject.ExportDXF File
    
    Print #File, " 0" & CRLF & "ENDSEC"
    Print #File, " 0" & CRLF & "EOF"
    Close File
    
Error:
End Sub

Public Sub ExportAllDXF()
    File3do.SaveDXF True, 0, 0, 0
End Sub

' Save the 3do model as a DXF. '
Public Sub SaveDXF(Filename As String)
    Dim File As Integer
    
    On Error Resume Next
    File = FreeFile
    Open Filename For Output As File

    ' Write the DXF header. '
    WriteDXFHeader File
    
    ' Write the 3d data. '
    File3do.ExportDXF File, True
    
    Print #File, " 0" & CRLF & "ENDSEC"
    Print #File, " 0" & CRLF & "EOF"
    Close File
End Sub

' Write the DXF header. '
Public Sub WriteDXFHeader(File As Integer)
    Print #File, "  0" & CRLF & "SECTION"
    Print #File, "  2" & CRLF & "ENTITIES"
End Sub

' Render the 3do model to the screen. '
Public Sub Render()
    Dim FrontCenterX As Long, FrontCenterY As Long, RightCenterX As Long, RightCenterY As Long, TopCenterX As Long, TopCenterY As Long
    Dim x As Long, y As Long
    
    On Error GoTo Error
    
    If ZoomFactor = 0 Then ZoomFactor = 2
    
    With Frm3do
    RenderOffsetX = 0
    RenderOffsetY = 0
    RenderOffsetZ = 0
    .PicFront.Cls
    .PicRight.Cls
    .PicTop.Cls
    
    If ShowGrid Then
        FrontCenterX = .PicFront.ScaleWidth / 2
        FrontCenterY = .PicFront.ScaleHeight / 2
        RightCenterX = .PicRight.ScaleWidth / 2
        RightCenterY = .PicRight.ScaleHeight / 2
        TopCenterX = .PicTop.ScaleWidth / 2
        TopCenterY = .PicTop.ScaleHeight / 2
        
        .PicFront.Line (FrontCenterX - ZoomFactor * Center.x, 0)-(FrontCenterX - ZoomFactor * Center.x, .PicFront.ScaleHeight), Colors(ColorGrid)
        .PicFront.Line (0, FrontCenterY + ZoomFactor * Center.y)-(.PicFront.ScaleWidth, FrontCenterY + ZoomFactor * Center.y), Colors(ColorGrid)
        .PicRight.Line (RightCenterX - ZoomFactor * Center.z, 0)-(RightCenterX - ZoomFactor * Center.z, .PicRight.ScaleHeight), Colors(ColorGrid)
        .PicRight.Line (0, RightCenterY + ZoomFactor * Center.y)-(.PicRight.ScaleWidth, RightCenterY + ZoomFactor * Center.y), Colors(ColorGrid)
        .PicTop.Line (TopCenterX - ZoomFactor * Center.x, 0)-(TopCenterX - ZoomFactor * Center.x, .PicTop.ScaleHeight), Colors(ColorGrid)
        .PicTop.Line (0, TopCenterY - ZoomFactor * Center.z)-(.PicTop.ScaleWidth, TopCenterY - ZoomFactor * Center.z), Colors(ColorGrid)
        
        FrontCenterX = FrontCenterX - ZoomFactor * Center.x
        FrontCenterY = FrontCenterY + ZoomFactor * Center.y
        RightCenterX = RightCenterX - ZoomFactor * Center.z
        RightCenterY = RightCenterY + ZoomFactor * Center.y
        TopCenterX = TopCenterX - ZoomFactor * Center.x
        TopCenterY = TopCenterY - ZoomFactor * Center.z
        
        Do
            Do
                .PicFront.PSet (FrontCenterX + x, FrontCenterY + y), Colors(ColorGrid)
                .PicFront.PSet (FrontCenterX - x, FrontCenterY + y), Colors(ColorGrid)
                .PicFront.PSet (FrontCenterX + x, FrontCenterY - y), Colors(ColorGrid)
                .PicFront.PSet (FrontCenterX - x, FrontCenterY - y), Colors(ColorGrid)
                
                .PicRight.PSet (RightCenterX + x, RightCenterY + y), Colors(ColorGrid)
                .PicRight.PSet (RightCenterX - x, RightCenterY + y), Colors(ColorGrid)
                .PicRight.PSet (RightCenterX + x, RightCenterY - y), Colors(ColorGrid)
                .PicRight.PSet (RightCenterX - x, RightCenterY - y), Colors(ColorGrid)
                
                .PicTop.PSet (TopCenterX + x, TopCenterY + y), Colors(ColorGrid)
                .PicTop.PSet (TopCenterX - x, TopCenterY + y), Colors(ColorGrid)
                .PicTop.PSet (TopCenterX + x, TopCenterY - y), Colors(ColorGrid)
                .PicTop.PSet (TopCenterX - x, TopCenterY - y), Colors(ColorGrid)
                x = x + (GridInterval * ZoomFactor)
                If ((FrontCenterX + x > .PicFront.ScaleWidth) And (FrontCenterX - x < 0) And (RightCenterX + x > .PicRight.ScaleWidth) And (RightCenterX - x < 0) And (TopCenterX + x > .PicTop.ScaleWidth) And (TopCenterX - x < 0)) Then Exit Do
            Loop
            x = 0
            y = y + (GridInterval * ZoomFactor)
            If ((FrontCenterY + y > .PicFront.ScaleHeight) And (FrontCenterY - y < 0) And (RightCenterY + y > .PicRight.ScaleHeight) And (RightCenterY - y < 0) And (TopCenterY + y > .PicTop.ScaleHeight) And (TopCenterY - y < 0)) Then Exit Do
        Loop
    End If
    
    File3do.Render
    SelectedObject.Render False, RenderOffsetX, RenderOffsetY, RenderOffsetZ
    End With
Error:
End Sub

Public Sub CreateOpenGLModel()
    If Not DisableGL Then
        RemoveAllObjects
        File3do.GLCreateModel
    End If
End Sub

' Create the object tree view for this model. '
Public Sub CreateModelTree()
    Dim Index As Integer
    
    On Error GoTo Error
    Frm3do.Tree3do.Nodes.Clear
    File3do.CreateTree "", tvwNext
    For Index = 1 To Frm3do.Tree3do.Nodes.Count
        Frm3do.Tree3do.Nodes(Index).EnsureVisible
    Next
Error:
End Sub

' HPI save callback. '
Public Function HPICallBack(XFileName As CString, XHPIName As CString, ByVal FileCount As Long, ByVal FileCountTotal As Long, ByVal FileBytes As Long, ByVal FileBytesTotal As Long, ByVal TotalBytes As Long, ByVal TotalBytesTotal As Long) As Long
    'FrmProgress.Update TotalBytes, TotalBytesTotal
End Function

Public Sub GetCenterModel()
    Dim MinX As Single, MinY As Single, MinZ As Single
    Dim MaxX As Single, MaxY As Single, MaxZ As Single
    
    On Error GoTo Error
    
    MinX = 1000
    MinY = 1000
    MinZ = 1000
    MaxX = -1000
    MaxY = -1000
    MaxZ = -1000
    If AutoCenter Then
        File3do.GetModelCenter MinX, MinY, MinZ, MaxX, MaxY, MaxZ, 0, 0, 0
        
        Center.x = MinX + Abs(MaxX - MinX) / 2
        Center.y = MinY + Abs(MaxY - MinY) / 2
        Center.z = MinZ + Abs(MaxZ - MinZ) / 2
    Else
        Center.x = 0
        Center.y = 0
        Center.z = 0
    End If
    
Error:
End Sub

