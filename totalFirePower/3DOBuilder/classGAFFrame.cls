VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "classGAFFrame"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' GAF frame class. '

Option Explicit

' Frame used flag. '
Public Used As Boolean

' Position in saved file of frame. '
Public FilePosition As Long

Public Width As Integer
Public Height As Integer
Public xPosition As Integer
Public yPosition As Integer
Public CompressFlag As Byte ' 0: pixel dump, 1: compressed '
Private Unknown1 As Byte ' 09 '
Private Unknown2 As Byte ' 0 '
Private Unknown3 As Long ' 0 '
Private Unknown4 As Long ' 0 '
Private NumFramePointers As Byte ' Number of pointers to frame headers. '
Private PTRFrameData As Long ' Pointer to the start of the image. '
Private GAFImage() As Byte
Private FramePointers() As New classGAFFrame

' Initialize the frame. '
Public Sub Initialize()
    Used = False
    FilePosition = 0
    Width = 0
    Height = 0
    xPosition = 0
    yPosition = 0
    CompressFlag = 0
    NumFramePointers = 0
    ReDim GAFImage(0)
    ReDim FramePointers(0)
End Sub

Public Sub SaveBMP(File As Integer, FileName As String)
    If LoadBMPFile(FileName) Then
        ConvertPalette
        Width = BitmapInfo.biWidth
        Height = BitmapInfo.biHeight
        xPosition = 0
        yPosition = 0
        CompressFlag = 0
        Unknown1 = 9
        Unknown2 = 0
        Unknown3 = 0
        Unknown4 = 0
        NumFramePointers = 0
        PTRFrameData = Seek(File) + 23
        Put File, , Width
        Put File, , Height
        Put File, , xPosition
        Put File, , yPosition
        Put File, , Unknown1
        Put File, , CompressFlag
        Put File, , NumFramePointers
        Put File, , Unknown2
        Put File, , Unknown3
        Put File, , PTRFrameData
        Put File, , Unknown4
        Put File, , Bits()
    Else
        Width = 0
        Height = 0
        xPosition = 0
        yPosition = 0
        CompressFlag = 0
        Unknown1 = 9
        Unknown2 = 0
        Unknown3 = 0
        Unknown4 = 0
        NumFramePointers = 0
        PTRFrameData = Seek(File) + 43
        Put File, , Width
        Put File, , Height
        Put File, , xPosition
        Put File, , yPosition
        Put File, , Unknown1
        Put File, , CompressFlag
        Put File, , NumFramePointers
        Put File, , Unknown2
        Put File, , Unknown3
        Put File, , PTRFrameData
        Put File, , Unknown4
    End If
End Sub
