VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "classResize"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit


Public Error As Boolean
Public ErrorNumber As Long
Public ErrorDescription As String

'Public Sub ResizeRight(ByRef ResizeMapData() As Long, ByRef ResizeHeightData() As Byte, ByRef ResizeSceneAttr() As Integer, ByRef OldWidth As Long, ByRef OldHeight As Long, ByVal NewWidth As Long, ByVal NewHeight As Long, ByVal ResizeTile As Boolean)
'On Error GoTo Error
'    Dim OldMapData() As Long
'    Dim OldHeightData() As Byte
'    Dim OldSceneAttr() As Integer
'    Dim Index As Long
'    Dim x As Long, y As Long
'    Dim ResizeIndex As Long
'    Dim OldIndex As Long
'    Dim OldWidthMod As Long
'    Dim ResizeWidthMod As Long
'    Dim OldHeightMod As Long
'    Dim ResizeHeightMod As Long
'    Dim TileNewHeight As Long
'    Dim TileNewWidth As Long
'    Dim TileOldHeight As Long
'    Dim TileOldWidth As Long
'
'
'    ' Resize. '
'    TileNewHeight = Int(NewHeight / 2)
'    TileNewWidth = Int(NewWidth / 2)
'    TileOldHeight = Int(OldHeight / 2)
'    TileOldWidth = Int(OldWidth / 2)
'    ReDim OldMapData(UBound(ResizeMapData))
'    ReDim OldHeightData(UBound(ResizeHeightData))
'    ReDim OldSceneAttr(UBound(ResizeHeightData))
'    For Index = 0 To UBound(ResizeMapData)
'        OldMapData(Index) = ResizeMapData(Index)
'    Next
'    For Index = 0 To UBound(ResizeHeightData)
'        OldHeightData(Index) = ResizeHeightData(Index)
'        OldSceneAttr(Index) = ResizeSceneAttr(Index)
'    Next
'    ReDim ResizeMapData(TileNewWidth * (TileNewHeight) - 1)
'    ReDim ResizeHeightData(NewWidth * NewHeight - 1)
'    ReDim ResizeSceneAttr(NewWidth * NewHeight - 1)
'
'
'    ' Copy map data. '
'    For y = 0 To TileNewHeight - 1
'        For x = 0 To TileNewWidth - 1
'            ResizeIndex = (y * TileNewWidth) + x ' Set resize index
'            If ResizeTile = False And x >= TileOldWidth = 0 And y >= TileOldHeight = 0 Then
'                ResizeMapData(ResizeIndex) = 1
'            Else
'                ' Get Adjusted Height/Width index to copy to new array '
'                OldWidthMod = (TileOldWidth - (((TileNewWidth Mod TileOldWidth) - x) Mod TileOldWidth)) Mod TileOldWidth
'                OldHeightMod = (TileOldHeight - (((TileNewHeight Mod TileOldHeight) - y) Mod TileOldHeight)) Mod TileOldHeight
'                OldIndex = OldWidthMod + (OldHeightMod * TileOldWidth)
'                ResizeMapData(ResizeIndex) = OldMapData(OldIndex)
'            End If
'        Next
'    Next
'
'    ' Copy height and scene data. '
'    For y = 0 To NewHeight - 1
'        For x = 0 To NewWidth - 1
'            ResizeIndex = (y * NewWidth) + x ' Set resize index
'            If ResizeTile = False And x Mod OldWidth = 0 And y Mod OldHeight = 0 Then
'                ResizeHeightData(ResizeIndex) = Header(SeaLevel)
'                ResizeSceneAttr(ResizeIndex) = -1
'            Else
'                ' Get Adjusted Height/Width index to copy to new array '
'                OldWidthMod = ((NewWidth Mod OldWidth) + x) Mod OldWidth
'                OldHeightMod = (((NewHeight Mod OldHeight) + y) Mod OldWidth) * OldWidth
'                OldIndex = OldWidthMod + OldHeightMod
'                ResizeHeightData(ResizeIndex) = OldHeightData(OldIndex)
'                ResizeSceneAttr(ResizeIndex) = OldSceneAttr(OldIndex)
'            End If
'        Next
'    Next
'
'    OldWidth = NewWidth
'    OldHeight = NewHeight
'Exit Sub
'Error:
'ErrorNumber = Err.Number
'ErrorDescription = Err.Description
'Error = True
'End Sub
'Public Sub ResizeCenter(ByRef ResizeMapData() As Long, ByRef ResizeHeightData() As Byte, ByRef ResizeSceneAttr() As Integer, ByRef OldWidth As Long, ByRef OldHeight As Long, ByVal NewWidth As Long, ByVal NewHeight As Long, ByVal ResizeTile As Boolean)
'On Error GoTo Error
'
'    Dim OldMapData() As Long
'    Dim OldHeightData() As Byte
'    Dim OldSceneAttr() As Integer
'    Dim Index As Long
'    Dim x As Long, y As Long
'    Dim ResizeIndex As Long
'    Dim OldIndex As Long
'    Dim OldWidthMod As Long
'    Dim ResizeWidthMod As Long
'    Dim OldHeightMod As Long
'    Dim ResizeHeightMod As Long
'    Dim TileNewHeight As Long
'    Dim TileNewWidth As Long
'    Dim TileOldHeight As Long
'    Dim TileOldWidth As Long
'
'
'    ' Resize. '
'    TileNewHeight = Int(NewHeight / 2)
'    TileNewWidth = Int(NewWidth / 2)
'    TileOldHeight = Int(OldHeight / 2)
'    TileOldWidth = Int(OldWidth / 2)
'    ReDim OldMapData(UBound(ResizeMapData))
'    ReDim OldHeightData(UBound(ResizeHeightData))
'    ReDim OldSceneAttr(UBound(ResizeHeightData))
'    For Index = 0 To UBound(ResizeMapData)
'        OldMapData(Index) = ResizeMapData(Index)
'    Next
'    For Index = 0 To UBound(ResizeHeightData)
'        OldHeightData(Index) = ResizeHeightData(Index)
'        OldSceneAttr(Index) = ResizeSceneAttr(Index)
'    Next
'    ReDim ResizeMapData(TileNewWidth * (TileNewHeight) - 1)
'    ReDim ResizeHeightData(NewWidth * NewHeight - 1)
'    ReDim ResizeSceneAttr(NewWidth * NewHeight - 1)
'
'
'    ' Copy map data. '
'    For y = 0 To TileNewHeight - 1
'        For x = 0 To TileNewWidth - 1
'            ResizeIndex = (y * TileNewWidth) + x ' Set resize index
'            If ResizeTile = False And x >= TileOldWidth = 0 And y >= TileOldHeight = 0 Then
'                ResizeMapData(ResizeIndex) = 1
'            Else
'                ' Get Adjusted Height/Width index to copy to new array '
'                OldHeightMod = (TileOldHeight - (Int(TileNewHeight / 2) - Int(TileOldHeight / 2))) + y
'                OldHeightMod = OldHeightMod Mod TileOldHeight
'                OldHeightMod = (TileOldHeight + OldHeightMod) Mod TileOldHeight
'                OldWidthMod = (TileOldWidth - (Int(TileNewWidth / 2) - Int(TileOldWidth / 2))) + x
'                OldWidthMod = OldWidthMod Mod TileOldWidth
'                OldWidthMod = (TileOldWidth + OldWidthMod) Mod TileOldWidth
'                OldIndex = OldWidthMod + (OldHeightMod * TileOldWidth)
'                ResizeMapData(ResizeIndex) = OldMapData(OldIndex)
'            End If
'        Next
'    Next
'
'    ' Copy height and scene data. '
'    For y = 0 To NewHeight - 1
'        For x = 0 To NewWidth - 1
'            ResizeIndex = (y * NewWidth) + x ' Set resize index
'            If ResizeTile = False And x >= OldWidth = 0 And y >= OldHeight = 0 Then
'                ResizeHeightData(ResizeIndex) = Header(SeaLevel)
'                ResizeSceneAttr(ResizeIndex) = -1
'            Else
'                ' Get Adjusted Height/Width index to copy to new array '
'                OldHeightMod = (OldHeight - (Int(NewHeight / 2) - Int(OldHeight / 2))) + y
'                OldHeightMod = OldHeightMod Mod OldHeight
'                OldHeightMod = (OldHeight + OldHeightMod) Mod OldHeight
'                OldWidthMod = (OldWidth - (Int(NewWidth / 2) - Int(OldWidth / 2))) + x
'                OldWidthMod = OldWidthMod Mod OldWidth
'                OldWidthMod = (OldWidth + OldWidthMod) Mod OldWidth
'                OldIndex = OldWidthMod + (OldHeightMod * OldWidth)
'                ResizeHeightData(ResizeIndex) = OldHeightData(OldIndex)
'                ResizeSceneAttr(ResizeIndex) = OldSceneAttr(OldIndex)
'            End If
'        Next
'    Next
'
'    OldWidth = NewWidth
'    OldHeight = NewHeight
'
'Exit Sub
'Error:
'ErrorNumber = Err.Number
'ErrorDescription = Err.Description
'Error = True
'End Sub
'
'Public Sub ResizeLeft(ByRef ResizeMapData() As Long, ByRef ResizeHeightData() As Byte, ByRef ResizeSceneAttr() As Integer, ByRef OldWidth As Long, ByRef OldHeight As Long, ByVal NewWidth As Long, ByVal NewHeight As Long, ByVal ResizeTile As Boolean)
'On Error GoTo Error
'    Dim OldMapData() As Long
'    Dim OldHeightData() As Byte
'    Dim OldSceneAttr() As Integer
'    Dim Index As Long
'    Dim x As Long, y As Long
'    Dim ResizeIndex As Long
'    Dim OldIndex As Long
'    Dim OldWidthMod As Long
'    Dim ResizeWidthMod As Long
'    Dim OldHeightMod As Long
'    Dim ResizeHeightMod As Long
'    Dim TileNewHeight As Long
'    Dim TileNewWidth As Long
'    Dim TileOldHeight As Long
'    Dim TileOldWidth As Long
'
'    ' Resize. '
'    TileNewHeight = Int(NewHeight / 2)
'    TileNewWidth = Int(NewWidth / 2)
'    TileOldHeight = Int(OldHeight / 2)
'    TileOldWidth = Int(OldWidth / 2)
'    ReDim OldMapData(UBound(ResizeMapData))
'    ReDim OldHeightData(UBound(ResizeHeightData))
'    ReDim OldSceneAttr(UBound(ResizeHeightData))
'    For Index = 0 To UBound(ResizeMapData)
'        OldMapData(Index) = ResizeMapData(Index)
'    Next
'    For Index = 0 To UBound(ResizeHeightData)
'        OldHeightData(Index) = ResizeHeightData(Index)
'        OldSceneAttr(Index) = ResizeSceneAttr(Index)
'    Next
'    ReDim ResizeMapData(TileNewWidth * (TileNewHeight) - 1)
'    ReDim ResizeHeightData(NewWidth * NewHeight - 1)
'    ReDim ResizeSceneAttr(NewWidth * NewHeight - 1)
'
'
'    ' Copy data. '
'    For y = 0 To TileNewHeight - 1
'        For x = 0 To TileNewWidth - 1
'            ResizeIndex = (y * TileNewWidth) + x ' Set Resize Index
'            If ResizeTile = True Then
'                ' Get Adjusted Height/Width index to copy to new array '
'                OldWidthMod = x Mod TileOldWidth
'                OldHeightMod = (y Mod TileOldHeight) * TileOldWidth
'                OldIndex = OldHeightMod + OldWidthMod ' Set Old Map Index
'                ResizeMapData(ResizeIndex) = OldMapData(OldIndex)
'            Else
'                ResizeMapData(ResizeIndex) = 1
'            End If
'        Next
'    Next
'
'    For y = 0 To NewHeight - 1
'        For x = 0 To NewWidth - 1
'            ResizeIndex = (y * NewWidth) + x ' Set Resize Index
'            If ResizeTile = True Then
'                ' Get Adjusted Height/Width index to copy to new array '
'                OldWidthMod = x Mod OldWidth
'                OldHeightMod = (y Mod OldHeight) * OldWidth
'                OldIndex = OldHeightMod + OldWidthMod ' Set Old Map Index
'                ResizeHeightData(ResizeIndex) = OldHeightData(OldIndex)
'                ResizeSceneAttr(ResizeIndex) = OldSceneAttr(OldIndex)
'            Else
'                ResizeHeightData(ResizeIndex) = Header(SeaLevel)
'                ResizeSceneAttr(ResizeIndex) = 1
'            End If
'        Next
'    Next
'
'    ' Set new height/width for return '
'    OldWidth = NewWidth
'    OldHeight = NewHeight
'Exit Sub
'Error:
'ErrorNumber = Err.Number
'ErrorDescription = Err.Description
'Error = True
'End Sub
