VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "classSection"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Section class. '

Option Explicit

Public Name As String
Public HPIName As String
Public Filename As String

Public RegionTiles As Boolean
Public RegionHeight As Boolean

' Section properties. '
Public Width As Long
Public Height As Long
Public Tiles As Long
Private TileData() As Byte
Private TileList() As Long
Private MapData() As Integer
Private HeightData() As Byte
Private Minimap() As Byte

Private FileBuffer() As Byte

' Overlay properties. '
Public Holds As Integer ' The number of holds on this section. '
Public Hold As Boolean
Public Selected As Boolean

Public Sub Initialize()
    Name = ""
    HPIName = ""
    Filename = ""
    Width = 0
    Height = 0
    Tiles = 0
    
    Hold = False
    Holds = 0
    Selected = False
    
    ReDim TileData(0)
    ReDim TileList(0)
    ReDim MapData(0)
    ReDim HeightData(0)
    ReDim Minimap(0)
End Sub

Public Sub Copy(cName As String, cWidth As Long, cHeight As Long, cTileData() As Byte, cTileList() As Long, cMapData() As Integer, cHeightData() As Byte)
    Name = cName
    Width = cWidth
    Height = cHeight
    ReDim TileData(UBound(cTileData))
    ReDim TileList(UBound(cTileList))
    ReDim MapData(UBound(cMapData))
    ReDim HeightData(UBound(cHeightData))
    CopyMemory TileData(0), cTileData(0), UBound(cTileData) + 1
    CopyMemory TileList(0), cTileList(0), UBound(cTileList) * 4 + 4
    CopyMemory MapData(0), cMapData(0), UBound(cMapData) * 2 + 2
    CopyMemory HeightData(0), cHeightData(0), UBound(cHeightData) + 1
    CreateMinimap
    Hold = True
End Sub

Public Sub SetSection(NewSection As classSection, DefaultName As String)
    If Name = "" Or Name = "Clip" Then
        NewSection.Copy DefaultName, Width, Height, TileData(), TileList(), MapData(), HeightData()
    Else
        NewSection.Copy Name, Width, Height, TileData(), TileList(), MapData(), HeightData()
    End If
End Sub

' Load the minimap from the SCT file. '
Public Sub LoadMini()
    Dim HPI As Long
    Dim FileHandle As Long
    Dim Header(6) As Long
    Dim rc As Long
    
    If Hold Then Exit Sub
    If HPIName = "" Then Exit Sub
    
    On Error Resume Next
    ReDim Minimap(128 * 128 - 1)
    HPI = HPIOpen(HPIName)
    If HPI = 0 Then Exit Sub
    FileHandle = HPIOpenFile(HPI, Filename)
    If FileHandle = 0 Then Exit Sub
    
    HPIGet Header(0), FileHandle, 0, 7 * 4
    Width = Header(SCTWidth)
    Height = Header(SCTHeight)
    If Header(SCTPTRMini) > 0 Then
        HPIGet Minimap(0), FileHandle, Header(SCTPTRMini), UBound(Minimap) + 1
    End If
    
    rc = HPICloseFile(FileHandle)
    rc = HPIClose(HPI)
End Sub

Public Sub FreeMini()
    If Hold Then Exit Sub
    ReDim Minimap(0)
End Sub

Public Sub LoadSection()
    Dim HPI As Long
    Dim FileHandle As Long
    Dim Header(6) As Long
    Dim Buffer() As Long
    Dim Index As Long
    Dim Flag As Boolean
    Dim rc As Long
    
    RegionTiles = PasteTiles
    RegionHeight = PasteHeight
    If Hold Then Exit Sub
    If HPIName = "" Then Exit Sub
    
    On Error GoTo Error
    FreeSection
    HPI = HPIOpen(HPIName)
    If HPI = 0 Then Exit Sub
    FileHandle = HPIOpenFile(HPI, Filename)
    If FileHandle = 0 Then Exit Sub
    
    HPIGet Header(0), FileHandle, 0, 7 * 4
    ReDim TileData(Header(SCTNumTiles) * 1024 - 1)
    HPIGet TileData(0), FileHandle, Header(SCTPTRTiles), UBound(TileData) + 1
    ReDim MapData(Header(SCTWidth) * Header(SCTHeight) - 1)
    HPIGet MapData(0), FileHandle, Header(SCTPTRData), UBound(MapData) * 2 + 2
    ReDim HeightData(Header(SCTWidth) * Header(SCTHeight) * 4 - 1)
    
    ' Load the height data from the buffer. '
    If Header(SCTVersion) = 2 Then
        ReDim Buffer(Header(SCTWidth) * Header(SCTHeight) * 8 - 1)
        HPIGet Buffer(0), FileHandle, Header(SCTPTRData) + UBound(MapData) * 2 + 2, UBound(Buffer) * 4 + 4
        Flag = True
        For Index = 0 To UBound(Buffer)
            If Flag Then
                HeightData(Int(Index / 2)) = Buffer(Index) And &HFF
            End If
            Flag = Not Flag
        Next
    ElseIf Header(SCTVersion) = 3 Then
        ReDim Buffer(Header(SCTWidth) * Header(SCTHeight) * 4 - 1)
        HPIGet Buffer(0), FileHandle, Header(SCTPTRData) + UBound(MapData) * 2 + 2, UBound(Buffer) * 4 + 4
        For Index = 0 To UBound(Buffer)
            HeightData(Index) = Buffer(Index) And &HFF
        Next
    End If
    UpdateTileList
    Selected = True
    
Error:
    rc = HPICloseFile(FileHandle)
    rc = HPIClose(HPI)
End Sub

Public Sub FreeSection()
    On Error Resume Next
    If Holds <= 0 And Not Hold Then
        ReDim TileData(0)
        ReDim MapData(0)
        ReDim HeightData(0)
    End If
    If SelectedSection.Name = Name Then Set SelectedSection = New classSection
    Selected = False
End Sub

Public Sub CreatePalette(xIndex As Integer, yIndex As Integer, DrawBorder As Boolean)
    Dim rc As Long
    
    With FrmAnnihilator
    Screens(PaletteSections).TileDraw 0, 0, 128, 128, Minimap()
    Screens(PaletteSections).Show .PicSections.hdc, xIndex, yIndex, 128, 128, 0, 0
    If DrawBorder Then
        .PicSections.Line (xIndex - 2, yIndex - 2)-(xIndex + 128 + 2, yIndex - 2), &HFF8080
        .PicSections.Line (xIndex - 2, yIndex - 2)-(xIndex - 2, yIndex + 128 + 2), &HFF8080
        .PicSections.Line (xIndex - 2, yIndex + 128 + 2)-(xIndex + 128 + 3, yIndex + 128 + 2), &HFF8080
        .PicSections.Line (xIndex + 128 + 2, yIndex - 2)-(xIndex + 128 + 2, yIndex + 128 + 2), &HFF8080
    End If
    .PicSectionsTemp.Cls
    .PicSectionsTemp.Print Name & " - " & CStr(Width * 32) & "x" & CStr(Height * 32)
    rc = BitBlt(.PicSections.hdc, xIndex, yIndex + 128 + 5, .PicSectionsTemp.ScaleWidth, .PicSectionsTemp.ScaleHeight, .PicSectionsTemp.hdc, 0, 0, SRCCOPY)
    .PicSections.Line (0, yIndex + 128 + 23)-(.PicSections.ScaleWidth, yIndex + 128 + 23), 0 '&H80000010
    .PicSections.Line (0, yIndex + 128 + 24)-(.PicSections.ScaleWidth, yIndex + 128 + 24), 0 '&H80000014
    yIndex = yIndex + 128 + 30
    End With
End Sub

' Update the tile graphics checksum. '
Public Sub UpdateTileList()
    Dim Index As Long
    
    If UBound(TileData) < 1023 Then Exit Sub
    ReDim TileList((UBound(TileData) + 1) / 1024 - 1)
    Index = UBound(TileList)
    CreateTileChecksumList TileData(0), TileList(0), Index
End Sub

' Paste the section into a map. '
Public Sub PasteSection(StartX As Long, StartY As Long, MapWidth As Long, MapHeight As Long, PasteMapData() As Long, PasteHeightData() As Byte, PasteTileData() As Byte, PasteTileList() As Long)
    Dim x As Long, y As Long
    Dim Index As Long, Offset As Long, i As Long, k As Long, Flag As Boolean
    Dim SectionMapIndex As Long, SectionAttrIndex As Long
    Dim Buffer As Long
    Dim Indexes() As Long
    Dim CopyIndexes() As Long
    Dim TileOffset As Long
    
    On Error GoTo Error
    
    ' Make sure no duplicate tiles are copied on the map. '
    ReDim CopyIndexes(0)
    If RegionTiles Then
        ReDim Indexes(UBound(TileList))
        For Index = 0 To UBound(TileList)
            For i = 0 To UBound(PasteTileList)
                Flag = False
                If TileList(Index) = PasteTileList(i) Then
                    Flag = True
                    For k = 0 To 1023
                        If TileData(Index * 1024 + k) <> PasteTileData(i * 1024 + k) Then
                            Flag = False
                            Exit For
                        End If
                    Next
                End If
                If Flag Then Exit For
            Next
            If Flag Then
                Indexes(Index) = i
            Else
                ReDim Preserve CopyIndexes(UBound(CopyIndexes) + 1)
                CopyIndexes(UBound(CopyIndexes)) = Index
                Indexes(Index) = UBound(PasteTileList) + UBound(CopyIndexes)
            End If
        Next
    End If
                
    TileOffset = UBound(PasteTileList) + 1
    ReDim Preserve PasteTileList(UBound(PasteTileList) + UBound(CopyIndexes))
    Offset = UBound(PasteTileData) + 1
    ReDim Preserve PasteTileData(UBound(PasteTileData) + UBound(CopyIndexes) * 1024)
    For Index = 1 To UBound(CopyIndexes)
        PasteTileList(TileOffset + Index - 1) = TileList(CopyIndexes(Index))
        CopyMemory PasteTileData(Offset + (Index - 1) * 1024), TileData(CopyIndexes(Index) * 1024), 1024
    Next
       
    ' Copy section to the map. '
    SectionMapIndex = 0
    For y = StartY To StartY + Height - 1
            For x = StartX To StartX + Width - 1
                If (y >= 0) And (y <= MapHeight - 1) Then
                    If (x >= 0) And (x <= MapWidth - 1) Then
                        If RegionTiles Then
                            PasteMapData(y * MapWidth + x) = Indexes(MapData(SectionMapIndex))
                        End If
                        If RegionHeight Then
                            SectionAttrIndex = 4 * (y - StartY) * Width + (x - StartX) * 2
                            Buffer = HeightData(SectionAttrIndex) + HeightOffset
                            If Buffer > 255 Then Buffer = 255
                            If Buffer < 0 Then Buffer = 0
                            PasteHeightData(4 * y * MapWidth + x * 2) = Buffer
                            Buffer = HeightData(SectionAttrIndex + 1) + HeightOffset
                            If Buffer > 255 Then Buffer = 255
                            If Buffer < 0 Then Buffer = 0
                            PasteHeightData(4 * y * MapWidth + (x * 2 + 1)) = Buffer
                            Buffer = HeightData(SectionAttrIndex + Width * 2) + HeightOffset
                            If Buffer > 255 Then Buffer = 255
                            If Buffer < 0 Then Buffer = 0
                            PasteHeightData((2 * y + 1) * 2 * MapWidth + x * 2) = Buffer
                            Buffer = HeightData(SectionAttrIndex + Width * 2 + 1) + HeightOffset
                            If Buffer > 255 Then Buffer = 255
                            If Buffer < 0 Then Buffer = 0
                            PasteHeightData((2 * y + 1) * 2 * MapWidth + (x * 2 + 1)) = Buffer
                        End If
                    End If
                End If
                SectionMapIndex = SectionMapIndex + 1
            Next
    Next
    UpdateStatusbar
    Exit Sub
    
Error:
    MsgBox "There was an error pasting this section: " & Err.Description, vbExclamation
    UpdateStatusbar
End Sub

Public Sub DrawTiles(ByVal x As Long, ByVal y As Long, ViewX As Long, ViewY As Long, MapWidth As Long, MapHeight As Long)
    Dim ViewWidth As Long, ViewHeight As Long
    Dim IndexX As Long, IndexY As Long
    Dim MapPosition As Long
    
    On Error Resume Next
    ViewWidth = Int(FrmAnnihilator.Canvas.ScaleWidth / 32)
    ViewHeight = Int(FrmAnnihilator.Canvas.ScaleHeight / 32)
    
    For IndexX = x To x + Width - 1
        If IndexX > (MapWidth / 2) - 1 Then Exit For
        If IndexX >= ViewX Then
            For IndexY = y To y + Height - 1
                If IndexY > (MapHeight / 2) - 1 Then Exit For
                If IndexY >= ViewY Then
                    If ((IndexX + Width > ViewX) And (IndexX <= ViewX + ViewWidth) And (IndexY + Height > ViewY) And (IndexY <= ViewY + ViewHeight)) Then
                        MapPosition = MapData((IndexY - y) * Width + (IndexX - x))
                        MapPosition = MapPosition * 1024
                        Screens(Canvas).TileDraw (IndexX - ViewX) * 32, (IndexY - ViewY) * 32, 32, 32, TileData(), MapPosition
                    End If
                End If
            Next
        End If
    Next
End Sub

Public Function GetHeight(Index As Long) As Byte
    Dim Buffer As Long
    
    On Error Resume Next
    If Not RegionHeight Then Exit Function
    Buffer = HeightData(Index) + HeightOffset
    If Buffer > 255 Then Buffer = 255
    If Buffer < 0 Then Buffer = 0
    GetHeight = Buffer
End Function

Public Sub SetHeight(Index As Long, Height As Byte)
    On Error Resume Next
    HeightData(Index) = Height - HeightOffset
End Sub

Public Sub CopySection(ByVal x As Long, ByVal y As Long, ByVal rWidth As Long, ByVal rHeight As Long, MapWidth As Long, MapHeight As Long, ByRef rMapData() As Long, rHeightData() As Byte, rTileData() As Byte)
    Dim xIndex As Long, yIndex As Long
    Dim Index As Long, Flag As Boolean, IndexAt As Long
    Dim MapIndexes() As Long, SectionIndexes() As Long
    
    On Error GoTo Error
    IndexAt = 0
    Width = rWidth
    Height = rHeight
    ReDim MapData(Width * Height - 1)
    ReDim HeightData(Width * Height * 4 - 1)
    ReDim TileData(0)
    ReDim MapIndexes(Width * Height)
    ReDim SectionIndexes(Width * Height)
    For yIndex = y To y + Height - 1
        For xIndex = x To x + Width - 1
            If RegionTiles Then
                Flag = False
                For Index = 1 To IndexAt
                    If MapIndexes(Index) = rMapData(yIndex * MapWidth + xIndex) Then
                        Flag = True
                        Exit For
                    End If
                Next
                If Flag Then
                    MapData((yIndex - y) * Width + (xIndex - x)) = SectionIndexes(Index)
                Else
                    MapIndexes(IndexAt + 1) = rMapData(yIndex * MapWidth + xIndex)
                    SectionIndexes(IndexAt + 1) = IndexAt
                    ReDim Preserve TileData((IndexAt + 1) * 1024 - 1)
                    For Index = IndexAt * 1024 To UBound(TileData)
                        TileData(Index) = rTileData(rMapData(yIndex * MapWidth + xIndex) * 1024 + Index - IndexAt * 1024)
                    Next
                    MapData((yIndex - y) * Width + (xIndex - x)) = IndexAt
                    IndexAt = IndexAt + 1
                End If
                rMapData(yIndex * MapWidth + xIndex) = 0
            End If
            If RegionHeight Then
                HeightData((2 * (yIndex - y)) * Width * 2 + (2 * (xIndex - x))) = rHeightData(4 * yIndex * MapWidth + 2 * xIndex)
                rHeightData(4 * yIndex * MapWidth + 2 * xIndex) = 0
                HeightData((2 * (yIndex - y)) * Width * 2 + (2 * (xIndex - x)) + 1) = rHeightData(4 * yIndex * MapWidth + 2 * xIndex + 1)
                rHeightData(4 * yIndex * MapWidth + 2 * xIndex + 1) = 0
                HeightData((2 * (yIndex - y)) * Width * 2 + (2 * (xIndex - x)) + Width * 2) = rHeightData(4 * yIndex * MapWidth + 2 * xIndex + MapWidth * 2)
                rHeightData(4 * yIndex * MapWidth + 2 * xIndex + MapWidth * 2) = 0
                HeightData((2 * (yIndex - y)) * Width * 2 + (2 * (xIndex - x)) + Width * 2 + 1) = rHeightData(4 * yIndex * MapWidth + 2 * xIndex + MapWidth * 2 + 1)
                rHeightData(4 * yIndex * MapWidth + 2 * xIndex + MapWidth * 2 + 1) = 0
            End If
        Next
    Next
Error:
    UpdateTileList
    UpdateStatusbar
End Sub

' Export a BMP file for this section. '
Public Sub ExportBMP(Filename As String)
    Dim MapBits() As Byte
    Dim IndexX As Long, IndexY As Long
    Dim xPos As Long, yPos As Long
    Dim MapIndex As Long
    Dim Buffer As Long
    
    ReDim MapBits((UBound(MapData) + 1) * 1024 - 1)
    For IndexY = 0 To Height - 1
        For IndexX = 0 To Width - 1
            For yPos = 0 To 31
                For xPos = 0 To 31
                    Buffer = MapData(MapIndex)
                    MapBits((Width * 32) * (IndexY * 32 + yPos) + IndexX * 32 + xPos) = TileData(Buffer * 1024 + yPos * 32 + xPos)
'                    If MapBits((Width * 32) * (IndexY * 32 + yPos) + IndexX * 32 + xPos) = 0 Then Stop
                Next
            Next
            MapIndex = MapIndex + 1
            DoEvents
        Next
    Next
    
    SaveBMPFile Filename, MapBits(), TAPalette(), Width * 32, Height * 32
End Sub

' Export a SCT file for this section. '
Public Sub ExportSCT(Filename As String)
    Dim i As Integer
    Dim File As Integer
    Dim Header(6) As Long
    Dim IntBuffer As Integer
    Dim LongBuffer As Long
    Dim ByteBuffer As Byte
        
    Header(SCTVersion) = 3
    Header(SCTPTRMini) = ((UBound(Header) + 1) * 4) + (UBound(TileData) + 1) + ((UBound(HeightData) + 1) * 4) + ((UBound(MapData) + 1) * 2)
    Header(SCTNumTiles) = ((UBound(TileData) + 1) / 1024)
    Header(SCTPTRTiles) = (UBound(Header) + 1) * 4
    Header(SCTWidth) = Width
    Header(SCTHeight) = Height
    Header(SCTPTRData) = ((UBound(Header) + 1) * 4) + (UBound(TileData) + 1)
    
    File = FreeFile
    Open Filename For Binary Access Write As File
        Put File, , Header()
        Put File, , TileData()
        Put File, , MapData()
        
        IntBuffer = -1
        ByteBuffer = 0
        For i = 0 To UBound(HeightData)
            Put File, , HeightData(i)
            Put File, , IntBuffer
            Put File, , ByteBuffer
        Next
        Put File, , Minimap()
    Close File
End Sub

' Export a greyscale map (BMP) for this section. '
Public Sub ExportHeight(Filename As String)
    Dim Index As Long
    Dim GreyPalette(255) As RGBQUAD
    
    ' Create palette. '
    On Error GoTo Error
    For Index = 0 To 255
        GreyPalette(Index).rgbRed = Index
        GreyPalette(Index).rgbGreen = Index
        GreyPalette(Index).rgbBlue = Index
        GreyPalette(Index).rgbReserved = 0
    Next
    
    SaveBMPFile Filename, HeightData(), GreyPalette(), Width * 2, Height * 2
    Exit Sub
Error:
    MsgBox "There was an error exporting the heightmap for this section.", vbExclamation, "Export Heightmap"
End Sub

' Import a greyscale map (BMP for this section. '
Public Sub ImportHeight(Filename As String)
    Dim xIndex As Long, yIndex As Long
    Dim ScenePos As Long, BitmapPos As Long
    
    On Error GoTo Error
    If Filename = "" Then Exit Sub
    If Not LoadBMPFile(Filename) Then
        MsgBox "There was an error loading the height map bitmap " & Filename & ".", vbExclamation, "Error"
        Exit Sub
    End If
    
    If (Width * 2 > modBmp.BitmapInfo.biWidth) Or (Height * 2 > modBmp.BitmapInfo.biHeight) Then
        MsgBox "The height map specified was too small, and could not be loaded."
        Exit Sub
    End If

    For yIndex = 0 To (Height * 2 - 1)
        For xIndex = 0 To (Width * 2 - 1)
            HeightData(ScenePos) = Bits(BitmapPos + xIndex)
            ScenePos = ScenePos + 1
        Next
        BitmapPos = BitmapPos + modBmp.BitmapInfo.biWidth
    Next
    Exit Sub
Error:
    MsgBox "There was an error loading the heightmap you selected.", vbExclamation, "Import Heightmap"
End Sub

Sub CreateMinimap()
    Dim IndexX As Long, IndexY As Long
    Dim PosX As Single, PosY As Single
    Dim position As Long
    Dim TileIndex As Long
    Dim Buffer As Byte
    Dim TileX As Long, TileY As Long
    Dim Index As Long
    Dim sWidth As Long
    Dim sHeight As Long
    Dim MinisWidth As Integer
    Dim MinisHeight As Integer
    Dim lBuffer As Long
    
    On Error GoTo Error
    
    ' Use 100 as the fill color. '
    ReDim Minimap(128 * 128 - 1)
    For Index = 0 To UBound(Minimap)
        Minimap(Index) = 100
    Next
    
    sWidth = (Width * 32)
    sHeight = (Height * 32)
    
    If sWidth > sHeight Then ' It will be 128 across. '
        MinisWidth = 128
        MinisHeight = CInt((MinisWidth * sHeight) / sWidth)
    ElseIf sHeight > sWidth Then
        MinisHeight = 128
        MinisWidth = CInt((MinisHeight * sWidth) / sHeight)
    ElseIf sWidth = sHeight Then
        MinisWidth = 128
        MinisHeight = 128
    End If
    
    ' Create the new mini map. '
    PosX = 0
    PosY = 0
    position = 0
    TileIndex = 0
    For IndexY = 0 To MinisHeight - 1
        For IndexX = 0 To MinisWidth - 1
            TileX = Int(PosX) - Int(32 * Int(PosX / 32))
            TileY = Int(PosY) - Int(32 * Int(PosY / 32))
            If TileX >= 32 Then TileX = 32
            If TileY >= 32 Then TileY = 32
            TileIndex = (Int(PosY / 32) * Width) + Int(PosX / 32)
            lBuffer = MapData(TileIndex)
            Buffer = TileData(lBuffer * 1024 + ((TileY * 32) + TileX))
            Minimap(position + IndexX) = Buffer
            PosX = PosX + sWidth / MinisWidth
            If PosX >= sWidth Then PosX = sWidth - 1
          Next
        position = position + 128
        PosX = 0
        PosY = PosY + sHeight / MinisHeight
        If PosY >= sHeight Then PosY = sHeight - 1
    Next
    Exit Sub
Error:
    MsgBox "There was an error creating the minimap."
    'Resume
End Sub

Public Sub ExportHPI(FileHandle As Long, Path As String)
    Dim Header(6) As Long
    Dim IntBuffer As Integer
    Dim i As Long, Offset As Long
    Dim rc As Long
    
    ' Create header. '
    Header(SCTVersion) = 3
    Header(SCTPTRMini) = ((UBound(Header) + 1) * 4) + (UBound(TileData) + 1) + ((UBound(HeightData) + 1) * 4) + ((UBound(MapData) + 1) * 2)
    Header(SCTNumTiles) = ((UBound(TileData) + 1) / 1024)
    Header(SCTPTRTiles) = (UBound(Header) + 1) * 4
    Header(SCTWidth) = Width
    Header(SCTHeight) = Height
    Header(SCTPTRData) = ((UBound(Header) + 1) * 4) + (UBound(TileData) + 1)
    
    ReDim FileBuffer(UBound(Header) * 4 + 3)
    CopyMemory FileBuffer(0), Header(0), UBound(Header) * 4 + 4
    Offset = UBound(FileBuffer) + 1
    ReDim Preserve FileBuffer(Offset + UBound(TileData))
    CopyMemory FileBuffer(Offset), TileData(0), UBound(TileData) + 1
    
    Offset = UBound(FileBuffer) + 1
    ReDim Preserve FileBuffer(Offset + UBound(MapData) * 2 + 1)
    For i = 0 To UBound(MapData)
        CopyMemory FileBuffer(Offset + i * 2), MapData(i), 2
    Next
        
    IntBuffer = 1
    Offset = UBound(FileBuffer) + 1
    ReDim Preserve FileBuffer(Offset + UBound(HeightData) * 4 + 3)
    For i = 0 To UBound(HeightData)
        FileBuffer(Offset + i * 4) = HeightData(i)
        CopyMemory FileBuffer(Offset + i * 4 + 1), IntBuffer, 2
        FileBuffer(Offset + i * 4 + 3) = 0
    Next
    
    Offset = UBound(FileBuffer) + 1
    ReDim Preserve FileBuffer(Offset + UBound(Minimap))
    CopyMemory FileBuffer(Offset), Minimap(0), UBound(Minimap) + 1
    
    rc = HPIAddFileFromMemory(FileHandle, Path & Name, VarPtr(FileBuffer(0)), UBound(FileBuffer) + 1)
End Sub

Public Sub ClearBuffer()
    ReDim FileBuffer(0)
End Sub

Public Sub ImportBMP(Filename As String)
    Dim Index As Long
    
    If Not LoadBMPFile(Filename, True) Then Exit Sub

    ' Create tile data. '
    Width = Int(modBmp.BitmapInfo.biWidth / 32)
    Height = Int(modBmp.BitmapInfo.biHeight / 32)
    ReDim TileData((Int(modBmp.BitmapInfo.biWidth / 32) * Int(modBmp.BitmapInfo.biHeight / 32)) * 1024 - 1)
    CreateTilesFromBmp Bits(0), TileData(0), modBmp.BitmapInfo.biWidth, modBmp.BitmapInfo.biHeight
    UpdateTileList
    
    ' Create the map data. '
    ReDim MapData(Width * Height - 1)
    For Index = 0 To UBound(MapData)
        MapData(Index) = Index ' Default to first tile in the tile data. '
    Next
        
    ' Create the scene data. '
    ReDim SceneAttr(Width * Height * 4 - 1)
    ReDim HeightData(Width * Height * 4 - 1)
    
    CreateMinimap
    
    Hold = True
    Name = GetFilename(Filename)
    Name = Left(Name, Len(Name) - 3) & "sct"
End Sub

Public Sub FillMap(fMapData() As Long, fHeightData() As Byte, fTileData() As Byte, fTileList() As Long, fWidth As Long, fHeight As Long)
    Dim xIndex As Long, yIndex As Long
    Dim xAt As Long, yAt As Long
    Dim Index As Long
    
    On Error GoTo Error:
    UpdateTileList
    ReDim fTileData(UBound(TileData))
    For Index = 0 To UBound(TileData)
        fTileData(Index) = TileData(Index)
    Next
    ReDim fTileList(UBound(TileList))
    For Index = 0 To UBound(TileList)
        fTileList(Index) = TileList(Index)
    Next
    
    For yIndex = 0 To fHeight - 1
        For xIndex = 0 To fWidth - 1
            xAt = xIndex - Width * Int(xIndex / Width)
            yAt = yIndex - Height * Int(yIndex / Height)
            fMapData(xIndex + yIndex * fWidth) = MapData(xAt + yAt * Width)
            fHeightData(xIndex * 2 + yIndex * fWidth * 4) = HeightData(xAt * 2 + yAt * Width * 4)
            fHeightData(xIndex * 2 + yIndex * fWidth * 4 + 1) = HeightData(xAt * 2 + yAt * Width * 4 + 1)
            fHeightData(xIndex * 2 + yIndex * fWidth * 4 + fWidth * 2) = HeightData(xAt * 2 + yAt * Width * 4 + Width * 2)
            fHeightData(xIndex * 2 + yIndex * fWidth * 4 + fWidth * 2 + 1) = HeightData(xAt * 2 + yAt * Width * 4 + Width * 2 + 1)
        Next
    Next
Error:
End Sub

Public Sub FillOverlay()
    Dim NewMapData() As Long
    Dim Index As Integer
    
    ReDim NewMapData(UBound(MapData))
    For Index = 0 To UBound(MapData)
        NewMapData(Index) = MapData(Index)
    Next
    
    SelectedSection.FillMap NewMapData(), HeightData(), TileData(), TileList(), Width, Height

    For Index = 0 To UBound(MapData)
        MapData(Index) = NewMapData(Index)
    Next
End Sub

Public Sub HeightSet(Value As Byte)
    Dim Index As Long
    
    On Error GoTo Error
    For Index = 0 To UBound(HeightData)
        HeightData(Index) = Value
    Next
    
Error:
End Sub
