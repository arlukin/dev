VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.1#0"; "COMDLG32.OCX"
Begin VB.Form FrmUnitPic 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Create Unit Picture"
   ClientHeight    =   2265
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   5280
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2265
   ScaleWidth      =   5280
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.PictureBox PicUnitView 
      AutoRedraw      =   -1  'True
      Height          =   5115
      Left            =   60
      ScaleHeight     =   337
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   461
      TabIndex        =   7
      Top             =   4020
      Width           =   6975
   End
   Begin VB.Timer TmrClipboard 
      Interval        =   1000
      Left            =   360
      Top             =   1380
   End
   Begin VB.CommandButton CmdClose 
      Caption         =   "&Close"
      Default         =   -1  'True
      Height          =   375
      Left            =   3960
      TabIndex        =   6
      Top             =   1740
      Width           =   1155
   End
   Begin VB.Frame Frame2 
      Height          =   1995
      Left            =   120
      TabIndex        =   2
      Top             =   120
      Width           =   3675
      Begin VB.TextBox TxtUnitName 
         Height          =   315
         Left            =   1800
         TabIndex        =   8
         Top             =   540
         Width           =   1695
      End
      Begin VB.CommandButton CmdBackground 
         Caption         =   "&Import Image..."
         Height          =   375
         Left            =   1800
         TabIndex        =   5
         Top             =   960
         Width           =   1695
      End
      Begin VB.PictureBox PicUnitpic 
         AutoRedraw      =   -1  'True
         Height          =   1500
         Left            =   180
         ScaleHeight     =   96
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   96
         TabIndex        =   4
         Top             =   300
         Width           =   1500
      End
      Begin VB.CommandButton CmdGrab 
         Caption         =   "&Grab from Unitview"
         Height          =   375
         Left            =   1800
         TabIndex        =   3
         Top             =   1440
         Width           =   1695
      End
      Begin VB.Label Label1 
         Caption         =   "Unitname"
         Height          =   195
         Left            =   1800
         TabIndex        =   9
         Top             =   240
         Width           =   1215
      End
   End
   Begin MSComDlg.CommonDialog CommonDialog 
      Left            =   4620
      Top             =   1260
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   327681
      CancelError     =   -1  'True
   End
   Begin VB.CommandButton CmdSaveBMP 
      Caption         =   "Save &BMP..."
      Height          =   375
      Left            =   3960
      TabIndex        =   1
      Top             =   240
      Width           =   1155
   End
   Begin VB.CommandButton CmdSaveGAF 
      Caption         =   "Save &GAF..."
      Height          =   375
      Left            =   3960
      TabIndex        =   0
      Top             =   720
      Width           =   1155
   End
End
Attribute VB_Name = "FrmUnitPic"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim Unitpic() As Byte
Dim bg() As Byte

Dim OriginalParenthWnd As Long

Public Sub DisplayUnitPic()
    TexturePalette.TileDraw 0, 0, 96, 96, bg()
    TexturePalette.ClearTileDraw 0, 0, 96, 96, Unitpic(), 100, 255, 1
    TexturePalette.Show PicUnitpic.hdc, 0, 0, 96, 96, 0, 0
    PicUnitpic.Refresh
End Sub

Private Sub MergeImage(Buffer() As Byte)
    Dim Index As Integer
    
    ReDim Buffer(UBound(Unitpic))
    For Index = 0 To UBound(Unitpic)
        If Unitpic(Index) <> 100 Then
            Buffer(Index) = Unitpic(Index)
        Else
            Buffer(Index) = bg(Index)
        End If
    Next
End Sub

Sub SaveGadget(Filename As String, Unitname As String)
    Dim Buffer() As Byte
    Dim Image() As Byte
    Dim Grey() As Byte
    Dim Light() As Byte
    Dim Greys() As RGBQUAD
    Dim Lights() As RGBQUAD
    Dim Index As Long
    Dim File As Integer
    Dim GAFHeader(2) As Long
    Dim Frames As Integer
    Dim Unknown1 As Integer ' 1 '
    Dim Unknown2 As Long ' 0 '
    Dim EntryName As String
    Dim LongBuf As Long, ByteBuf As Byte
    
    On Error GoTo Error
    
    MergeImage Buffer()
    
    ' Create the normal image. '
    Index = 64
    ReDim Image(Index * Index - 1)
    ReDim Grey(Index * Index - 1)
    ReDim Light(Index * Index - 1)
    ResampleImage Buffer(), 96, 96, Image(), 64, 64, TAPalette()
    For Index = 0 To UBound(Image)
        Grey(Index) = Image(Index)
        Light(Index) = Image(Index)
    Next
    
    ' Create the greyscale image. '
    ReDim Greys(255)
    For Index = 0 To 255
        Greys(Index).rgbRed = Index
        Greys(Index).rgbGreen = Index
        Greys(Index).rgbBlue = Index
    Next
    ConvertPalette Grey(), TAPalette(), Greys()
    ConvertPalette Grey(), Greys(), TAPalette()
    
    ' Create the Hilighted image. '
    ReDim Lights(255)
    LightenPalette TAPalette(), Lights()
    ConvertPalette Light(), Lights(), TAPalette()
    
    ' Write the GAF file. '
    File = FreeFile
    Open Filename For Binary As File
    
    ' Write header. '
    GAFHeader(0) = &H10100
    GAFHeader(1) = 1
    GAFHeader(2) = 0
    Put File, , GAFHeader()
    LongBuf = Seek(File) - 1 + 4
    Put File, , LongBuf
    
    ' Write the sequence. '
    Frames = 3
    Put File, , Frames
    Unknown1 = 1
    Put File, , Unknown1
    Unknown2 = 0
    Put File, , Unknown2
    EntryName = UCase(Unitname)
    For Index = 1 To 31
        If Index <= Len(EntryName) Then
            ByteBuf = Asc(Mid(EntryName, Index, 1))
        Else
            ByteBuf = 0
        End If
        Put File, , ByteBuf
    Next
    ByteBuf = 0
    Put File, , ByteBuf
    
    Index = 64
    LongBuf = Seek(File) + 23
    Put File, , LongBuf
    LongBuf = 0 '10
    Put File, , LongBuf
    LongBuf = Seek(File) + 15 + 24 + Index * Index
    Put File, , LongBuf
    LongBuf = 0 '10
    Put File, , LongBuf
    LongBuf = Seek(File) + 7 + 2 * (Index * Index + 24)
    Put File, , LongBuf
    LongBuf = 0 '10
    Put File, , LongBuf
    
    SaveGAFFrame File, Image(), 64, 64
    SaveGAFFrame File, Light(), 64, 64
    SaveGAFFrame File, Grey(), 64, 64
    
    Close File
Error:
End Sub

Private Sub SaveGAFFrame(File As Integer, Image() As Byte, Width As Integer, Height As Integer)
    Dim xPosition As Integer
    Dim yPosition As Integer
    Dim CompressFlag As Byte ' 0: pixel dump, 1: compressed '
    Dim Unknown1 As Byte ' 09 '
    Dim Unknown2 As Byte ' 0 '
    Dim Unknown3 As Long ' 0 '
    Dim Unknown4 As Long ' 0 '
    Dim NumFramePointers As Byte ' Number of pointers to frame headers. '
    Dim PTRFrameData As Long ' Pointer to the start of the image. '

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
    Put File, , Image()
End Sub

Private Sub CmdBackground_Click()
    Dim Index As Integer
    
    On Error GoTo Error
    CommonDialog.Filter = "BMP files (*.bmp)|*.bmp"
    CommonDialog.DefaultExt = "bmp"
    CommonDialog.Filename = ""
    CommonDialog.ShowOpen
    If (CommonDialog.Filename <> "") And (Not Err) Then
        Screen.MousePointer = vbHourglass
        If LoadBMPFile(CommonDialog.Filename, True) Then
            If BitmapInfo.biWidth <> 96 Or BitmapInfo.biHeight <> 96 Then
                MsgBox "The background image must be a 96x96, 256 color bitmap.", vbInformation
            Else
                For Index = 0 To UBound(Bits)
                    bg(Index) = Bits(Index)
                Next
                DisplayUnitPic
            End If
        Else
            MsgBox "The background image must be a 96x96, 256 color bitmap.", vbInformation
        End If
    End If
Error:
    Screen.MousePointer = vbNormal
End Sub

Private Sub CmdClose_Click()
    Unload Me
End Sub

Private Sub CmdGrab_Click()
    MsgBox "Switch to the Unit Viewer and press Alt-Printscreen.", vbInformation
End Sub

Private Sub CmdSaveBMP_Click()
    Dim Index As Integer
    Dim Buffer() As Byte
    
    On Error GoTo Error
    CommonDialog.Filter = "BMP files (*.bmp)|*.bmp"
    CommonDialog.DefaultExt = "bmp"
    CommonDialog.Filename = ""
    CommonDialog.ShowSave
    If (CommonDialog.Filename <> "") And (Not Err) Then
        MergeImage Buffer()
        SaveBMPFile CommonDialog.Filename, Buffer(), TAPalette(), 96, 96
    End If
Error:
    Screen.MousePointer = vbNormal
End Sub

Private Sub CmdSaveGAF_Click()
    Dim Index As Integer
    
    On Error GoTo Error
    
    If TxtUnitName = "" Then
        MsgBox "Please enter a unit name.", vbInformation
        TxtUnitName.SetFocus
        Exit Sub
    End If
    
    CommonDialog.Filter = "GAF files (*.gaf)|*.gaf"
    CommonDialog.DefaultExt = "gaf"
    CommonDialog.Filename = UCase(TxtUnitName) & "_gadget.gaf"
    CommonDialog.ShowSave
    If (CommonDialog.Filename <> "") And (Not Err) Then
        Screen.MousePointer = vbHourglass
        DoEvents
        SaveGadget CommonDialog.Filename, TxtUnitName
    End If
Error:
    Screen.MousePointer = vbNormal
End Sub

Private Sub Form_Load()
    Dim i As Long
    
    OriginalParenthWnd = SetWindowLong(Me.hwnd, GWW_HWNDPARENT, Frm3do.hwnd)
    
    i = 96
    ReDim bg(i * i - 1)
    ReDim Unitpic(i * i - 1)
    For i = 0 To UBound(bg)
        bg(i) = 255
    Next
    For i = 0 To UBound(Unitpic)
        Unitpic(i) = 100
    Next
    DisplayUnitPic
    
    Clipboard.Clear
    Clipboard.SetText "3do"
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Dim rc As Long
    
    If OriginalParenthWnd <> 0 Then
        rc = SetWindowLong(Me.hwnd, GWW_HWNDPARENT, OriginalParenthWnd)
    End If
End Sub

Private Sub TmrClipboard_Timer()
    Dim rc As Long
    Dim Buffer() As Byte
    Dim Width As Long
    If Clipboard.GetFormat(vbCFBitmap) Then
        PicUnitView.Picture = Clipboard.GetData(vbCFBitmap)
        Clipboard.Clear
        Clipboard.SetText "3do"
        TexturePalette.Blt PicUnitView.hdc, 0, 0, 450, 300, 0, 0
        Width = 450
        ReDim Buffer(Width * 300 - 1)
        TexturePalette.GrabRegion 0, 0, 450, 300, Buffer()
        ParseUnitPic Buffer(), 450, 300
    End If
End Sub

Private Sub ParseUnitPic(Buffer() As Byte, Width As Long, Height As Long)
    Dim Index As Long
    Dim xPos As Long, yPos As Long
    Dim x As Long, y As Long
    Dim Image() As Byte
    
    x = 160
    ReDim Image(x * x - 1)
    For Index = 0 To UBound(Buffer)
        If Buffer(Index) = 100 Then
            xPos = Index Mod Width
            yPos = Int(Index / Width)
            Exit For
        End If
    Next
    
    
    For y = yPos To yPos + 160 - 1
        For x = xPos To xPos + 160 - 1
            Image((x - xPos) + (y - yPos) * 160) = Buffer(x + y * Width)
        Next
    Next
    For y = 148 To 160 - 1
        For x = 0 To 70
            Image(x + y * 160) = 100
        Next
    Next
    
    ResampleImage Image(), 160, 160, Unitpic(), 96, 96, TAPalette(), 1
    DisplayUnitPic
'    TexturePalette.TileDraw 0, 0, 160, 160, Image()
'    TexturePalette.Show PicUnitpic.hdc, 0, 0, 96, 96, 0, 0, 160, 160, True
    'rc = BitBlt(.PicTextures.hdc, xIndex, yIndex + Height + 5, .PicTemp.ScaleWidth, .PicTemp.ScaleHeight, .PicTemp.hdc, 0, 0, SRCCOPY)
End Sub

Private Sub ResampleImage(Source() As Byte, SrcWidth As Long, SrcHeight As Long, Dest() As Byte, DestWidth As Long, DestHeight As Long, sPalette() As RGBQUAD, Optional Pad As Integer = 0)
    Dim avgRed() As Long, avgGreen() As Long, avgBlue() As Long, avgIndex() As Long
    Dim x As Single, y As Single
    Dim xStep As Single, yStep As Single
    Dim NewX As Long, NewY As Long
    Dim Index As Long
    Dim i As Integer, AvgR As Long, AvgG As Long, AvgB As Long
    Dim r As Long, g As Long, b As Long, Best As Long
    
    ReDim avgRed(UBound(Dest))
    ReDim avgGreen(UBound(Dest))
    ReDim avgBlue(UBound(Dest))
    ReDim avgIndex(UBound(Dest))
    
    xStep = SrcWidth / DestWidth
    yStep = SrcHeight / DestHeight
    For y = 0 + Pad To SrcHeight - 1 - Pad
        NewX = 0
        NewY = CInt(y / yStep)
        For x = 0 + Pad To SrcWidth - 1 - Pad
            NewX = CInt(x / xStep)
            Index = NewX + NewY * DestWidth
            If Source(x + y * SrcWidth) <> 100 Then
                If Source(x - Pad + y * SrcWidth) <> 100 And Source(x + Pad + y * SrcWidth) <> 100 And Source(x + (y - Pad) * SrcWidth) <> 100 And Source(x + (y + Pad) * SrcWidth) <> 100 Then
                    'Dest(Index) = Source(x + y * SrcWidth)
                    avgRed(Index) = avgRed(Index) + sPalette(Source(x + y * SrcWidth)).rgbRed
                    avgGreen(Index) = avgGreen(Index) + sPalette(Source(x + y * SrcWidth)).rgbGreen
                    avgBlue(Index) = avgBlue(Index) + sPalette(Source(x + y * SrcWidth)).rgbBlue
                    avgIndex(Index) = avgIndex(Index) + 1
                End If
            End If
        Next
    Next
    
    For Index = 0 To UBound(Dest)
        If avgIndex(Index) > 0 Then
            AvgR = CInt(avgRed(Index) / avgIndex(Index))
            AvgG = CInt(avgGreen(Index) / avgIndex(Index))
            AvgB = CInt(avgBlue(Index) / avgIndex(Index))
            r = 255
            g = 255
            b = 255
            Best = 255
            For i = 0 To UBound(sPalette)
                If (Abs(AvgR - sPalette(i).rgbRed) + Abs(AvgG - sPalette(i).rgbGreen) + Abs(AvgB - sPalette(i).rgbBlue)) < (r + g + b) Then
                    Best = i
                    r = Abs(AvgR - sPalette(i).rgbRed)
                    g = Abs(AvgG - sPalette(i).rgbGreen)
                    b = Abs(AvgB - sPalette(i).rgbBlue)
                End If
            Next
            Dest(Index) = Best
        Else
            Dest(Index) = 100
        End If
    Next
End Sub

' Convert a bitmap to another palette. '
Private Sub ConvertPalette(Buffer() As Byte, SrcPal() As RGBQUAD, DestPal() As RGBQUAD)
    Dim Lut() As Long ' Look-up table. '
    Dim Index As Long, i As Integer
    Dim r As Integer, g As Integer, b As Integer, Best As Integer
    Dim br As Integer, bg As Integer, bb As Integer
    
    ReDim Lut(255)
    For Index = 0 To UBound(SrcPal)
        r = 255
        g = 255
        b = 255
        Best = 255
        For i = 0 To UBound(DestPal)
            br = SrcPal(Index).rgbRed
            bg = SrcPal(Index).rgbGreen
            bb = SrcPal(Index).rgbBlue
            If (Abs(br - DestPal(i).rgbRed) + Abs(bg - DestPal(i).rgbGreen) + Abs(bb - DestPal(i).rgbBlue)) < (r + g + b) Then
                Best = i
                r = Abs(br - DestPal(i).rgbRed)
                g = Abs(bg - DestPal(i).rgbGreen)
                b = Abs(bb - DestPal(i).rgbBlue)
            End If
        Next
        Lut(Index) = Best
    Next
    
    For Index = 0 To UBound(Buffer)
        Buffer(Index) = Lut(Buffer(Index))
    Next
End Sub

Private Sub LightenPalette(SrcPal() As RGBQUAD, DstPal() As RGBQUAD)
    Dim i As Long, Buffer As Long
    
    For i = 0 To 255
        Buffer = SrcPal(i).rgbRed
        Buffer = (Buffer * 4 + 255) / 5
        DstPal(i).rgbRed = Buffer
        Buffer = SrcPal(i).rgbGreen
        Buffer = (Buffer * 4 + 255) / 5
        DstPal(i).rgbGreen = Buffer
        Buffer = SrcPal(i).rgbBlue
        Buffer = (Buffer * 4 + 255) / 5
        DstPal(i).rgbBlue = Buffer
    Next
End Sub
