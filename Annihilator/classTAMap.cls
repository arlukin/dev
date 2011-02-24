VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "classTAMap"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' TA map class. '

Option Explicit

' TNT data. '
Dim Header(15) As Long
Dim MapData() As Long
Dim HeightData() As Byte
Dim SceneAttr() As Integer
Dim TileData() As Byte
Dim AnimTitles() As String

' Map tile checksums. '
Dim TileList() As Long

' OTA data. '
Dim otaInfo(38) As String
Dim PlayerPosX(10) As Long
Dim PlayerPosY(10) As Long

' Subclasses. '
Private Minimap As New classMinimap
Private MapFeatures() As New classFeature ' All the features of the map. '

Private Overlay As New classSection ' Section overlays on this map. '
Private Region As New classRubberband ' Selected section region on this map. '
Public RegionMouseOver As Boolean

' Globals. '
Public MapLoaded As Boolean ' There is a map loaded. '
Public MapChanged As Boolean ' The map has changed. '
Public MapFilename As String ' The filename for this map. '
Public ViewX As Long, ViewY As Long ' The position of the view. '

' Selected items. '
Private SelectedTile As Long ' The selected palette tile. '
Private SelectedAttr() As Long

' Initialize the map. '
Public Sub Initialize()
    Dim Index As Long
    
    For Index = 0 To UBound(Header)
        Header(Index) = 0
    Next
    
    For Index = 0 To UBound(PlayerPosX)
        PlayerPosX(Index) = 0
        PlayerPosY(Index) = 0
    Next
    
    ReDim MapData(0)
    ReDim HeightData(0)
    ReDim SceneAttr(0)
    ReDim TileData(0)
    ReDim AnimTitles(0)
    ReDim TileList(0)
    ReDim MapFeatures(0)
    ReDim SelectedTiles(0)
    ReDim SelectedAttr(0)
    
    Overlay.Holds = Overlay.Holds - 1
    Set Overlay = New classSection
    Set Region = New classRubberband
    
    MapLoaded = False
    MapChanged = False
    MapFilename = ""
    ViewX = 0
    ViewY = 0
    SelectedTile = 0
End Sub

' Load a map from an HPI file. '
Public Sub LoadMapHPI(HPIFilename As String, HPI As Long, Filename As String)
    Dim FileHandle As Long
    Dim rc As Long
    Dim Buffer As String
    Dim MapLoadData() As Integer
    Dim SceneData() As Byte
    Dim AnimData() As Byte
    
    ' Initialize. '
    On Error GoTo Error
    MapLoaded = False
    Screen.MousePointer = vbHourglass
    FrmProgress.Captions "Initializing...", "Loading map"
    FrmProgress.Show , FrmAnnihilator
    DoEvents
    
    ' Open the map. '
    FileHandle = HPIOpenFile(HPI, Filename)
    If FileHandle = 0 Then Exit Sub
    
    ' Load the header settings. '
    HPIGet Header(0), FileHandle, 0, 16 * 4
    If Header(IDiversion) <> 8192 Then GoTo Error
    
    ' Get the map's information. '
    FrmProgress.Captions "Loading map information...", "Loading map"
    ReDim MapLoadData((Header(MapWidth) * Header(MapHeight)) / 4 - 1)
    HPIGet MapLoadData(0), FileHandle, Header(PTRMapData), (UBound(MapLoadData) + 1) * 2
    ConvertMapData MapLoadData()
    
    ReDim SceneData((Header(MapWidth) * Header(MapHeight)) * 4 - 1)
    HPIGet SceneData(0), FileHandle, Header(PTRMapAttr), UBound(SceneData) + 1
    ConvertSceneData SceneData()
    FrmProgress.Update 1, 4
    
    FrmProgress.Captions "Loading textures...", "Loading map"
    ReDim TileData(Header(Tiles) * 1024 - 1)
    HPIGet TileData(0), FileHandle, Header(PTRTileGfx), UBound(TileData) + 1
    FrmProgress.Update 1, 1
    
    If Header(TileAnims) = 0 Then
        ReDim AnimData(0)
    Else
        ReDim AnimData(Header(TileAnims) * 132 - 1)
        HPIGet AnimData(0), FileHandle, Header(PTRTileAnim), UBound(AnimData) + 1
    End If
    AnimationsCreateList AnimData()

    Minimap.HeaderWidth = Header(MapWidth)
    Minimap.HeaderHeight = Header(MapHeight)
    Minimap.MiniMapLoad FileHandle, True, Header(PTRMiniMap)
    
    rc = HPICloseFile(FileHandle)
    
    ' Load the OTA file. '
    Buffer = App.Path
    If Right(Buffer, 1) <> "\" Then
        Buffer = Buffer & "\temp.ota"
    Else
        Buffer = Buffer & "temp.ota"
    End If
    rc = HPIExtractFile(HPI, Left(Filename, Len(Filename) - 3) & "ota", Buffer)
    If rc > 0 Then
        OTALoad Buffer
    Else
        OTADefaults
    End If
    On Error Resume Next
    Kill Buffer
    On Error GoTo Error
    
    ' Clean-up. '
    Screen.MousePointer = vbDefault
    Unload FrmProgress
    MapLoaded = True
    MapChanged = False
    MapFilename = Left(HPIFilename, Len(HPIFilename) - 4)
    MapInitialize
    Exit Sub
    
Error:
    Unload FrmProgress
    MsgBox "There was an error loading your map: " & Err.Description, vbExclamation
'    Resume
    Initialize
End Sub

' Load a map file. '
Public Sub LoadMap(Filename As String)
    Dim FileHandle As Integer
    
    ' Initialize. '
    MapLoaded = False
    Screen.MousePointer = vbHourglass
    
    ' Open the map file. '
    On Error GoTo Error
    FileHandle = FreeFile
    Open Filename For Binary As FileHandle
    DoEvents
    
    ' Load the header settings. '
    Get FileHandle, , Header()
    If Header(IDiversion) <> 8192 Then GoTo Error
    
    ' Get the map's information. '
    LoadMapData FileHandle
    LoadSceneData FileHandle
    LoadTileData FileHandle
    LoadAnimData FileHandle
    LoadMinimap FileHandle
    OTALoad Left(Filename, Len(Filename) - 3) & "ota"
    
    ' Clean-up. '
    Close FileHandle
    Screen.MousePointer = vbDefault
    MapLoaded = True
    MapChanged = False
    MapFilename = Left(Filename, Len(Filename) - 4)
    MapInitialize
    Exit Sub
    
Error:
    Initialize
End Sub

' Load the MapData. '
Private Sub LoadMapData(FileHandle As Integer)
    Dim MapLoadData() As Integer
    
    ' Load the MapData from the file. '
    Seek #FileHandle, Header(PTRMapData) + 1
    ReDim MapLoadData((Header(MapWidth) / 2) * (Header(MapHeight) / 2) - 1)
    Get FileHandle, , MapLoadData()
    ConvertMapData MapLoadData()
End Sub

' Convert the MapData into a long array. '
Private Sub ConvertMapData(MapLoadData() As Integer)
    Dim Index As Long
    Dim Buffer As Long
        
    ReDim MapData(UBound(MapLoadData))
    For Index = 0 To UBound(MapLoadData)
        If MapLoadData(Index) < 0 Then
            MapData(Index) = MapLoadData(Index) + 65536
        Else
            MapData(Index) = MapLoadData(Index)
        End If
    Next
End Sub

' Convert the long array back to integer and save. '
Private Sub SaveMapData(FileHandle As Integer)
    Dim Index As Long
    Dim Buffer As Long
    Dim MapLoadData() As Integer
        
    ReDim MapLoadData(UBound(MapData))
    For Index = 0 To UBound(MapData)
        If MapData(Index) > 65536 Then
            MapLoadData(Index) = -32768
        ElseIf (MapData(Index) > 32767) And (MapData(Index) <= 65536) Then
            Buffer = MapData(Index) - 65536
            MapLoadData(Index) = Buffer
        Else
            MapLoadData(Index) = MapData(Index)
        End If
    Next
    
    Put FileHandle, , MapLoadData()
End Sub

' Load the SceneData for the map. '
Private Sub LoadSceneData(FileHandle As Integer)
    Dim SceneData() As Byte

    ReDim SceneData(16 * ((Header(MapWidth) / 2) * (Header(MapHeight) / 2)) - 1)
    Seek FileHandle, Header(PTRMapAttr) + 1
    Get FileHandle, , SceneData()
    ConvertSceneData SceneData()
End Sub

' Get the various parts from the SceneData long. '
Private Sub ConvertSceneData(SceneData() As Byte)
    Dim Byte1 As Long, Byte2 As Long, Buffer As Long
    Dim i As Long, k As Long
        
    ' Load the entire SceneData to one byte array. '
    ReDim HeightData(4 * ((Header(MapWidth) / 2) * (Header(MapHeight) / 2)) - 1)
    ReDim SceneAttr(4 * ((Header(MapWidth) / 2) * (Header(MapHeight) / 2)) - 1)
    
    ' Convert SceneData to SceneAttr and HeightData. '
    For i = 0 To UBound(SceneData) Step 4
        HeightData(k) = SceneData(i)
        Byte1 = SceneData(i + 1)
        Byte2 = SceneData(i + 2)
        Buffer = (Byte2 * 256) Or Byte1
        If Buffer > 32767 Then
            Buffer = Buffer - 65536
        End If
        SceneAttr(k) = Buffer
        k = k + 1
    Next
End Sub

' Load the map's TileData. '
Private Sub LoadTileData(FileHandle As Integer)
    Dim Index As Long, i As Long, position As Long
    Dim TileDataGet() As Byte

    On Error GoTo Error
    Seek #FileHandle, Header(PTRTileGfx) + 1
    ReDim TileData(Header(Tiles) * 1024 - 1)
    DoEvents
        
    ' Do a quick load for maps with under 20,000 tiles. '
    If Header(Tiles) < 20000 Then
        Get FileHandle, , TileData()
        Exit Sub
    End If
    
    ' Load tiles in blocks of 132000 bytes. '
    position = 0
    ReDim TileDataGet(131999)
    Do While (position + 132000) <= (Header(Tiles) * 1024)
        If ((Header(Tiles) * 1024) > position) And ((Header(Tiles) * 1024) < (position + 132000)) Then
            ReDim TileDataGet((Header(Tiles) * 1024) - position - 1)
        End If
        Get FileHandle, , TileDataGet()
        For i = 0 To UBound(TileDataGet)
            If (position + i) <= UBound(TileData) Then
                TileData(position + i) = TileDataGet(i)
            End If
        Next
        position = position + 132000
        DoEvents
    Loop
    Exit Sub
Error:
    MsgBox "Error: " & Err.Number & ": " & Err.Description
    'Resume
End Sub

' Load the map's AnimData, and convert to a string array. '
Private Sub LoadAnimData(FileHandle As Integer)
    Dim AnimData() As Byte
    
    ' Load the raw anim names list. '
    If Header(TileAnims) = 0 Then
        ReDim AnimData(0)
    Else
        Seek FileHandle, Header(PTRTileAnim) + 1
        ReDim AnimData(Header(TileAnims) * 132 - 1)
        ReDim MapFeatures(0)
        Get FileHandle, , AnimData()
    End If
    
    ' Convert to a string array. '
    AnimationsCreateList AnimData()
End Sub

' Load the minimap for the map. '
Private Sub LoadMinimap(FileHandle As Integer)
    Minimap.HeaderWidth = Header(MapWidth)
    Minimap.HeaderHeight = Header(MapHeight)
    Seek FileHandle, Header(PTRMiniMap) + 9 ' Skip two long values (252 each). '
    Minimap.MiniMapLoad FileHandle
End Sub

Public Sub SaveTNT(Filename As String)
    Dim MapSize As Long
    Dim MapPTR As Long
    Dim Byte1 As Long, Byte2 As Long, Buffer As Long
    Dim Blank As Byte
    Dim i As Long, k As Long
    Dim MapBuffer() As Byte
    Dim MapLoadData() As Integer
    Dim SceneData() As Byte
    Dim AnimData() As Byte
    Dim Index As Long
    Dim FileHandle As Long
    Dim rc As Long
    
    If Region.Usable Then
        rc = MsgBox("You have unpasted sections on your map.  Do you want to paste them now?", vbYesNo + vbQuestion, "Save Map")
        If rc = vbYes Then OverlayPaste
    End If
            
    ' Convert the map's MapData. '
    ReDim MapLoadData(UBound(MapData))
    For Index = 0 To UBound(MapData)
        If MapData(Index) > 65536 Then
            MapLoadData(Index) = -32768
        ElseIf (MapData(Index) > 32767) And (MapData(Index) <= 65536) Then
            Buffer = MapData(Index) - 65536
            MapLoadData(Index) = Buffer
        Else
            MapLoadData(Index) = MapData(Index)
        End If
    Next
    
    ' Create the map's SceneData. '
    Blank = 0
    ReDim SceneData(16 * ((Header(MapWidth) / 2) * (Header(MapHeight) / 2)) - 1)
    For i = 0 To UBound(SceneData) Step 4
        Buffer = SceneAttr(k)
        If Buffer < 0 Then Buffer = Buffer + 65536
        Byte1 = Buffer Mod 256
        Byte2 = Int(Buffer / 256)
        SceneData(i) = HeightData(k)
        SceneData(i + 1) = Byte1
        SceneData(i + 2) = Byte2
        SceneData(i + 3) = 0
        k = k + 1
    Next
    
    ' Create the map's AnimData. '
    On Error Resume Next
    ReDim AnimData((UBound(MapFeatures)) * 132 - 1)
    If Err Then
        ReDim AnimData(0)
    Else
        For Index = 1 To UBound(MapFeatures)
            For i = 1 To Len(MapFeatures(Index).Name)
                AnimData((Index - 1) * 132 + i + 3) = Asc(Mid(MapFeatures(Index).Name, i, 1))
            Next
        Next
    End If
    On Error GoTo Error
    
    ' Update the header. '
    Header(IDiversion) = 8192
    Header(PTRMapData) = 64
    Header(PTRMapAttr) = 64 + (UBound(MapData) * 2 + 2)
    Header(PTRTileGfx) = Header(PTRMapAttr) + (UBound(HeightData) * 4 + 4)
    Header(PTRTileAnim) = Header(PTRTileGfx) + (UBound(TileData) + 1)
    Header(PTRMiniMap) = Header(PTRTileAnim) + (UBound(AnimData) + 1)
    Header(Tiles) = Int((UBound(TileData) + 1) / 1024)
    Header(TileAnims) = Int((UBound(AnimData) + 1) / 132)
    Header(hBool) = 1
    For Index = 12 To 15
        Header(Index) = 0
    Next

    ' Write the map to disk. '
    FileHandle = FreeFile
    Open Filename For Binary As FileHandle
    
    Put FileHandle, , Header()
    Put FileHandle, , MapLoadData()
    Put FileHandle, , SceneData()
    Put FileHandle, , TileData()
    Put FileHandle, , AnimData()
    Buffer = 252
    Buffer = (Buffer * Buffer) + 8
    ReDim MapBuffer(Buffer - 1)
    Minimap.WriteMinimap MapBuffer(), 0
    Put FileHandle, , MapBuffer()
    
    Close FileHandle
    
    ' Save the OTA map settings. '
    OTASave Left(Filename, Len(Filename) - 3) & "ota"

    Exit Sub
Error:
    MsgBox "There was an error exporting this map: " & Err.Description, vbExclamation, "Export Map"
End Sub

' Save the map. '
Public Sub SaveMap(Optional Filename As String = "", Optional CompressType As Integer = ZLIB_COMPRESSION)
    Dim MapSize As Long
    Dim MapPTR As Long
    Dim Byte1 As Long, Byte2 As Long, Buffer As Long
    Dim Blank As Byte
    Dim i As Long, k As Long
    Dim MapBuffer() As Byte
    Dim MapLoadData() As Integer
    Dim SceneData() As Byte
    Dim AnimData() As Byte
    Dim Index As Long
    Dim FileHandle As Long
    Dim rc As Long
    
    If Region.Usable Then
        rc = MsgBox("You have unpasted sections on your map.  Do you want to paste them now?", vbYesNo + vbQuestion, "Save Map")
        If rc = vbYes Then OverlayPaste
    End If
    
    ' Create an HPI file. '
    On Error GoTo Error
    Screen.MousePointer = vbHourglass
    FrmProgress.Captions "Initializing...", "Saving map"
    FrmProgress.Show , FrmAnnihilator
    DoEvents
    FileHandle = HPICreate(MapFilename & ".ufo", AddressOf HPICallBack)
    If FileHandle = 0 Then Exit Sub
    
    ' Convert the map's MapData. '
    ReDim MapLoadData(UBound(MapData))
    For Index = 0 To UBound(MapData)
        If MapData(Index) > 65536 Then
            MapLoadData(Index) = -32768
        ElseIf (MapData(Index) > 32767) And (MapData(Index) <= 65536) Then
            Buffer = MapData(Index) - 65536
            MapLoadData(Index) = Buffer
        Else
            MapLoadData(Index) = MapData(Index)
        End If
    Next
    
    ' Create the map's SceneData. '
    Blank = 0
    ReDim SceneData(16 * ((Header(MapWidth) / 2) * (Header(MapHeight) / 2)) - 1)
    For i = 0 To UBound(SceneData) Step 4
        Buffer = SceneAttr(k)
        If Buffer < 0 Then Buffer = Buffer + 65536
        Byte1 = Buffer Mod 256
        Byte2 = Int(Buffer / 256)
        SceneData(i) = HeightData(k)
        SceneData(i + 1) = Byte1
        SceneData(i + 2) = Byte2
        SceneData(i + 3) = 0
        k = k + 1
    Next
    
    ' Create the map's AnimData. '
    On Error Resume Next
    ReDim AnimData((UBound(MapFeatures)) * 132 - 1)
    If Err Then
        ReDim AnimData(0)
    Else
        For Index = 1 To UBound(MapFeatures)
            For i = 1 To Len(MapFeatures(Index).Name)
                AnimData((Index - 1) * 132 + i + 3) = Asc(Mid(MapFeatures(Index).Name, i, 1))
            Next
        Next
    End If
    On Error GoTo Error
    
    ' Update the header. '
    Header(IDiversion) = 8192
    Header(PTRMapData) = 64
    Header(PTRMapAttr) = 64 + (UBound(MapData) * 2 + 2)
    Header(PTRTileGfx) = Header(PTRMapAttr) + (UBound(HeightData) * 4 + 4)
    Header(PTRTileAnim) = Header(PTRTileGfx) + (UBound(TileData) + 1)
    Header(PTRMiniMap) = Header(PTRTileAnim) + (UBound(AnimData) + 1)
    Header(Tiles) = Int((UBound(TileData) + 1) / 1024)
    Header(TileAnims) = Int((UBound(AnimData) + 1) / 132)
    Header(hBool) = 1
    For Index = 12 To 15
        Header(Index) = 0
    Next

    ' Calculate the file size of the map. '
    MapSize = UBound(Header) * 4 + 4
    MapSize = MapSize + UBound(TileData) + 1
    MapSize = MapSize + UBound(MapData) * 2 + 2
    MapSize = MapSize + UBound(SceneData) + 1
    MapSize = MapSize + UBound(AnimData) + 1
    Buffer = 252
    MapSize = MapSize + (Buffer * Buffer) + 8 ' Minimap. '

    ' Write the map into a memory block. '
    ReDim MapBuffer(MapSize - 1)
    CopyMemory MapBuffer(0), Header(0), UBound(Header) * 4 + 4
    CopyMemory MapBuffer(Header(PTRMapData)), MapLoadData(0), UBound(MapLoadData) * 2 + 2
    CopyMemory MapBuffer(Header(PTRMapAttr)), SceneData(0), UBound(SceneData) + 1
    CopyMemory MapBuffer(Header(PTRTileGfx)), TileData(0), UBound(TileData) + 1
    CopyMemory MapBuffer(Header(PTRTileAnim)), AnimData(0), UBound(AnimData) + 1
    Minimap.WriteMinimap MapBuffer(), Header(PTRMiniMap)
    MapPTR = VarPtr(MapBuffer(0))
    
    ' Add the OTA to the UFO file. '
    On Error Resume Next
    Kill App.Path & "\temp.ota"
    OTASave App.Path & "\temp.ota"
    rc = HPIAddFile(FileHandle, "maps\" & GetFilename(MapFilename) & ".ota", App.Path & "\temp.ota")
    On Error GoTo Error

    ' Add the TNT to the UFO file. '
    If HPIAddFileFromMemory(FileHandle, "maps\" & GetFilename(MapFilename) & ".tnt", MapPTR, MapSize) = 0 Then
        GoTo Error
    End If
        
    ' Save the map copyright. '
    SaveCopyright FileHandle
    
    ' Save the map in memory to the UFO file. '
    FrmProgress.Captions "Compressing map..."
    DoEvents
    If HPIPackArchive(FileHandle, CompressType) = 0 Then
        GoTo Error
    End If
    
    On Error Resume Next
    Kill App.Path & "\temp.ota"
    Kill App.Path & "\copyright.txt"

    ' Cleanup. '
    Screen.MousePointer = vbNormal
    Unload FrmProgress
    Exit Sub
Error:
    Screen.MousePointer = vbNormal
    Unload FrmProgress
    MsgBox "There was an error saving this map: " & Err.Description & "  If you are low on memory, try freeing some, or exporting this map (File/Export Map) as a straight TNT to save memory.", vbExclamation, "Save Map"
End Sub

Sub SaveCopyright(FileHandle As Long)
    Dim File As Integer, rc As Long
    Dim Buffer As String
    
    Buffer = "Made with Annihilator 1.0" & Chr(13) & Chr(10) & _
                    "Written by Kinboat, 1998" & Chr(13) & Chr(10) & Chr(13) & Chr(10) & _
                    "Questions?  Contact: hotlizard@annihilator.org."
                     
    On Error Resume Next
    File = FreeFile
    Open App.Path & "\copyright.txt" For Binary As File
    Put File, , Buffer
    Close File

    rc = HPIAddFile(FileHandle, "Annihilator.txt", App.Path & "\copyright.txt")
End Sub

' Combine the HeightData and SceneAttr into SceneData and save. '
Sub SaveSceneData(FileHandle As Integer)
    Dim Byte1 As Long, Byte2 As Long, Buffer As Long
    Dim Blank As Byte
    Dim i As Long, k As Long
    Dim SceneData() As Byte
    
    Blank = 0
    ReDim SceneData(16 * ((Header(MapWidth) / 2) * (Header(MapHeight) / 2)) - 1)
    For i = 0 To UBound(SceneData) Step 4
        Buffer = SceneAttr(k)
        If Buffer < 0 Then Buffer = Buffer + 65536
        Byte1 = Buffer Mod 256
        Byte2 = Int(Buffer / 256)
        SceneData(i) = HeightData(k)
        SceneData(i + 1) = Byte1
        SceneData(i + 2) = Byte2
        SceneData(i + 3) = Blank
        k = k + 1
    Next
    
    Put FileHandle, , SceneData()
End Sub

' Save the AnimData for the map. '
Sub SaveAnimData(FileHandle As Integer)
    Dim Index As Long, i As Long
    Dim Buffer As Byte
    Dim AnimData() As Byte
End Sub

' Save the Minimap for the map. '
Sub SaveMiniMap(FileHandle As Integer)
    Dim Pad As Long
    
    Pad = 252
    Put FileHandle, , Pad
    Put FileHandle, , Pad
End Sub

' Load a map's OTA file. '
Sub OTALoad(OTAFileName)
    Dim FileHandle As Integer
    Dim CurrentPlayer As Integer
    Dim Index As Integer
    Dim Buffer As String
    Dim Key As String
    Dim FeatureNames() As String, FeatureXPos() As Long, FeatureZPos() As Long
    Dim FeatureName As String, xPos As Long, zPos As Long
    Dim LoadFeature As Boolean, LoadSpecial As Boolean
    Dim Response As Integer
    
    ReDim FeatureNames(0)
    ReDim FeatureXPos(0)
    ReDim FeatureZPos(0)
    
    If Dir(OTAFileName) = "" Then
        MsgBox "There was no OTA file with map, one will be generated...", vbInformation
        OTADefaults
        Exit Sub
    End If
        
    FileHandle = FreeFile
    Open OTAFileName For Input As FileHandle
    
    ' Get the data from the OTA file. '
    On Error Resume Next
    Do While Not EOF(FileHandle)
        Line Input #FileHandle, Buffer
        Index = InStr(1, Buffer, "=")
        If Index > 0 Then
            Key = Left(Buffer, Index - 1)
            RemoveBlanks Key
            Buffer = Right(Buffer, Len(Buffer) - Index)
            Buffer = Left(Buffer, Len(Buffer) - 1)
            If Buffer <> "" Then
                Select Case LCase(Key)
                    Case "missionname"
                        otaInfo(otaMissionName) = Buffer
                    Case "missiondescription"
                        otaInfo(otaMissionDescription) = Buffer
                    Case "planet"
                        otaInfo(otaPlanet) = Buffer
                    Case "missionhint"
                        otaInfo(otaMissionHint) = Buffer
                    Case "brief"
                        otaInfo(otaBrief) = Buffer
                    Case "narration"
                        otaInfo(otaNarration) = Buffer
                    Case "glamour"
                        otaInfo(otaGlamour) = Buffer
                    Case "lineofsight"
                        otaInfo(otaLineOfSight) = Buffer
                    Case "mapping"
                        otaInfo(otaMapping) = Buffer
                    Case "tidalstrength"
                        otaInfo(otaTidalStrength) = Buffer
                    Case "solarstrength"
                        otaInfo(otaSolarStrength) = Buffer
                    Case "lavaworld"
                        otaInfo(otaLavaWorld) = Buffer
                    Case "killmul"
                        otaInfo(otaKillMul) = Buffer
                    Case "minwindspeed"
                        otaInfo(otaMinWindSpeed) = Buffer
                    Case "maxwindspeed"
                        otaInfo(otaMaxWindSpeed) = Buffer
                    Case "gravity"
                        otaInfo(otaGravity) = Buffer
                    Case "waterdoesdamage"
                        otaInfo(otaWaterDoesDamage) = Buffer
                    Case "waterdamage"
                        otaInfo(otaWaterDamage) = Buffer
                    Case "numplayers"
                        otaInfo(otaNumPlayers) = Buffer
                    Case "memory"
                        otaInfo(otaMemory) = Buffer
                    Case "useonlyunits"
                        otaInfo(otaUseOnlyUnits) = Buffer
                    Case "destroyallunits"
                        otaInfo(otaDestroyAllUnits) = Buffer
                    Case "allunitskilled"
                        otaInfo(otaAllUnitsKilled) = Buffer
                    Case "type"
                        otaInfo(otaType) = Buffer
                    Case "aiprofile"
                        otaInfo(otaAIProfile) = Buffer
                    Case "surfacemetal"
                        otaInfo(otaSurfaceMetal) = Buffer
                    Case "mohometal"
                        otaInfo(otaMohoMetal) = Buffer
                    Case "humanmetal"
                        otaInfo(otaHumanMetal) = Buffer
                    Case "computermetal"
                        otaInfo(otaComputerMetal) = Buffer
                    Case "humanenergy"
                        otaInfo(otaHumanEnergy) = Buffer
                    Case "computerenergy"
                        otaInfo(otaComputerEnergy) = Buffer
                    Case "meteorweapon"
                        otaInfo(otaMeteorWeapon) = Buffer
                    Case "meteorradius"
                        otaInfo(otaMeteorRadius) = Buffer
                    Case "meteordensity"
                        otaInfo(otaMeteorDensity) = Buffer
                    Case "meteorduration"
                        otaInfo(otaMeteorDuration) = Buffer
                    Case "meteorinterval"
                        otaInfo(otaMeteorInterval) = Buffer
                    Case "specialwhat"
                        CurrentPlayer = Val(Right(Buffer, 1))
                        If CurrentPlayer = 0 Then
                            CurrentPlayer = Val(Right(Buffer, 2))
                        End If
                        LoadSpecial = True
                        LoadFeature = False
                    Case "xpos"
                        If LoadSpecial Then
                            If CurrentPlayer <> 0 Then
                                PlayerPosX(CurrentPlayer) = Val(Buffer)
                            End If
                        ElseIf LoadFeature Then
                            xPos = Val(Buffer)
                        End If
                    Case "zpos"
                        If LoadSpecial Then
                            If CurrentPlayer <> 0 Then
                                PlayerPosY(CurrentPlayer) = Val(Buffer)
                            End If
                        ElseIf LoadFeature Then
                            zPos = Val(Buffer)
                            If FeatureName <> "" Then
                                ReDim Preserve FeatureNames(UBound(FeatureNames) + 1)
                                ReDim Preserve FeatureXPos(UBound(FeatureXPos) + 1)
                                ReDim Preserve FeatureZPos(UBound(FeatureZPos) + 1)
                                FeatureNames(UBound(FeatureNames)) = FeatureName
                                FeatureXPos(UBound(FeatureXPos)) = xPos
                                FeatureZPos(UBound(FeatureZPos)) = zPos
                            End If
                            FeatureName = ""
                            xPos = 0
                            zPos = 0
                            LoadFeature = False
                        End If
                    Case "featurename"
                        LoadFeature = True
                        LoadSpecial = False
                        FeatureName = Buffer
                End Select
            End If
        End If
    Loop
    On Error GoTo 0
    Close FileHandle
    
    If UBound(FeatureNames) > 0 Then
        Response = MsgBox("There were " & CStr(UBound(FeatureNames)) & " features found in your map's OTA settings file.  This occurs if your map was saved in Cavedog's map editor.  Do you want to add these features into your map?", vbQuestion + vbYesNo, "Load Map")
        If Response = vbYes Then
            OTAConvertFeatures FeatureNames(), FeatureXPos(), FeatureZPos()
        End If
    End If
End Sub

Public Sub OTAConvertFeatures(FeatureNames() As String, FeatureXPos() As Long, FeatureZPos() As Long)
    Dim Index As Long, i As Long
    Dim Flag As Boolean
    
    On Error Resume Next
    For Index = 1 To UBound(FeatureNames)
        Flag = False
        For i = 1 To UBound(MapFeatures)
            If LCase(FeatureNames(Index)) = LCase(MapFeatures(i).Name) Then
                Flag = True
                Exit For
            End If
        Next
        If Flag Then
            SceneAttr(FeatureXPos(Index) + FeatureZPos(Index) * Header(MapWidth)) = i - 1
        Else
            ReDim Preserve MapFeatures(UBound(MapFeatures) + 1)
            If Not Features.AttachFeature(LCase(FeatureNames(Index)), MapFeatures(UBound(MapFeatures))) Then
                ReDim Preserve MapFeatures(UBound(MapFeatures) - 1)
            Else
                MapFeatures(UBound(MapFeatures)).Holds = MapFeatures(UBound(MapFeatures)).Holds + 1
                MapFeatures(UBound(MapFeatures)).LoadImage
                SceneAttr(FeatureXPos(Index) + FeatureZPos(Index) * Header(MapWidth)) = UBound(MapFeatures) - 1
            End If
        End If
    Next
End Sub

' Save a map's OTA file. '
Public Sub OTASave(OTAFileName)
    Dim FileHandle As Integer
    Dim Index As Integer
    Dim sTab As String * 1
    
    sTab = Chr(9)
    FileHandle = FreeFile
    Open OTAFileName For Output As FileHandle

    Print #FileHandle, "[GlobalHeader]"
    Print #FileHandle, sTab & "{"
    Print #FileHandle, sTab & "missionname=" & otaInfo(otaMissionName) & ";"
    Print #FileHandle, sTab & "missiondescription=" & otaInfo(otaMissionDescription) & ";"
    Print #FileHandle, sTab & "planet=" & otaInfo(otaPlanet) & ";"
    Print #FileHandle, sTab & "missionhint=" & otaInfo(otaMissionHint) & ";"
    Print #FileHandle, sTab & "brief=" & otaInfo(otaBrief) & ";"
    Print #FileHandle, sTab & "narration=" & otaInfo(otaNarration) & ";"
    Print #FileHandle, sTab & "glamour=" & otaInfo(otaGlamour) & ";"
    Print #FileHandle, sTab & "lineofsight=" & otaInfo(otaLineOfSight) & ";"
    Print #FileHandle, sTab & "mapping=" & otaInfo(otaMapping) & ";"
    Print #FileHandle, sTab & "tidalstrength=" & otaInfo(otaTidalStrength) & ";"
    Print #FileHandle, sTab & "solarstrength=" & otaInfo(otaSolarStrength) & ";"
    Print #FileHandle, sTab & "lavaworld=" & otaInfo(otaLavaWorld) & ";"
    Print #FileHandle, sTab & "killmul=" & otaInfo(otaKillMul) & ";"
    Print #FileHandle, sTab & "timemul=" & otaInfo(otaTimeMul) & ";"
    Print #FileHandle, sTab & "minwindspeed=" & otaInfo(otaMinWindSpeed) & ";"
    Print #FileHandle, sTab & "maxwindspeed=" & otaInfo(otaMaxWindSpeed) & ";"
    Print #FileHandle, sTab & "gravity=" & otaInfo(otaGravity) & ";"
    Print #FileHandle, sTab & "waterdoesdamage=" & otaInfo(otaWaterDoesDamage) & ";"
    Print #FileHandle, sTab & "waterdamage=" & otaInfo(otaWaterDamage) & ";"
    Print #FileHandle, sTab & "numplayers=" & otaInfo(otaNumPlayers) & ";"
    otaInfo(otaSize) = CStr(WidthUnit) & " x " & CStr(HeightUnit)
    Print #FileHandle, sTab & "size=" & otaInfo(otaSize) & ";"
    Print #FileHandle, sTab & "memory=" & otaInfo(otaMemory) & ";"
    Print #FileHandle, sTab & "useonlyunits=" & otaInfo(otaUseOnlyUnits) & ";"
    Print #FileHandle, sTab & "DestroyAllUnits=" & otaInfo(otaDestroyAllUnits) & ";"
    Print #FileHandle, sTab & "AllUnitsKilled=" & otaInfo(otaAllUnitsKilled) & ";"

    Print #FileHandle, sTab & "SCHEMACOUNT=1;"
    Print #FileHandle, sTab & "[Schema 0]"
    Print #FileHandle, sTab & sTab & "{"
    Print #FileHandle, sTab & sTab & "Type=" & otaInfo(otaType) & ";"
    Print #FileHandle, sTab & sTab & "aiprofile=" & otaInfo(otaAIProfile) & ";"
    Print #FileHandle, sTab & sTab & "SurfaceMetal=" & otaInfo(otaSurfaceMetal) & ";"
    Print #FileHandle, sTab & sTab & "MohoMetal=" & otaInfo(otaMohoMetal) & ";"
    Print #FileHandle, sTab & sTab & "HumanMetal=" & otaInfo(otaHumanMetal) & ";"
    Print #FileHandle, sTab & sTab & "ComputerMetal=" & otaInfo(otaComputerMetal) & ";"
    Print #FileHandle, sTab & sTab & "HumanEnergy=" & otaInfo(otaHumanEnergy) & ";"
    Print #FileHandle, sTab & sTab & "ComputerEnergy=" & otaInfo(otaComputerEnergy) & ";"
    Print #FileHandle, sTab & sTab & "MeteorWeapon=" & otaInfo(otaMeteorWeapon) & ";"
    Print #FileHandle, sTab & sTab & "MeteorRadius=" & otaInfo(otaMeteorRadius) & ";"
    Print #FileHandle, sTab & sTab & "MeteorDensity=" & otaInfo(otaMeteorDensity) & ";"
    Print #FileHandle, sTab & sTab & "MeteorDuration=" & otaInfo(otaMeteorDuration) & ";"
    Print #FileHandle, sTab & sTab & "MeteorInterval=" & otaInfo(otaMeteorInterval) & ";"
    Print #FileHandle, sTab & sTab & "[specials]"
    Print #FileHandle, sTab & sTab & sTab & "{"
    For Index = 1 To 10
        If PlayerPosX(Index) > 0 And PlayerPosY(Index) > 0 Then
            Print #FileHandle, sTab & sTab & sTab & "[special" & CStr(Index - 1) & "]"
            Print #FileHandle, sTab & sTab & sTab & sTab & "{"
            Print #FileHandle, sTab & sTab & sTab & sTab & "specialwhat=StartPos" & CStr(Index) & ";"
            Print #FileHandle, sTab & sTab & sTab & sTab & "XPos=" & CStr(PlayerPosX(Index)) & ";"
            Print #FileHandle, sTab & sTab & sTab & sTab & "ZPos=" & CStr(PlayerPosY(Index)) & ";"
            Print #FileHandle, sTab & sTab & sTab & sTab & "}"
        End If
    Next
    Print #FileHandle, sTab & sTab & sTab & "}"
    Print #FileHandle, sTab & sTab & "}"
    Print #FileHandle, sTab & "}"
    Close FileHandle
End Sub

Sub OTADefaults()
    Dim Index As Integer

    otaInfo(otaMissionName) = "Untitled Map"
    otaInfo(otaMissionDescription) = CStr(WidthUnit) & " x " & CStr(HeightUnit) & " Map"
    otaInfo(otaAIProfile) = "DEFAULT"
    otaInfo(otaPlanet) = ""
    otaInfo(otaLineOfSight) = "0"
    otaInfo(otaMapping) = "0"
    otaInfo(otaTidalStrength) = "10"
    otaInfo(otaSolarStrength) = "20"
    otaInfo(otaLavaWorld) = "0"
    otaInfo(otaKillMul) = "50"
    otaInfo(otaTimeMul) = "0"
    otaInfo(otaMinWindSpeed) = "0"
    otaInfo(otaMaxWindSpeed) = "3000"
    otaInfo(otaGravity) = "112"
    otaInfo(otaNumPlayers) = "2"
    otaInfo(otaSize) = CStr(WidthUnit) & " x " & CStr(HeightUnit)
    otaInfo(otaMemory) = "16 mb"
    otaInfo(otaDestroyAllUnits) = "1"
    otaInfo(otaAllUnitsKilled) = "1"
    otaInfo(otaType) = "Network 1"
    otaInfo(otaSurfaceMetal) = "3"
    otaInfo(otaMohoMetal) = "30"
    otaInfo(otaHumanMetal) = "1000"
    otaInfo(otaComputerMetal) = "1000"
    otaInfo(otaHumanEnergy) = "1000"
    otaInfo(otaComputerEnergy) = "1000"
End Sub

Public Sub OTAGetSettings(otaCopy() As String)
    Dim Index As Integer
    
    ReDim otaCopy(UBound(otaInfo))
    otaInfo(otaSize) = CStr(WidthUnit) & " x " & CStr(HeightUnit)
    For Index = 0 To UBound(otaInfo)
        otaCopy(Index) = otaInfo(Index)
    Next
End Sub

Public Sub OTASetSettings(otaSet() As String)
    Dim Index As Integer
    
    On Error Resume Next
    For Index = 0 To UBound(otaSet)
        otaInfo(Index) = otaSet(Index)
    Next
End Sub

' Add a feature to the map. '
Public Function FeatureAdd(FeatureIndex As Long) As Integer
    Dim Index As Integer
    Dim Flag As Boolean
    
    Flag = False
    For Index = 0 To UBound(MapFeatures)
        If LCase(MapFeatures(Index).Name) = LCase(SelectedFeatures(FeatureIndex).Name) Then
            Flag = True
            Exit For
        End If
    Next
    If Not Flag Then
        ReDim Preserve MapFeatures(UBound(MapFeatures) + 1)
        Set MapFeatures(UBound(MapFeatures)) = SelectedFeatures(FeatureIndex)
        MapFeatures(UBound(MapFeatures)).LoadImage
        MapFeatures(UBound(MapFeatures)).Holds = MapFeatures(UBound(MapFeatures)).Holds + 1
        Header(TileAnims) = UBound(MapFeatures)
        Index = UBound(MapFeatures)
    End If
    FeatureAdd = Index - 1
End Function

' Remove an animation from the map. '
Public Sub AnimationRemove(ByVal RemoveIndex As Long)
    Dim Index As Long
    
    If UBound(AnimTitles) = 0 Then
        ReDim AnimTitles(0)
        Exit Sub
    End If
    RemoveIndex = RemoveIndex - 1
    For Index = RemoveIndex + 1 To UBound(AnimTitles)
        AnimTitles(Index - 1) = AnimTitles(Index)
    Next
    ReDim Preserve AnimTitles(UBound(AnimTitles) - 1)
    Header(TileAnims) = UBound(AnimTitles)
    For Index = 0 To UBound(SceneAttr)
        If SceneAttr(Index) = RemoveIndex Then
            SceneAttr(Index) = -1
        ElseIf SceneAttr(Index) > RemoveIndex Then
            SceneAttr(Index) = SceneAttr(Index) - 1
        End If
    Next
End Sub

' Get the names of the Animations for this map. '
Sub AnimationsCreateList(AnimData() As Byte)
    Dim position As Long
    Dim Index As Integer
    Dim Buffer As String
    
    ' Get the preliminary anim list. '
    On Error GoTo Error
    ReDim AnimTitles(0)
    If UBound(AnimData) > 0 Then
        For position = 0 To UBound(AnimData) Step 132
            Buffer = ""
            For Index = 0 To 120
                If AnimData(position + Index + 4) = 0 Then Exit For
                Buffer = Buffer & Chr(AnimData(position + Index + 4))
            Next
            If Trim(Buffer) <> "" Then
                ReDim Preserve AnimTitles(UBound(AnimTitles) + 1)
                AnimTitles(UBound(AnimTitles)) = Trim(Buffer)
            End If
        Next
    End If
    
    ReDim SelectedAttr(0)
    MapLoadFeatures
    Exit Sub
    
Error:
    MsgBox "There was an error loading this map's features.", vbInformation, "Load Map"
End Sub

' Check every anim to confirm that it exists. '
Sub AnimationsCleanList()
    Dim Index As Long, i As Long
    Dim Found As Boolean
        
    For Index = UBound(AnimTitles) To 1 Step -1
        Found = False
        For i = 0 To UBound(TAList)
            If LCase(Trim(TAList(i).Feature)) = LCase(AnimTitles(Index)) Then
                Found = True
            End If
        Next
        If Not Found Then ' The anim was not found. '
            ' Remove from the list. '
            AnimationRemove Index
        End If
    Next
End Sub

' Create pointers to the features on this map. '
Sub MapLoadFeatures()
    Dim Index As Long
    
    ReDim MapFeatures(UBound(AnimTitles))
    If UBound(AnimTitles) = 0 Then Exit Sub
    
    For Index = 1 To UBound(AnimTitles)
        If Not Features.AttachFeature(AnimTitles(Index), MapFeatures(Index)) Then
            Set MapFeatures(Index) = New classFeature
            MapFeatures(Index).Initialize
            MapFeatures(Index).Name = AnimTitles(Index)
        End If
        MapFeatures(Index).Holds = MapFeatures(Index).Holds + 1
        MapFeatures(Index).LoadImage
    Next
End Sub

' Initialize new map. '
Sub CreateNewMap(NewMapWidth As Long, NewMapHeight As Long)
    Dim Index As Long
    
    Initialize
    
    ' Create the TileData. '
    ReDim TileData(1023)
    For Index = 0 To 1023
        TileData(Index) = 100
    Next
    Dim AnimTitles(0)
    
    ' Create the header for the map. '
    Header(IDiversion) = 8192
    Header(MapWidth) = NewMapWidth * 2
    Header(MapHeight) = NewMapHeight * 2
    Header(Tiles) = Int((UBound(TileData) + 1) / 1024)
    Header(SeaLevel) = 75
    Header(TileAnims) = 0
    
    ' Create the map data. '
    ReDim MapData((Header(MapWidth) / 2) * (Header(MapHeight) / 2) - 1)
        
    ' Create the scene data. '
    ReDim HeightData(4 * ((Header(MapWidth) / 2) * (Header(MapHeight) / 2)) - 1)
    ReDim Void(4 * ((Header(MapWidth) / 2) * (Header(MapHeight) / 2)) - 1)
    ReDim SceneAttr(4 * ((Header(MapWidth) / 2) * (Header(MapHeight) / 2)) - 1)
    For Index = 0 To UBound(SceneAttr)
        'HeightData(Index) = 76
        SceneAttr(Index) = -1
    Next
    
    ' Create the mini-map. '
    Minimap.HeaderWidth = Header(MapWidth)
    Minimap.HeaderHeight = Header(MapHeight)
    Minimap.MiniMapCalculateDimensions
    Minimap.MiniMapGenerateDraft MapData(), TileData()
    
    ' Create an OTA file. '
    OTADefaults
    'CreateStartingPositions
    MapLoaded = True
    MapChanged = False
    MapFilename = ""
End Sub

' Create random starting positions. '
Sub CreateStartingPositions()
    Dim Index As Integer
    Dim Rand As Long
    Dim Min As Long, MaxX As Long, MaxY As Long
    
    Min = 100
    MaxX = (Header(MapWidth)) * 16 - 100
    MaxY = (Header(MapHeight)) * 16 - 100
    
    Randomize
    For Index = 1 To 10
        Rand = Int((MaxX - Min + 1) * Rnd + Min)
        PlayerPosX(Index) = Rand
        Rand = Int((MaxY - Min + 1) * Rnd + Min)
        PlayerPosY(Index) = Rand
    Next
End Sub

' Create the tile/map data from the specified bitmap. '
Sub CreateNewMapFromBMP()
    Dim Index As Long
    Dim xIndex As Long, yIndex As Long
    Dim TileIndex As Long, position As Long, PositionOffset As Long
    Dim TileX As Long, TileY As Long
    Dim Buffer As Integer
    
    ' Create the header for the map. '
    DoEvents
    Header(IDiversion) = 8192

    ' Create tile data. '
    Header(MapWidth) = Int(modBmp.BitmapInfo.biWidth / 32) * 2
    Header(MapHeight) = Int(modBmp.BitmapInfo.biHeight / 32) * 2
    ReDim TileData((Int(modBmp.BitmapInfo.biWidth / 32) * Int(modBmp.BitmapInfo.biHeight / 32)) * 1024 - 1)
    Header(Tiles) = Int((UBound(TileData) + 1) / 1024)
    Header(SeaLevel) = 75
    CreateTilesFromBmp Bits(0), TileData(0), modBmp.BitmapInfo.biWidth, modBmp.BitmapInfo.biHeight
    Dim AnimTitles(0)
    
    ' Create the map data. '
    ReDim MapData((Header(MapWidth) / 2) * (Header(MapHeight) / 2) - 1)
    For Index = 0 To UBound(MapData)
        MapData(Index) = Index ' Default to first tile in the tile data. '
    Next
        
    ' Create the scene data. '
    ReDim SceneAttr(4 * (Header(MapWidth) / 2) * (Header(MapHeight) / 2) - 1)
    ReDim HeightData(4 * (Header(MapWidth) / 2) * (Header(MapHeight) / 2) - 1)
    ReDim Void(4 * (Header(MapWidth) / 2) * (Header(MapHeight) / 2) - 1)
    For Index = 0 To UBound(SceneAttr)
        HeightData(Index) = 76
        SceneAttr(Index) = -1
        DoEvents
    Next
    
    ' Create the mini-map. '
    Minimap.HeaderWidth = Header(MapWidth)
    Minimap.HeaderHeight = Header(MapHeight)
    Minimap.MiniMapGenerateDraft MapData(), TileData()
    
    ' Create an OTA file. '
    OTADefaults
    CreateStartingPositions
    MapLoaded = True
    MapChanged = False
    MapFilename = ""
End Sub

' Load a heightmap from a bitmap. '
Sub HeightMapImport(Filename As String)
    Dim xIndex As Long, yIndex As Long
    Dim ScenePos As Long, BitmapPos As Long
        
    On Error GoTo Error
    If Filename = "" Then Exit Sub
    If Not LoadBMPFile(Filename) Then
        MsgBox "There was an error loading the height map bitmap " & Filename & ".", vbExclamation, "Error"
        Exit Sub
    End If
    
    If (Header(MapWidth) > modBmp.BitmapInfo.biWidth) Or (Header(MapHeight) > modBmp.BitmapInfo.biHeight) Then
        MsgBox "The height map specified was too small, and could not be loaded."
        Exit Sub
    End If

    For yIndex = 0 To (Header(MapHeight) - 1)
        For xIndex = 0 To (Header(MapWidth) - 1)
            HeightData(ScenePos) = Bits(BitmapPos + xIndex)
            ScenePos = ScenePos + 1
        Next
        BitmapPos = BitmapPos + modBmp.BitmapInfo.biWidth
    Next
    Exit Sub
Error:
    MsgBox "There was an error loading the heightmap you selected.", vbExclamation, "Import Heightmap"
End Sub

' Export a BMP file for the map. '
Public Sub ExportMapAsBMP(Filename As String)
    Dim MapBits() As Byte
    Dim IndexX As Long, IndexY As Long
    Dim xPos As Long, yPos As Long
    Dim MapIndex As Long
    
    On Error GoTo Error
    
    Screen.MousePointer = vbHourglass
    FrmProgress.ShowCancel = True
    FrmProgress.Captions "Creating BMP file...", "Exporting map"
    FrmProgress.Show , FrmAnnihilator
    DoEvents
    
    ReDim MapBits((UBound(MapData) + 1) * 1024 - 1)
    For IndexY = 0 To Header(MapHeight) / 2 - 1
        FrmProgress.Update IndexY, Header(MapHeight) / 2 - 1
        For IndexX = 0 To Header(MapWidth) / 2 - 1
            For yPos = 0 To 31
                For xPos = 0 To 31
                    MapBits((Header(MapHeight) * 16 - 1 - (IndexY + 1) * 32 + (32 - yPos)) * (Header(MapWidth) * 16) + IndexX * 32 + xPos) = TileData(MapData(MapIndex) * 1024 + yPos * 32 + xPos)
                Next
            Next
            MapIndex = MapIndex + 1
        Next
        DoEvents
        If FrmProgress.Canceled Then
            Unload FrmProgress
            Screen.MousePointer = vbNormal
            Exit Sub
        End If
    Next
    
    SaveBMPFile Filename, MapBits(), TAPalette(), Header(MapWidth) * 16, Header(MapHeight) * 16, False
    Unload FrmProgress
    Screen.MousePointer = vbNormal
    Exit Sub
Error:
    Unload FrmProgress
    Screen.MousePointer = vbNormal
    MsgBox "There was an error exporting this map: " & Err.Description, vbExclamation, "Export Map as BMP"
End Sub

' Return the size of the saved map. '
Function MapFileSize() As Single
    Dim MapSize As Single

    MapSize = (UBound(MapData) + 1) * 4
    MapSize = MapSize + UBound(TileData) + 1
    MapSize = MapSize + (UBound(HeightData) + 1) * 4
    MapSize = CInt(MapSize / 1024) / 1024
    MapFileSize = MapSize
End Function

Function MapTextureSize() As Single
    MapTextureSize = CInt((UBound(TileData) + 1) / 1024) / 1024
End Function

Sub MapInitialize()
    Dim Index As Long
    
    ' Initialize. '
    With FrmAnnihilator
    .Status.Panels(1).Text = "Initializing map..."
    
    ' Create the tile checksum list. '
    ReDim TileList(Int((UBound(TileData) + 1) / 1024) - 1)
    Index = UBound(TileList)
    CreateTileChecksumList TileData(0), TileList(0), Index
    
    ' Update the Sealevel slider. '
    SelectedTile = 0
    DrawSeaLevel
    
    ' Show the mini-map. '
    Minimap.MiniMapUpdateView 0, 0
    End With
End Sub

' Draw the map. '
Sub DrawMap()
    On Error GoTo Error
    
    If Region.Usable And Overlay.RegionTiles Then
        DrawTiles
        Overlay.DrawTiles Region.Left, Region.Top, ViewX, ViewY, Header(MapWidth), Header(MapHeight)
    Else
        DrawTiles
    End If
    If OverHeight Then
        If Region.Usable And Overlay.RegionHeight Then
            DrawOverHeight
        Else
            DrawHeight
        End If
    ElseIf OverContour Then
        If Region.Usable And Overlay.RegionHeight Then
            DrawOverHeightMesh
        Else
            DrawHeightMesh
        End If
    ElseIf OverGrid Then
        DrawGrid
    End If
    If OverFeatures Or SelectedTool = ToolFeatures Then
        DrawFeatures
    End If
    If OverSpecials Or SelectedTool = ToolSpecial Then
        DrawStartingLocations
    End If
    
    ' Refresh the view. '
    With FrmAnnihilator
    Screens(Canvas).Show .Canvas.hdc, 0, 0, .Canvas.ScaleWidth, .Canvas.ScaleHeight, 0, 0
    .Canvas.Refresh
    'MiniMapRefresh
    DrawBounds
    End With
    Exit Sub
    
Error:
    MsgBox "Runtime Error: " & Trim$(Str$(Err.Number)) & ".  There was an error displaying the map.", vbExclamation, "Draw map"
End Sub

' Draw the map's bounds. '
Sub DrawBounds()
    If (Header(MapWidth) * 16 - 32) - ViewX * 32 <= FrmAnnihilator.Canvas.ScaleWidth Then
        FrmAnnihilator.Canvas.DrawMode = 7
        FrmAnnihilator.Canvas.DrawStyle = 0
        FrmAnnihilator.Canvas.Line ((Header(MapWidth) * 16 - 32) - ViewX * 32, 0)-((Header(MapWidth) * 16 - 32) - ViewX * 32, Header(MapHeight) * 16 - ViewY * 32), RGB(0, 255, 0)
        FrmAnnihilator.Canvas.DrawMode = 13
        FrmAnnihilator.Canvas.DrawStyle = 1
        FrmAnnihilator.Canvas.Line ((Header(MapWidth) * 16 - 32) - ViewX * 32, 0)-((Header(MapWidth) * 16 - 32) - ViewX * 32, Header(MapHeight) * 16 - ViewY * 32), RGB(255, 255, 255)
    End If
    If (Header(MapHeight) * 16 - 128) - ViewY * 32 <= FrmAnnihilator.Canvas.ScaleHeight Then
        FrmAnnihilator.Canvas.DrawMode = 7
        FrmAnnihilator.Canvas.DrawStyle = 0
        FrmAnnihilator.Canvas.Line (0, (Header(MapHeight) * 16 - 128) - ViewY * 32)-(Header(MapWidth) * 16 - ViewX * 32, (Header(MapHeight) * 16 - 128) - ViewY * 32), RGB(0, 255, 0)
        FrmAnnihilator.Canvas.DrawMode = 13
        FrmAnnihilator.Canvas.DrawStyle = 1
        FrmAnnihilator.Canvas.Line (0, (Header(MapHeight) * 16 - 128) - ViewY * 32)-(Header(MapWidth) * 16 - ViewX * 32, (Header(MapHeight) * 16 - 128) - ViewY * 32), RGB(255, 255, 255)
    End If
    FrmAnnihilator.Canvas.DrawStyle = 0
End Sub

' Draw the grid on the map. '
Sub DrawGrid()
    Dim IndexX As Integer, IndexY As Integer
    Dim StartX As Integer, StartY As Integer
    Dim ViewWidth As Integer, ViewHeight As Integer
    
    ViewWidth = FrmAnnihilator.Canvas.ScaleWidth
    ViewHeight = FrmAnnihilator.Canvas.ScaleHeight
    If ViewWidth > Header(MapWidth) * 16 Then ViewWidth = Header(MapWidth) * 16
    If ViewHeight > Header(MapHeight) * 16 Then ViewHeight = Header(MapHeight) * 16
    StartX = GridSizeX * Int((ViewX * 32) / GridSizeX) - (ViewX * 32)
    StartY = GridSizeY * Int((ViewY * 32) / GridSizeY) - (ViewY * 32)
    
    For IndexY = StartY To ViewHeight Step GridSizeY
        Screens(Canvas).LineDraw 0, IndexY, ViewWidth, IndexY, 255
    Next
    For IndexX = StartX To ViewWidth Step GridSizeX
        Screens(Canvas).LineDraw IndexX, 0, IndexX, ViewHeight, 255
    Next
End Sub

' Show the animations on the screen. '
Sub DrawFeatures()
    Dim MapPosition As Long, Index As Long
    Dim IndexX As Long, IndexY As Long
    Dim ViewWidth As Long, ViewHeight As Long
    Dim NewX As Long, NewY As Long
    Dim rc As Long
    Dim i As Integer, Flag As Boolean
    
    On Error GoTo Error
    ViewWidth = Int(FrmAnnihilator.Canvas.ScaleWidth / 16)
    ViewHeight = Int(FrmAnnihilator.Canvas.ScaleHeight / 16)
    MapPosition = GetMapAttrIndex(ViewX * 32, ViewY * 32)

    For IndexY = 0 To (ViewHeight - 1) + 8
        If (IndexY + ViewY * 2) >= Header(MapHeight) Then Exit For
        For IndexX = 0 To (ViewWidth - 1) + 1
            If (IndexX + ViewX * 2) >= Header(MapWidth) Then Exit For
            Index = MapPosition + IndexX
            If SceneAttr(Index) > -1 Then
                Flag = False
                For i = 1 To UBound(SelectedAttr)
                    If Index = SelectedAttr(i) Then
                        Flag = True
                        Exit For
                    End If
                Next
                MapFeatures(SceneAttr(Index) + 1).DrawMapFeature IndexX * 16 - MapFeatures(SceneAttr(Index) + 1).PositionX + MapFeatures(SceneAttr(Index) + 1).FootprintX * 8, IndexY * 16 - CInt(GetHeight(Index) / 2) - MapFeatures(SceneAttr(Index) + 1).PositionY + MapFeatures(SceneAttr(Index) + 1).FootprintY * 8, Flag
            End If
        Next
        MapPosition = MapPosition + Header(MapWidth)
    Next

Error:
End Sub

' Draw the height overlay map to the screen. '
Sub DrawHeight()
    Dim MapPosition As Long
    Dim IndexX As Long, IndexY As Long
    Dim ViewWidth As Long, ViewHeight As Long
    Dim yPos As Long
    Dim y1 As Long, y2 As Long
    Dim NewX As Long, NewY As Long
    Dim Height As Byte
    Dim WaterColor As Byte, LandColor As Byte
    
    On Error GoTo Error
    With FrmAnnihilator
    ViewWidth = Int(.Canvas.ScaleWidth / 16)
    ViewHeight = Int(.Canvas.ScaleHeight / 16)
    MapPosition = GetMapAttrIndex(ViewX * 32, ViewY * 32)
    
    yPos = 0
    For IndexY = 0 To (ViewHeight + 8)
        If (IndexY + ViewY * 2) >= Header(MapHeight) Then Exit For
        For IndexX = 0 To (ViewWidth + 1)
            If (IndexX + ViewX * 2) >= Header(MapWidth) Then Exit For
            Height = HeightData(MapPosition + IndexX)
            y1 = CInt(yPos - (HeightData(MapPosition + IndexX) / 2))
            
            WaterColor = 0
            LandColor = 0
            If Height < Header(SeaLevel) And Header(SeaLevel) > 0 Then
                WaterColor = Int((Height * UBound(HeightWater)) / Header(SeaLevel))
            End If
            If Height >= Header(SeaLevel) Then
                LandColor = Int(((Height - Header(SeaLevel)) * UBound(HeightLand)) / (255 - Header(SeaLevel)))
            End If
            If HeightSwitchColors Then
                WaterColor = HeightLand(9 - WaterColor)
                LandColor = HeightWater(9 - LandColor)
            Else
                WaterColor = HeightWater(WaterColor)
                LandColor = HeightLand(LandColor)
            End If
            
            If (IndexX + ViewX * 2 + 1) < Header(MapWidth) Then
                y2 = CInt(yPos - (HeightData(MapPosition + 1 + IndexX) / 2))
                If SceneAttr(MapPosition + IndexX) = -4 Then
                    Screens(Canvas).LineDraw IndexX * 16, y1, IndexX * 16 + 16, y2, 249
                ElseIf Height < Header(SeaLevel) Then
                    Screens(Canvas).LineDraw IndexX * 16, y1, IndexX * 16 + 16, y2, WaterColor
                Else
                    Screens(Canvas).LineDraw IndexX * 16, y1, IndexX * 16 + 16, y2, LandColor
                End If
            End If
            If MapPosition + Header(MapWidth) + IndexX <= UBound(HeightData) Then
                y2 = CInt(yPos + 16 - (HeightData(MapPosition + Header(MapWidth) + IndexX) / 2))
                If SceneAttr(MapPosition + IndexX) = -4 Then
                    Screens(Canvas).LineDraw IndexX * 16, y1, IndexX * 16, y2, 249
                ElseIf Height < Header(SeaLevel) Then
                    Screens(Canvas).LineDraw IndexX * 16, y1, IndexX * 16, y2, WaterColor
                Else
                    Screens(Canvas).LineDraw IndexX * 16, y1, IndexX * 16, y2, LandColor
                End If
            End If
        Next
        yPos = yPos + 16
        MapPosition = MapPosition + Header(MapWidth)
    Next
    
    End With
    Exit Sub
Error:
    MsgBox "Height draw: " & Err.Number
    Resume Next
End Sub

Sub DrawOverHeight()
    Dim MapPosition As Long
    Dim IndexX As Long, IndexY As Long
    Dim ViewWidth As Long, ViewHeight As Long
    Dim yPos As Long
    Dim y1 As Long, y2 As Long
    Dim NewX As Long, NewY As Long
    Dim Height As Byte
    Dim WaterColor As Byte, LandColor As Byte
    
    On Error GoTo Error
    With FrmAnnihilator
    ViewWidth = Int(.Canvas.ScaleWidth / 16)
    ViewHeight = Int(.Canvas.ScaleHeight / 16)
    MapPosition = GetMapAttrIndex(ViewX * 32, ViewY * 32)
    
    yPos = 0
    For IndexY = 0 To (ViewHeight + 8)
        If (IndexY + ViewY * 2) >= Header(MapHeight) Then Exit For
        For IndexX = 0 To (ViewWidth + 1)
            If (IndexX + ViewX * 2) >= Header(MapWidth) Then Exit For
            Height = GetHeight(MapPosition + IndexX)
            y1 = CInt(yPos - Height / 2)
            
            WaterColor = 0
            LandColor = 0
            If Height < Header(SeaLevel) And Header(SeaLevel) > 0 Then
                WaterColor = Int((Height * UBound(HeightWater)) / Header(SeaLevel))
            End If
            If Height >= Header(SeaLevel) Then
                LandColor = Int(((Height - Header(SeaLevel)) * UBound(HeightLand)) / (255 - Header(SeaLevel)))
            End If
            If HeightSwitchColors Then
                WaterColor = HeightLand(9 - WaterColor)
                LandColor = HeightWater(9 - LandColor)
            Else
                WaterColor = HeightWater(WaterColor)
                LandColor = HeightLand(LandColor)
            End If
            
            If (IndexX + ViewX * 2 + 1) < Header(MapWidth) Then
                y2 = CInt(yPos - GetHeight(MapPosition + IndexX + 1) / 2)
                If SceneAttr(MapPosition + IndexX) = -4 Then
                    Screens(Canvas).LineDraw IndexX * 16, y1, IndexX * 16 + 16, y2, 249
                ElseIf Height < Header(SeaLevel) Then
                    Screens(Canvas).LineDraw IndexX * 16, y1, IndexX * 16 + 16, y2, WaterColor
                Else
                    Screens(Canvas).LineDraw IndexX * 16, y1, IndexX * 16 + 16, y2, LandColor
                End If
            End If
            If MapPosition + Header(MapWidth) + IndexX <= UBound(HeightData) Then
                y2 = CInt(yPos + 16 - GetHeight(MapPosition + IndexX + Header(MapWidth)) / 2)
                If SceneAttr(MapPosition + IndexX) = -4 Then
                    Screens(Canvas).LineDraw IndexX * 16, y1, IndexX * 16, y2, 249
                ElseIf Height < Header(SeaLevel) Then
                    Screens(Canvas).LineDraw IndexX * 16, y1, IndexX * 16, y2, WaterColor
                Else
                    Screens(Canvas).LineDraw IndexX * 16, y1, IndexX * 16, y2, LandColor
                End If
            End If
        Next
        yPos = yPos + 16
        MapPosition = MapPosition + Header(MapWidth)
    Next
    
    End With
    Exit Sub
Error:
    Resume Next
End Sub

' Draw the height mesh to the screen. '
Sub DrawHeightMesh()
On Error GoTo Error
    Dim ari As Integer
    
    Dim MapPosition As Long
    Dim ViewWidth As Long, ViewHeight As Long
    Dim NewX As Long, NewY As Long
    
    Dim UL As Byte, UR As Byte, DL As Byte, DR As Byte ' Height data for tile. '
    Dim x As Integer, y As Integer
    Dim xx As Integer, yy As Integer
    Dim V As Single
    Dim S As Single
    Dim a(255) As MeshRecord
    Dim C As Byte
    Dim Spot As Byte ' POINTER ^ '
    Dim BB As Byte ' Mesh interval. '
    Dim CC As Byte ' Red line. '
    Dim WaterColor As Byte, LandColor As Byte
    
    ' Default mesh interval, red line. '
    BB = HeightMeshInterval
    CC = Header(SeaLevel)
    ViewWidth = Int(FrmAnnihilator.Canvas.ScaleWidth / 16)
    ViewHeight = Int(FrmAnnihilator.Canvas.ScaleHeight / 16)
    NewX = ViewX
    NewY = ViewY
    MapPosition = GetMapAttrIndex(NewX * 32, NewY * 32)

    For yy = 0 To (ViewHeight + 8)
        If ViewY * 2 + yy + 1 >= Header(MapHeight) Then Exit For
        'If MapPosition > UBound(HeightData) Then Exit For
        For xx = 0 To (ViewWidth + 2)
            If ViewX * 2 + xx + 1 >= Header(MapWidth) Then Exit For
            'If MapPosition > UBound(HeightData) Then Exit For
                    UL = HeightData(MapPosition + xx)
                    UR = HeightData(MapPosition + xx + 1)
                    DL = HeightData((MapPosition + xx) + (Header(MapWidth)))
                    DR = HeightData((MapPosition + xx) + (Header(MapWidth) + 1))
                    
                    C = 0
                    If UL > UR Then
                        V = 16 / (UL - UR)
                        For x = UR To UL - 1
                            If ((x Mod BB) = 0) Or (x = CC) Then
                                a(C).x = Int((UL - x) * V)
                                a(C).y = 0
                                a(C).V = x
                                a(C).E = (V > 0)
                                C = C + 1
                            End If
                        Next
                    End If
                    If UR > UL Then
                        V = 16 / (UR - UL)
                        For x = UL To UR - 1
                            If ((x Mod BB) = 0) Or (x = CC) Then
                                a(C).x = Int((x - UL) * V)
                                a(C).y = 0
                                a(C).V = x
                                a(C).E = (V < 0)
                                C = C + 1
                            End If
                        Next
                    End If
                    
                    If DR > UR Then
                        V = 16 / (DR - UR)
                        For x = UR To DR - 1
                            If ((x Mod BB) = 0) Or (x = CC) Then
                                a(C).x = 16
                                a(C).y = Int((x - UR) * V)
                                a(C).V = x
                                a(C).E = (V < 0)
                                C = C + 1
                            End If
                        Next
                    End If
                    If UR > DR Then
                        V = 16 / (UR - DR)
                        For x = DR To UR - 1
                            If ((x Mod BB) = 0) Or (x = CC) Then
                                a(C).x = 16
                                a(C).y = Int((UR - x) * V)
                                a(C).V = x
                                a(C).E = (V > 0)
                                C = C + 1
                            End If
                        Next
                    End If
                    
                    If DL > DR Then
                        V = 16 / (DL - DR)
                        For x = DR To DL - 1
                            If ((x Mod BB) = 0) Or (x = CC) Then
                                a(C).x = Int((DL - x) * V)
                                a(C).y = 16
                                a(C).V = x
                                a(C).E = (V < 0)
                                C = C + 1
                            End If
                        Next
                    End If
                    If DR > DL Then
                        V = 16 / (DR - DL)
                        For x = DL To DR - 1
                            If ((x Mod BB) = 0) Or (x = CC) Then
                                a(C).x = Int((x - DL) * V)
                                a(C).y = 16
                                a(C).V = x
                                a(C).E = (V > 0)
                                C = C + 1
                            End If
                        Next
                    End If
    
                    If DL > UL Then
                        V = 16 / (DL - UL)
                        For x = UL To DL - 1
                            If ((x Mod BB) = 0) Or (x = CC) Then
                                a(C).x = 0
                                a(C).y = Int((x - UL) * V)
                                a(C).V = x
                                a(C).E = (V > 0)
                                C = C + 1
                            End If
                        Next
                    End If
                    If UL > DL Then
                        V = 16 / (UL - DL)
                        For x = DL To UL - 1
                            If ((x Mod BB) = 0) Or (x = CC) Then
                                a(C).x = 0
                                a(C).y = Int((UL - x) * V)
                                a(C).V = x
                                a(C).E = (V < 0)
                                C = C + 1
                            End If
                        Next
                    End If
    
                    For x = 0 To C - 1
                        For y = x + 1 To C - 1
                            If (a(x).V = a(y).V) And (a(x).E <> a(y).E) Then
                                If CC = a(x).V Then
                                    'FrmAnnihilator.Canvas.Line ((CInt(xx * 16) + a(x).x), (CInt(yy * 16) + a(x).y - Int(a(x).V / 2)))-((CInt(xx * 16) + a(y).x), (CInt(yy * 16) + a(y).y - Int(a(y).V / 2))), RGB(255, 0, 0) ', HeightWaterColor, bmpWidth, bmpHeight, addrView
                                    Screens(Canvas).LineDraw (CInt(xx * 16) + a(x).x), (CInt(yy * 16) + a(x).y - Int(a(x).V / 2)), (CInt(xx * 16) + a(y).x), (CInt(yy * 16) + a(y).y - Int(a(y).V / 2)), 211
                                Else
                                    WaterColor = Int((a(x).V * 9) / Header(SeaLevel))
                                    LandColor = Int(((a(x).V - Header(SeaLevel)) * 9) / (255 - Header(SeaLevel)))
                                    If a(x).V <= Header(SeaLevel) Then
                                        'FrmAnnihilator.Canvas.Line ((CInt(xx * 16) + a(x).x), (CInt(yy * 16) + a(x).y - Int(a(x).V / 2)))-((CInt(xx * 16) + a(y).x), (CInt(yy * 16) + a(y).y - Int(a(y).V / 2))), RGB(128 + Int((a(x).V * 127) / 255), 128 + Int((a(x).V * 127) / 255), 128 + Int((a(x).V * 127) / 255)) ', HeightWaterColor, bmpWidth, bmpHeight, addrView
                                        Screens(Canvas).LineDraw (CInt(xx * 16) + a(x).x), (CInt(yy * 16) + a(x).y - Int(a(x).V / 2)), (CInt(xx * 16) + a(y).x), (CInt(yy * 16) + a(y).y - Int(a(y).V / 2)), HeightWater(WaterColor)
                                    Else
                                        'FrmAnnihilator.Canvas.Line ((CInt(xx * 16) + a(x).x), (CInt(yy * 16) + a(x).y - Int(a(x).V / 2)))-((CInt(xx * 16) + a(y).x), (CInt(yy * 16) + a(y).y - Int(a(y).V / 2))), RGB(0, 0, 128 + Int((a(x).V * 127) / 255)) ', HeightWaterColor, bmpWidth, bmpHeight, addrView
                                        Screens(Canvas).LineDraw (CInt(xx * 16) + a(x).x), (CInt(yy * 16) + a(x).y - Int(a(x).V / 2)), (CInt(xx * 16) + a(y).x), (CInt(yy * 16) + a(y).y - Int(a(y).V / 2)), HeightLand(LandColor)
                                    End If
                                End If
                            End If
                        Next
                    Next
            Next
        MapPosition = MapPosition + Header(MapWidth)
        If MapPosition < 0 Then Exit For
    Next
    Exit Sub
    
Error:
    Resume Next
End Sub

Sub DrawOverHeightMesh()
On Error GoTo Error
    Dim ari As Integer
    
    Dim MapPosition As Long
    Dim ViewWidth As Long, ViewHeight As Long
    Dim NewX As Long, NewY As Long
    
    Dim UL As Byte, UR As Byte, DL As Byte, DR As Byte ' Height data for tile. '
    Dim x As Integer, y As Integer
    Dim xx As Integer, yy As Integer
    Dim V As Single
    Dim S As Single
    Dim a(255) As MeshRecord
    Dim C As Byte
    Dim Spot As Byte ' POINTER ^ '
    Dim BB As Byte ' Mesh interval. '
    Dim CC As Byte ' Red line. '
    Dim WaterColor As Byte, LandColor As Byte
    
    ' Default mesh interval, red line. '
    BB = HeightMeshInterval
    CC = Header(SeaLevel)
    ViewWidth = Int(FrmAnnihilator.Canvas.ScaleWidth / 16)
    ViewHeight = Int(FrmAnnihilator.Canvas.ScaleHeight / 16)
    NewX = ViewX
    NewY = ViewY
    MapPosition = GetMapAttrIndex(NewX * 32, NewY * 32)

    For yy = 0 To (ViewHeight + 4)
        If ViewY * 2 + yy + 1 >= Header(MapHeight) Then Exit For
        'If MapPosition > UBound(HeightData) Then Exit For
        For xx = 0 To (ViewWidth + 2)
            If ViewX * 2 + xx + 1 >= Header(MapWidth) Then Exit For
            'If (IndexX + ViewX * 2) >= Header(MapWidth) Then Exit For
            'If MapPosition > UBound(HeightData) Then Exit For
                    UL = GetHeight(MapPosition + xx) 'HeightData(MapPosition + xx)
                    UR = GetHeight(MapPosition + xx + 1) 'HeightData(MapPosition + xx + 1)
                    DL = GetHeight(MapPosition + xx + Header(MapWidth)) 'HeightData((MapPosition + xx) + (Header(MapWidth)))
                    DR = GetHeight(MapPosition + xx + Header(MapWidth) + 1) 'HeightData((MapPosition + xx) + (Header(MapWidth) + 1))
                    
                    C = 0
                    If UL > UR Then
                        V = 16 / (UL - UR)
                        For x = UR To UL - 1
                            If ((x Mod BB) = 0) Or (x = CC) Then
                                a(C).x = Int((UL - x) * V)
                                a(C).y = 0
                                a(C).V = x
                                a(C).E = (V > 0)
                                C = C + 1
                            End If
                        Next
                    End If
                    If UR > UL Then
                        V = 16 / (UR - UL)
                        For x = UL To UR - 1
                            If ((x Mod BB) = 0) Or (x = CC) Then
                                a(C).x = Int((x - UL) * V)
                                a(C).y = 0
                                a(C).V = x
                                a(C).E = (V < 0)
                                C = C + 1
                            End If
                        Next
                    End If
                    
                    If DR > UR Then
                        V = 16 / (DR - UR)
                        For x = UR To DR - 1
                            If ((x Mod BB) = 0) Or (x = CC) Then
                                a(C).x = 16
                                a(C).y = Int((x - UR) * V)
                                a(C).V = x
                                a(C).E = (V < 0)
                                C = C + 1
                            End If
                        Next
                    End If
                    If UR > DR Then
                        V = 16 / (UR - DR)
                        For x = DR To UR - 1
                            If ((x Mod BB) = 0) Or (x = CC) Then
                                a(C).x = 16
                                a(C).y = Int((UR - x) * V)
                                a(C).V = x
                                a(C).E = (V > 0)
                                C = C + 1
                            End If
                        Next
                    End If
                    
                    If DL > DR Then
                        V = 16 / (DL - DR)
                        For x = DR To DL - 1
                            If ((x Mod BB) = 0) Or (x = CC) Then
                                a(C).x = Int((DL - x) * V)
                                a(C).y = 16
                                a(C).V = x
                                a(C).E = (V < 0)
                                C = C + 1
                            End If
                        Next
                    End If
                    If DR > DL Then
                        V = 16 / (DR - DL)
                        For x = DL To DR - 1
                            If ((x Mod BB) = 0) Or (x = CC) Then
                                a(C).x = Int((x - DL) * V)
                                a(C).y = 16
                                a(C).V = x
                                a(C).E = (V > 0)
                                C = C + 1
                            End If
                        Next
                    End If
    
                    If DL > UL Then
                        V = 16 / (DL - UL)
                        For x = UL To DL - 1
                            If ((x Mod BB) = 0) Or (x = CC) Then
                                a(C).x = 0
                                a(C).y = Int((x - UL) * V)
                                a(C).V = x
                                a(C).E = (V > 0)
                                C = C + 1
                            End If
                        Next
                    End If
                    If UL > DL Then
                        V = 16 / (UL - DL)
                        For x = DL To UL - 1
                            If ((x Mod BB) = 0) Or (x = CC) Then
                                a(C).x = 0
                                a(C).y = Int((UL - x) * V)
                                a(C).V = x
                                a(C).E = (V < 0)
                                C = C + 1
                            End If
                        Next
                    End If
    
                    For x = 0 To C - 1
                        For y = x + 1 To C - 1
                            If (a(x).V = a(y).V) And (a(x).E <> a(y).E) Then
                                If CC = a(x).V Then
                                    'FrmAnnihilator.Canvas.Line ((CInt(xx * 16) + a(x).x), (CInt(yy * 16) + a(x).y - Int(a(x).V / 2)))-((CInt(xx * 16) + a(y).x), (CInt(yy * 16) + a(y).y - Int(a(y).V / 2))), RGB(255, 0, 0) ', HeightWaterColor, bmpWidth, bmpHeight, addrView
                                    Screens(Canvas).LineDraw (CInt(xx * 16) + a(x).x), (CInt(yy * 16) + a(x).y - Int(a(x).V / 2)), (CInt(xx * 16) + a(y).x), (CInt(yy * 16) + a(y).y - Int(a(y).V / 2)), 211
                                Else
                                    WaterColor = Int((a(x).V * 9) / Header(SeaLevel))
                                    LandColor = Int(((a(x).V - Header(SeaLevel)) * 9) / (255 - Header(SeaLevel)))
                                    If a(x).V <= Header(SeaLevel) Then
                                        'FrmAnnihilator.Canvas.Line ((CInt(xx * 16) + a(x).x), (CInt(yy * 16) + a(x).y - Int(a(x).V / 2)))-((CInt(xx * 16) + a(y).x), (CInt(yy * 16) + a(y).y - Int(a(y).V / 2))), RGB(128 + Int((a(x).V * 127) / 255), 128 + Int((a(x).V * 127) / 255), 128 + Int((a(x).V * 127) / 255)) ', HeightWaterColor, bmpWidth, bmpHeight, addrView
                                        Screens(Canvas).LineDraw (CInt(xx * 16) + a(x).x), (CInt(yy * 16) + a(x).y - Int(a(x).V / 2)), (CInt(xx * 16) + a(y).x), (CInt(yy * 16) + a(y).y - Int(a(y).V / 2)), HeightWater(WaterColor)
                                    Else
                                        'FrmAnnihilator.Canvas.Line ((CInt(xx * 16) + a(x).x), (CInt(yy * 16) + a(x).y - Int(a(x).V / 2)))-((CInt(xx * 16) + a(y).x), (CInt(yy * 16) + a(y).y - Int(a(y).V / 2))), RGB(0, 0, 128 + Int((a(x).V * 127) / 255)) ', HeightWaterColor, bmpWidth, bmpHeight, addrView
                                        Screens(Canvas).LineDraw (CInt(xx * 16) + a(x).x), (CInt(yy * 16) + a(x).y - Int(a(x).V / 2)), (CInt(xx * 16) + a(y).x), (CInt(yy * 16) + a(y).y - Int(a(y).V / 2)), HeightLand(LandColor)
                                    End If
                                End If
                            End If
                        Next
                    Next
            Next
        MapPosition = MapPosition + Header(MapWidth)
        If MapPosition < 0 Then Exit For
    Next
    Exit Sub
    
Error:
    Resume Next
End Sub

Sub DrawTiles()
    Dim MapPosition As Long
    Dim IndexX As Long, IndexY As Long
    Dim ViewWidth As Long, ViewHeight As Long
    Dim BlankTile(1023) As Byte
    
    On Error Resume Next
    ViewWidth = Int(FrmAnnihilator.Canvas.ScaleWidth / 32) + 1
    ViewHeight = Int(FrmAnnihilator.Canvas.ScaleHeight / 32) + 1
    
    MapPosition = GetMapIndex(ViewX * 32, ViewY * 32)
    If MapPosition = -1 Then MapPosition = 0
    
    ' Draw the map. '
    For IndexY = 0 To (ViewHeight - 1)
        For IndexX = 0 To (ViewWidth - 1)
            If (ViewX + IndexX < Header(MapWidth) / 2) And (ViewY + IndexY < Header(MapHeight) / 2) Then
                Screens(Canvas).TileDraw IndexX * 32, IndexY * 32, 32, 32, TileData(), MapData(MapPosition + IndexX) * 1024
            Else
                Screens(Canvas).TileDraw IndexX * 32, IndexY * 32, 32, 32, WhiteTile()
            End If
        Next
        MapPosition = MapPosition + (Header(MapWidth) / 2)
    Next
End Sub

Sub DrawStartingLocations()
    Dim MinX As Long, MinY As Long, MaxX As Long, MaxY As Long
    Dim Index As Integer
    
    MinX = ViewX * 32
    MinY = ViewY * 32
    MaxX = MinX + FrmAnnihilator.Canvas.ScaleWidth
    MaxY = MinY + FrmAnnihilator.Canvas.ScaleHeight
    For Index = 1 To UBound(Players)
        If (PlayerPosX(Index) > MinX) And (PlayerPosY(Index) > MinY) And (PlayerPosX(Index) < MaxX) And (PlayerPosY(Index) < MaxY) Then ' Draw the starting location tile. '
            Screens(Canvas).MaskTileDraw PlayerPosX(Index) - (ViewX * 32) - 16, PlayerPosY(Index) - (ViewY * 32) - 16, 32, 32, StartingTile(), 255, Players(Index)
        End If
    Next
    MiniMapRefresh
End Sub

Public Sub DrawSeaLevel()
    Dim Index As Long
    Dim Step As Single, PosStep As Single
    Dim Value As Single, position As Single
    
    With FrmAnnihilator
    .SliderSeaLevel.Value = Header(SeaLevel)
    .PicSeaLevel.Cls
    Step = 15 / .PicSeaLevel.ScaleWidth
    PosStep = 255 / .PicSeaLevel.ScaleWidth
    Value = 0
    position = 0
    For Index = 0 To .PicSeaLevel.ScaleWidth
        If Int(position) >= Header(SeaLevel) Then ' Green. '
            .PicSeaLevel.Line (Index, 0)-(Index, .PicSeaLevel.ScaleHeight), RGB(0, (128 + Int(Value) * 8), 0)
        Else ' Blue. '
            .PicSeaLevel.Line (Index, 0)-(Index, .PicSeaLevel.ScaleHeight), RGB(0, 0, 128 + Int(Value) * 8)
        End If
        Value = Value + Step
        position = position + PosStep
    Next
    End With
End Sub

' Return an index to MapData from a point on the map. '
Public Function GetMapIndex(x As Long, y As Long) As Long
    On Error Resume Next
    Dim xIndex As Long, yIndex As Long
    
    xIndex = Int(x / 32)
    yIndex = Int(y / 32)
    GetMapIndex = -1
    If xIndex >= (Header(MapWidth) / 2) Or yIndex >= (Header(MapHeight) / 2) Then
        Exit Function
    End If
    
    GetMapIndex = (yIndex * (Header(MapWidth) / 2)) + xIndex
    If (GetMapIndex > UBound(MapData)) Or (GetMapIndex < 0) Then
        GetMapIndex = -1
    End If
End Function

' Return an index to SceneData from a point on the map. '
Public Function GetMapAttrIndex(x As Long, y As Long) As Long
    On Error Resume Next
    Dim xIndex As Long, yIndex As Long
    Dim Offset As Long
    
    xIndex = Int(x / 16)
    yIndex = Int(y / 16)
    GetMapAttrIndex = -1
    If xIndex >= Header(MapWidth) Or yIndex >= Header(MapHeight) Or xIndex < 0 Or yIndex < 0 Then
        Exit Function
    End If
    
    GetMapAttrIndex = (yIndex * Header(MapWidth)) + xIndex + Offset
    If (GetMapAttrIndex > UBound(SceneAttr)) Or (GetMapAttrIndex < 0) Then
        GetMapAttrIndex = -1
    End If
End Function

Public Sub HeightMapExport(Filename As String)
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
    
    SaveBMPFile Filename, HeightData(), GreyPalette(), Header(MapWidth), Header(MapHeight)
    Exit Sub
Error:
    MsgBox "There was an error exporting the heightmap for this map.", vbExclamation, "Export Heightmap"
End Sub

' Free the memory and close this map. '
Sub MapClose()
    Dim Index As Integer
    
    On Error Resume Next
    For Index = 1 To UBound(MapFeatures)
        MapFeatures(Index).Holds = MapFeatures(Index).Holds - 1
    Next
    Initialize
End Sub

' Process mouse input the map for the selected tool. '
Public Sub ToolsProcess(ByVal x As Long, ByVal y As Long, ByVal Button As Integer, Optional MouseMove As Boolean = False)
    ' Initialize. '
    On Error GoTo Error
    ToolsUpdateMouse x, y, Button
    If Button = 0 Then Exit Sub
    If SelectedTool = ToolRegion Then Exit Sub
    
    With FrmAnnihilator
    Select Case SelectedItem
        Case ToolSections
            ToolsSection .CanvasCursor.Left, .CanvasCursor.Top, x, y, Button, MouseMove
        Case ToolFeatures
            ToolsFeatures x, y, Button, MouseMove
        Case ToolHeight
            ToolsHeight x, y, Button
        Case ToolSpecial
            ToolsStarting x, y, Button
        Case ToolTiles
            ToolsTiles x, y, Button
        'Case ToolClone
        '    ToolsClone X, Y, Button
        'Case ToolFill
        '    ToolsFill X, Y, Button
    End Select
    End With
    Exit Sub
    
Error:
    MsgBox "There was an error using the selected tool.", vbExclamation, "Tool"
'    Resume
End Sub

Private Sub ToolsUpdateMouse(ByVal x As Long, ByVal y As Long, ByVal Button As Integer)
    Dim Height As Long
    Dim Feature As Integer, FeatureName As String
    
    ' Update the Statusbar. '
    On Error GoTo Error
    Feature = -1
    Height = GetMapAttrIndex(ViewX * 32 + 16 * CInt(x / 16), ViewY * 32 + 16 * CInt(y / 16))
    If Height > -1 Then
        Feature = SceneAttr(Height)
        Height = GetHeight(Height)
    Else
        Height = 0
    End If
    If Feature > -1 Then
        FeatureName = MapFeatures(Feature + 1).Name
    End If
    If Region.Usable Then
        If FrmAnnihilator.Rubber.Visible Then
            UpdateStatusbar 2, Int(x / 16), Int(y / 16), Height, FrmAnnihilator.Rubber.Width, FrmAnnihilator.Rubber.Height, FeatureName
        Else
            UpdateStatusbar 2, Int(x / 16), Int(y / 16), Height, Region.Width * 32, Region.Height * 32, FeatureName
        End If
    Else
        If FrmAnnihilator.Rubber.Visible Then
            UpdateStatusbar 2, Int(x / 16), Int(y / 16), Height, FrmAnnihilator.Rubber.Width, FrmAnnihilator.Rubber.Height, FeatureName
        Else
            UpdateStatusbar 2, Int(x / 16), Int(y / 16), Height, 0, 0, FeatureName
        End If
    End If
    
    With FrmAnnihilator
    Select Case SelectedTool
        Case ToolDefault
            Select Case SelectedItem
                Case ToolSections
                    '.Canvas.MousePointer = vbNormal
                    .CanvasCursor.Visible = (SelectedSection.Name <> "")
                    If SelectedSection.Name <> "" Then
                        .CanvasCursor.Width = SelectedSection.Width * 32
                        .CanvasCursor.Height = SelectedSection.Height * 32
                        .CanvasCursor.Left = 32 * Int((x - Int(.CanvasCursor.Width / 2)) / 32)
                        .CanvasCursor.Top = 32 * Int((y - Int(.CanvasCursor.Height / 2)) / 32)
                    End If
                Case ToolFeatures
                    .Canvas.MousePointer = vbNormal
                    If UBound(SelectedFeatures) > 0 Then
                        .CanvasCursor.Visible = True
                        .CanvasCursor.Width = FeatureRadius * 32
                        .CanvasCursor.Height = FeatureRadius * 32
                        .CanvasCursor.Left = x - FeatureRadius * 16
                        .CanvasCursor.Top = y - FeatureRadius * 16
                    Else
                        If SelectedFeatures(0).Name <> "" Then
                            .CanvasCursor.Width = SelectedFeatures(0).Width
                            .CanvasCursor.Height = SelectedFeatures(0).Height
                            .CanvasCursor.Left = 16 * CInt(x / 16) - SelectedFeatures(0).PositionX + SelectedFeatures(0).FootprintX * 8
                            .CanvasCursor.Top = 16 * CInt(y / 16) - CInt(Height / 2) - SelectedFeatures(0).PositionY + SelectedFeatures(0).FootprintY * 8
                            .CanvasCursor.Visible = True
                        Else
                            .CanvasCursor.Visible = False
                        End If
                    End If
                Case ToolHeight
                    .Canvas.MousePointer = vbSizeNS
                    .CanvasCursor.Visible = True
                    If HeightCursorSize = 1 Then
                        .CanvasCursor.Width = 8
                        .CanvasCursor.Height = 8
                        .CanvasCursor.Left = 16 * CInt(x / 16) - 4
                        .CanvasCursor.Top = 16 * CInt(y / 16) - CInt(Height / 2) - 4
                    Else
                        .CanvasCursor.Width = HeightCursorSize * 16
                        .CanvasCursor.Height = HeightCursorSize * 16
                        .CanvasCursor.Left = 16 * CInt(x / 16)
                        .CanvasCursor.Top = 16 * CInt(y / 16) - CInt(Height / 2)
                    End If
                Case ToolSpecial
                    .Canvas.MousePointer = 2
                    .CanvasCursor.Visible = False
                Case ToolTiles
                    .Canvas.MousePointer = vbNormal
                    .CanvasCursor.Visible = True
                    .CanvasCursor.Width = 32
                    .CanvasCursor.Height = 32
                    .CanvasCursor.Left = 32 * Int(x / 32)
                    .CanvasCursor.Top = 32 * Int(y / 32)
                Case Else
                    .Canvas.MousePointer = vbNormal
                    .CanvasCursor.Visible = False
            End Select
        Case ToolRegion
            '.Canvas.MousePointer = vbNormal
            .CanvasCursor.Visible = False
        Case ToolOddRegion
            '.Canvas.MousePointer = vbNormal
            .CanvasCursor.Visible = False
    End Select
    End With
Error:
End Sub

Private Sub ToolsSection(ByVal x As Long, ByVal y As Long, ByVal MouseX As Long, MouseY As Long, ByVal Button As Integer, MouseMove As Boolean)
    If (SelectedSection.Name <> "") And (Not MouseMove) Then
        If Button = 1 Then
            SelectedSection.Holds = SelectedSection.Holds + 1
            OverlayPaste
            Set Overlay = SelectedSection
            Region.Left = ViewX + Int(x / 32)
            Region.Top = ViewY + Int(y / 32)
            Region.Width = Overlay.Width
            Region.Height = Overlay.Height
            Region.Usable = True
            OverlayRefreshView
            DrawMap
            Set SelectedSection = New classSection
            Sections.CreatePalette
            FrmAnnihilator.CanvasCursor.Visible = False
        Else
            Set SelectedSection = New classSection
            Sections.CreatePalette
            FrmAnnihilator.CanvasCursor.Visible = False
        End If
    ElseIf Not MouseMove Then
        OverlayCheckMouseOver MouseX, MouseY
        If RegionMouseOver Then
            Rubberband.StartMove FrmAnnihilator.Selected, MouseX, MouseY, 32
        Else
            Rubberband.Initialize FrmAnnihilator.Rubber, MouseX, MouseY, 32
        End If
    End If
End Sub

Private Sub ToolsFeatures(ByVal x As Long, ByVal y As Long, ByVal Button As Integer, MouseMove As Boolean)
    Dim Index As Long, i As Long
    Dim IndexX As Long, IndexY As Long
    Dim Buffer As Long
    Dim NewIndex As Long, Flag As Boolean
    
    If UBound(SelectedFeatures) = 0 Then
        'Index = GetMapAttrIndex(ViewX * 32 + x, ViewY * 32 + y)
        Index = GetMapAttrIndex(ViewX * 32 + 16 * CInt(x / 16), ViewY * 32 + 16 * CInt(y / 16))
        If Index = -1 Then Exit Sub
        If Button = 1 Then
            If SelectedFeatures(0).Name = "" Then Exit Sub
            SceneAttr(Index) = FeatureAdd(0)
            ReDim Preserve SelectedAttr(UBound(SelectedAttr) + 1)
            SelectedAttr(UBound(SelectedAttr)) = Index
            DrawMap
        ElseIf Button > 1 Then
            If Not MouseMove Then
                Rubberband.Initialize FrmAnnihilator.Rubber, x, y, 1
            End If
            'SceneAttr(Index) = -1
        End If
    Else
        Randomize
        Buffer = False
        For Index = 0 To UBound(SelectedFeatures)
            If SelectedFeatures(Index).Name <> "" Then
                Buffer = True
                Exit For
            End If
        Next
        If Not Buffer Then Exit Sub
        For IndexX = ViewX * 32 + x - FeatureRadius * 16 To ViewX * 32 + x + FeatureRadius * 16 Step 16
            For IndexY = ViewY * 32 + y - FeatureRadius * 16 To ViewY * 32 + y + FeatureRadius * 16 Step 16
                Index = GetMapAttrIndex(IndexX, IndexY)
                If Index >= 0 Then
                    Buffer = Int(100 * Rnd + 1)
                    If CInt(Buffer / 10) <= FeatureDensity Then
                        Buffer = Int((UBound(SelectedFeatures) + 1) * Rnd)
                        Do While SelectedFeatures(Buffer).Name = ""
                            Buffer = Int((UBound(SelectedFeatures) + 1) * Rnd)
                        Loop
                        Flag = False
                        For i = 1 To FeaturePadding
                            NewIndex = GetMapAttrIndex(IndexX - i * 16, IndexY + i * 16)
                            If NewIndex > -1 Then
                                If GetHeight(NewIndex) < FeatureMinHeight Or GetHeight(NewIndex) > FeatureMaxHeight Then
                                    Flag = True
                                    Exit For
                                End If
                            End If
                            NewIndex = GetMapAttrIndex(IndexX * 16, IndexY + i * 16)
                            If NewIndex > -1 Then
                                If GetHeight(NewIndex) < FeatureMinHeight Or GetHeight(NewIndex) > FeatureMaxHeight Then
                                    Flag = True
                                    Exit For
                                End If
                            End If
                            NewIndex = GetMapAttrIndex(IndexX + i * 16, IndexY + i * 16)
                            If NewIndex > -1 Then
                                If GetHeight(NewIndex) < FeatureMinHeight Or GetHeight(NewIndex) > FeatureMaxHeight Then
                                    Flag = True
                                    Exit For
                                End If
                            End If
                            NewIndex = GetMapAttrIndex(IndexX - i * 16, IndexY * 16)
                            If NewIndex > -1 Then
                                If GetHeight(NewIndex) < FeatureMinHeight Or GetHeight(NewIndex) > FeatureMaxHeight Then
                                    Flag = True
                                    Exit For
                                End If
                            End If
                            NewIndex = GetMapAttrIndex(IndexX + i * 16, IndexY * 16)
                            If NewIndex > -1 Then
                                If GetHeight(NewIndex) < FeatureMinHeight Or GetHeight(NewIndex) > FeatureMaxHeight Then
                                    Flag = True
                                    Exit For
                                End If
                            End If
                            NewIndex = GetMapAttrIndex(IndexX - i * 16, IndexY - i * 16)
                            If NewIndex > -1 Then
                                If GetHeight(NewIndex) < FeatureMinHeight Or GetHeight(NewIndex) > FeatureMaxHeight Then
                                    Flag = True
                                    Exit For
                                End If
                            End If
                            NewIndex = GetMapAttrIndex(IndexX * 16, IndexY - i * 16)
                            If NewIndex > -1 Then
                                If GetHeight(NewIndex) < FeatureMinHeight Or GetHeight(NewIndex) > FeatureMaxHeight Then
                                    Flag = True
                                    Exit For
                                End If
                            End If
                            NewIndex = GetMapAttrIndex(IndexX + i * 16, IndexY - i * 16)
                            If NewIndex > -1 Then
                                If GetHeight(NewIndex) < FeatureMinHeight Or GetHeight(NewIndex) > FeatureMaxHeight Then
                                    Flag = True
                                    Exit For
                                End If
                            End If
                        Next
                        If Not Flag Then
                            If GetHeight(Index) >= FeatureMinHeight And GetHeight(Index) <= FeatureMaxHeight Then
                                If Button = 1 Then
                                    SceneAttr(Index) = FeatureAdd(Buffer)
                                    ReDim Preserve SelectedAttr(UBound(SelectedAttr) + 1)
                                    SelectedAttr(UBound(SelectedAttr)) = Index
                                ElseIf Button = 2 Then
                                    SceneAttr(Index) = -1
                                End If
                            End If
                        End If
                    End If
                End If
            Next
        Next
        DrawMap
    End If
End Sub

Private Sub ToolsHeight(ByVal x As Long, ByVal y As Long, ByVal Button As Integer)
    Dim NewX As Long, NewY As Long
    Dim IndexX As Long, IndexY As Long
    Dim Index As Long, Value As Long
    
    NewX = 16 * CInt(x / 16) + (ViewX * 32)
    NewY = 16 * CInt(y / 16) + (ViewY * 32)
    For IndexX = 0 To HeightCursorSize * 16 - 16 Step 16
        For IndexY = 0 To HeightCursorSize * 16 - 16 Step 16
            Index = GetMapAttrIndex(NewX + IndexX, NewY + IndexY)
            If Index <> -1 Then
                Value = GetHeight(Index)
                If (Button = 1) Then
                    If HeightVoid Then
                        SceneAttr(Index) = -4
                    Else
                        If Value + HeightInterval < 256 Then
                            SetHeight Index, Value + HeightInterval
                        Else
                            SetHeight Index, 255
                        End If
                    End If
                ElseIf (Button = 2) Then
                    If HeightVoid Then
                        SceneAttr(Index) = -1
                    Else
                        If Value - HeightInterval >= 0 Then
                            SetHeight Index, Value - HeightInterval
                        Else
                            SetHeight Index, 0
                        End If
                    End If
                End If
            End If
        Next
    Next
    If Button > 0 Then
        DrawMap
    End If
End Sub

Private Sub ToolsStarting(ByVal x As Long, ByVal y As Long, ByVal Button As Integer)
    If Button = 0 Then Exit Sub
    If SelectedPlayer > 0 Then
        PlayerPosX(SelectedPlayer) = x + (ViewX * 32)
        PlayerPosY(SelectedPlayer) = y + (ViewY * 32)
        DrawMap
    End If
End Sub

Private Sub ToolsTiles(ByVal x As Long, ByVal y As Long, ByVal Button As Integer)
    Dim NewX As Long, NewY As Long, Index As Long
    
'    If (Button = 1) And (CtrlDown) Then
'        ' Get the tile index, and select that tile on the palette. '
'        NewX = FrmAnnihilator.CanvasHScroll.Value
'        NewY = FrmAnnihilator.CanvasVScroll.Value
'        NewX = 32 * Int(x / 32) + (NewX * 32)
'        NewY = 32 * Int(y / 32) + (NewY * 32)
'        Index = GetMapIndex(NewX, NewY)
'        If Index <> -1 Then
'            ReDim SelectedTiles(0)
'            SelectedTiles(0) = MapData(Index)
'        End If
'        TileCreatePalette
'        TileScroll.Value = Int(MapData(Index) / TileCols)
'    ElseIf (Button = 1) And (ShiftDown) Then
'        If (NewX <> 32 * Int(x / 32)) Or (NewY <> 32 * Int(y / 32)) Then
'            NewX = 32 * Int(x / 32)
'            NewY = 32 * Int(y / 32)
'            If (SelectedTiles(0) + 1) <= Int((UBound(TileData) + 1) / 1024) Then
'                SelectedTiles(0) = SelectedTiles(0) + 1
'                TileCreatePalette
'                TileScroll.Value = Int(SelectedTiles(0) / TileCols)
'            End If
'        End If
'    ElseIf (Button = 1) And Not (ShiftDown) And Not (CtrlDown) Then
    If Button = 1 Then
        NewX = 32 * Int(x / 32) + (ViewX * 32)
        NewY = 32 * Int(y / 32) + (ViewY * 32)
            Index = GetMapIndex(NewX, NewY)
            If (Index <> -1) Then
                MapData(Index) = SelectedTile
            End If
        DrawMap
    End If
'    End If
End Sub

Private Sub ToolsClone(ByVal x As Long, ByVal y As Long, ByVal Button As Integer)
'    If (Button = 1) And (CtrlDown) Or (AltDown) Or (ShiftDown) Then
'        NewX = FrmAnnihilator.CanvasHScroll.Value
'        NewY = FrmAnnihilator.CanvasVScroll.Value
'        NewX = 32 * Int(x / 32) + (NewX * 32)
'        NewY = 32 * Int(y / 32) + (NewY * 32)
'        RubberBand.Top = CanvasCursor.Top
'        RubberBand.Left = CanvasCursor.Left
'        RubberBand.Width = CanvasCursor.Width
'        RubberBand.Height = CanvasCursor.Height
'        RubberBand.Visible = True
'        CloneIndex = GetMapIndex(NewX, NewY)
'        CloneStart = -1
'    ElseIf Button = 1 Then
'        NewX = FrmAnnihilator.CanvasHScroll.Value
'        NewY = FrmAnnihilator.CanvasVScroll.Value
'        NewX = 32 * Int(x / 32) + (NewX * 32)
'        NewY = 32 * Int(y / 32) + (NewY * 32)
'        If CloneIndex >= 0 And CloneStart = -1 Then
'            CloneStart = GetMapIndex(NewX, NewY)
'        End If
'        For IndexX = 0 To (CanvasCursor.Width - 32) Step 32
'            For IndexY = 0 To (CanvasCursor.Height - 32) Step 32
'                Index = GetMapIndex(NewX + IndexX, NewY + IndexY)
'                If (Index <> -1) And (((32 * Int(x / 32)) + IndexX) < Canvas.ScaleWidth) And (((32 * Int(y / 32)) + IndexY) < Canvas.ScaleHeight) Then
'                    x3 = x1
'                    y3 = y1
'                    xOffset = x1 - x2
'                    yOffset = y1 - y2
'                    Call GetIndexMapTile(x2, y2, CloneIndex)
'                    x1 = x2 + xOffset
'                    y1 = y2 + yOffset
'                    If x1 >= 0 And x1 <= (Header(MapWidth) / 2) Then
'                        If y1 >= 0 And y1 <= (Header(MapHeight) / 2) Then
'                            If CloneAnims Then
'                                SceneAttr(((y3 * 2) * Header(MapWidth)) + (x3 * 2)) = SceneAttr(((y1 * 2) * Header(MapWidth)) + (x1 * 2))
'                                SceneAttr((((y3 * 2) * Header(MapWidth)) + (x3 * 2)) + 1) = SceneAttr((((y1 * 2) * Header(MapWidth)) + (x1 * 2)) + 1)
'                                SceneAttr((((y3 * 2) * Header(MapWidth)) + (x3 * 2)) + Header(MapWidth)) = SceneAttr((((y1 * 2) * Header(MapWidth)) + (x1 * 2)) + Header(MapWidth))
'                                SceneAttr((((y3 * 2) * Header(MapWidth)) + (x3 * 2)) + Header(MapWidth) + 1) = SceneAttr((((y1 * 2) * Header(MapWidth)) + (x1 * 2)) + Header(MapWidth) + 1)
'                            End If
'                            If CloneAnims Then
'                                HeightData(((y3 * 2) * Header(MapWidth)) + (x3 * 2)) = HeightData(((y1 * 2) * Header(MapWidth)) + (x1 * 2))
'                                HeightData((((y3 * 2) * Header(MapWidth)) + (x3 * 2)) + 1) = HeightData((((y1 * 2) * Header(MapWidth)) + (x1 * 2)) + 1)
'                                HeightData((((y3 * 2) * Header(MapWidth)) + (x3 * 2)) + Header(MapWidth)) = HeightData((((y1 * 2) * Header(MapWidth)) + (x1 * 2)) + Header(MapWidth))
'                                HeightData((((y3 * 2) * Header(MapWidth)) + (x3 * 2)) + Header(MapWidth) + 1) = HeightData((((y1 * 2) * Header(MapWidth)) + (x1 * 2)) + Header(MapWidth) + 1)
'                            End If
'                            If CloneTiles Then
'                                MapData(Index) = MapData(GetMapIndex(x1 * 32, y1 * 32))
'                                DrawTile MapData(Index), 32 * Int(x / 32) + IndexX, 32 * Int(y / 32) + IndexY
'                            End If
'                        End If
'                    End If
'                End If
'            Next
'        Next
'    End If
End Sub

Private Sub ToolsFill(ByVal x As Long, ByVal y As Long, ByVal Button As Integer)
'    If (Button = 1) Then
'        If RubberBand.Visible And (x > RubberBand.Left) And (x < (RubberBand.Left + RubberBand.Width)) And (y > RubberBand.Top) And (y < (RubberBand.Top + RubberBand.Height)) Then
'            NewX = FrmAnnihilator.CanvasHScroll.Value
'            NewY = FrmAnnihilator.CanvasVScroll.Value
'            NewX = RubberBand.Left + (NewX * 32)
'            NewY = RubberBand.Top + (NewY * 32)
'            x2 = RubberBand.Width
'            y2 = RubberBand.Height
'            NewAction ActionTile
'            For IndexX = 0 To x2 - 32 Step 32
'                For IndexY = 0 To y2 - 32 Step 32
'                    Index = GetMapIndex(NewX + IndexX, NewY + IndexY)
'                    If Index <> -1 Then
'                        AppendAction ActionTile, Index
'                        RandomNumber = Int(Rnd * (UBound(SelectedTiles) + 1))
'                        MapData(Index) = SelectedTiles(RandomNumber)
'                        DrawTile SelectedTiles(RandomNumber), 32 * Int(x / 32) + IndexX, 32 * Int(y / 32) + IndexY
'                    End If
'                Next
'            Next
'            DrawCanvas
'        Else ' Fill entire screen. '
'            MsgBox "You must select an area to fill.  Use the right mouse button to drag over the area you want to fill.", vbInformation, "Fill"
'        End If
'    End If
End Sub

Public Function Width() As Long
    Width = Header(MapWidth)
End Function

Public Function Height() As Long
    Height = Header(MapHeight)
End Function

Public Function WidthUnit() As Long
    Dim Value As Long
    
    Value = Header(MapWidth) * 16
    Value = Int(Value / 512)
    If ((Header(MapWidth) * 16) Mod 512) <> 0 Then Value = Value + 1
    WidthUnit = Value
End Function

Public Function HeightUnit() As Long
    Dim Value As Long
    
    Value = Header(MapHeight) * 16
    Value = Int(Value / 512)
    If ((Header(MapHeight) * 16) Mod 512) <> 0 Then Value = Value + 1
    HeightUnit = Value
End Function

' Change the viewing position on the map. '
Sub ScrollMap(xPos As Long, yPos As Long)
    If (xPos = ViewX) And (yPos = ViewY) Then Exit Sub
    If (xPos < 0) Or (xPos > FrmAnnihilator.CanvasHScroll.Max) Then xPos = ViewX
    If (yPos < 0) Or (yPos > FrmAnnihilator.CanvasVScroll.Max) Then yPos = ViewY
    
    ViewX = xPos
    If FrmAnnihilator.CanvasHScroll.Value <> ViewX Then FrmAnnihilator.CanvasHScroll.Value = ViewX
    ViewY = yPos
    If FrmAnnihilator.CanvasVScroll.Value <> ViewY Then FrmAnnihilator.CanvasVScroll.Value = ViewY
    
    If ViewMinimap Then
        View.Visible = True
        Minimap.MiniMapViewPosition
    End If
    DoEvents
    DrawMap
    OverlayRefreshView
End Sub

Sub ResizeMapScrollBars()
    Dim CanvasWidth As Long, CanvasHeight As Long
    
    With FrmAnnihilator
    If MapLoaded Then
        CanvasWidth = CInt(.Canvas.ScaleWidth / 32)
        CanvasHeight = CInt(.Canvas.ScaleHeight / 32)
        .CanvasHScroll.LargeChange = CanvasWidth
        .CanvasVScroll.LargeChange = CanvasHeight
        CanvasWidth = (Header(MapWidth) / 2) - CanvasWidth + 1
        CanvasHeight = (Header(MapHeight) / 2) - CanvasHeight + 1
        If CanvasWidth < 0 Then CanvasWidth = 0
        If CanvasHeight < 0 Then CanvasHeight = 0
        .CanvasHScroll.Max = CanvasWidth
        .CanvasVScroll.Max = CanvasHeight
        If .CanvasHScroll.Max = 0 Then
            .CanvasHScroll.Visible = False
        Else
            .CanvasHScroll.Visible = True
        End If
        If .CanvasVScroll.Max = 0 Then
            .CanvasVScroll.Visible = False
        Else
            .CanvasVScroll.Visible = True
        End If
        If Not .CanvasHScroll.Visible And Not .CanvasVScroll.Visible Then
            .PicScroll.Visible = False
        Else
            .PicScroll.Visible = True
        End If
        If .CanvasHScroll.Value > .CanvasHScroll.Max Then .CanvasHScroll.Value = .CanvasHScroll.Max
        If .CanvasVScroll.Value > .CanvasVScroll.Max Then .CanvasVScroll.Value = .CanvasVScroll.Max
        If ViewMinimap Then
            MiniMapUpdateView ViewX, ViewY, True
        End If
    End If
    End With
End Sub

Sub MiniMapCreateDraft()
    Minimap.MiniMapGenerateDraft MapData(), TileData()
End Sub

Sub MiniMapCreateFinal()
    Minimap.MiniMapGenerateFinal MapData(), TileData()
End Sub

Sub MiniMapRefresh()
    If Not ViewMinimap Then Exit Sub
    Minimap.MiniMapRefresh
    Minimap.MiniMapViewPosition
    If OverSpecials Then
        MinimapDrawStartingLocations
    End If
End Sub

' Refresh the map on the interface. '
Sub Refresh()
    With FrmAnnihilator
    NoScroll = True
    ResizeMapScrollBars
    .CanvasHScroll.Value = ViewX
    .CanvasVScroll.Value = ViewY
    NoScroll = False
    .SliderSeaLevel.Value = Header(SeaLevel)
    DrawMap
    .ScrollTiles = 0
    TileCreatePalette
    MiniMapRefresh
    OverlayRefreshView
    End With
End Sub

Sub MiniMapUpdateView(ByVal x As Single, ByVal y As Single, Optional CanvasCoord As Boolean = False)
    Minimap.MiniMapUpdateView x, y, CanvasCoord
End Sub

Sub MinimapDrawStartingLocations()
    Minimap.MinimapDrawStartingLocations PlayerPosX(), PlayerPosY()
End Sub

' Paste an overlay on the map. '
Public Sub OverlayPaste(Optional Index As Integer = 0)
    If Not Region.Usable Then Exit Sub
    
    Screen.MousePointer = vbHourglass
    DoEvents
    Overlay.PasteSection Region.Left, Region.Top, Header(MapWidth) / 2, Header(MapHeight) / 2, MapData(), HeightData(), TileData(), TileList()
    Overlay.Holds = Overlay.Holds - 1
    If Overlay.Holds = 0 Then Overlay.FreeSection
    'If Not Overlay.Selected Then Overlay.FreeSection
    Set Overlay = Nothing
    Set Region = New classRubberband
    FrmAnnihilator.Selected.Visible = False
    Screen.MousePointer = vbNormal
    OverlayRefreshView
    DrawMap
    TileCreatePalette
End Sub

Public Sub OverlayClear()
    Dim i As Integer
    
    If UBound(SelectedAttr) > 0 Then
        For i = 0 To UBound(SelectedAttr)
            SceneAttr(SelectedAttr(i)) = -1
        Next
        ReDim SelectedAttr(0)
    Else
        Overlay.Holds = Overlay.Holds - 1
        If Not Overlay.Selected Then Overlay.FreeSection
        Set Overlay = Nothing
        Set Region = New classRubberband
        FrmAnnihilator.Selected.Visible = False
        Screen.MousePointer = vbNormal
        OverlayRefreshView
    End If
    DrawMap
End Sub

Public Sub TileCreatePalette()
    Dim IndexX As Long, IndexY As Long, Index As Long
    Dim TileIndex As Long
    Dim TileRows As Long, TileCols As Long
    
    On Error GoTo Error
    TileResizeScroll
    If Header(Tiles) = 0 Then Exit Sub
    
    With FrmAnnihilator
    .PicTilePalette.Cls
    TileCols = Int((.PicTilePalette.ScaleWidth - .ScrollTiles.Width) / 34)
    If TileCols <= 0 Then TileCols = 1
    TileRows = CInt(((UBound(TileData) / 1024) + 1) / TileCols) - 1
    TileIndex = .ScrollTiles.Value * TileCols
    If TileIndex < 0 Then TileIndex = 0
    
    For IndexY = 0 To Int(.PicTilePalette.ScaleHeight / 32) + 1
        For IndexX = 0 To (TileCols * 34 - 1) Step 34
            If TileIndex * 1024 <= UBound(TileData) Then
                Screens(PaletteTiles).TileDraw 0, 0, 32, 32, TileData(), TileIndex * 1024
                Screens(PaletteTiles).Show .PicTilePalette.hdc, IndexX + 2, IndexY * 34 + 2, 32, 32, 0, 0
                If TileIndex = SelectedTile Then
                    .PicTilePalette.Line (IndexX + 1, IndexY * 34 + 1)-(IndexX + 35, IndexY * 34 + 1), &HFF8080
                    .PicTilePalette.Line (IndexX + 1, IndexY * 34 + 1)-(IndexX + 1, IndexY * 34 + 34), &HFF8080
                    .PicTilePalette.Line (IndexX + 1, IndexY * 34 + 34)-(IndexX + 35, IndexY * 34 + 34), &HFF8080
                    .PicTilePalette.Line (IndexX + 35, IndexY * 34 + 1)-(IndexX + 35, IndexY * 34 + 34), &HFF8080
                End If
            End If
            TileIndex = TileIndex + 1
        Next
        If TileIndex > UBound(TileData) Then Exit For
    Next
    .PicTilePalette.Refresh
    End With
    
Error:
End Sub

Sub TileResizeScroll()
    Dim TileCols As Long, TileRows As Long
    
    TileCols = Int((FrmAnnihilator.PicTilePalette.ScaleWidth - FrmAnnihilator.ScrollTiles.Width) / 34)
    If TileCols <= 0 Then TileCols = 1
    TileRows = CInt((Int(UBound(TileData) / 1024) + 1) / TileCols) - 1
    FrmAnnihilator.ScrollTiles.Max = TileRows
    If FrmAnnihilator.ScrollTiles.Min < FrmAnnihilator.ScrollTiles.Max Then
        FrmAnnihilator.ScrollTiles.Visible = True
    Else
        FrmAnnihilator.ScrollTiles.Visible = False
    End If
End Sub

' Select a tile. '
Public Sub TileSelect(ByVal x As Long, ByVal y As Long)
    Dim TileCols As Long, TileRows As Long
    Dim NewX As Long, NewY As Long
    Dim Value As Long
    
    TileCols = Int((FrmAnnihilator.PicTilePalette.ScaleWidth - FrmAnnihilator.ScrollTiles.Width) / 34)
    If TileCols <= 0 Then TileCols = 1
    TileRows = CInt((Int(UBound(TileData) / 1024) + 1) / TileCols) - 1

    NewX = 34 * Int(x / 34)
    If Int(NewX / 34) >= TileCols Then Exit Sub
    NewY = 34 * Int(y / 34)
    Value = Int(NewX / 34) + (Int(NewY / 34) * TileCols) + (FrmAnnihilator.ScrollTiles.Value * TileCols)
    If Int((UBound(TileData) + 1) / 1024) > Value Then
        SelectedTile = Value
        TileCreatePalette
    End If
End Sub

' Compress the map. '
Sub CompressMap()
    Dim Index As Long, i As Long
    Dim RemoveTiles() As Boolean
    Dim Indexes() As Long
    Dim Count As Long
    
    On Error GoTo Error
    
    FrmProgress.Captions "Initializing...", "Compressing map"
    FrmProgress.Show , FrmAnnihilator
    DoEvents

    ' Remove invalid feature indexes. '
    For Index = 0 To UBound(SceneAttr)
        If SceneAttr(Index) >= UBound(MapFeatures) Then
            SceneAttr(Index) = -1
        End If
    Next
    
    ReDim RemoveTiles(CInt(UBound(TileData) / 1024) - 1)
    For Index = 0 To UBound(RemoveTiles)
        RemoveTiles(Index) = True
    Next

    ' Reindex map information. '
    ReDim Indexes(CInt(UBound(TileData) / 1024) - 1)
    For Index = 0 To UBound(Indexes)
        Indexes(Index) = Index
    Next
    
    For Index = 0 To UBound(MapData)
        RemoveTiles(MapData(Index)) = False
    Next
    
    Count = 0
    FrmProgress.Captions "Removing unused graphics...", "Compressing map"
    For Index = 0 To UBound(Indexes)
        FrmProgress.Update Index, UBound(Indexes)
        If RemoveTiles(Index) Then
            Count = Count + 1
        Else
            Indexes(Index) = Indexes(Index) - Count
            For i = 0 To 1023
                TileData(Indexes(Index) * 1024 + i) = TileData(Index * 1024 + i)
            Next
        End If
    Next
    ReDim Preserve TileData(UBound(TileData) - Count * 1024)
    
    For Index = 0 To UBound(MapData)
        MapData(Index) = Indexes(MapData(Index))
    Next
        
    Header(Tiles) = CInt(UBound(TileData) / 1024)
    ReDim TileList(Int((UBound(TileData) + 1) / 1024) - 1)
    Index = UBound(TileList)
    CreateTileChecksumList TileData(0), TileList(0), Index
    TileCreatePalette
    DrawMap
    MsgBox "Compression complete." & Chr(13) & Chr(10) & Chr(13) & Chr(10) & "Space saved in map: " & CStr(Count) & "k", vbInformation, "Compress Map"
    Unload FrmProgress
    Exit Sub
    
Error:
    MsgBox "There was an error compressing this map: " & Err.Description, vbExclamation
    Header(Tiles) = CInt(UBound(TileData) / 1024)
    ReDim TileList(Int((UBound(TileData) + 1) / 1024) - 1)
    Index = UBound(TileList)
    CreateTileChecksumList TileData(0), TileList(0), Index
    TileCreatePalette
    Unload FrmProgress
    Exit Sub
End Sub

' Set an overlay to the selected region. '
Public Sub OverlaySet(Area As classRubberband)
    On Error GoTo Error
    OverlayPaste
    If Area.Usable Then
        If Area.Left >= Header(MapWidth) * 16 Or Area.Top >= Header(MapHeight) * 16 Then Exit Sub
        If Area.Left + Area.Width > Header(MapWidth) * 16 Then
            Area.Width = Header(MapWidth) * 16 - Area.Left
        End If
        If Area.Top + Area.Height > Header(MapHeight) * 16 Then
            Area.Height = Header(MapHeight) * 16 - Area.Top
        End If
        Screen.MousePointer = vbHourglass
        DoEvents
        Set Overlay = New classSection
        Region.Left = ViewX + Int(Area.Left / 32)
        Region.Top = ViewY + Int(Area.Top / 32)
        Region.Width = Int(Area.Width / 32)
        Region.Height = Int(Area.Height / 32)
        If Region.Left < 0 Then
            Region.Width = Region.Left + Region.Width
            Region.Left = 0
        End If
        If Region.Top < 0 Then
            Region.Height = Region.Top + Region.Height
            Region.Top = 0
        End If
        If Region.Left + Region.Width > Header(MapWidth) / 2 Then
            Region.Width = Header(MapWidth) / 2 - Region.Left
        End If
        If Region.Top + Region.Height > Header(MapHeight) / 2 Then
            Region.Height = Header(MapHeight) / 2 - Region.Top
        End If
        Overlay.RegionTiles = PasteTiles
        Overlay.RegionHeight = PasteHeight
        Overlay.CopySection Region.Left, Region.Top, Region.Width, Region.Height, Header(MapWidth) / 2, Header(MapHeight) / 2, MapData(), HeightData(), TileData()
        Region.Usable = True
        Area.SetShape FrmAnnihilator.Selected
        OverlayRefreshView
        DrawMap
        Screen.MousePointer = vbNormal
    End If
    Exit Sub
Error:
    Set Overlay = New classSection
    Set Region = New classRubberband
    Screen.MousePointer = vbNormal
    DrawMap
End Sub

' Put the SelectedSection overlay on the map. '
Public Sub OverlayPut()
    OverlayPaste
    Set Overlay = SelectedSection
    Region.Left = ViewX
    Region.Top = ViewY
    Region.Width = Overlay.Width
    Region.Height = Overlay.Height
    Region.Usable = True
    Overlay.RegionTiles = PasteTiles
    Overlay.RegionHeight = PasteHeight
    OverlayRefreshView
    DrawMap
    Set SelectedSection = New classSection
    Sections.CreatePalette
    FrmAnnihilator.CanvasCursor.Visible = False
End Sub

' Reposition the overlay. '
Public Sub OverlayReposition(Area As classRubberband)
    Region.Left = ViewX + Int(Area.Left / 32)
    Region.Top = ViewY + Int(Area.Top / 32)
'    Region.Width = Int(Area.Width / 32)
'    Region.Height = Int(Area.Height / 32)
    DrawMap
End Sub

' Move the overlay selection on the map. '
Public Sub OverlayRefreshView()
    With FrmAnnihilator
    If Region.Usable Then
        .Selected.Left = ((Region.Left * 32) - (ViewX * 32))
        .Selected.Top = ((Region.Top * 32) - (ViewY * 32))
        .Selected.Width = Overlay.Width * 32
        .Selected.Height = Overlay.Height * 32
        .Selected.Visible = True
    Else
        .Selected.Visible = False
    End If
    End With
End Sub

Public Sub OverlayCheckMouseOver(ByVal x As Long, ByVal y As Long)
    With FrmAnnihilator
    If .Selected.Visible Then
        If (x >= .Selected.Left) And (x <= .Selected.Left + .Selected.Width) And (y >= .Selected.Top) And (y <= .Selected.Top + .Selected.Height) Then
            .Canvas.MousePointer = vbSizeAll
            RegionMouseOver = True
        Else
            .Canvas.MousePointer = vbNormal
            RegionMouseOver = False
        End If
    Else
        .Canvas.MousePointer = vbNormal
        RegionMouseOver = False
    End If
    End With
End Sub

Public Sub OverlaySelectAll()
    On Error GoTo Error
    
    Screen.MousePointer = vbHourglass
    OverlayPaste
    Set Overlay = SelectedSection
    Region.Left = 0
    Region.Top = 0
    Region.Width = Header(MapWidth) / 2
    Region.Height = Header(MapHeight) / 2
    Region.Usable = True
    Overlay.RegionTiles = True
    Overlay.RegionHeight = True
    Overlay.CopySection Region.Left, Region.Top, Region.Width, Region.Height, Header(MapWidth) / 2, Header(MapHeight) / 2, MapData(), HeightData(), TileData()
Error:
    OverlayRefreshView
    DrawMap
    Screen.MousePointer = vbNormal
End Sub

Public Function GetSealevel() As Long
    GetSealevel = Header(SeaLevel)
End Function

Public Sub SetSealevel(Value As Long)
    Header(SeaLevel) = Value
End Sub

Public Function MapName() As String
    MapName = otaInfo(otaMissionName)
End Function

Public Sub MinimapImport(Filename As String)
    Minimap.Import Filename
End Sub

Public Sub MinimapExport(Filename As String)
    Minimap.Export Filename
End Sub

' Return the height value for the selected index. '
Public Function GetHeight(Index As Long) As Byte
    Dim xIndex As Long, yIndex As Long
    
    On Error Resume Next
    If Region.Usable And Overlay.RegionHeight Then
        yIndex = Int(Index / Header(MapWidth))
        xIndex = Index - Header(MapWidth) * Int(Index / Header(MapWidth))
        If (xIndex / 2 >= Region.Left) And (xIndex / 2 < Region.Left + Region.Width) And (yIndex / 2 >= Region.Top) And (yIndex / 2 < Region.Top + Region.Height) Then
            GetHeight = Overlay.GetHeight(xIndex - Region.Left * 2 + Region.Width * 2 * (yIndex - Region.Top * 2))
        Else
            GetHeight = HeightData(Index)
        End If
    Else
        GetHeight = HeightData(Index)
    End If
End Function

' Set the height value of the selected index. '
Public Sub SetHeight(Index As Long, Height As Byte)
    Dim xIndex As Long, yIndex As Long
    
    On Error Resume Next
    If Region.Usable Then
        yIndex = Int(Index / Header(MapWidth))
        xIndex = Index - Header(MapWidth) * Int(Index / Header(MapWidth))
        If (xIndex / 2 >= Region.Left) And (xIndex / 2 < Region.Left + Region.Width) And (yIndex / 2 >= Region.Top) And (yIndex / 2 < Region.Top + Region.Height) Then
            Overlay.SetHeight (xIndex - Region.Left * 2 + Region.Width * 2 * (yIndex - Region.Top * 2)), Height
        Else
            HeightData(Index) = Height
        End If
    Else
        HeightData(Index) = Height
    End If
End Sub

Public Sub CopySection()
    If Region.Usable Then
        If Overlay.RegionTiles And Overlay.RegionHeight Then
            Sections.NewSection Overlay
        Else
            MsgBox "Sections must have both textures and height to be copied to the section palette.  Change your selection filters.", vbInformation, "Copy to Palette"
        End If
    End If
End Sub

' Fill map with the selected section. '
Public Sub FillMap()
    If SelectedSection.Name <> "" Then
        Screen.MousePointer = vbHourglass
        SelectedSection.FillMap MapData(), HeightData(), TileData(), TileList(), Header(MapWidth) / 2, Header(MapHeight) / 2
        DrawMap
        UpdateStatusbar
        Screen.MousePointer = vbNormal
        SelectedSection.FreeSection
        Set SelectedSection = New classSection
        Sections.CreatePalette
    End If
End Sub

Public Sub FillOverlay()
    If SelectedSection.Name <> "" And Region.Usable Then
        Screen.MousePointer = vbHourglass
        Overlay.FillOverlay
        DrawMap
        UpdateStatusbar
        Screen.MousePointer = vbNormal
        SelectedSection.FreeSection
        Set SelectedSection = New classSection
        Sections.CreatePalette
    End If
End Sub

Public Sub OverlayFill()
    On Error Resume Next
    If Region.Usable Then
        Screen.MousePointer = vbHourglass
        Overlay.FillMap MapData(), HeightData(), TileData(), TileList(), Header(MapWidth) / 2, Header(MapHeight) / 2
        DrawMap
        UpdateStatusbar
        Screen.MousePointer = vbNormal
    End If
End Sub

Public Sub FeaturesRemoveAll()
    Dim Index As Long
    
    For Index = 0 To UBound(SceneAttr)
        If SceneAttr(Index) >= 0 Then SceneAttr(Index) = -1
    Next
    For Index = 1 To UBound(MapFeatures)
        MapFeatures(Index).Holds = MapFeatures(Index).Holds - 1
    Next
    ReDim MapFeatures(0)
    DrawMap
End Sub

Public Sub FeaturesFillOverlay()
    Dim IndexX As Long, IndexY As Long
    Dim Index As Long, SceneIndex As Long, i As Integer, NewIndex As Long, Flag As Boolean
    Dim Count As Long, Percent As Single
    Dim Buffer As Long
    
    On Error GoTo Error
    If Not Region.Usable Then Exit Sub
    
    Percent = FeatureDensity / 10
    Count = Percent * Region.Width * Region.Height * 2
    For Index = 0 To Count
        IndexX = Int(((Region.Left * 2 + Region.Width * 2) - Region.Left * 2 + 1) * Rnd + Region.Left * 2)
        IndexY = Int(((Region.Top * 2 + Region.Height * 2) - Region.Top * 2 + 1) * Rnd + Region.Top * 2)
        SceneIndex = GetMapAttrIndex(IndexX * 16, IndexY * 16)
        Flag = False
        For i = 1 To FeaturePadding
            NewIndex = GetMapAttrIndex((IndexX - i) * 16, (IndexY + i) * 16)
            If NewIndex > -1 Then
                If GetHeight(NewIndex) < FeatureMinHeight Or GetHeight(NewIndex) > FeatureMaxHeight Then
                    Flag = True
                    Exit For
                End If
            End If
            NewIndex = GetMapAttrIndex((IndexX) * 16, (IndexY + i) * 16)
            If NewIndex > -1 Then
                If GetHeight(NewIndex) < FeatureMinHeight Or GetHeight(NewIndex) > FeatureMaxHeight Then
                    Flag = True
                    Exit For
                End If
            End If
            NewIndex = GetMapAttrIndex((IndexX + i) * 16, (IndexY + i) * 16)
            If NewIndex > -1 Then
                If GetHeight(NewIndex) < FeatureMinHeight Or GetHeight(NewIndex) > FeatureMaxHeight Then
                    Flag = True
                    Exit For
                End If
            End If
            NewIndex = GetMapAttrIndex((IndexX - i) * 16, IndexY * 16)
            If NewIndex > -1 Then
                If GetHeight(NewIndex) < FeatureMinHeight Or GetHeight(NewIndex) > FeatureMaxHeight Then
                    Flag = True
                    Exit For
                End If
            End If
            NewIndex = GetMapAttrIndex((IndexX + i) * 16, IndexY * 16)
            If NewIndex > -1 Then
                If GetHeight(NewIndex) < FeatureMinHeight Or GetHeight(NewIndex) > FeatureMaxHeight Then
                    Flag = True
                    Exit For
                End If
            End If
            NewIndex = GetMapAttrIndex((IndexX - i) * 16, (IndexY - i) * 16)
            If NewIndex > -1 Then
                If GetHeight(NewIndex) < FeatureMinHeight Or GetHeight(NewIndex) > FeatureMaxHeight Then
                    Flag = True
                    Exit For
                End If
            End If
            NewIndex = GetMapAttrIndex((IndexX) * 16, (IndexY - i) * 16)
            If NewIndex > -1 Then
                If GetHeight(NewIndex) < FeatureMinHeight Or GetHeight(NewIndex) > FeatureMaxHeight Then
                    Flag = True
                    Exit For
                End If
            End If
            NewIndex = GetMapAttrIndex((IndexX + i) * 16, (IndexY - i) * 16)
            If NewIndex > -1 Then
                If GetHeight(NewIndex) < FeatureMinHeight Or GetHeight(NewIndex) > FeatureMaxHeight Then
                    Flag = True
                    Exit For
                End If
            End If
        Next
        If Not Flag Then
            If GetHeight(SceneIndex) >= FeatureMinHeight And GetHeight(SceneIndex) <= FeatureMaxHeight Then
                Buffer = Rnd * UBound(SelectedFeatures)
                SceneAttr(SceneIndex) = FeatureAdd(Buffer)
            End If
        End If
    Next
    DrawMap
    Exit Sub
    
Error:
    DrawMap
End Sub

Public Sub FeaturesRemoveRegion()
    Dim IndexX As Long, IndexY As Long
    Dim Index As Long
    
    On Error GoTo Error
    If Not Region.Usable Then Exit Sub
    
    For IndexX = Region.Left * 32 To Region.Left * 32 + Region.Width * 32 Step 16
        For IndexY = Region.Top * 32 To Region.Top * 32 + Region.Height * 32 Step 16
            Index = GetMapAttrIndex(IndexX, IndexY)
            If Index >= 0 Then
                If SceneAttr(Index) >= 0 Then
                    SceneAttr(Index) = -1
                End If
            End If
        Next
    Next

Error:
    DrawMap
End Sub

Public Sub FeaturesValidate()

End Sub

Public Sub ClipCopy()
    If Region.Usable Then
        If Not Overlay.RegionTiles Or Not Overlay.RegionHeight Then
            MsgBox "Sections must have both textures and height to be copied.  Change your selection filters.", vbInformation, "Copy to Palette"
            Exit Sub
        End If
        Overlay.SetSection Clip, "Clip"
        Clip.Holds = 32000
    End If
End Sub

Public Sub ClipPaste()
    If Clip.Name = "Clip" Then
        OverlayPaste
        Set Overlay = Clip
        Region.Left = ViewX
        Region.Top = ViewY
        Region.Width = Clip.Width
        Region.Height = Clip.Height
        Region.Usable = True
        Overlay.RegionTiles = PasteTiles
        Overlay.RegionHeight = PasteHeight
        OverlayRefreshView
        DrawMap
        Set SelectedSection = New classSection
        SelectedSection.Holds = SelectedSection.Holds - 1
        SelectedSection.FreeSection
        Sections.CreatePalette
        FrmAnnihilator.CanvasCursor.Visible = False
    End If
End Sub

Public Sub OverlaySetHeight(Value As Byte)
    If Region.Usable Then
        Overlay.HeightSet Value
        DrawMap
    End If
End Sub

Public Sub ResizeMap(NewWidth As Long, NewHeight As Long, Align As Integer, Tile As Boolean)
    Dim NewMapData() As Long
    Dim NewHeightData() As Byte
    Dim NewSceneAttr() As Integer
    Dim x As Long, y As Long
    Dim Index As Long
    
    On Error GoTo Error
    OverlayPaste
'    If Align = 0 Then
'        ResizeLeft MapData(), HeightData(), SceneAttr(), Header(MapWidth), Header(MapHeight), NewWidth * 2, NewHeight * 2, Tile
'    ElseIf Align = 1 Then
'        ResizeCenter MapData(), HeightData(), SceneAttr(), Header(MapWidth), Header(MapHeight), NewWidth * 2, NewHeight * 2, Tile
'    ElseIf Align = 2 Then
'        ResizeRight MapData(), HeightData(), SceneAttr(), Header(MapWidth), Header(MapHeight), NewWidth * 2, NewHeight * 2, Tile
'    End If
    
    ReDim NewMapData(NewWidth * NewHeight - 1)
    ReDim NewHeightData(NewWidth * NewHeight * 4 - 1)
    ReDim NewSceneAttr(NewWidth * NewHeight * 4 - 1)
    
    For y = 0 To NewHeight - 1
        For x = 0 To NewWidth - 1
            If x < Header(MapWidth) / 2 And y < Header(MapHeight) / 2 Then
                NewMapData(x + y * NewWidth) = MapData(x + y * Header(MapWidth) / 2)
            Else
                NewMapData(x + y * NewWidth) = 0
            End If
        Next
    Next
    
    For y = 0 To NewHeight * 2 - 1
        For x = 0 To NewWidth * 2 - 1
            If x < Header(MapWidth) And y < Header(MapHeight) Then
                NewHeightData(x + y * NewWidth * 2) = HeightData(x + y * Header(MapWidth))
                NewSceneAttr(x + y * NewWidth * 2) = SceneAttr(x + y * Header(MapWidth))
            Else
                NewHeightData(x + y * NewWidth * 2) = 0
                NewSceneAttr(x + y * NewWidth * 2) = -1
            End If
        Next
    Next
    
    ReDim MapData(UBound(NewMapData))
    ReDim HeightData(UBound(NewHeightData))
    ReDim SceneAttr(UBound(NewSceneAttr))
    For Index = 0 To UBound(HeightData)
        If Index <= UBound(MapData) Then
            MapData(Index) = NewMapData(Index)
        End If
        HeightData(Index) = NewHeightData(Index)
        SceneAttr(Index) = NewSceneAttr(Index)
    Next
    
Error:
    ScrollMap 0, 0
    Header(MapWidth) = NewWidth * 2
    Header(MapHeight) = NewHeight * 2
    Minimap.HeaderWidth = Header(MapWidth)
    Minimap.HeaderHeight = Header(MapHeight)
    MiniMapCreateDraft
    Refresh
End Sub

Public Sub FeaturesSelect(Area As classRubberband)
    Dim MapPosition As Long, Index As Long
    Dim IndexX As Long, IndexY As Long
    Dim ViewWidth As Long, ViewHeight As Long
    Dim NewX As Long, NewY As Long
    Dim rc As Long
    Dim RegionLeft As Long, RegionTop As Long, RegionWidth As Long, RegionHeight As Long
    Dim FeatureLeft As Long, FeatureTop As Long, FeatureWidth As Long, FeatureHeight As Long
    
    On Error GoTo Error

    ReDim SelectedAttr(0)
    
    If Area.Left >= Header(MapWidth) * 16 Or Area.Top >= Header(MapHeight) * 16 Then Exit Sub
    If Area.Left + Area.Width > Header(MapWidth) * 16 Then
        Area.Width = Header(MapWidth) * 16 - Area.Left
    End If
    If Area.Top + Area.Height > Header(MapHeight) * 16 Then
        Area.Height = Header(MapHeight) * 16 - Area.Top
    End If
    
    Screen.MousePointer = vbHourglass
    DoEvents
    
    RegionLeft = ViewX * 32 + Area.Left
    RegionTop = ViewY * 32 + Area.Top
    RegionWidth = Area.Width
    RegionHeight = Area.Height
    If RegionLeft < 0 Then
        RegionWidth = RegionLeft + RegionWidth
        RegionLeft = 0
    End If
    If RegionTop < 0 Then
        RegionHeight = RegionTop + RegionHeight
        RegionTop = 0
    End If
    If RegionLeft + RegionWidth > Header(MapWidth) * 16 Then
        RegionWidth = Header(MapWidth) * 16 - RegionLeft
    End If
    If RegionTop + RegionHeight > Header(MapHeight) * 16 Then
        RegionHeight = Header(MapHeight) * 16 - RegionTop
    End If

    ViewWidth = Int(FrmAnnihilator.Canvas.ScaleWidth / 16)
    ViewHeight = Int(FrmAnnihilator.Canvas.ScaleHeight / 16)
    MapPosition = GetMapAttrIndex(ViewX * 32, ViewY * 32)

    For IndexY = 0 To (ViewHeight - 1) + 8
        If (IndexY + ViewY * 2) >= Header(MapHeight) Then Exit For
        For IndexX = 0 To (ViewWidth - 1) + 1
            If (IndexX + ViewX * 2) >= Header(MapWidth) Then Exit For
            Index = MapPosition + IndexX
            If SceneAttr(Index) > -1 Then
                FeatureLeft = ViewX * 32 + IndexX * 16 - MapFeatures(SceneAttr(Index) + 1).PositionX + MapFeatures(SceneAttr(Index) + 1).FootprintX * 8
                FeatureTop = ViewY * 32 + IndexY * 16 - CInt(GetHeight(Index) / 2) - MapFeatures(SceneAttr(Index) + 1).PositionY + MapFeatures(SceneAttr(Index) + 1).FootprintY * 8
                FeatureWidth = MapFeatures(SceneAttr(Index) + 1).Width
                FeatureHeight = MapFeatures(SceneAttr(Index) + 1).Height
                If (((FeatureLeft >= RegionLeft) And (FeatureLeft <= RegionLeft + RegionWidth)) Or ((FeatureLeft + FeatureWidth >= RegionLeft) And (FeatureLeft + FeatureWidth <= RegionLeft + RegionWidth))) Or (((RegionLeft >= FeatureLeft) And (RegionLeft <= FeatureLeft + FeatureWidth)) Or ((RegionLeft + RegionWidth >= FeatureLeft) And (RegionLeft + RegionWidth <= FeatureLeft + FeatureWidth))) Then
                    If (((FeatureTop >= RegionTop) And (FeatureTop <= RegionTop + RegionHeight)) Or ((FeatureTop + FeatureHeight >= RegionTop) And (FeatureTop + FeatureHeight <= RegionTop + RegionHeight))) Or (((RegionTop >= FeatureTop) And (RegionTop <= FeatureTop + FeatureHeight)) Or ((RegionTop + RegionHeight >= FeatureTop) And (RegionTop + RegionHeight <= FeatureTop + FeatureHeight))) Then
                        ReDim Preserve SelectedAttr(UBound(SelectedAttr) + 1)
                        SelectedAttr(UBound(SelectedAttr)) = Index
                    End If
                End If
            End If
        Next
        MapPosition = MapPosition + Header(MapWidth)
    Next
    DrawMap
    
Error:
    Screen.MousePointer = vbNormal
End Sub
