Attribute VB_Name = "modTextures"
' TA texture module. '

Option Explicit

Private HPIFiles() As String
Private TextureFiles() As String

Public Textures() As New classTextureGroup
Public SelectedTexture As New classTexture
Public SelectedPalette As New classTextureGroup

' Load all the textures found in the HPI files. '
Public Sub LoadTextures()
    Dim Index As Integer
    
    On Error GoTo Error
    Screen.MousePointer = vbHourglass
    FrmProgress.Show
    FrmProgress.Status = "Loading textures..."
    FrmProgress.Progress = 0
    
    HPI.CopyArrays HPITextures, HPIFiles(), TextureFiles()
    ReDim Textures(UBound(TextureFiles))
    For Index = 0 To UBound(Textures)
        FrmProgress.Update Index, UBound(Textures)
        Textures(Index).LoadTextures TextureFiles(Index), HPIFiles(Index)
    Next

    CreateTextureList
Error:
    On Error Resume Next
    Unload FrmProgress
    Screen.MousePointer = vbNormal
End Sub

Public Sub AddTexture(Filename As String, HPIFile As String)
    Dim Buffer As String
    
    ReDim Preserve Textures(UBound(Textures) + 1)
    Textures(UBound(Textures)).LoadTextures Filename, HPIFile
        
    Buffer = Right(Filename, Len(Filename) - 9)
    Buffer = Left(Buffer, Len(Buffer) - 4)
    Frm3do.LstTextures.AddItem LCase(Buffer)
    Frm3do.LstTextures.ListIndex = Frm3do.LstTextures.ListCount - 1
End Sub

' Create the texture tabs. '
Public Sub CreateTextureList()
    Dim Buffer As String
    Dim Index As Integer
    
    On Error GoTo Error
    With Frm3do
    .LstTextures.Clear
    For Index = 0 To UBound(TextureFiles)
        Buffer = Right(TextureFiles(Index), Len(TextureFiles(Index)) - 9)
        Buffer = Left(Buffer, Len(Buffer) - 4)
        .LstTextures.AddItem LCase(Buffer)
    Next
    .LstTextures.ListIndex = 0
    Set SelectedPalette = Textures(0)
'    SelectedPalette.LoadImages
    CreateTexturePalette
    End With
Error:
End Sub

Public Sub CreateTexturePalette()
    On Error Resume Next
    SelectedPalette.CreatePalette
End Sub

Public Sub SelectTexture(yIndex As Integer)
    On Error Resume Next
    SelectedPalette.GetTexture yIndex
End Sub

Public Function LoadTexture(TextureName As String) As Boolean
    Dim Index As Integer
    
    LoadTexture = False
    For Index = 0 To UBound(Textures)
        If Textures(Index).LoadTexture(TextureName) Then
            LoadTexture = True
            Exit For
        End If
    Next
End Function

Public Sub DisplayTexture(TextureName As String)
    Dim Index As Integer
    
    'Frm3do.PicTexture.Picture = Frm3do.Picture
    Frm3do.PicTexture.Cls
    For Index = 0 To UBound(Textures)
        If Textures(Index).DisplayTexture(TextureName) Then
            Exit For
        End If
    Next
End Sub

Public Sub GetTextureInfo(TextureName As String, TexturePTR As Long, TextureWidth As Integer, TextureHeight As Integer)
    Dim Index As Integer
    
    For Index = 0 To UBound(Textures)
        If Textures(Index).GetTextureInfo(TextureName, TexturePTR, TextureWidth, TextureHeight) Then
            Exit For
        End If
    Next
End Sub

Public Sub SetTexture(TextureName As String)
    Dim TextureIndex As Long
    Dim Index As Integer
    
    On Error GoTo Error
    For Index = 0 To UBound(Textures)
        TextureIndex = Textures(Index).FindTexture(TextureName)
        If TextureIndex > -1 Then
            Frm3do.LstTextures.ListIndex = Index
            Textures(Index).SetTexture TextureIndex
            Frm3do.ScrollTextures.Value = TextureIndex
            CreateTexturePalette
            Exit For
        End If
    Next
Error:
End Sub
