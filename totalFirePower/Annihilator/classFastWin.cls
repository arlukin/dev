VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "classFastWin"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Fast window graphics class. '
' Use with modFastWin. '

Option Explicit

Public hBitmap As Long
Public addrBits As Long
Public BmpWidth As Long
Public BmpHeight As Long
Public hWindow As Long

' Temporary. '
Private BMInfo As BitmapInfo
Private PalInfo As LOGPALETTE

Public Function Initialize(Width As Long, Height As Long, ActiveWindow As Long) As Boolean
   Dim PalHan As Long
   Dim ScreenDC As Long
   Dim rc As Long
   Dim i As Long
    
   ScreenDC = GetDC(ActiveWindow)
     
   BMInfo.bmiHeader.biSize = 40
   BMInfo.bmiHeader.biWidth = Width
   BMInfo.bmiHeader.biHeight = -Abs(Height) ' Top-down bitmap. '
   BMInfo.bmiHeader.biPlanes = 1
   BMInfo.bmiHeader.biBitCount = 8
   BMInfo.bmiHeader.biCompression = BI_RGB
   BMInfo.bmiHeader.biSizeImage = 0
   BMInfo.bmiHeader.biXPelsPerMeter = 0
   BMInfo.bmiHeader.biYPelsPerMeter = 0
   BMInfo.bmiHeader.biClrUsed = 256
   BMInfo.bmiHeader.biClrImportant = 256

    For i = 0 To 255
        BMInfo.bmiColors(i) = TAPalette(i)
    Next
    PalInfo.palVersion = 768
    PalInfo.palNumEntries = 256
    For i = 0 To 255
        PalInfo.palPalEntry(i).peRed = TAPalette(i).rgbRed
        PalInfo.palPalEntry(i).peGreen = TAPalette(i).rgbGreen
        PalInfo.palPalEntry(i).peBlue = TAPalette(i).rgbBlue
        PalInfo.palPalEntry(i).peFlags = PC_NOCOLLAPSE ' Or PC_RESERVED
    Next
    PalHan = CreatePalette(PalInfo)
    rc = SelectPalette(ScreenDC, PalHan, 0)
    rc = RealizePalette(ScreenDC)
    rc = DeleteObject(PalHan)

    hBitmap = CreateDIBSection(ScreenDC, BMInfo, DIB_RGB_COLORS, addrBits, 0, 0)
    rc = ReleaseDC(ActiveWindow, ScreenDC)

    ' Set Options. '
    BmpWidth = Width
    BmpHeight = Height
    hWindow = ActiveWindow
    If addrBits = 0 Then
        Initialize = False
    Else
        Initialize = True
        InitializeColors ActiveWindow
    End If
End Function

Private Sub InitializeColors(ActiveWindow As Long)
   Dim PalHan As Long
   Dim ScreenDC
   Dim rc As Long

   ' Get the active window. '
   ScreenDC = GetDC(ActiveWindow)

   ' Create, select, and realize a palette. '
   PalHan = CreatePalette(PalInfo)
   rc = SelectPalette(ScreenDC, PalHan, 0)
   rc = RealizePalette(ScreenDC)
    
   ' Release the screen device context. '
   rc = ReleaseDC(hWindow, ScreenDC)

   ' Delete the palette handle. '
   rc = DeleteObject(PalHan)
End Sub

Public Sub Show(ScreenDC As Long, ByVal DestLeft As Long, ByVal DestTop As Long, ByVal DestWidth As Long, ByVal DestHeight As Long, SrcLeft As Long, SrcTop As Long, Optional SrcWidth As Long = 1, Optional SrcHeight As Long = 1, Optional StretchFlag As Boolean = False)
    Dim DefaultBitmap As Long
    Dim Context As Long
    Dim Dest As RECT
    Dim rc As Long
    
    If hWindow = 0 Then Exit Sub
    rc = GetClientRect(hWindow, Dest)

    Context = CreateCompatibleDC(0)
    DefaultBitmap = SelectObject(Context, hBitmap)
    If StretchFlag Then
        rc = SetStretchBltMode(ScreenDC, COLORONCOLOR)
        rc = StretchBlt(ScreenDC, DestLeft, DestTop, DestWidth, DestHeight, Context, SrcLeft, SrcTop, SrcWidth, SrcHeight, SRCCOPY)
    Else
        rc = BitBlt(ScreenDC, DestLeft, DestTop, DestWidth, DestHeight, Context, SrcLeft, SrcTop, SRCCOPY)
    End If
    
    rc = SelectObject(Context, DefaultBitmap)
    rc = DeleteDC(Context)
    rc = DeleteObject(DefaultBitmap)
    rc = ReleaseDC(hBitmap, ScreenDC)
End Sub

' FastWin graphics. '
Public Sub TileDraw(ByVal xPos As Long, ByVal yPos As Long, ByVal Width As Long, ByVal Height As Long, Buffer() As Byte, Optional TilePosition As Long = 0)
    WriteTile xPos, yPos, Width, Height, BmpWidth, BmpHeight, addrBits, Buffer(TilePosition)
End Sub

Public Sub LineDraw(ByVal x1 As Long, ByVal y1 As Long, ByVal x2 As Long, ByVal y2 As Long, Color As Byte)
    DrawLine x1, y1, x2, y2, Color, BmpWidth, BmpHeight, addrBits
End Sub

Public Sub PixelDraw(ByVal x As Long, ByVal y As Long, Color As Byte)
    WritePixel addrBits, x + y * BmpWidth, Color
End Sub

Public Sub ClearTileDraw(ByVal x As Long, ByVal y As Long, ByVal Width As Long, ByVal Height As Long, Buffer() As Byte, ByVal MaskColor As Byte, ByVal BackColor As Byte, ByVal ClearFlag As Long)
    ClearTile x, y, Width, Height, BmpWidth, BmpHeight, addrBits, Buffer(0), MaskColor, BackColor, ClearFlag
End Sub

Public Sub MaskTileDraw(ByVal x As Long, ByVal y As Long, ByVal Width As Long, ByVal Height As Long, Buffer() As Byte, ByVal MaskColor As Byte, ByVal ReplaceColor As Byte)
    MaskTile x, y, Width, Height, BmpWidth, BmpHeight, addrBits, Buffer(0), MaskColor, ReplaceColor
End Sub

Public Sub GrabRegion(ByVal x As Long, ByVal y As Long, ByVal Width As Long, ByVal Height As Long, Buffer() As Byte)
    GetRegion x, y, Width, Height, BmpWidth, BmpHeight, addrBits, Buffer(0)
End Sub
