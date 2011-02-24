VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "classFeature"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Feature class. '

Option Explicit

' Feature properties. '
Public Name As String
Public HPIFile As String
Public Filename As String
Public Seqname As String
Public Objectname As String
Public FootprintX As Integer
Public FootprintY As Integer

Dim FilePTR As Long
Public Width As Integer
Public Height As Integer
Public PositionX As Integer
Public PositionY As Integer
Dim Buffer() As Byte

' Settings. '
Public Holds As Integer ' The number of map holds on this feature. '
Public Loaded As Boolean

Sub Initialize()
    Name = ""
    Width = 0
    Height = 0
    PositionX = 0
    PositionY = 0
    FootprintX = 0
    FootprintY = 0
    ReDim Buffer(0)
    FilePTR = 0
    Holds = 0
    Loaded = False
End Sub

Sub LoadImage()
    Dim Flag As Boolean
    
    ' Load the image from the GAF file. '
    If Loaded Then Exit Sub
    Flag = False
    If Trim(Filename) <> "" And Trim(Seqname) <> "" Then
        If LoadGAFImage(HPIFile, Filename, Seqname, Width, Height, PositionX, PositionY, Buffer()) Then
            Flag = True
        End If
    ElseIf Trim(Objectname) <> "" Then
        Load3doImage HPIFile, Filename, Buffer(), Width, Height
        PositionX = Width / 2
        PositionY = Height / 2
        Flag = True
    End If
    
    If Not Flag Then ' Create an image with the name of the feature. '
        Width = 0
        Height = 0
        ReDim Buffer(0)
    End If
    Loaded = True
End Sub

Public Sub ClearMemory()
    If RetainFeatures Then Exit Sub
    If Holds <= 0 Then
        ReDim Buffer(0)
        Holds = 0
        Loaded = False
    End If
End Sub

Sub CreatePalette(xIndex As Integer, yIndex As Integer, DrawBorder As Boolean)
    Dim Color As Byte
    Dim rc As Long
    
    With FrmAnnihilator
    Color = GAFMaskColor
    If Width > 0 And Height > 0 Then
        Screens(PaletteFeatures).ClearTileDraw 0, 0, Width, Height, Buffer(), Color, 255, 0
        Screens(PaletteFeatures).Show .PicFeatures.hdc, xIndex, yIndex, Width, Height, 0, 0
    End If
    If DrawBorder Then
        .PicFeatures.Line (xIndex - 2, yIndex - 2)-(xIndex + Width + 2, yIndex - 2), &HFF8080
        .PicFeatures.Line (xIndex - 2, yIndex - 2)-(xIndex - 2, yIndex + Height + 2), &HFF8080
        .PicFeatures.Line (xIndex - 2, yIndex + Height + 2)-(xIndex + Width + 3, yIndex + Height + 2), &HFF8080
        .PicFeatures.Line (xIndex + Width + 2, yIndex - 2)-(xIndex + Width + 2, yIndex + Height + 2), &HFF8080
    End If
    .PicTemp.Cls
    .PicTemp.Print Name
    rc = BitBlt(.PicFeatures.hdc, xIndex, yIndex + Height + 5, .PicTemp.ScaleWidth, .PicTemp.ScaleHeight, .PicTemp.hdc, 0, 0, SRCCOPY)
    .PicFeatures.Line (0, yIndex + Height + 23)-(.PicFeatures.ScaleWidth, yIndex + Height + 23), RGB(0, 0, 0)
    .PicFeatures.Line (0, yIndex + Height + 24)-(.PicFeatures.ScaleWidth, yIndex + Height + 24), RGB(0, 0, 0)
    yIndex = yIndex + Height + 30
    End With
End Sub

Sub DrawMapFeature(MapPositionX As Long, MapPositionY As Long, Optional Selected As Boolean = False)
    If Selected Then
        'Screens(Canvas).LineDraw MapPositionX + PositionX - FootprintX * 8, MapPositionY + PositionY - FootprintX * 8, MapPositionX + PositionX + FootprintX * 8, MapPositionY + PositionY - FootprintX * 8, 249
        Screens(Canvas).LineDraw MapPositionX, MapPositionY, MapPositionX + Width, MapPositionY, 249
        Screens(Canvas).LineDraw MapPositionX + Width, MapPositionY, MapPositionX + Width, MapPositionY + Height, 249
        Screens(Canvas).LineDraw MapPositionX + Width, MapPositionY + Height, MapPositionX, MapPositionY + Height, 249
        Screens(Canvas).LineDraw MapPositionX, MapPositionY + Height, MapPositionX, MapPositionY, 249
        '.PicFeatures.Line (xIndex + PositionX - FootprintX * 8, yIndex + PositionY - FootprintY * 8)-(xIndex + PositionX - FootprintX * 8, yIndex + PositionY + FootprintY * 8), RGB(0, 255, 0)
        '.PicFeatures.Line (xIndex + PositionX - FootprintX * 8, yIndex + PositionY - FootprintY * 8)-(xIndex + PositionX + FootprintX * 8, yIndex + PositionY - FootprintY * 8), RGB(0, 255, 0)
    End If
    Screens(Canvas).ClearTileDraw MapPositionX, MapPositionY, Width, Height, Buffer(), GAFMaskColor, 100, 1
End Sub

Public Sub AddFeature(LoadFeature As classFeatureLoad)
    Initialize
    Name = LoadFeature.Feature
    Seqname = LoadFeature.Seqname
    Objectname = LoadFeature.Objectname
    FootprintX = LoadFeature.FootprintX
    FootprintY = LoadFeature.FootprintY
    
    If LoadFeature.Filename <> "" Then
        HPI.FindFile HPIAnims, "anims\" & LoadFeature.Filename & ".gaf", HPIFile, Filename
    ElseIf LoadFeature.Objectname <> "" Then
        HPI.FindFile HPIObjects, "objects3d\" & LoadFeature.Objectname & ".3do", HPIFile, Filename
    End If
    If Trim(Name) = "" Then
        Initialize
    End If
End Sub
