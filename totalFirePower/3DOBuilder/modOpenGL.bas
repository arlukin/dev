Attribute VB_Name = "modOpenGL"
' VB OpenGL module. '

Option Explicit

' OpenGL DLL type declarations. '
Public Type Vertex3D
    X As Single
    Y As Single
    Z As Single
End Type

Public Type Face3D
    Color As Byte ' The color of the face. '
    Hilighted As Byte ' The face is outlined red. '
    Vertexes As Integer ' The number of Vertexes in the face. '
    TextureWidth As Integer ' The width of the face's texture. '
    TextureHeight As Integer ' The height of the face's texture. '
    StartVertsIndices As Long ' The index in the array of vertex indexes. '
    PTRTexture As Long ' Pointer to the texture graphic in memory. '
End Type

'Private Type RGBQUAD
'    rgbRed As Byte
'    rgbGreen As Byte
'    rgbBlue As Byte
'    rgbReserved As Byte
'End Type

' Object view constants. '
Public Const DisplayTextured = 0
Public Const DisplayGouraud = 1
Public Const DisplayWireframe = 2
Public Const DisplayInvisible = 3

' OpenGL DLL functions. '
Public Declare Function Initialize3D Lib "3dorender.dll" Alias "Initialize" (Palette() As RGBQUAD) As Long
Public Declare Sub Cleanup3D Lib "3dorender.dll" ()

Public Declare Function Add3DObject Lib "3dorender.dll" (Faces() As Face3D, VertexList() As Vertex3D, VertsIndices() As Integer, ByVal OffsetX As Single, ByVal OffsetY As Single, ByVal OffsetZ As Single) As Long
Public Declare Sub Remove3DObject Lib "3dorender.dll" (ByVal ObjectIndex As Long)
Public Declare Sub RemoveAllObjects Lib "3dorender.dll" ()
Public Declare Sub Update3DObject Lib "3dorender.dll" (ByVal ObjectIndex As Long, ByVal Hilighted As Byte, ByVal ScaleFactor As Single, ByVal OffsetX As Single, ByVal OffsetY As Single, ByVal OffsetZ As Single)
Public Declare Sub Update3DFace Lib "3dorender.dll" (ByVal ObjectIndex As Long, ByVal FaceIndex As Long, ByVal Hilighted As Byte, ByVal PTRTexture As Long)
Public Declare Sub SelectFace Lib "3dorender.dll" (ByVal X As Long, ByVal Y As Long, ByRef ObjectIndex As Long, ByRef FaceIndex As Long)

Public Declare Function GetAddress Lib "3dorender.dll" (ByRef Value As Any) As Long

Public Declare Sub CreateFront Lib "3dorender.dll" (ByVal hwnd As Long, ByVal Width As Long, ByVal Height As Long)
Public Declare Sub CreateView Lib "3dorender.dll" (ByVal hwnd As Long, ByVal Width As Long, ByVal Height As Long)
Public Declare Sub CreateTop Lib "3dorender.dll" (ByVal hwnd As Long, ByVal Width As Long, ByVal Height As Long)
Public Declare Sub CreateRight Lib "3dorender.dll" (ByVal hwnd As Long, ByVal Width As Long, ByVal Height As Long)

Public Declare Sub DrawFront Lib "3dorender.dll" ()
Public Declare Sub DrawView Lib "3dorender.dll" ()
Public Declare Sub DrawTop Lib "3dorender.dll" ()
Public Declare Sub DrawRight Lib "3dorender.dll" ()

Public Declare Sub ResizeFront Lib "3dorender.dll" (ByVal Width As Long, ByVal Height As Long)
Public Declare Sub ResizeView Lib "3dorender.dll" (ByVal Width As Long, ByVal Height As Long)
Public Declare Sub ResizeTop Lib "3dorender.dll" (ByVal Width As Long, ByVal Height As Long)
Public Declare Sub ResizeRight Lib "3dorender.dll" (ByVal Width As Long, ByVal Height As Long)

Public Declare Sub RotateView Lib "3dorender.dll" (ByVal X As Single, ByVal Y As Single, ByVal Z As Single)

Public Declare Sub SetView Lib "3dorender.dll" (ByVal DisplayType As Integer, ByVal Background As Integer)
Public Declare Sub Set3DView Lib "3dorender.dll" (ByVal DisplayType As Integer, ByVal Background As Integer)

Public Declare Sub SelectFront Lib "3dorender.dll" (ByVal X As Long, ByVal Y As Long, ByRef ObjectIndex As Long, ByRef FaceIndex As Long)
Public Declare Sub SelectView Lib "3dorender.dll" (ByVal X As Long, ByVal Y As Long, ByRef ObjectIndex As Long, ByRef FaceIndex As Long)
Public Declare Sub SelectTop Lib "3dorender.dll" (ByVal X As Long, ByVal Y As Long, ByRef ObjectIndex As Long, ByRef FaceIndex As Long)
Public Declare Sub SelectRight Lib "3dorender.dll" (ByVal X As Long, ByVal Y As Long, ByRef ObjectIndex As Long, ByRef FaceIndex As Long)
