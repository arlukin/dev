Attribute VB_Name = "modGAF"
' GAF image extraction. '

Option Explicit

' GAF Header constants. '
Const IDiversion = 0
Const Entries = 1
Const unknown = 2

' GAF file types. '
Private Type GAFFrame
    PTRFrameTable As Long
    unknown3 As Long
End Type
Private Type GAFFrameData
    Width As Integer
    Height As Integer
    PositionX As Integer
    PositionY As Integer
    unknown1 As Byte
    CompressFlag As Byte
    FramePointers As Byte
    unknown2 As Byte
    unknown3 As Long
    PTRFrameData As Long
    unknown4 As Long
End Type
Private Type GAFEntry
    frames As Integer
    unknown1 As Integer
    unknown2 As Long
    EntryName As String * 32
    GAFFrames() As GAFFrame
End Type

' GAF file. '
Dim GAFHeader(2) As Long
Dim GAFPTRs() As Long
Dim GAFEntries() As GAFEntry
Dim Frame As GAFFrameData

Public Const GAFMaskColor As Byte = 9

' Load a GAF Image. '
Public Function LoadGAFImage(HPIFile As String, GAFFile As String, Animname As String, Width As Integer, Height As Integer, PositionX As Integer, PositionY As Integer, Buffer() As Byte) As Boolean
    Dim HPI As Long
    Dim FileHandle As Integer
    Dim Index As Long
    Dim rc As Long
    Dim EntryName As String * 32
    'Dim frames As Integer
    
    ' Load the HPI file. '
    On Error Resume Next
    LoadGAFImage = False
    HPI = HPIOpen(HPIFile)
    If HPI = 0 Then Exit Function
    
    ' Extract the GAF file. '
    Kill App.Path & "\temp.gaf"
    rc = HPIExtractFile(HPI, GAFFile, App.Path & "\temp.gaf")
    If rc = 0 Then Exit Function
    
    rc = HPIClose(HPI)
    
    ' Open the GAF file. '
    FileHandle = FreeFile
    Open App.Path & "\temp.gaf" For Binary As FileHandle
    
    ' Get the Header. '
    Get FileHandle, , GAFHeader()
    
    ' Get the GAF Entry Pointers. '
    ReDim GAFPTRs(GAFHeader(Entries) - 1)
    ReDim GAFEntries(GAFHeader(Entries) - 1)
    Get FileHandle, , GAFPTRs()
    
    ' Get the GAF Entries. '
    For Index = 0 To GAFHeader(Entries) - 1
        Seek FileHandle, GAFPTRs(Index) + 1
        Get FileHandle, , GAFEntries(Index).frames
        Get FileHandle, , GAFEntries(Index).unknown1
        Get FileHandle, , GAFEntries(Index).unknown2
        Get FileHandle, , GAFEntries(Index).EntryName
        If GAFEntries(Index).frames <> 0 Then
            ReDim GAFEntries(Index).GAFFrames(GAFEntries(Index).frames - 1)
            Get FileHandle, , GAFEntries(Index).GAFFrames()
            If LCase(Left(GAFEntries(Index).EntryName, Len(Animname) + 1)) = LCase(Animname) & Chr(0) Then
                Seek FileHandle, GAFEntries(Index).GAFFrames(0).PTRFrameTable + 1
                Get FileHandle, , Width
                Get FileHandle, , Height
                Get FileHandle, , PositionX
                Get FileHandle, , PositionY
                ReDim Buffer(Width * Height - 1)
                'Close FileHandle
                LoadGAFImage = GetGAFImage(FileHandle, Index, Width, Height, PositionX, PositionY, Buffer())
                'GAFImageLoad App.Path & "\temp.gaf", GAFEntries(Index).GAFFrames(0).PTRFrameTable, Buffer(0)
                LoadGAFImage = True
                Exit For
            End If
        End If
    Next
    
    Close FileHandle
    Kill App.Path & "\temp.gaf"
End Function

Private Function GetGAFImage(FileHandle As Integer, GAFIndex As Long, Width As Integer, Height As Integer, PositionX As Integer, PositionY As Integer, Buffer() As Byte) As Boolean
    Dim x As Long, y As Long
    Dim xAt As Long
    Dim Bytes As Integer
    Dim xPos As Long, yPos As Long
    Dim CH As Byte
    Dim CHPixels As Byte
    Dim CHFlag As Byte
    Dim PointerList() As Long
    Dim Pixel As Byte
    Dim xMax As Long, yMax As Long
    
    On Error GoTo Error
    
    GetGAFImage = True
    If GAFEntries(GAFIndex).GAFFrames(0).PTRFrameTable <> 0 Then
        Seek FileHandle, GAFEntries(GAFIndex).GAFFrames(0).PTRFrameTable + 1
        Get FileHandle, , Frame
        Width = Frame.Width
        Height = Frame.Height
        PositionX = Frame.PositionX
        PositionY = Frame.PositionY
        xMax = Frame.Width
        yMax = Frame.Height
        ReDim Buffer(xMax * yMax - 1)
        For xAt = 0 To UBound(Buffer)
            Buffer(xAt) = GAFMaskColor ' Set all pixels to blanks. '
        Next
        
        Seek FileHandle, Frame.PTRFrameData + 1
        If Frame.FramePointers <> 0 Then
            ReDim PointerList(Frame.FramePointers - 1)
            Get FileHandle, , PointerList()
        End If
        yPos = 0 ' Frame.PositionY
        If Frame.CompressFlag = 0 Then
            Get FileHandle, , Buffer()
'            For y = 0 To Frame.Height - 1
'                For x = 0 To Frame.Width - 1
'                    Get FileHandle, , Pixel
'                    Buffer(y * xMax + x) = Pixel
'                Next
'            Next
        ElseIf Frame.CompressFlag = 1 Then
            For y = 0 To Frame.Height - 1
                Get FileHandle, , Bytes
                xPos = 0 ' Frame.PositionX
                x = 1
                Do While x <= Bytes
                    Get FileHandle, , CH
                    x = x + 1
                    If (CH And 1) = 1 Then ' transparent '
                        xPos = xPos + Int(CH / 2)
                    Else
                        If (CH And 2) = 2 Then ' repeat pixel '
                            Get FileHandle, , Pixel
                            x = x + 1
                            For xAt = 0 To Int(CH / 4)
                                Buffer((y + yPos) * xMax + xPos + xAt) = Pixel
                            Next
                            xPos = xPos + Int(CH / 4) + 1
                        Else ' draw pixels '
                            For xAt = 0 To Int(CH / 4)
                                Get FileHandle, , Pixel
                                x = x + 1
                                Buffer((y + yPos) * xMax + xPos + xAt) = Pixel
                            Next
                            xPos = xPos + Int(CH / 4) + 1
                        End If
                    End If
                Loop
            Next
        End If
    End If
    Exit Function
    
Error:
    GetGAFImage = False
    MsgBox "Error " & Err.Description
    Resume
End Function



