Attribute VB_Name = "modBmp"
' bitmap file functions '

Option Explicit

Type BITMAPFILEHEADER ' 14 bytes '
        bfType As Integer
        bfSize As Long
        bfReserved1 As Integer
        bfReserved2 As Integer
        bfOffBits As Long
End Type
'Type BITMAPINFOHEADER ' 40 bytes '
'        biSize As Long
'        biWidth As Long
'        biHeight As Long
'        biPlanes As Integer
'        biBitCount As Integer
'        biCompression As Long
'        biSizeImage As Long
'        biXPelsPerMeter As Long
'        biYPelsPerMeter As Long
'        biClrUsed As Long
'        biClrImportant As Long
'End Type
Type SaveBitmapInfo
        bmiHeader As BITMAPINFOHEADER
        bmiColors(255) As RGBQUAD
End Type

Declare Function BMPInfo Lib "annihilator.dll" (ByVal Filename As String, ByRef BitSize As Long, ByRef BitmapInfo As BITMAPINFOHEADER) As Integer
Declare Function LoadBMP Lib "annihilator.dll" (ByVal Filename As String, ByRef Image As Byte, ByRef BmpPalette As RGBQUAD) As Integer

Global Bits() As Byte
Global BmpPalette(255) As RGBQUAD
Global BitmapInfo As BITMAPINFOHEADER

' load a bitmap file into the bits buffer. '
Function LoadBMPFile(Filename As String, Optional Convert As Boolean = False) As Boolean
    Dim rc As Integer
    Dim Index As Long
    
    Index = 0
    rc = BMPInfo(Filename, Index, BitmapInfo)
    If rc = 0 Then
        LoadBMPFile = False
        Exit Function
    End If
    
    ReDim Bits(Index - 1)
    rc = LoadBMP(Filename, Bits(0), BmpPalette(0))
    If rc = 0 Then
        LoadBMPFile = False
    Else
        If Convert Then
            ConvertPalette Bits(0), UBound(Bits), BmpPalette(0), TAPalette(0)
        End If
        LoadBMPFile = True
    End If
End Function

' save a 256 color bitmap. '
Sub SaveBMPFile(Filename As String, BMPBits() As Byte, BMPPal() As RGBQUAD, ByVal Width As Long, ByVal Height As Long, Optional FixBits As Boolean = True)
    Dim BMPHeader As BITMAPFILEHEADER
    Dim BMPInfo As SaveBitmapInfo
    Dim FileHandle As Integer
    Dim i As Long, x As Long, y As Long
    Dim Buffer() As Byte
    Dim NewWidth As Long
    
    NewWidth = Width
    If Width Mod 4 <> 0 Then
        NewWidth = Width + (4 - Width Mod 4)
    End If
    
    ' flip the pixel data. '
    If FixBits Then
        ReDim Buffer(NewWidth * Height - 1)
        For y = 0 To Height - 1
            For x = 0 To Width - 1
                Buffer(y * NewWidth + x) = BMPBits((Height - y - 1) * Width + x)
            Next
        Next
    End If
    
    ' create the bitmap header. '
    BMPHeader.bfType = &H4D42
    BMPHeader.bfSize = 14 + 40 + 1024 + UBound(BMPBits) + 1
    BMPHeader.bfReserved1 = 0
    BMPHeader.bfReserved2 = 0
    BMPHeader.bfOffBits = 14 + 40 + 1024
    
    ' create the bitmap info header. '
    BMPInfo.bmiHeader.biSize = 40
    BMPInfo.bmiHeader.biWidth = Width
    BMPInfo.bmiHeader.biHeight = Height
    BMPInfo.bmiHeader.biPlanes = 1
    BMPInfo.bmiHeader.biBitCount = 8
    BMPInfo.bmiHeader.biCompression = BI_RGB
    BMPInfo.bmiHeader.biSizeImage = 0 'UBound(BMPBits) + 1
    BMPInfo.bmiHeader.biXPelsPerMeter = 0
    BMPInfo.bmiHeader.biYPelsPerMeter = 0
    BMPInfo.bmiHeader.biClrUsed = 256
    BMPInfo.bmiHeader.biClrImportant = 256
    For i = 0 To 255
        BMPInfo.bmiColors(i) = BMPPal(i)
    Next
    
    On Error Resume Next
    If FileLen(Filename) > 0 Then Kill Filename
    FileHandle = FreeFile
    Open Filename For Binary As FileHandle
    Put FileHandle, , BMPHeader
    Put FileHandle, , BMPInfo
    If FixBits Then
        Put FileHandle, , Buffer()
    Else
        Put FileHandle, , BMPBits()
    End If
    Close FileHandle
    On Error GoTo 0
End Sub
