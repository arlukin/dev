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
    Unknown3 As Long
End Type
Private Type GAFFrameData
    Width As Integer
    Height As Integer
    PositionX As Integer
    PositionY As Integer
    Unknown1 As Byte
    CompressFlag As Byte
    FramePointers As Byte
    Unknown2 As Byte
    Unknown3 As Long
    PTRFrameData As Long
    Unknown4 As Long
End Type
Private Type GAFEntry
    Frames As Integer
    Unknown1 As Integer
    Unknown2 As Long
    EntryName As String
    GAFFrames() As GAFFrame
End Type

' GAF file. '
Dim GAFHeader(2) As Long
Dim GAFPTRs() As Long
Dim GAFEntries() As GAFEntry
Dim Frame As GAFFrameData

Const GAFMaskColor As Byte = 9

Public Sub CreateGAFPTRList(HPIFile As String, GAFfile As String, GAFPTR() As Long, Names() As String)
    Dim HPI As Long
    Dim FileHandle As Integer
    Dim Index As Long
    Dim rc As Long
    Dim EntryName As String * 32
    Dim ByteBuffer As Byte, IntBuffer As Integer, LongBuffer As Long
    Dim Offset As Long
    Dim Width As Integer, Height As Integer, PositionX As Integer, PositionY As Integer
    
    ' Load the HPI file. '
    On Error Resume Next
    HPI = HPIOpen(HPIFile)
    If HPI = 0 Then Exit Sub
    
    ' Extract the GAF file. '
    Kill App.Path & "\temp.gaf"
    rc = HPIExtractFile(HPI, GAFfile, App.Path & "\temp.gaf")
    If rc = 0 Then Exit Sub
    
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
        Get FileHandle, , GAFEntries(Index).Frames
        Get FileHandle, , GAFEntries(Index).Unknown1
        Get FileHandle, , GAFEntries(Index).Unknown2
        GAFEntries(Index).EntryName = GetGAFEntryName(FileHandle)
        If GAFEntries(Index).Frames <> 0 Then
            ReDim GAFEntries(Index).GAFFrames(GAFEntries(Index).Frames - 1)
            Get FileHandle, , GAFEntries(Index).GAFFrames()
            Seek FileHandle, GAFEntries(Index).GAFFrames(0).PTRFrameTable + 1
            Get FileHandle, , Width
            Get FileHandle, , Height
            Get FileHandle, , PositionX
            Get FileHandle, , PositionY
            Get FileHandle, , ByteBuffer
            Get FileHandle, , ByteBuffer
            If Width <> 0 And Height <> 0 Then  ' And ByteBuffer = 0
                ReDim Preserve GAFPTR(UBound(GAFPTR) + 1)
                ReDim Preserve Names(UBound(Names) + 1)
                GAFPTR(UBound(GAFPTR)) = GAFEntries(Index).GAFFrames(0).PTRFrameTable + 1
                Names(UBound(Names)) = GAFEntries(Index).EntryName
            End If
        End If
    Next
    
    Close FileHandle
    Kill App.Path & "\temp.gaf"
    On Error GoTo 0
End Sub

Public Sub GetGAFImage(FileHandle As Integer, FilePTR As Long, Width As Long, Height As Long, Buffer() As Byte)
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
    Dim HPI As Long
    Dim rc As Long
        
    On Error Resume Next
    If FilePTR <> 0 Then
        Seek FileHandle, FilePTR
        Get FileHandle, , Frame
        Width = Frame.Width
        Height = Frame.Height
        xMax = Frame.Width
        yMax = Frame.Height
        ReDim Buffer(xMax * yMax - 1)
        
        Seek FileHandle, Frame.PTRFrameData + 1
        If Frame.FramePointers <> 0 Then
            ReDim PointerList(Frame.FramePointers - 1)
            Get FileHandle, , PointerList()
        End If
        yPos = 0 ' Frame.PositionY
        If Frame.CompressFlag = 0 Then
            Get FileHandle, , Buffer()
        ElseIf Frame.CompressFlag = 1 Then
            For xAt = 0 To UBound(Buffer)
                Buffer(xAt) = GAFMaskColor ' Set all pixels to blanks. '
            Next
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
                    DoEvents
                Loop
            Next
        End If
    End If
    
    On Error GoTo 0
End Sub

' Load a GAF entry name from a file. '
Public Function GetGAFEntryName(File As Integer) As String
    Dim Buffer(31) As Byte
    Dim Index As Integer
    Dim Result As String
    
    Get File, , Buffer()
    For Index = 0 To 31
        If Buffer(Index) <> 0 Then
            Result = Result & Chr(Buffer(Index))
        Else
            Exit For
        End If
    Next
    GetGAFEntryName = Result
End Function
