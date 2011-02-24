VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "classTexture"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' TA texture class. '

Option Explicit

Public Name As String
Public Width As Long
Public Height As Long
Private Buffer() As Byte

Public FilePTR As Long

Public Loaded As Boolean

Public Sub LoadImage(File As Integer)
    On Error Resume Next
    ReDim Buffer(0)
    GetGAFImage File, FilePTR, Width, Height, Buffer()
    Loaded = True
End Sub

Public Sub CreatePalette(xIndex As Integer, yIndex As Integer, DrawBorder As Boolean)
    Dim rc As Long
    
    With Frm3do
    If Width > 0 And Height > 0 Then
        TexturePalette.TileDraw 0, 0, Width, Height, Buffer()
        TexturePalette.Show .PicTextures.hdc, xIndex, yIndex, Width, Height, 0, 0
    End If
    If DrawBorder Then
        .PicTextures.Line (xIndex - 2, yIndex - 2)-(xIndex + Width + 2, yIndex - 2), &HFF8080
        .PicTextures.Line (xIndex - 2, yIndex - 2)-(xIndex - 2, yIndex + Height + 2), &HFF8080
        .PicTextures.Line (xIndex - 2, yIndex + Height + 2)-(xIndex + Width + 3, yIndex + Height + 2), &HFF8080
        .PicTextures.Line (xIndex + Width + 2, yIndex - 2)-(xIndex + Width + 2, yIndex + Height + 2), &HFF8080
    End If
    .PicTemp.Cls
    .PicTemp.Print Name
    rc = BitBlt(.PicTextures.hdc, xIndex, yIndex + Height + 5, .PicTemp.ScaleWidth, .PicTemp.ScaleHeight, .PicTemp.hdc, 0, 0, SRCCOPY)
    .PicTextures.Line (0, yIndex + Height + 23)-(.PicTextures.ScaleWidth, yIndex + Height + 23), RGB(0, 0, 0)
    .PicTextures.Line (0, yIndex + Height + 24)-(.PicTextures.ScaleWidth, yIndex + Height + 24), RGB(0, 0, 0)
    yIndex = yIndex + Height + 27
    End With
End Sub

Public Sub DisplayTexture()
    'Frm3do.PicTexture.Picture = Frm3do.PicToolbox.Picture
    Frm3do.PicTexture.Cls
    If Width > 0 And Height > 0 Then
        TexturePalette.TileDraw 0, 0, Width, Height, Buffer()
        TexturePalette.Show Frm3do.PicTexture.hdc, 0, 0, Frm3do.PicTexture.ScaleWidth, Frm3do.PicTexture.ScaleHeight, 0, 0, Width, Height, True
        'Frm3do.PicTexture.Picture = Frm3do.PicTexture.Image
        'Frm3do.PicTexture.Refresh
    End If
End Sub

' Return a pointer to the image. '
Public Function GetImagePTR() As Long
    On Error GoTo Error
    If UBound(Buffer) = 0 Then
        GetImagePTR = 0
    Else
        'GetImagePTR = GetAddress(Buffer(0))
    End If
    Exit Function
Error:
        GetImagePTR = 0
End Function

Public Sub GetTextureInfo(TexturePTR As Long, TextureWidth As Integer, TextureHeight As Integer)
    TexturePTR = GetAddress(Buffer(0))
    TextureWidth = Width
    TextureHeight = Height
End Sub

