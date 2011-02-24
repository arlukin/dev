VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "classMinimap"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Minimap class. '

Option Explicit

' Mini-map. '
Public MiniMapWidth As Long
Public MiniMapHeight As Long
Public MiniMapScaleWidth As Long
Public MiniMapScaleHeight As Long
Public TNTMapWidth As Long
Public TNTMapHeight As Long

Public HeaderWidth As Long
Public HeaderHeight As Long

Private MiniMapBuffer(63503) As Byte
Private MinimapDest As PictureBox
Private MinimapView As Shape

Sub MiniMapCalculateDimensions()
    TNTMapWidth = (HeaderWidth * 16) - 32
    TNTMapHeight = (HeaderHeight * 16) - 128
    
    If TNTMapWidth > TNTMapHeight Then ' It will be 252 across. '
        MiniMapWidth = 252
        MiniMapHeight = Int((MiniMapWidth * TNTMapHeight) / TNTMapWidth)
    ElseIf TNTMapHeight > TNTMapWidth Then
        MiniMapHeight = 252
        MiniMapWidth = Int((MiniMapHeight * TNTMapWidth) / TNTMapHeight)
    ElseIf TNTMapWidth = TNTMapHeight Then
        MiniMapWidth = 252
        MiniMapHeight = 252
    End If
    MiniMapResizeScale
End Sub

Sub MiniMapDrawCanvasView(x As Long, y As Long, Optional CanvasCoord As Boolean = False)
    Dim xCanvas As Long, yCanvas As Long

    On Error Resume Next
    If CanvasCoord Then
        xCanvas = x
        yCanvas = y
    Else
        xCanvas = Int(((x * TNTMapWidth) / MiniMapScaleWidth) / 32)
        yCanvas = Int(((y * TNTMapHeight) / MiniMapScaleHeight) / 32)
    End If
    If xCanvas > FrmAnnihilator.CanvasHScroll.Max Then
        xCanvas = FrmAnnihilator.CanvasHScroll.Max
    End If
    If yCanvas > FrmAnnihilator.CanvasVScroll.Max Then
        yCanvas = FrmAnnihilator.CanvasVScroll.Max
    End If
    View.Visible = False
    Maps(SelectedMap).ScrollMap xCanvas, yCanvas
    View.Visible = True
End Sub

Public Sub MiniMapGenerateDraft(MapData() As Long, TileData() As Byte)
    Dim IndexX As Long, IndexY As Long
    Dim PosX As Single, PosY As Single
    Dim position As Long
    Dim TileIndex As Long
    Dim Buffer As Byte, lBuffer As Long
    Dim TileX As Long, TileY As Long
    Dim MiniStepX As Single, MiniStepY As Single
    Dim MiniIndex As Long
    
    On Error GoTo Error
    
    MiniMapCalculateDimensions
    For position = 0 To UBound(MiniMapBuffer)
        MiniMapBuffer(position) = 100
    Next

    ' Create the new mini map. '
    PosX = 0
    PosY = 0
    position = 0
    TileIndex = 0
    For IndexY = 0 To MiniMapHeight - 1
        For IndexX = 0 To MiniMapWidth - 1
            TileX = Int(PosX) - Int(32 * Int(PosX / 32))
            TileY = Int(PosY) - Int(32 * Int(PosY / 32))
            If TileX >= 32 Then TileX = 32
            If TileY >= 32 Then TileY = 32
            TileIndex = (Int(PosY / 32) * HeaderWidth / 2) + Int(PosX / 32)
            lBuffer = MapData(TileIndex)
            Buffer = TileData(lBuffer * 1024 + ((TileY * 32) + TileX))
            MiniMapBuffer(position + IndexX) = Buffer
            PosX = PosX + TNTMapWidth / MiniMapWidth
            If PosX >= TNTMapWidth Then PosX = TNTMapWidth - 1
          Next
        position = position + 252
        PosX = 0
        PosY = PosY + TNTMapHeight / MiniMapHeight
        If PosY >= TNTMapHeight Then PosY = TNTMapHeight - 1
    Next

Error:
    ' Draw the mini-map. '
    MiniMapRefresh
End Sub

Sub MiniMapGenerateFinal(MapData() As Long, TileData() As Byte)
    Dim IndexX As Long, IndexY As Long, Index As Long, i As Long
    Dim PosX As Long, PosY As Long
    Dim position As Long
    Dim TileIndex As Long
    Dim Buffer As Byte
    Dim TileX As Long, TileY As Long
    Dim MiniStepX As Long, MiniStepY As Long
    Dim MiniIndex As Long
    Dim ColorCount() As Long
    Dim AvgColors() As Byte, AvgR As Long, AvgG As Long, AvgB As Long
    Dim ThisVal As Long, BestMatchVal As Long, BestMatch As Byte
    Dim Value As Single
    
    On Error GoTo Error
    
    FrmProgress.Caption = "Creating Minimap"
    FrmProgress.Status = "Generating..."
    FrmProgress.Progress.Value = 0
    FrmProgress.Show , FrmAnnihilator
    Screen.MousePointer = vbHourglass
    DoEvents
    
    'MiniGenerateFinal2 MapData(), TileData()
    'MiniGenerateFinal MapData(0), TileData(0), MiniMapBuffer(0), HeaderWidth, HeaderHeight, TAPalette(0), AddressOf CallbackStatus, UBound(TileData) + 1
    'MiniMapRefresh
    'Unload FrmProgress
    'Screen.MousePointer = vbNormal
    'Exit Sub
    
    ' initialize. '
    MiniMapCalculateDimensions
    For position = 0 To UBound(MiniMapBuffer)
        MiniMapBuffer(position) = 100
    Next

    ' get the average color index list for tiles. '
    FrmProgress.Caption = "Creating Minimap"
    FrmProgress.Status = "Creating average tile color table..."
    FrmProgress.Progress.Value = 0
    FrmProgress.Show
    Screen.MousePointer = vbHourglass
    DoEvents
    ReDim AvgColors(CInt((UBound(TileData) + 1) / 1024) - 1)
    For Index = 0 To UBound(AvgColors)
        AvgR = 0
        AvgG = 0
        AvgB = 0
        For i = 0 To 1023
            AvgR = AvgR + TAPalette(TileData(Index * 1024 + i)).rgbRed
            AvgG = AvgG + TAPalette(TileData(Index * 1024 + i)).rgbGreen
            AvgB = AvgB + TAPalette(TileData(Index * 1024 + i)).rgbBlue
        Next
        AvgR = AvgR / 1024
        AvgG = AvgG / 1024
        AvgB = AvgB / 1024
        ' find the color that matches the nearest in the palette. '
        BestMatchVal = 10000
        For i = 0 To 255
            ThisVal = Abs(AvgR - TAPalette(i).rgbRed) + Abs(AvgG - TAPalette(i).rgbGreen) + Abs(AvgB - TAPalette(i).rgbBlue)
            If ThisVal < BestMatchVal Then
                BestMatchVal = ThisVal
                BestMatch = i
            End If
        Next
        AvgColors(Index) = BestMatch
        Value = Index
        FrmProgress.Progress.Value = CInt((Value / UBound(AvgColors)) * 100)
        DoEvents
    Next

    ' create the mini map. '
    FrmProgress.Caption = "Creating Minimap"
    FrmProgress.Status = "Generating Minimap..."
    FrmProgress.Progress.Value = 0
    DoEvents
    MiniIndex = 0
    MiniStepX = Int(TNTMapWidth / MiniMapWidth)
    MiniStepY = Int(TNTMapHeight / MiniMapHeight)
    For IndexY = 0 To HeaderHeight * 16 - 1 Step MiniStepY
        MiniIndex = Int(IndexY / MiniStepY) * 252
        For IndexX = 0 To HeaderWidth * 16 - 1 Step MiniStepX
            TileIndex = GetMapIndex(IndexX, IndexY)
            If MiniIndex <= UBound(MiniMapBuffer) And TileIndex > -1 Then
                MiniMapBuffer(MiniIndex) = AvgColors(MapData(TileIndex))
                MiniIndex = MiniIndex + 1
            Else
                Exit For
            End If
        Next
        Value = IndexY
        FrmProgress.Progress.Value = CInt((Value / Int(HeaderHeight * 16) * 100))
        DoEvents
    Next

Error:
    ' draw the mini map. '
    MiniMapRefresh
    Unload FrmProgress
    Screen.MousePointer = vbNormal
End Sub

Sub MiniGenerateFinal2(MapData() As Long, TileData() As Byte)
    Dim TNTMapWidth As Long, TNTMapHeight As Long
    Dim MiniMapWidth As Long, MiniMapHeight As Long
    Dim MiniIndex As Long, MiniIndexX As Long, MiniStepX As Long, MiniStepY As Long
    Dim IndexX As Long, IndexY As Long, StepX As Long, StepY As Long, i As Long, k As Long
    Dim AvgR() As Long, AvgG() As Long, AvgB() As Long, AvgCount() As Long
    Dim difR As Long, difG As Long, difB As Long, dif As Long, difIndex As Long
    Dim TileIndex As Long, PosX As Long, PosY As Long
    Dim TempX As Long, TempY As Long
    Dim MapIndex As Long
    Dim PaletteIndex As Byte
    Dim MiniBound As Long
    On Error GoTo Error
    
    ' Initialize. '
    TNTMapWidth = (HeaderWidth * 16) - 32
    TNTMapHeight = (HeaderHeight * 16) - 128
    If (TNTMapWidth > TNTMapHeight) Then ' It will be 252 across.
        MiniMapWidth = 252
        MiniMapHeight = ((MiniMapWidth * TNTMapHeight) / TNTMapWidth)
    ElseIf (TNTMapHeight > TNTMapWidth) Then
        MiniMapHeight = 252
        MiniMapWidth = ((MiniMapHeight * TNTMapWidth) / TNTMapHeight)
    ElseIf (TNTMapWidth = TNTMapHeight) Then
        MiniMapWidth = 252
        MiniMapHeight = 252
    End If
    
    MiniBound = 252
    MiniBound = MiniBound * 252
    For i = 0 To MiniBound - 1
        MiniMapBuffer(i) = 100
    Next
    
    ReDim AvgR(MiniBound - 1)
    ReDim AvgG(MiniBound - 1)
    ReDim AvgB(MiniBound - 1)
    ReDim AvgCount(MiniBound - 1)
    
    PosY = 0
    MiniIndex = 0
    MiniStepX = (TNTMapWidth / MiniMapWidth)
    MiniStepY = (TNTMapHeight / MiniMapHeight)
    For IndexY = 0 To TNTMapHeight - 1
        PosX = 0
        TileIndex = Int(IndexY / 32)
        TileIndex = TileIndex * (HeaderWidth / 2)
        MiniIndex = (IndexY / MiniStepY) * 252
        If (MiniIndex >= (MiniBound)) Then Exit For
        CallbackStatus IndexY * TNTMapWidth, TNTMapWidth * TNTMapHeight
        For IndexX = 0 To TNTMapWidth - 1
            MiniIndexX = Int(IndexX / MiniStepX)
            If (MiniIndexX >= 252) Then MiniIndexX = 251

            MapIndex = MapData(TileIndex) * 1024 + PosY * 32 + PosX
            If ((MapIndex < UBound(TileData) + 1) And (MapIndex >= 0)) Then
                PaletteIndex = TileData(MapIndex)
                AvgR(MiniIndex + MiniIndexX) = AvgR(MiniIndex + MiniIndexX) + TAPalette(PaletteIndex).rgbRed
                AvgG(MiniIndex + MiniIndexX) = AvgG(MiniIndex + MiniIndexX) + TAPalette(PaletteIndex).rgbGreen
                AvgB(MiniIndex + MiniIndexX) = AvgB(MiniIndex + MiniIndexX) + TAPalette(PaletteIndex).rgbBlue
                AvgCount(MiniIndex + MiniIndexX) = AvgCount(MiniIndex + MiniIndexX) + 1
            End If
            PosX = PosX + 1
            If (PosX = 32) Then
                PosX = 0
                TileIndex = TileIndex + 1
            End If
        Next
        PosY = PosY + 1
        If (PosY = 32) Then PosY = 0
    Next

    For i = 0 To MiniBound - 1
        CallbackStatus i, MiniBound - 1
        AvgR(i) = AvgR(i) / AvgCount(i)
        AvgG(i) = AvgG(i) / AvgCount(i)
        AvgB(i) = AvgB(i) / AvgCount(i)
        dif = 10000
        difIndex = 0
        For k = 0 To 255
            difR = Abs(AvgR(i) - TAPalette(k).rgbRed)
            difG = Abs(AvgG(i) - TAPalette(k).rgbGreen)
            difB = Abs(AvgB(i) - TAPalette(k).rgbBlue)
            If ((difR + difG + difB) < dif) Then
                dif = difR + difG + difB
                difIndex = k
            End If
        Next
        MiniMapBuffer(i) = difIndex
    Next
    Exit Sub
Error:
    'MsgBox Err.Description
    Resume Next
End Sub

Sub MinimapDrawStartingLocations(PlayerPosX() As Long, PlayerPosY() As Long)
    Dim Index As Integer
    Dim xValue As Long, yValue As Long

    ' Draw the starting locations. '
    For Index = 1 To 10
        If PlayerPosX(Index) > 0 And PlayerPosY(Index) > 0 Then
            xValue = Int((MiniMapScaleWidth * PlayerPosX(Index)) / TNTMapWidth)
            yValue = Int((MiniMapScaleHeight * PlayerPosY(Index)) / TNTMapHeight)
            'PicMiniMap.PSet (xValue, yValue), RGB(TAPalette(Players(Index)).rgbRed, TAPalette(Players(Index)).rgbGreen, TAPalette(Players(Index)).rgbBlue)
            PicMiniMap.PSet (xValue - 1, yValue), RGB(TAPalette(Players(Index)).rgbRed, TAPalette(Players(Index)).rgbGreen, TAPalette(Players(Index)).rgbBlue)
            PicMiniMap.PSet (xValue + 1, yValue), RGB(TAPalette(Players(Index)).rgbRed, TAPalette(Players(Index)).rgbGreen, TAPalette(Players(Index)).rgbBlue)
            PicMiniMap.PSet (xValue, yValue - 1), RGB(TAPalette(Players(Index)).rgbRed, TAPalette(Players(Index)).rgbGreen, TAPalette(Players(Index)).rgbBlue)
            PicMiniMap.PSet (xValue, yValue + 1), RGB(TAPalette(Players(Index)).rgbRed, TAPalette(Players(Index)).rgbGreen, TAPalette(Players(Index)).rgbBlue)
            PicMiniMap.PSet (xValue + 1, yValue + 1), RGB(TAPalette(Players(Index)).rgbRed, TAPalette(Players(Index)).rgbGreen, TAPalette(Players(Index)).rgbBlue)
            PicMiniMap.PSet (xValue - 1, yValue + 1), RGB(TAPalette(Players(Index)).rgbRed, TAPalette(Players(Index)).rgbGreen, TAPalette(Players(Index)).rgbBlue)
            PicMiniMap.PSet (xValue - 1, yValue - 1), RGB(TAPalette(Players(Index)).rgbRed, TAPalette(Players(Index)).rgbGreen, TAPalette(Players(Index)).rgbBlue)
            PicMiniMap.PSet (xValue + 1, yValue - 1), RGB(TAPalette(Players(Index)).rgbRed, TAPalette(Players(Index)).rgbGreen, TAPalette(Players(Index)).rgbBlue)
        End If
    Next
End Sub

Sub MiniMapDrawAnimations()
    Dim Index As Long
    Dim xValue As Long, yValue As Long
    Dim Color As Byte

'    Color = 250
'    If SelectedAnimation = -1 Then Exit Sub
'    For Index = 0 To UBound(SceneAttr)
'        If SceneAttr(Index) = SelectedAnimation Then
'            yValue = Int(Index / HeaderWidth) * 16
'            xValue = (Index Mod HeaderWidth) * 16
'            xValue = Int((MiniMapWidth * xValue) / TNTMapWidth)
'            yValue = Int((MiniMapHeight * yValue) / TNTMapHeight)
'            'WritePixel addrMiniMap, yValue * 252 + xValue, Color
'        End If
'    Next
End Sub

' Calculate the scale width/height of the mini map if it was resized. '
Public Sub MiniMapResizeScale()
    Dim Value As Long
    
    If Not ViewMinimap Then Exit Sub
    TNTMapWidth = HeaderWidth * 16 - 32
    TNTMapHeight = HeaderHeight * 16 - 128

    Value = PicMiniMap.ScaleHeight
    If TNTMapWidth > TNTMapHeight Then ' It will be 252 across. '
        MiniMapScaleWidth = Value
        MiniMapScaleHeight = CInt((MiniMapScaleWidth * TNTMapHeight) / TNTMapWidth)
    ElseIf TNTMapHeight > TNTMapWidth Then
        MiniMapScaleHeight = Value
        MiniMapScaleWidth = CInt((MiniMapScaleHeight * TNTMapWidth) / TNTMapHeight)
    ElseIf TNTMapWidth = TNTMapHeight Then
        MiniMapScaleWidth = Value
        MiniMapScaleHeight = Value
    End If
End Sub

' Update the size of the mini map view rectangle. '
Public Sub MiniMapUpdateView(Optional x As Single, Optional y As Single, Optional CanvasCoord As Boolean = False, Optional Use As Boolean = True)
    Dim NewX As Long, NewY As Long
    Dim ViewWidth As Long, ViewHeight As Long
    
    MiniMapResizeScale
    ViewWidth = 32 * Int(FrmAnnihilator.Canvas.ScaleWidth / 32)
    ViewHeight = 32 * Int(FrmAnnihilator.Canvas.ScaleHeight / 32)
    ViewWidth = CInt((ViewWidth * MiniMapScaleWidth) / TNTMapWidth)
    ViewHeight = CInt((ViewHeight * MiniMapScaleHeight) / TNTMapHeight)
    View.Width = ViewWidth + 1
    View.Height = ViewHeight + 1
    If Not Use Then Exit Sub
    
    If Not CanvasCoord Then
        NewX = x - Int(ViewWidth / 2)
        NewY = y - Int(ViewHeight / 2)
        If (NewX + ViewWidth) > MiniMapScaleWidth Then
            NewX = MiniMapScaleWidth - ViewWidth
        End If
        If (NewY + ViewHeight) > MiniMapScaleHeight Then
            NewY = MiniMapScaleHeight - ViewHeight
        End If
        If NewX < 0 Then NewX = 0
        If NewY < 0 Then NewY = 0
    Else
        NewX = x
        NewY = y
    End If
    
    MiniMapDrawCanvasView NewX, NewY, CanvasCoord
End Sub

' Move the mini-map view to match scroll position. '
Public Sub MiniMapViewPosition()
    Dim xIndex As Long
    Dim yIndex As Long
    
    MiniMapResizeScale
    xIndex = FrmAnnihilator.CanvasHScroll.Value
    yIndex = FrmAnnihilator.CanvasVScroll.Value
    xIndex = xIndex * 32
    yIndex = yIndex * 32
    
    View.Left = Int((xIndex * MiniMapScaleWidth) / TNTMapWidth)
    View.Top = Int((yIndex * MiniMapScaleHeight) / TNTMapHeight)
    MiniMapUpdateView , , , False
End Sub

Sub MiniMapRefresh()
    If Not ViewMinimap Then Exit Sub
    MiniMapCalculateDimensions
    Screens(Minimap).TileDraw 0, 0, 252, 252, MiniMapBuffer()
    PicMiniMap.Picture = FrmAnnihilator.PicToolbox.Picture
    PicMiniMap.Cls
    Screens(Minimap).Show PicMiniMap.hdc, 0, 0, MiniMapScaleWidth, MiniMapScaleHeight, 0, 0, MiniMapWidth, MiniMapHeight, True
    PicMiniMap.Picture = PicMiniMap.Image
    'PicMiniMap.Refresh
End Sub

Sub MiniMapLoad(ByVal FileHandle As Long, Optional HPIFlag As Boolean = False, Optional Pointer As Long = 0)
    ' Get the Mini Map data. '
    If HPIFlag Then
        HPIGet MiniMapBuffer(0), FileHandle, Pointer + 8, UBound(MiniMapBuffer) + 1
    Else
        Get FileHandle, , MiniMapBuffer()
    End If
End Sub

' Return an index to MapData from a point on the map. '
Public Function GetMapIndex(ByVal x As Long, ByVal y As Long) As Long
    On Error Resume Next
    Dim xIndex As Long, yIndex As Long
    
    xIndex = Int(x / 32)
    yIndex = Int(y / 32)
    GetMapIndex = -1
    If xIndex > (HeaderWidth / 2) Or yIndex > (HeaderHeight / 2) Then
        Exit Function
    End If
    
    GetMapIndex = (yIndex * (HeaderWidth / 2)) + xIndex
    If (GetMapIndex < 0) Then
        GetMapIndex = -1
    End If
End Function

' Return an index to SceneData from a point on the map. '
Public Function GetMapAttrIndex(ByVal x As Long, ByVal y As Long) As Long
    On Error Resume Next
    Dim xIndex As Long, yIndex As Long
    Dim Offset As Long
    
    xIndex = Int(x / 16)
    yIndex = Int(y / 16)
    GetMapAttrIndex = -1
    If xIndex > HeaderWidth Or yIndex > HeaderHeight Then
        Exit Function
    End If
    
    GetMapAttrIndex = (yIndex * HeaderWidth) + xIndex + Offset
    If (GetMapAttrIndex < 0) Then
        GetMapAttrIndex = -1
    End If
End Function

' Import minimap graphic. '
Public Sub Import(Filename As String)
    Dim Index As Long
        
    On Error GoTo Error
    If Filename = "" Then Exit Sub
    If Not LoadBMPFile(Filename) Then
        MsgBox "There was an error loading the bitmap " & Filename & ".", vbExclamation, "Error"
        Exit Sub
    End If
    
    If (252 <> modBmp.BitmapInfo.biWidth) Or (252 <> modBmp.BitmapInfo.biHeight) Then
        MsgBox "The Minimap bitmap must be exactly 252 x 252 pixels."
        Exit Sub
    End If

    For Index = 0 To UBound(Bits)
        MiniMapBuffer(Index) = Bits(Index)
    Next
    
    MiniMapRefresh
    Exit Sub
Error:
    MsgBox "There was an error loading the file you selected.", vbExclamation, "Import Minimap"
End Sub

' Export minimap graphic. '
Public Sub Export(Filename As String)
    SaveBMPFile Filename, MiniMapBuffer(), TAPalette(), 252, 252
End Sub

Public Sub WriteMinimap(MapBuffer() As Byte, position As Long)
    Dim Buffer(1) As Long
    
    On Error Resume Next
    Buffer(0) = 252
    Buffer(1) = 252
    'BlockWrite Buffer(0), position, 8
    'BlockWrite MiniMapBuffer(0), position + 8, UBound(MiniMapBuffer) + 1
    CopyMemory MapBuffer(position), Buffer(0), 8
    CopyMemory MapBuffer(position + 8), MiniMapBuffer(0), UBound(MiniMapBuffer) + 1
End Sub

