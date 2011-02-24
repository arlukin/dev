VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "classFeatures"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Global feature handler. '

Option Explicit

Private Worlds() As New classFeatureWorld

Public Sub Initialize()
    ReDim Worlds(0)
    Worlds(0).Initialize
End Sub

Public Function FindFeature(World As String, Category As String, Feature As String) As Boolean
    Dim Index As Long
    Dim Flag As Boolean
    
    Flag = False
    For Index = 0 To UBound(Worlds)
        If LCase(Worlds(Index).Name) = LCase(World) Then
            Flag = Worlds(Index).FindFeature(Category, Feature)
            Exit For
        End If
    Next
    FindFeature = Flag
End Function

Public Sub AddFeature(LoadFeature As classFeatureLoad)
    Dim Index As Long
    Dim Flag As Boolean
    
    On Error GoTo Error
    
    If Not LoadFeature.Used Then Exit Sub
    
    Flag = False
    For Index = 0 To UBound(Worlds)
        If LCase(Worlds(Index).Name) = LCase(LoadFeature.World) Then
            Flag = True
            Worlds(Index).AddFeature LoadFeature
        End If
    Next
    If Not Flag Then ' Add a new world. '
        Flag = False
        For Index = 0 To UBound(Worlds)
            If Trim(Worlds(Index).Name) = "" Then
                Flag = True
                Worlds(Index).Initialize
                Worlds(Index).Name = LoadFeature.World
                Worlds(Index).AddFeature LoadFeature
            End If
        Next
        If Not Flag Then
            ReDim Preserve Worlds(UBound(Worlds) + 1)
            Worlds(UBound(Worlds)).Initialize
            Worlds(UBound(Worlds)).Name = LoadFeature.World
            Worlds(UBound(Worlds)).AddFeature LoadFeature
        End If
    End If
Error:
End Sub

Public Sub CreateTabs()
    Dim Index As Integer
    Dim Count As Integer
    
    On Error GoTo Error
    
    With FrmAnnihilator
    .TabFeatureWorld.Tabs.Clear
    .TabFeatureCategory.Tabs.Clear
    For Index = 0 To UBound(Worlds)
        If SelectedFeatureWorld = "" Then
            SelectedFeatureWorld = Trim(Worlds(Index).Name)
        End If
        If Trim(Worlds(Index).Name) <> "" Then
            Count = Count + 1
            .TabFeatureWorld.Tabs.Add , tKey(Index), SCase(Worlds(Index).Name)
            If LCase(SelectedFeatureWorld) = LCase(Worlds(Index).Name) Then
                Set .TabFeatureWorld.SelectedItem = .TabFeatureWorld.Tabs(.TabFeatureWorld.Tabs.Count)
                'Worlds(Index).CreateTabs
            End If
        End If
    Next
    
Error:
    If Count = 0 Then
        .TabFeatureWorld.Visible = False
        .TabFeatureCategory.Visible = False
        .PicFeatures.Visible = False
    Else
        .TabFeatureWorld.Visible = True
        .TabFeatureCategory.Visible = True
        .PicFeatures.Visible = True
    End If
    End With
End Sub

Public Sub CreateCategoryTabs()
    Dim Index As Integer
    
    With FrmAnnihilator
    .TabFeatureCategory.Tabs.Clear
    For Index = 0 To UBound(Worlds)
        If SelectedFeatureWorld = "" Then
            SelectedFeatureWorld = Trim(Worlds(Index).Name)
        End If
        If Trim(Worlds(Index).Name) <> "" Then
            If LCase(SelectedFeatureWorld) = LCase(Worlds(Index).Name) Then
                Worlds(Index).CreateTabs
            End If
        End If
    Next
    End With
End Sub

Public Sub CreatePalette()
    Dim Index As Integer
    
    If SelectedFeatureWorld = "" Or SelectedFeatureCategory = "" Then Exit Sub
    For Index = 0 To UBound(Worlds)
        If LCase(Worlds(Index).Name) = LCase(SelectedFeatureWorld) Then
            Worlds(Index).CreatePalette
        End If
    Next
End Sub

Public Sub ClearMemory()
    Dim Index As Integer
    
    If SelectedFeatureWorld = "" Or SelectedFeatureCategory = "" Then Exit Sub
    For Index = 0 To UBound(Worlds)
        If LCase(Worlds(Index).Name) = LCase(SelectedFeatureWorld) Then
            Worlds(Index).ClearMemory
        End If
    Next
End Sub

Public Sub LoadMemory()
    Dim Index As Integer
    
    If SelectedFeatureWorld = "" Or SelectedFeatureCategory = "" Then Exit Sub
    For Index = 0 To UBound(Worlds)
        If LCase(Worlds(Index).Name) = LCase(SelectedFeatureWorld) Then
            Worlds(Index).LoadMemory
        End If
    Next
End Sub

' Attach the handle of the specified feature to the PTR. '
Public Function AttachFeature(FeatureName As String, FeaturePTR As classFeature) As Boolean
    Dim Index As Integer
    
    On Error GoTo Error
    
    AttachFeature = False
    For Index = 0 To UBound(Worlds)
        If Worlds(Index).AttachFeature(FeatureName, FeaturePTR) Then
            AttachFeature = True
            Exit For
        End If
    Next
Error:
End Function

Public Sub SelectFeature(ByVal x As Long, ByVal y As Long, ByVal Button As Integer)
    Worlds(tIndex(FrmAnnihilator.TabFeatureWorld.SelectedItem.Key)).SelectFeature x, y, Button
End Sub
