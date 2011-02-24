Attribute VB_Name = "modFastWin"
' Fast window graphics module. '
' Use with classFastWin. '

Option Explicit

Type PALETTEENTRY
        peRed As Byte
        peGreen As Byte
        peBlue As Byte
        peFlags As Byte
End Type

Type RGBQUAD
        rgbBlue As Byte
        rgbGreen As Byte
        rgbRed As Byte
        rgbReserved As Byte
End Type

Type BITMAPINFOHEADER ' 40 bytes. '
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

Type BitmapInfo
        bmiHeader As BITMAPINFOHEADER
        bmiColors(255) As RGBQUAD
End Type

Type LOGPALETTE
        palVersion As Integer
        palNumEntries As Integer
        palPalEntry(255) As PALETTEENTRY
End Type

Type RECT
        Left As Long
        Top As Long
        Right As Long
        Bottom As Long
End Type

Type POINTAPI
        x As Long
        y As Long
End Type

' constants for the biCompression field
Global Const BI_RGB = 0&
Global Const BI_RLE8 = 1&
Global Const BI_RLE4 = 2&
Global Const BI_bitfields = 3&

' palette entry flags
Global Const PC_RESERVED = &H1  '  palette index used for animation
Global Const PC_EXPLICIT = &H2  '  palette index is explicit to device
Global Const PC_NOCOLLAPSE = &H4        '  do not match color to system palette

' DIB color table identifiers
Global Const DIB_RGB_COLORS = 0 '  color table in RGBs
Global Const DIB_PAL_COLORS = 1 '  color table in palette indices
Global Const DIB_PAL_INDICES = 2 '  No color table indices into surf palette
Global Const DIB_PAL_PHYSINDICES = 2 '  No color table indices into surf palette
Global Const DIB_PAL_LOGINDICES = 4 '  No color table indices into DC palette

'  Ternary raster operations
Global Const SRCCOPY = &HCC0020 ' (DWORD) dest = source
Global Const SRCPAINT = &HEE0086        ' (DWORD) dest = source OR dest
Global Const SRCAND = &H8800C6  ' (DWORD) dest = source AND dest
Global Const SRCINVERT = &H660046       ' (DWORD) dest = source XOR dest
Global Const SRCERASE = &H440328        ' (DWORD) dest = source AND (NOT dest )
Global Const NOTSRCCOPY = &H330008      ' (DWORD) dest = (NOT source)
Global Const NOTSRCERASE = &H1100A6     ' (DWORD) dest = (NOT src) AND (NOT dest)
Global Const MERGECOPY = &HC000CA       ' (DWORD) dest = (source AND pattern)
Global Const MERGEPAINT = &HBB0226      ' (DWORD) dest = (NOT source) OR dest
Global Const PATCOPY = &HF00021 ' (DWORD) dest = pattern
Global Const PATPAINT = &HFB0A09        ' (DWORD) dest = DPSnoo
Global Const PATINVERT = &H5A0049       ' (DWORD) dest = pattern XOR dest
Global Const DSTINVERT = &H550009       ' (DWORD) dest = (NOT dest)
Global Const BLACKNESS = &H42 ' (DWORD) dest = BLACK
Global Const WHITENESS = &HFF0062       ' (DWORD) dest = WHITE

' StretchBlt() Modes
Public Const BLACKONWHITE = 1
Public Const WHITEONBLACK = 2
Public Const COLORONCOLOR = 3
Public Const HALFTONE = 4
Public Const MAXSTRETCHBLTMODE = 4

'  Pen Styles
Public Const PS_SOLID = 0
Public Const PS_DASH = 1                    '  -------
Public Const PS_DOT = 2                     '  .......
Public Const PS_DASHDOT = 3                 '  _._._._
Public Const PS_DASHDOTDOT = 4              '  _.._.._
Public Const PS_NULL = 5
Public Const PS_INSIDEFRAME = 6
Public Const PS_USERSTYLE = 7
Public Const PS_ALTERNATE = 8
Public Const PS_STYLE_MASK = &HF

' API declares
Declare Function CreateDIBSection Lib "gdi32" (ByVal hdc As Long, pBitmapInfo As BitmapInfo, ByVal un As Long, ByRef plpVoid As Long, ByVal handle As Long, ByVal dw As Long) As Long
Declare Function CreateCompatibleDC Lib "gdi32" (ByVal hdc As Long) As Long
Declare Function ReleaseDC Lib "user32" (ByVal hwnd As Long, ByVal hdc As Long) As Long
Declare Function GetActiveWindow Lib "user32" () As Long
Declare Function GetDC Lib "user32" (ByVal hwnd As Long) As Long
Declare Function CreatePalette Lib "gdi32" (lpLogPalette As LOGPALETTE) As Long
Declare Function SelectPalette Lib "gdi32" (ByVal hdc As Long, ByVal hPalette As Long, ByVal bForceBackground As Long) As Long
Declare Function RealizePalette Lib "gdi32" (ByVal hdc As Long) As Long
Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
Declare Function DeleteDC Lib "gdi32" (ByVal hdc As Long) As Long
Declare Function GetClientRect Lib "user32" (ByVal hwnd As Long, lpRect As RECT) As Long
Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long
Declare Function StretchBlt Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal nSrcWidth As Long, ByVal nSrcHeight As Long, ByVal dwRop As Long) As Long
Declare Function SelectObject Lib "gdi32" (ByVal hdc As Long, ByVal hObject As Long) As Long
Declare Function LineTo Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long) As Long
Declare Function MoveTo Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long) As Long
Declare Function MoveToEx Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long, lpPoint As POINTAPI) As Long
Declare Function SetStretchBltMode Lib "gdi32" (ByVal hdc As Long, ByVal nStretchMode As Long) As Long
Declare Function CreatePen Lib "gdi32" (ByVal nPenStyle As Long, ByVal nWidth As Long, ByVal crColor As Long) As Long

' Globals. '
Global Screens() As New classFastWin

' Clear all the graphics screens. '
Public Sub FastWinFree()
    Dim Index As Integer
    Dim rc As Long
    
    For Index = 0 To UBound(Screens)
        If Screens(Index).hBitmap <> 0 Then
            rc = DeleteObject(Screens(Index).hBitmap)
        End If
    Next
    ReDim Screens(0)
End Sub
