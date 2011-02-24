Attribute VB_Name = "mod3do"
Option Explicit

' 3do file types. '
Type Object3d
    VersionSignature As Long
    NumberOfVertexes As Long
    NumberOfPrimitives As Long
    UnknownFlag As Long
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

Type Point3d
    x As Long
    y As Long
    z As Long
End Type

Type LoadPrimitive3d
    Unknown0 As Long
    NumberOfVertexIndexes As Long
    Always0 As Long
    OffsetToVertexIndexArray As Long
    OffsetToTextureName As Long
    Unknown1 As Long
    Unknown2 As Long
    Unknown3 As Long
End Type

Type Primitive3d
    Vertexes() As Integer
    Texture As String
End Type

Public Const Key3do As String = "01a"

Public File3do As New class3do
Public LoadCount As Long ' Number of bytes read from 3do file. '
Public Textures() As String
Public SelObj As String

' Load a 3do file and display its contents. '
Public Sub Load3do(Filename As String)
    Dim File As Integer
    Dim Total As Long
    
    ' Initialize. '
    On Error GoTo Error
    File = FreeFile
    Total = FileLen(Filename)
    ReDim Textures(0)
    SelObj = ""
    Open Filename For Binary As File
    
    File3do.Load File
            
    ' Cleanup. '
    Frm3doview.Status = "Loaded " & CStr(LoadCount) & " bytes out of " & CStr(Total) & " bytes total."
    Close File
    RefreshInterface
    Exit Sub
Error:
    MsgBox "There was an error loading the 3do file you selected.", vbExclamation, "Load 3do"
End Sub

Public Sub RefreshInterface()
    Dim rc As Boolean
    
    With Frm3doview
        .Tree3do.Nodes.Clear
        .LstInfo.Clear
        File3do.CreateTree "", tvwNext
        rc = File3do.ShowInfo(SelObj)
    End With
End Sub
