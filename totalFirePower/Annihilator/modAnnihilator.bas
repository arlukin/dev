Attribute VB_Name = "modAnnihilator"
' Annihilator globals, declarations. '

Option Explicit

Global Const ProgramName = "Annihilator"
Global Const ProgramVersion = "1.0"


''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Annihilator Global Types Section:

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Annihilator Declares Section:

' Annihilator.dll '
Declare Sub WriteTile Lib "annihilator.dll" (ByVal xPos As Long, ByVal yPos As Long, ByVal xWidth As Long, ByVal yWidth As Long, ByVal BmpWidth As Long, ByVal BmpHeight As Long, ByVal pBitmap As Long, TileData As Byte)
Declare Sub ClearTile Lib "annihilator.dll" (ByVal xPos As Long, ByVal yPos As Long, ByVal xWidth As Long, ByVal yWidth As Long, ByVal BmpWidth As Long, ByVal BmpHeight As Long, ByVal pBitmap As Long, TileData As Byte, ByVal MaskColor As Byte, ByVal BackColor As Byte, ByVal ClearFlag As Long)
Declare Sub MaskTile Lib "annihilator.dll" (ByVal xPos As Long, ByVal yPos As Long, ByVal xWidth As Long, ByVal yWidth As Long, ByVal BmpWidth As Long, ByVal BmpHeight As Long, ByVal pBitmap As Long, TileData As Byte, ByVal MaskColor As Byte, ByVal NewColor As Byte)
Declare Sub DrawLine Lib "annihilator.dll" (ByVal x1 As Long, ByVal y1 As Long, ByVal x2 As Long, ByVal y2 As Long, ByVal Color As Byte, ByVal BmpWidth As Long, ByVal BmpHeight As Long, ByVal pBitmap As Long)
Declare Sub WritePixel Lib "annihilator.dll" (ByVal pBitmap As Long, ByVal position As Long, ByVal Value As Byte)
Declare Sub GetRegion Lib "annihilator.dll" (ByVal xPos As Long, ByVal yPos As Long, ByVal RegionWidth As Long, ByVal RegionHeight As Long, ByVal Width As Long, ByVal Height As Long, ByVal pBitmap As Long, ByRef Buffer As Byte)
Declare Sub CreateTilesFromBmp Lib "annihilator.dll" (pBitmap As Byte, pTiles As Byte, ByVal BmpWidth As Long, ByVal BmpHeight As Long)
Declare Sub ConvertPalette Lib "annihilator.dll" (ByRef Image As Byte, ByVal MaxValue As Long, ByRef BmpPalette As RGBQUAD, ByRef TAPalette As RGBQUAD)
Declare Sub CreateTileChecksumList Lib "annihilator.dll" (ByRef TileData As Byte, ByRef TileList As Long, ByVal MaxTileList As Long)
Declare Sub GAFImageLoad Lib "annihilator.dll" (ByVal Filename As String, ByVal ImagePTR As Long, ByRef Buffer As Byte)
Declare Sub CopyArray Lib "annihilator.dll" (ByRef ArrayDest As Any, ByRef ArraySrc As Any, ByVal Size As Long)
Declare Sub BlockCreate Lib "annihilator.dll" (ByVal Size As Long)
Declare Sub BlockWrite Lib "annihilator.dll" (ByRef Data As Any, ByVal position As Long, ByVal DataSize As Long)
Declare Function BlockGet Lib "annihilator.dll" () As Long
Declare Function BlockExport Lib "annihilator.dll" (ByVal Filename As String) As Long
Declare Sub BlockFree Lib "annihilator.dll" ()
Declare Sub MiniGenerateFinal Lib "annihilator.dll" (ByRef MapData As Long, ByRef TileData As Byte, ByRef Minimap As Byte, ByVal MapWidth As Long, ByVal MapHeight As Long, ByRef TAPalette As RGBQUAD, ByVal Callback As Any, ByVal MaxTile As Long)

' General Declares. '
Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (hpvDest As Any, hpvSource As Any, ByVal cbCopy As Long)

' Open default viewer application. '
Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long
Global Const SW_NORMAL = 1

' Odd-window region. '
Declare Function SetWindowRgn Lib "user32" (ByVal hwnd As Long, ByVal hRgn As Long, ByVal bRedraw As Boolean) As Long
Declare Function CreateEllipticRgn Lib "gdi32" (ByVal x1 As Long, ByVal y1 As Long, ByVal x2 As Long, ByVal y2 As Long) As Long
Declare Function CreateRoundRectRgn Lib "gdi32" (ByVal x1 As Long, ByVal y1 As Long, ByVal x2 As Long, ByVal y2 As Long, ByVal X3 As Long, ByVal Y3 As Long) As Long
Declare Function CreatePolygonRgn Lib "gdi32" (lpPoint As POINTAPI, ByVal nCount As Long, ByVal nPolyFillMode As Long) As Long

' Child window function. '
Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long, ByVal wNewLong As Long) As Long
Global Const GWW_HWNDPARENT = (-8)


''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Annihilator Options Section:

' Memory options. '
Global RetainFeatures As Boolean

' Startup Locations. '
Global StartupLocations() As String

' File locations. '
Global InitFileOpenDir As String
Global InitFileSaveDir As String
Global InitFileHPIDir As String

' Misc. '
Global LastDocs(3) As String


''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Annihilator Tools Section:

' Constants. '
Global Const ToolDefault = 0
Global Const ToolSelection = 1
Global Const ToolRegion = 2
Global Const ToolOddRegion = 3

Global Const ToolSections = 10
Global Const ToolFeatures = 11
Global Const ToolHeight = 12
Global Const ToolVoid = 13
Global Const ToolSpecial = 14
Global Const ToolTiles = 15
Global Const ToolClone = 16

' Selected tool items. '
Global SelectedTool As Integer ' The selected map editing tool. '
Global SelectedItem As Integer ' The selected item. '

Global SelectedSection As New classSection
Global SelectedFeatures() As New classFeature
Global SelectedPlayer As Byte ' The selected player. '

Global SelectedSectionCategory As String ' The selected category tab. '
Global SelectedSectionWorld As String ' The selected world tab. '
Global SelectedFeatureCategory As String ' The selected category tab. '
Global SelectedFeatureWorld As String ' The selected world tab. '

' Cursor size. '
Global CursorWidth As Long
Global CursorHeight As Long
Global ZoomValue As Long

' Clone tool. '
Global CloneTiles As Boolean
Global CloneHeight As Boolean
Global CloneAnims As Boolean
Global CloneIndex As Long
Global CloneStart As Long

' Features. '
Global FeatureDensity As Integer
Global FeatureRadius As Integer
Global FeatureMinHeight As Byte
Global FeatureMaxHeight As Byte
Global FeaturePadding As Integer

' Height editing. '
Global HeightCursorSize As Integer
Global HeightVoid As Boolean
Global HeightInterval As Byte
Global HeightEditArea As Boolean
Global HeightMeshInterval As Byte
Global HeightSwitchColors As Boolean
Global HeightWater() As Byte
Global HeightLand() As Byte

' Player colors. '
Global Players(10) As Byte

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Annihilator FastWin Graphics Section:

Global Const Canvas = 0 ' The main view. '
Global Const Minimap = 1 ' Docked minimap. '
Global Const PaletteSections = 2 ' Section palette. '
Global Const PaletteFeatures = 3 ' Features palette. '
Global Const PaletteSpecials = 4 ' Specials palette. '
Global Const PaletteTiles = 5 ' Tile palette. '


''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Annihilator Globals Section:

' Miscelaneous. '
Global TAPalette(255) As RGBQUAD ' The palette for everything (TM). '
Global DirectoryReturn As String ' The directory returned by FrmDirectory. '
Global StartingTile(1023) As Byte ' The bitmap the holds the starting location icon. '
Global WhiteTile(1023) As Byte
Global ViewMinimap As Boolean
Global AITypes() As String
Global NoUpdate As Boolean ' Do not update the startup dialog. '
Global IgnoreWorlds() As String ' Ignore feature worlds on load. '

' Child windows. '
Global OriginalParenthWndMiniMap As Long

' Overlay (view) options. '
Global OverGrid As Boolean
Global OverHeight As Boolean
Global OverContour As Boolean
Global OverFeatures As Boolean
Global OverSpecials As Boolean

Global GridSizeX As Integer
Global GridSizeY As Integer

Global MiniSize As Integer

Global PasteTiles As Boolean
Global PasteHeight As Boolean
Global PasteFeatures As Boolean

' Get the location of TA. '
Public Function TALocation() As String
    Dim Buffer As CString, Location As String
    
    GetTADirectory Buffer
    Location = MakeVBString(Buffer)
    If Right(Location, 1) <> "\" Then
        TALocation = Location & "\"
    Else
        TALocation = Location
    End If
    If TALocation = "\" Then TALocation = ""
End Function

