VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "class3DFace"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private Vertexes() As Integer

Public Name As String

Public Sub Initialize()
    ReDim Vertexes(0)
End Sub

' Load the vertex list from a file. '
Public Sub LoadVertexes(File As Integer, Number As Long, Offset As Long)
    Dim Index As Long
    
    On Error Resume Next
    ReDim Vertexes(Number - 1)
    Get File, , Vertexes()
    For Index = 0 To UBound(Vertexes)
        Vertexes(Index) = Vertexes(Index) + Offset
    Next
End Sub

Public Sub SetVertexes(VertexList() As Integer)
    Dim Index As Integer
    
    On Error GoTo Error
    ReDim Vertexes(UBound(VertexList))
    For Index = 0 To UBound(VertexList)
        Vertexes(Index) = VertexList(Index)
    Next
Error:
End Sub

' Put the vertex list into another. '
Public Sub GetVertexes(VertexList() As Integer)
    Dim Index As Integer
    
    On Error GoTo Error
    ReDim VertexList(UBound(Vertexes))
    For Index = 0 To UBound(Vertexes)
        VertexList(Index) = Vertexes(Index)
    Next
Error:
End Sub
