VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "class3dPrimitive"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' 3d primitive class. '

Option Explicit

Public TextureName As String
Public Color As Integer
Public Angle As Integer

Private Vertexes() As Integer

Public Sub Initialize()
    ReDim Vertexes(0)
    Color = -1
    TextureName = ""
End Sub

Public Sub LoadPrimitiveTexture()
    Dim rc As Boolean
    
    rc = LoadTexture(TextureName)
End Sub

Public Sub Draw(Verteces() As class3dVertex, Verteces2d() As Point2D, Optional DrawColor As Long = ColorModel, Optional xOffset As Single = 0, Optional yOffset As Single = 0, Optional zOffset As Single = 0, Optional Special As Boolean = False)
    Dim Index As Integer
    Dim FrontOffsetX As Long, FrontOffsetY As Long, TopOffsetX As Long, TopOffsetY As Long, SideOffsetX As Long, SideOffsetY As Long
    
    On Error GoTo Error
    
    With Frm3do
    If Special Then
        DrawColor = ColorBack
        .PicFront.DrawStyle = 2
        .PicTop.DrawStyle = 2
        .PicRight.DrawStyle = 2
    End If
    FrontOffsetX = .PicFront.ScaleWidth / 2
    FrontOffsetY = .PicFront.ScaleHeight / 2
    TopOffsetX = .PicTop.ScaleWidth / 2
    TopOffsetY = .PicTop.ScaleHeight / 2
    SideOffsetX = .PicRight.ScaleWidth / 2
    SideOffsetY = .PicRight.ScaleHeight / 2
    If UBound(Vertexes) = 0 Then
        If DrawColor = ColorFace Then
            DrawPoint .PicFront, FrontOffsetX + ZoomFactor * (xOffset + Verteces(Vertexes(0)).x - Center.x), FrontOffsetY - ZoomFactor * (yOffset + Verteces(Vertexes(0)).y - Center.y), Colors(ColorFace)
            DrawPoint .PicTop, TopOffsetX + ZoomFactor * (xOffset + Verteces(Vertexes(0)).x - Center.x), TopOffsetY + ZoomFactor * (zOffset + Verteces(Vertexes(0)).z - Center.z), Colors(ColorFace)
            DrawPoint .PicRight, SideOffsetX + ZoomFactor * (zOffset + Verteces(Vertexes(0)).z - Center.z), SideOffsetY - ZoomFactor * (yOffset + Verteces(Vertexes(0)).y - Center.y), Colors(ColorFace)
        Else
            DrawPoint .PicFront, FrontOffsetX + ZoomFactor * (xOffset + Verteces(Vertexes(0)).x - Center.x), FrontOffsetY - ZoomFactor * (yOffset + Verteces(Vertexes(0)).y - Center.y), Colors(ColorPoint)
            DrawPoint .PicTop, TopOffsetX + ZoomFactor * (xOffset + Verteces(Vertexes(0)).x - Center.x), TopOffsetY + ZoomFactor * (zOffset + Verteces(Vertexes(0)).z - Center.z), Colors(ColorPoint)
            DrawPoint .PicRight, SideOffsetX + ZoomFactor * (zOffset + Verteces(Vertexes(0)).z - Center.z), SideOffsetY - ZoomFactor * (yOffset + Verteces(Vertexes(0)).y - Center.y), Colors(ColorPoint)
        End If
    Else
        For Index = 0 To UBound(Vertexes) - 1
            .PicFront.Line (FrontOffsetX + ZoomFactor * (xOffset + Verteces(Vertexes(Index)).x - Center.x), FrontOffsetY - ZoomFactor * (yOffset + Verteces(Vertexes(Index)).y - Center.y))-(FrontOffsetX + ZoomFactor * (xOffset + Verteces(Vertexes(Index + 1)).x - Center.x), FrontOffsetY - ZoomFactor * (yOffset + Verteces(Vertexes(Index + 1)).y - Center.y)), Colors(DrawColor)
            .PicTop.Line (TopOffsetX + ZoomFactor * (xOffset + Verteces(Vertexes(Index)).x - Center.x), TopOffsetY + ZoomFactor * (zOffset + Verteces(Vertexes(Index)).z - Center.z))-(TopOffsetX + ZoomFactor * (xOffset + Verteces(Vertexes(Index + 1)).x - Center.x), TopOffsetY + ZoomFactor * (zOffset + Verteces(Vertexes(Index + 1)).z - Center.z)), Colors(DrawColor)
            .PicRight.Line (SideOffsetX + ZoomFactor * (zOffset + Verteces(Vertexes(Index)).z - Center.z), SideOffsetY - ZoomFactor * (yOffset + Verteces(Vertexes(Index)).y - Center.y))-(SideOffsetX + ZoomFactor * (zOffset + Verteces(Vertexes(Index + 1)).z - Center.z), SideOffsetY - ZoomFactor * (yOffset + Verteces(Vertexes(Index + 1)).y - Center.y)), Colors(DrawColor)
            '.PicView.Line (OffsetX + Verteces2d(Vertexes(Index)).x + Center.x, OffsetY + Verteces2d(Vertexes(Index)).y - Center.y)-(OffsetX + Verteces2d(Vertexes(Index + 1)).x + Center.x, OffsetY + Verteces2d(Vertexes(Index + 1)).y - Center.y), DrawColor
        Next
        .PicFront.Line (FrontOffsetX + ZoomFactor * (xOffset + Verteces(Vertexes(0)).x - Center.x), FrontOffsetY - ZoomFactor * (yOffset + Verteces(Vertexes(0)).y - Center.y))-(FrontOffsetX + ZoomFactor * (xOffset + Verteces(Vertexes(Index)).x - Center.x), FrontOffsetY - ZoomFactor * (yOffset + Verteces(Vertexes(Index)).y - Center.y)), Colors(DrawColor)
        .PicTop.Line (TopOffsetX + ZoomFactor * (xOffset + Verteces(Vertexes(0)).x - Center.x), TopOffsetY + ZoomFactor * (zOffset + Verteces(Vertexes(0)).z - Center.z))-(TopOffsetX + ZoomFactor * (xOffset + Verteces(Vertexes(Index)).x - Center.x), TopOffsetY + ZoomFactor * (zOffset + Verteces(Vertexes(Index)).z - Center.z)), Colors(DrawColor)
        .PicRight.Line (SideOffsetX + ZoomFactor * (zOffset + Verteces(Vertexes(0)).z - Center.z), SideOffsetY - ZoomFactor * (yOffset + Verteces(Vertexes(0)).y - Center.y))-(SideOffsetX + ZoomFactor * (zOffset + Verteces(Vertexes(Index)).z - Center.z), SideOffsetY - ZoomFactor * (yOffset + Verteces(Vertexes(Index)).y - Center.y)), Colors(DrawColor)
        '.PicView.Line (OffsetX + Verteces2d(Vertexes(0)).x + Center.x, OffsetY + Verteces2d(Vertexes(0)).y - Center.y)-(OffsetX + Verteces2d(Vertexes(Index)).x + Center.x, OffsetY + Verteces2d(Vertexes(Index)).y - Center.y), DrawColor
    End If
    If Special Then
        .PicFront.DrawStyle = 0
        .PicTop.DrawStyle = 0
        .PicRight.DrawStyle = 0
    End If
    End With
Error:
End Sub

Public Sub DrawPoint(Canvas As PictureBox, ByVal x As Long, ByVal y As Long, Color As Long)
    Canvas.PSet (x - 1, y - 1), Color
    Canvas.PSet (x - 1, y), Color
    Canvas.PSet (x - 1, y + 1), Color
    Canvas.PSet (x, y + 1), Color
    Canvas.PSet (x + 1, y + 1), Color
    Canvas.PSet (x + 1, y), Color
    Canvas.PSet (x + 1, y - 1), Color
    Canvas.PSet (x, y - 1), Color
End Sub

' Load the vertex list from a file. '
Public Sub LoadVertexes(File As Integer, Number As Long)
    On Error Resume Next
    ReDim Vertexes(Number - 1)
    Get File, , Vertexes()
End Sub

' Save the vertex list to disk. '
Public Sub SaveVertexes(File As Integer)
    Dim Indexes() As Integer
    Dim Index As Integer, i As Integer
    Dim Start As Integer
    
    On Error GoTo Error
    
    ReDim Indexes(UBound(Vertexes))
    For Index = 0 To UBound(Vertexes)
        Indexes(Index) = Vertexes(Index)
    Next
    
    For Index = 1 To Angle / 90
        Start = Indexes(0)
        For i = 0 To UBound(Indexes) - 1
            Indexes(i) = Indexes(i + 1)
        Next
        Indexes(UBound(Indexes)) = Start
    Next
    
    Put File, , Indexes()
Error:
End Sub

' Set the vertex list to another. '
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

' Return the number of vertexes in this primitive. '
Public Function VertexCount() As Long
    On Error Resume Next
    VertexCount = UBound(Vertexes) + 1
    If VertexCount = 0 Then
        ReDim Vertexes(0)
        VertexCount = 1
    End If
End Function

' Render the primitive to the screen. '
Public Sub Render(PTRVerts() As class3dVertex, Optional Color As Long = 0)
    'DrawFace PTRVerts(), Vertexes(), Color
End Sub

Public Sub SetPrimitive(sVertCount As Integer, sColor As Byte, sPTRTexture As Long, sTextureWidth As Integer, sTextureHeight As Integer)
    On Error Resume Next
    sVertCount = UBound(Vertexes) + 1
    sColor = Color
    'GetTextureInfo TextureName, sPTRTexture, sTextureWidth, sTextureHeight
End Sub

Public Sub Inverse()
    Dim Indexes() As Integer
    Dim Index As Integer
    
    On Error GoTo Error
    
    ReDim Indexes(UBound(Vertexes))
    Indexes(0) = Vertexes(0)
    For Index = 1 To UBound(Vertexes)
        Indexes(Index) = Vertexes(UBound(Vertexes) - Index + 1)
    Next
    For Index = 0 To UBound(Indexes)
        Vertexes(Index) = Indexes(Index)
    Next
Error:
End Sub

