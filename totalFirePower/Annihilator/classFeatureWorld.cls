VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "classFeatureWorld"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Feature world class. '

Option Explicit

Public Name As String
Private Categories() As New classFeatureCategory

Public Sub Initialize()
    Name = ""
    ReDim Categories(0)
    Categories(0).Initialize
End Sub

Public Function FindFeature(Category As String, Feature As String) As Boolean
    Dim Index As Long
    Dim Flag As Boolean
    
    Flag = False
    For Index = 0 To UBound(Categories)
        If LCase(Categories(Index).Name) = LCase(Category) Then
            Flag = Categories(Index).FindFeature(Feature)
            Exit For
        End If
    Next
    FindFeature = Flag
End Function

Public Sub AddFeature(LoadFeature As classFeatureLoad)
    Dim Index As Long
    Dim Flag As Boolean
    
    Flag = False
    For Index = 0 To UBound(Categories)
        If LCase(Categories(Index).Name) = LCase(LoadFeature.Category) Then
            Flag = True
            Categories(Index).AddFeature LoadFeature
            Exit For
        End If
    Next
    If Not Flag Then ' Add a new category. '
        Flag = False
        For Index = 0 To UBound(Categories)
            If Trim(Categories(Index).Name) = "" Then
                Flag = True
                Categories(Index).Initialize
                Categories(Index).Name = LoadFeature.Category
                Categories(Index).AddFeature LoadFeature
            End If
        Next
        If Not Flag Then
            ReDim Preserve Categories(UBound(Categories) + 1)
            Categories(UBound(Categories)).Initialize
            Categories(UBound(Categories)).Name = LoadFeature.Category
            Categories(UBound(Categories)).AddFeature LoadFeature
        End If
    End If
End Sub

Public Sub CreateTabs()
    Dim Index As Integer
    Dim Count As Integer
    
    With FrmAnnihilator
    For Index = 0 To UBound(Categories)
        If SelectedFeatureCategory = "" Then
            SelectedFeatureCategory = Trim(Categories(Index).Name)
        End If
        If Trim(Categories(Index).Name) <> "" Then
            Count = Count + 1
            .TabFeatureCategory.Tabs.Add , tKey(Index), SCase(Categories(Index).Name)
            If LCase(SelectedFeatureCategory) = LCase(Categories(Index).Name) Then
                Set .TabFeatureCategory.SelectedItem = .TabFeatureCategory.Tabs(.TabFeatureCategory.Tabs.Count)
            End If
        End If
    Next
    
    If Count = 0 Then
        .TabFeatureCategory.Visible = False
        .PicFeatures.Visible = False
    Else
        .TabFeatureCategory.Visible = True
        .PicFeatures.Visible = True
    End If
    End With
End Sub

Public Sub CreatePalette()
    Dim Index As Integer
    
    For Index = 0 To UBound(Categories)
        If LCase(Categories(Index).Name) = LCase(SelectedFeatureCategory) Then
            Categories(Index).CreatePalette
        End If
    Next
End Sub

Public Sub ClearMemory()
    Dim Index As Integer
    
    For Index = 0 To UBound(Categories)
        If LCase(Categories(Index).Name) = LCase(SelectedFeatureCategory) Then
            Categories(Index).ClearMemory
        End If
    Next
End Sub

Public Sub LoadMemory()
    Dim Index As Integer
    
    For Index = 0 To UBound(Categories)
        If LCase(Categories(Index).Name) = LCase(SelectedFeatureCategory) Then
            Categories(Index).LoadMemory
        End If
    Next
End Sub

Public Function AttachFeature(FeatureName As String, FeaturePTR As classFeature)
    Dim Index As Integer
    
    AttachFeature = False
    For Index = 0 To UBound(Categories)
        If Categories(Index).AttachFeature(FeatureName, FeaturePTR) Then
            AttachFeature = True
            Exit For
        End If
    Next
End Function

Public Sub SelectFeature(ByVal x As Long, ByVal y As Long, ByVal Button As Integer)
    Categories(tIndex(FrmAnnihilator.TabFeatureCategory.SelectedItem.Key)).SelectFeature x, y, Button
End Sub

