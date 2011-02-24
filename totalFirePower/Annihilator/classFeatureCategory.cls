VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "classFeatureCategory"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Feature category class. '

Option Explicit

Public Name As String
Private Features() As New classFeature

Public Sub Initialize()
    Name = ""
    ReDim Features(0)
    Features(0).Initialize
End Sub

Public Function FindFeature(Feature As String) As Boolean
    Dim Index As Long
    Dim Flag As Boolean
    
    Flag = False
    For Index = 0 To UBound(Features)
        If LCase(Features(Index).Name) = LCase(Feature) Then
            Flag = True
            Exit For
        End If
    Next
    FindFeature = Flag
End Function

Public Sub AddFeature(LoadFeature As classFeatureLoad)
    Dim Index As Long
    Dim Flag As Boolean
    
    Flag = False
    For Index = 0 To UBound(Features)
        If LCase(Features(Index).Name) = LCase(LoadFeature.Feature) Then
            Flag = True
        End If
    Next
    If Not Flag Then ' Add a new feature. '
        Flag = False
        For Index = 0 To UBound(Features)
            If Trim(Features(Index).Name) = "" Then
                Flag = True
                Features(Index).AddFeature LoadFeature
            End If
        Next
        If Not Flag Then
            ReDim Preserve Features(UBound(Features) + 1)
            Features(UBound(Features)).AddFeature LoadFeature
        End If
    End If
End Sub

Public Sub CreatePalette()
    Dim Index As Integer, I As Integer
    Dim xPos As Integer, yPos As Integer
    Dim Flag As Boolean
    
    With FrmAnnihilator
    If UBound(Features) > 0 Then
        .ScrollFeatures.Max = UBound(Features)
        .ScrollFeatures.Visible = True
    Else
        .ScrollFeatures.Max = 0
        .ScrollFeatures.Visible = False
    End If
    
    xPos = 2
    yPos = .TabFeatureCategory.Height + 2
    .PicFeatures.Picture = .PicFeaturePalette.Picture
    .PicFeatures.Cls
    For Index = .ScrollFeatures.Value To UBound(Features)
        Flag = False
        For I = 0 To UBound(SelectedFeatures)
            If LCase(Features(Index).Name) = LCase(SelectedFeatures(I).Name) Then
                Flag = True
                Exit For
            End If
        Next
        Features(Index).CreatePalette xPos, yPos, Flag
        If yPos > .PicFeatures.ScaleHeight Then Exit For
    Next
    .PicFeatures.Refresh
    End With
End Sub

' Free the image memory for this category. '
Public Sub ClearMemory()
    Dim Index As Integer
    
    For Index = 0 To UBound(Features)
        Features(Index).ClearMemory
    Next
End Sub

' Load all the images for this category. '
Public Sub LoadMemory()
    Dim Index As Long

    FrmProgress.Captions "Initializing...", "Loading features"
    FrmProgress.Show , FrmAnnihilator
    For Index = 0 To UBound(Features)
        FrmProgress.Captions "Loading " & Features(Index).Name & "..."
        FrmProgress.Update Index, UBound(Features)
        Features(Index).LoadImage
    Next
    Unload FrmProgress
End Sub

Public Function AttachFeature(FeatureName As String, FeaturePTR As classFeature) As Boolean
    Dim Index As Integer
    
    AttachFeature = False
    For Index = 0 To UBound(Features)
        If LCase(FeatureName) = LCase(Features(Index).Name) Then
            Set FeaturePTR = Features(Index)
            AttachFeature = True
            Exit For
        End If
    Next
End Function

Public Sub SelectFeature(ByVal X As Long, ByVal Y As Long, ByVal Button As Integer)
    Dim Index As Integer, I As Integer, Flag As Boolean, Start As Integer
    Dim yAt As Integer
    
    On Error Resume Next
    yAt = FrmAnnihilator.TabFeatureCategory.Height + 2
    For Index = FrmAnnihilator.ScrollFeatures.Value To UBound(Features)
        If (Y >= yAt) And (Y < (yAt + Features(Index).Height + 30)) Then
            If Button = 1 Then
                ReDim SelectedFeatures(0)
                Set SelectedFeatures(0) = Features(Index)
            ElseIf Button > 1 Then
                Flag = False
                For I = 0 To UBound(SelectedFeatures)
                    If SelectedFeatures(I).Name = Features(Index).Name Then
                        Start = I
                        Flag = True
                        Exit For
                    End If
                Next
                
                If Not Flag Then
                    ReDim Preserve SelectedFeatures(UBound(SelectedFeatures) + 1)
                    Set SelectedFeatures(UBound(SelectedFeatures)) = Features(Index)
                Else
                    If UBound(SelectedFeatures) > 0 Then
                        For I = Start To UBound(SelectedFeatures) - 1
                            Set SelectedFeatures(I) = SelectedFeatures(I + 1)
                        Next
                        ReDim Preserve SelectedFeatures(UBound(SelectedFeatures) - 1)
                    End If
                End If
            End If
            If UBound(SelectedFeatures) = 0 Then
                FrmAnnihilator.FrameFeatureOptions.Visible = False
            Else
                FrmAnnihilator.FrameFeatureOptions.Visible = True
            End If
            Exit For
        End If
        yAt = yAt + Features(Index).Height + 30
    Next
    FrmAnnihilator.Form_Resize
End Sub

