VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "classSectionCategory"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Section category class. '

Option Explicit

Public Name As String
Private Sections() As New classSection

Public Sub Initialize()
    Name = ""
    ReDim Sections(0)
    Sections(0).Initialize
End Sub

Public Sub AddSection(HPI As String, Filename As String, Section As String)
    Dim Index As Integer
    Dim Flag As Boolean
    
    Flag = False
    For Index = 0 To UBound(Sections)
        If Trim(Sections(Index).Name) = "" Then
            Sections(Index).Initialize
            Sections(Index).Name = Section
            Sections(Index).Filename = Filename
            Sections(Index).HPIName = HPI
            Flag = True
        End If
    Next
    If Not Flag Then
        ReDim Preserve Sections(UBound(Sections) + 1)
        Sections(UBound(Sections)).Initialize
        Sections(UBound(Sections)).Name = Section
        Sections(UBound(Sections)).Filename = Filename
        Sections(UBound(Sections)).HPIName = HPI
    End If
End Sub

Public Sub CreatePalette()
    Dim Index As Integer
    Dim xPos As Integer, yPos As Integer
    Dim TotalSections As Integer
    Dim VisibleSections As Integer
    On Error GoTo Error
    
    With FrmAnnihilator
    
    xPos = 4
    yPos = .TabSectionCategory.Height + 4
    .PicSections.Picture = .PicSectionPalette.Picture
    .PicSections.Cls
    For Index = 0 To UBound(Sections)
        If Sections(Index).Name <> "" Then
            If (TotalSections >= .ScrollSections.Value) And (yPos < .PicSections.ScaleHeight) Then
                Sections(Index).CreatePalette xPos, yPos, (LCase(SelectedSection.Name) = LCase(Sections(Index).Name))
            End If
            TotalSections = TotalSections + 1
        End If
    Next
    .PicSections.Refresh
    
    On Error Resume Next
    VisibleSections = Int(.PicSections.ScaleHeight / 158)
    If VisibleSections > 0 Then
        .ScrollSections.LargeChange = VisibleSections
    Else
        .ScrollSections.LargeChange = 1
    End If
    If (TotalSections - 1) > 0 And (VisibleSections < TotalSections) Then
        .ScrollSections.Max = TotalSections - 1
        .ScrollSections.Visible = True
    Else
        .ScrollSections.Max = 0
        .ScrollSections.Visible = False
    End If
    End With
Error:
End Sub

' Free the image memory for this category. '
Public Sub ClearMemory()
    Dim Index As Integer
    
    For Index = 0 To UBound(Sections)
        Sections(Index).FreeMini
    Next
End Sub

' Load all the images for this category. '
Public Sub LoadMemory()
    Dim Index As Integer
    
    For Index = 0 To UBound(Sections)
        Sections(Index).LoadMini
    Next
End Sub

Public Sub SelectSection(Index As Integer)
    Dim i As Integer, Count As Integer
    
    On Error GoTo Error
    For i = 0 To UBound(Sections)
        If Sections(i).Name <> "" Then
            If Count = Index Then
                Sections(i).LoadSection
                Set SelectedSection = Sections(i)
                SelectedSection.RegionTiles = PasteTiles
                SelectedSection.RegionHeight = PasteHeight
            End If
            Count = Count + 1
        End If
    Next
Error:
End Sub

Public Sub CreateTree(Tree As TreeView, Parent As String)
    Dim Index As Integer
    
    For Index = 0 To UBound(Sections)
        If Sections(Index).Name <> "" Then
            Tree.Nodes.Add Parent, tvwChild, Parent & "s" & CStr(Index), SCase(Sections(Index).Name), 3
        End If
    Next
End Sub

Public Sub RemoveSection(Section As Integer)
    On Error Resume Next
    Sections(Section).Initialize
End Sub

Public Sub RenameSection(Section As Integer, Buffer As String)
    On Error Resume Next
    Sections(Section).Name = Buffer
End Sub

Public Sub ExportHPI(FileHandle As Long, Path As String)
    Dim Index As Integer
    
    For Index = 0 To UBound(Sections)
        If Sections(Index).Name <> "" Then
            Sections(Index).LoadSection
            Sections(Index).LoadMini
            Sections(Index).ExportHPI FileHandle, Path & Name & "\"
        End If
    Next
End Sub

Public Sub ClearBuffer()
    Dim Index As Integer
    
    For Index = 0 To UBound(Sections)
        If Sections(Index).Name <> "" Then
            Sections(Index).FreeSection
            Sections(Index).ClearBuffer
        End If
    Next
End Sub

' Import a BMP file as a section. '
Public Function ImportBMP(Filename As String, Optional Greyscale As String = "") As Long
    Dim Index As Integer
    Dim Flag As Boolean
    
    On Error GoTo Error
    
    Flag = False
'    For Index = 0 To UBound(Sections)
'        If Trim(Sections(Index).Name) = "" Then
'            Sections(Index).Initialize
'            Sections(Index).Name = Section
'            Sections(Index).ImportBMP Filename
'            If Greyscale <> "" Then
'                Sections(Index).ImportHeight Greyscale
'            End If
'            SelectedSection.FreeSection
'            Set SelectedSection = Sections(Index)
'            Flag = True
'            Exit For
'        End If
'    Next
    If Not Flag Then
        ReDim Preserve Sections(UBound(Sections) + 1)
        Sections(UBound(Sections)).Initialize
        Sections(UBound(Sections)).ImportBMP Filename
        If Greyscale <> "" Then
            Sections(UBound(Sections)).ImportHeight Greyscale
        End If
        Sections(UBound(Sections)).RegionTiles = True
        Sections(UBound(Sections)).RegionHeight = True
        SelectedSection.FreeSection
        Set SelectedSection = Sections(UBound(Sections))
        Index = UBound(Sections)
    End If
    
Error:
    ImportBMP = Index
End Function

Public Function NewSection(Section As classSection) As Long
    Dim Index As Integer, i As Integer
    Dim Flag As Boolean
    On Error GoTo Error
    
    Flag = False
    For i = 0 To UBound(Sections)
        Index = i
        If Trim(Sections(i).Name) = "" Then
            Flag = True
            Exit For
        End If
    Next
    If Not Flag Then
        Index = Index + 1
        ReDim Preserve Sections(Index)
    End If
    
    Sections(Index).Initialize
    Section.SetSection Sections(Index), Name & Format(Index + 1, "00") & ".sct"
    SelectedSection.FreeSection
Error:
    NewSection = UBound(Sections)
End Function
