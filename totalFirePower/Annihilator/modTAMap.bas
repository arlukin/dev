Attribute VB_Name = "modTAMap"
' TA map module. '

Option Explicit

' TNT header constants. '
Global Const IDiversion = 0
Global Const MapWidth = 1
Global Const MapHeight = 2
Global Const PTRMapData = 3
Global Const PTRMapAttr = 4
Global Const PTRTileGfx = 5
Global Const Tiles = 6
Global Const TileAnims = 7
Global Const PTRTileAnim = 8
Global Const SeaLevel = 9
Global Const PTRMiniMap = 10
Global Const hBool = 11

' OTA file constants. '
Global Const otaMissionName = 1
Global Const otaMissionDescription = 2
Global Const otaPlanet = 3
Global Const otaMissionHint = 4
Global Const otaBrief = 5
Global Const otaNarration = 6
Global Const otaGlamour = 7
Global Const otaLineOfSight = 8
Global Const otaMapping = 9
Global Const otaTidalStrength = 10
Global Const otaSolarStrength = 11
Global Const otaLavaWorld = 12
Global Const otaKillMul = 13
Global Const otaTimeMul = 14
Global Const otaMinWindSpeed = 15
Global Const otaMaxWindSpeed = 16
Global Const otaGravity = 17
Global Const otaWaterDoesDamage = 18
Global Const otaWaterDamage = 19
Global Const otaNumPlayers = 20
Global Const otaSize = 21
Global Const otaMemory = 22
Global Const otaUseOnlyUnits = 23
Global Const otaDestroyAllUnits = 24
Global Const otaAllUnitsKilled = 25
Global Const otaType = 26
Global Const otaAIProfile = 27
Global Const otaSurfaceMetal = 28
Global Const otaMohoMetal = 29
Global Const otaHumanMetal = 30
Global Const otaComputerMetal = 31
Global Const otaHumanEnergy = 32
Global Const otaComputerEnergy = 33
Global Const otaMeteorWeapon = 34
Global Const otaMeteorRadius = 35
Global Const otaMeteorDensity = 36
Global Const otaMeteorDuration = 37
Global Const otaMeteorInterval = 38

' Map types. '
Type MeshRecord
    x As Byte
    y As Byte
    V As Byte
    E As Boolean
End Type

' Maps. '
Global Maps() As New classTAMap
Global SelectedMap As Long

' Minimap globals. '
Global PicMiniMap As PictureBox
Global View As Shape

' Flags. '
Global NoScroll As Boolean ' Do not scroll map when set. '

Public Sub InitializeMaps()
    ReDim Maps(0)
    SelectedMap = -1
End Sub

' Returns whether a map is open or not. '
Public Function MapLoaded() As Boolean
    Dim Index As Integer
    
    On Error GoTo Error
    MapLoaded = False
    For Index = 0 To UBound(Maps)
        If Maps(Index).MapLoaded Then
            MapLoaded = True
            Exit Function
        End If
    Next
Error:
End Function

' Load a map. '
Public Function LoadMap(Filename As String, Optional HPI As Long = -1, Optional HPIFilename As String = "") As Boolean
    Dim Index As Integer, Flag As Boolean
    
    Flag = False
    For Index = 0 To UBound(Maps)
        If Not Maps(Index).MapLoaded Then
            If HPI > 0 Then
                Maps(Index).LoadMapHPI HPIFilename, HPI, Filename
            Else
                Maps(Index).LoadMap Filename
            End If
            If Not Maps(Index).MapLoaded Then
                LoadMap = False
                Exit Function
            End If
            Flag = True
            Exit For
        End If
    Next
    
    If Not Flag Then ' Add a new map to the array. '
        ReDim Preserve Maps(UBound(Maps) + 1)
        Index = UBound(Maps)
        If HPI > 0 Then
            Maps(Index).LoadMapHPI HPIFilename, HPI, Filename
        Else
            Maps(Index).LoadMap Filename
        End If
        If Not Maps(Index).MapLoaded Then
            LoadMap = False
            Exit Function
        End If
    End If
    
    SelectedMap = Index
    LoadMap = True
    UpdateMapTabs
End Function

Public Sub SaveMap(Optional Filename As String = "", Optional CompressType As Integer = ZLIB_COMPRESSION)
    On Error Resume Next
    If Filename <> "" Then
        Maps(SelectedMap).MapFilename = Left(Filename, Len(Filename) - 4)
    End If
    Maps(SelectedMap).SaveMap , CompressType
    UpdateMapTabs
End Sub

' Create a map. '
Public Sub CreateMap(Width As Long, Height As Long)
    Dim Index As Integer, Flag As Boolean
    
    Flag = False
    For Index = 0 To UBound(Maps)
        If Not Maps(Index).MapLoaded Then
            Maps(Index).CreateNewMap Width, Height
            Flag = True
            Exit For
        End If
    Next
    
    If Not Flag Then ' Add a new map to the array. '
        ReDim Preserve Maps(UBound(Maps) + 1)
        Index = UBound(Maps)
        Maps(Index).CreateNewMap Width, Height
    End If
    
    SelectedMap = Index
    UpdateMapTabs
End Sub

' Create a map from a BMP file. '
Public Sub CreateMapFromBMP(Heightmap As String)
    Dim Index As Integer, Flag As Boolean
    
    Flag = False
    For Index = 0 To UBound(Maps)
        If Not Maps(Index).MapLoaded Then
            Maps(Index).CreateNewMapFromBMP
            Maps(Index).HeightMapImport Heightmap
            Flag = True
            Exit For
        End If
    Next
    
    If Not Flag Then ' Add a new map to the array. '
        ReDim Preserve Maps(UBound(Maps) + 1)
        Index = UBound(Maps)
        Maps(Index).CreateNewMapFromBMP
        Maps(Index).HeightMapImport Heightmap
    End If
    
    SelectedMap = Index
    UpdateMapTabs
End Sub

' Close map. '
Sub CloseMap(Index As Integer)
    Dim i As Integer
    
    If Index <= UBound(Maps) Then
        If Maps(Index).MapLoaded Then
            Maps(Index).MapClose
        End If
    End If
    
    ' Select the next available map. '
    SelectedMap = -1
    For i = UBound(Maps) To 0 Step -1
        If Maps(i).MapLoaded Then SelectedMap = i
    Next
    UpdateMapTabs
    InterfaceUpdate
End Sub

' Refresh the selected map. '
Public Sub RefreshMap()
    On Error Resume Next
    If SelectedMap < 0 Then Exit Sub
    Maps(SelectedMap).DrawMap
End Sub

' Compress the selected map. '
Public Sub CompressMap()
    On Error Resume Next
    Screen.MousePointer = vbHourglass
    Maps(SelectedMap).CompressMap
    Screen.MousePointer = vbNormal
End Sub

' HPI save callback. '
Public Function HPICallBack(XFileName As CString, XHPIName As CString, ByVal FileCount As Long, ByVal FileCountTotal As Long, ByVal FileBytes As Long, ByVal FileBytesTotal As Long, ByVal TotalBytes As Long, ByVal TotalBytesTotal As Long) As Long
    FrmProgress.Update TotalBytes, TotalBytesTotal
End Function

' Status callback. '
Public Sub CallbackStatus(ByVal Value As Long, ByVal Max As Long)
    FrmProgress.Update Value, Max
End Sub
