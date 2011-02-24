VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "classTextureGroup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' TA texture group class. '

Option Explicit

Private Textures() As New classTexture

Public HPIFilename As String
Public FileName As String

' Load all the textures in the specified GAF. '
Public Sub LoadTextures(tFIlename As String, tHPIFilename As String)
    Dim GAFPTRs() As Long
    Dim Names() As String
    Dim Index As Integer
    
    ReDim GAFPTRs(0)
    ReDim Names(0)
    
    On Error GoTo Error
    HPIFilename = tHPIFilename
    FileName = tFIlename
    CreateGAFPTRList HPIFilename, FileName, GAFPTRs(), Names()
    
    If UBound(Names) <> 0 Then
        ReDim Textures(UBound(Names) - 1)
        For Index = 0 To UBound(Textures)
            Textures(Index).Name = Names(Index + 1)
            Textures(Index).FilePTR = GAFPTRs(Index + 1)
        Next
    End If
Error:
End Sub

' Load all the images in this palette. '
Public Sub LoadImages()
    Dim HPI As Long
    Dim rc As Long
    Dim FileHandle As Integer
    Dim Index As Integer

    On Error GoTo Error
    Screen.MousePointer = vbHourglass
    FrmProgress.Show
    FrmProgress.Status = "Loading textures from " & FileName & "..."
    FrmProgress.Progress = 0

    ' Load the HPI file. '
    On Error Resume Next
    HPI = HPIOpen(HPIFilename)
    If HPI = 0 Then Exit Sub
    
    ' Extract the GAF file. '
    Kill App.Path & "\temp.gaf"
    rc = HPIExtractFile(HPI, FileName, App.Path & "\temp.gaf")
    If rc = 0 Then Exit Sub
    
    rc = HPIClose(HPI)
    
    ' Open the GAF file. '
    FileHandle = FreeFile
    Open App.Path & "\temp.gaf" For Binary As FileHandle
    
    ' Load the textures. '
    For Index = 0 To UBound(Textures)
        FrmProgress.Update Index, UBound(Textures)
        If Not Textures(Index).Loaded Then
            Textures(Index).LoadImage FileHandle
        End If
    Next
    
Error:
    Unload FrmProgress
    Screen.MousePointer = vbNormal
    Close FileHandle
    Kill App.Path & "\temp.gaf"
End Sub

' Create the texture palette. '
Public Sub CreatePalette()
    Dim Index As Integer, i As Integer
    Dim xPos As Integer, yPos As Integer
    Dim Flag As Boolean
    
    With Frm3do
    On Error GoTo Error
    
    xPos = 2
    yPos = 2
    .PicTextures.Picture = .Picture
    .PicTextures.Cls
    For Index = .ScrollTextures.Value To UBound(Textures)
        If Textures(Index).Name <> "" Then
            Flag = False
            If LCase(Textures(Index).Name) = LCase(SelectedTexture.Name) Then
                Flag = True
            End If
            Textures(Index).CreatePalette xPos, yPos, Flag
        End If
        If yPos > .PicTextures.ScaleHeight Then Exit For
    Next
    .PicTextures.Picture = .PicTextures.Image
    
    If UBound(Textures) > 0 Then
        .ScrollTextures.Max = UBound(Textures)
        .ScrollTextures.Visible = True
    Else
        .ScrollTextures.Max = 0
        .ScrollTextures.Visible = False
    End If
    End With
Error:
End Sub

Public Sub SelectTexture(ByVal y As Long)
    Dim Index As Integer, i As Integer
    Dim yPos As Integer
    Dim Flag As Boolean
    
    On Error GoTo Error
    
    yPos = 2
    For Index = Frm3do.ScrollTextures.Value To UBound(Textures)
        If Textures(Index).Name <> "" Then
            If (y >= yPos) And (y < yPos + Textures(Index).Height + 27) Then
                Set SelectedTexture = Textures(Index)
            End If
            yPos = yPos + Textures(Index).Height + 27
        End If
    Next
    CreatePalette
Error:
End Sub

Public Function FindTexture(Texture As String) As Long
    Dim Index As Long
    
    FindTexture = -1
    For Index = 0 To UBound(Textures)
        If LCase(Textures(Index).Name) = LCase(Texture) Then
            FindTexture = Index
            Exit For
        End If
    Next
End Function

Public Function GetTexture(y As Integer) As String
    Dim Index As Integer, i As Integer
    Dim xPos As Integer, yPos As Integer
    Dim Flag As Boolean
    
    With Frm3do
    On Error Resume Next
    xPos = 2
    yPos = 2
    For Index = .ScrollTextures.Value To UBound(Textures)
        If Textures(Index).Name <> "" Then
            If (y >= yPos) And (y < yPos + Textures(Index).Height + 30) Then
                GetTexture = Textures(Index).Name
                Exit For
            End If
            yPos = yPos + Textures(Index).Height + 30
            If yPos > .PicTextures.ScaleHeight Then Exit For
        End If
    Next
    End With
End Function

Public Function LoadTexture(TextureName As String) As Boolean
    Dim Index As Integer
    
    LoadTexture = False
    On Error GoTo Error
    For Index = 0 To UBound(Textures)
        If LCase(TextureName) = LCase(Textures(Index).Name) Then
            If Not Textures(Index).Loaded Then
                LoadImages
            End If
            LoadTexture = True
            Exit For
        End If
    Next
Error:
End Function

Public Function DisplayTexture(TextureName As String) As Boolean
    Dim Index As Integer
    
    DisplayTexture = False
    On Error GoTo Error
    For Index = 0 To UBound(Textures)
        If LCase(TextureName) = LCase(Textures(Index).Name) Then
            Textures(Index).DisplayTexture
            DisplayTexture = True
            Exit For
        End If
    Next
Error:
End Function

Public Function GetTextureInfo(TextureName As String, TexturePTR As Long, TextureWidth As Integer, TextureHeight As Integer) As Boolean
    Dim Index As Integer
    
    GetTextureInfo = False
    On Error GoTo Error
    For Index = 0 To UBound(Textures)
        If LCase(TextureName) = LCase(Textures(Index).Name) Then
            Textures(Index).GetTextureInfo TexturePTR, TextureWidth, TextureHeight
            GetTextureInfo = True
            Exit For
        End If
    Next
Error:
End Function

Public Sub SetTexture(Index As Long)
    On Error Resume Next
    Set SelectedTexture = Textures(Index)
End Sub
