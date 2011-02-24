Attribute VB_Name = "modBmp"
' Bitmap load/save module. '

Option Explicit

'Type RGBQUAD
'        rgbBlue As Byte
'        rgbGreen As Byte
'        rgbRed As Byte
'        rgbReserved As Byte
'End Type
Private Type BITMAPFILEHEADER ' 14 bytes '
        bfType As Integer
        bfSize As Long
        bfReserved1 As Integer
        bfReserved2 As Integer
        bfOffBits As Long
End Type
Private Type BITMAPINFOHEADER ' 40 bytes '
        biSize As Long
        biWidth As Long
        biHeight As Long
        biPlanes As Integer
        biBitCount As Integer
        biCompression As Long
        biSizeImage As Long
        biXPelsPerMeter As Long
        biYPelsPerMeter As Long
        biClrUsed As Long
        biClrImportant As Long
End Type
Private Type SaveBitmapInfo
        bmiHeader As BITMAPINFOHEADER
        bmiColors(255) As RGBQUAD
End Type
'Global Const BI_RGB = 0&

Declare Function BMPInfo Lib "annihilator.dll" (ByVal FileName As String, ByRef BitSize As Long, ByRef BitmapInfo As BITMAPINFOHEADER) As Integer
Declare Function LoadBMP Lib "annihilator.dll" (ByVal FileName As String, ByRef Image As Byte, ByRef BmpPalette As RGBQUAD) As Integer

Global Bits() As Byte
Global BmpPalette(255) As RGBQUAD
Global BMPColorIndex(255) As Long
Global BitmapInfo As BITMAPINFOHEADER

' load a bitmap file into the bits buffer. '
Public Function LoadBMPFile(FileName As String, Optional ConvertPal As Boolean = False) As Boolean
    Dim rc As Integer
    Dim Index As Long
    
    Index = 0
    rc = BMPInfo(FileName, Index, BitmapInfo)
    If rc = 0 Then
        LoadBMPFile = False
        Exit Function
    End If
    
    ReDim Bits(Index - 1)
    rc = LoadBMP(FileName, Bits(0), BmpPalette(0))
    If rc = 0 Then
        LoadBMPFile = False
    Else
        If ConvertPal Then
            ConvertPalette
        End If
        LoadBMPFile = True
    End If
End Function

' save a 256 color bitmap. '
Public Sub SaveBMPFile(FileName As String, BMPBits() As Byte, BMPPal() As RGBQUAD, Width As Long, Height As Long)
    Dim BMPHeader As BITMAPFILEHEADER
    Dim BMPInfo As SaveBitmapInfo
    Dim FileHandle As Integer
    Dim i As Long, x As Long, y As Long
    Dim Buffer() As Byte
    
    ' flip the pixel data. '
    ReDim Buffer(UBound(BMPBits))
    For y = 0 To Height - 1
        For x = 0 To Width - 1
            Buffer(y * Width + x) = BMPBits((Height - y - 1) * Width + x)
        Next
    Next
    
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
    FileHandle = FreeFile
    Open FileName For Binary As FileHandle
    Put FileHandle, , BMPHeader
    Put FileHandle, , BMPInfo
    Put FileHandle, , Buffer()
    Close FileHandle
    On Error GoTo 0
End Sub

' Convert a bitmap to another palette. '
Public Sub ConvertPalette()
    Dim Lut() As Long ' Look-up table. '
    Dim Index As Long, i As Integer
    Dim r As Integer, g As Integer, b As Integer, Best As Integer
    Dim br As Integer, bg As Integer, bb As Integer
    
    ReDim Lut(255)
    For Index = 0 To UBound(BmpPalette)
        r = 255
        g = 255
        b = 255
        Best = 255
        For i = 0 To UBound(TAPalette)
            br = BmpPalette(Index).rgbRed
            bg = BmpPalette(Index).rgbGreen
            bb = BmpPalette(Index).rgbBlue
            If (Abs(br - TAPalette(i).rgbRed) + Abs(bg - TAPalette(i).rgbGreen) + Abs(bb - TAPalette(i).rgbBlue)) < (r + g + b) Then
                Best = i
                r = Abs(br - TAPalette(i).rgbRed)
                g = Abs(bg - TAPalette(i).rgbGreen)
                b = Abs(bb - TAPalette(i).rgbBlue)
            End If
        Next
        Lut(Index) = Best
    Next
    
    For Index = 0 To UBound(Bits)
        Bits(Index) = Lut(Bits(Index))
    Next
End Sub
