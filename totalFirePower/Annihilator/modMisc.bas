Attribute VB_Name = "modMisc"
' Misc Annihilator functions. '

' Functions: '
' CompressDupes(cTileData() as byte, cMapData() as Byte)
'   Returns the number of duplicate tiles removed. '

Option Explicit

' Removal all duplicate tiles given tile and map data. '
Function CompressDupes(cTileData() As Byte, cMapData() As Byte) As Long
    Dim X As Long, Y As Long, i As Long
    Dim DupeTileCount As Long ' The number of duplicate tiles found. '
    Dim CheckSum() As Long ' The value of each tile. '
    Dim TileList() As Long
    Dim cNewTileData() As Byte
    Dim cTileUsed() As Boolean
    Dim cTileIndex() As Long
    
    ' Create a list of tile checksum values. '
    ReDim CheckSum(Int((UBound(cTileData) + 1) / 1024) - 1)
    For X = 0 To UBound(CheckSum)
        CheckSum(X) = 0
        For i = 0 To 1023
            CheckSum(X) = CheckSum(X) + ((cTileData(X * 1024 + i) * (1 + Int((255 * i) / 1024))))
        Next
        DoEvents
    Next

    ' Remove the duplicate tiles from the map. '
    ReDim TileList(0)
    For X = 0 To UBound(cTileUsed) - 1
        If cTileUsed(X) Then
            ReDim Preserve TileList(UBound(TileList) + 1)
            TileList(UBound(TileList)) = X
            For Y = (X + 1) To UBound(cTileUsed)
                ' Compare tile x to each tile y. '
                If cTileUsed(Y) Then
                    If (CheckSum(X) = CheckSum(Y)) Then ' The tiles match, remove one. '
                        DupeTileCount = DupeTileCount + 1
                        cTileUsed(Y) = False ' Tile is no longer used. '
                        cTileIndex(Y) = X ' The replacement tile. '
                    End If
                End If
            Next
        End If
        DoEvents
    Next

    ' Create the new map information. '
    ReDim cNewTileData(UBound(TileList) * 1024 - 1)
    For X = 1 To UBound(TileList)
        For i = 0 To 1023
            cNewTileData((X - 1) * 1024 + i) = cTileData(TileList(X) * 1024 + i)
        Next
        DoEvents
    Next
    For i = 0 To UBound(cMapData)
        For X = 1 To UBound(TileList)
            If TileList(X) = cTileIndex(cMapData(i)) Then
                cMapData(i) = X - 1
                Exit For
            End If
        Next
        If cMapData(i) > (UBound(TileList) - 1) Then cMapData(i) = 0
        DoEvents
    Next
End Function

' Remove trailing Null charecters from a string. '
Function FixString(Buffer As String) As String
    Dim Index As Long
    Dim NewString As String
    
    For Index = 1 To Len(Buffer)
        If (Asc(Mid(Buffer, Index, 1)) <> 0) Then
            NewString = NewString & Mid(Buffer, Index, 1)
        Else
            Exit For
        End If
    Next
    FixString = Trim(NewString)
End Function

Public Sub RemoveBlanks(Buffer As String)
    Dim Clean As String
    Dim Index As Integer
    
    For Index = 1 To Len(Buffer)
        If (Asc(LCase(Mid(Buffer, Index, 1))) >= Asc("a")) And (Asc(LCase(Mid(Buffer, Index, 1))) <= Asc("z")) Then
        Clean = Clean & Mid(Buffer, Index, 1)
        End If
    Next
    Buffer = Clean
End Sub

Public Function ParseDirName(ByRef Filename As String) As String
    Dim Buffer As String
    Dim Index As Integer
    
    On Error Resume Next
    For Index = 1 To Len(Filename)
        If Mid(Filename, Index, 1) <> "\" Then
            Buffer = Buffer & Mid(Filename, Index, 1)
        Else
            Exit For
        End If
    Next
    
    Filename = Right(Filename, Len(Filename) - Index)
    ParseDirName = Buffer
End Function

' Change string to sentence case. '
Public Function SCase(Buffer As String) As String
    SCase = UCase(Left(Buffer, 1)) & LCase(Right(Buffer, Len(Buffer) - 1))
End Function

' Return the directory from path. '
Public Function GetDirectory(Path As String) As String
    Dim rc As Long
    Dim i As Integer
    
    For i = 1 To Len(Path)
        If Mid(Path, i, 1) = "\" Then rc = i
    Next
    If rc > 0 Then
        GetDirectory = Left(Path, rc - 1)
    Else
        GetDirectory = Path
    End If
End Function

' Return the filename from path. '
Public Function GetFilename(Path As String) As String
    Dim rc As Long
    Dim i As Integer
    
    On Error Resume Next
    For i = 1 To Len(Path)
        If Mid(Path, i, 1) = "\" Then rc = i
    Next
    If rc > 0 Then
        GetFilename = Right(Path, Len(Path) - rc)
    Else
        GetFilename = Path
    End If
End Function
