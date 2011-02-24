VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "classSectionWorld"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Section world class. '

Option Explicit

Public Name As String
Private Categories() As New classSectionCategory

Public Sub Initialize()
    Name = ""
    ReDim Categories(0)
    Categories(0).Initialize
End Sub

Public Sub AddSection(HPI As String, Filename As String, Buffer As String)
    Dim Category As String
    Dim Flag As Boolean
    Dim Blank As Integer
    Dim Index As Integer

    Category = ParseDirName(Buffer)

    Blank = -1
    For Index = 0 To UBound(Categories)
        If LCase(Categories(Index).Name) = LCase(Category) Then
            Categories(Index).AddSection HPI, Filename, Buffer
            Flag = True
            Exit For
        End If
        If Trim(Categories(Index).Name) = "" Then Blank = Index
    Next
    If Not Flag Then
        If Blank >= 0 Then
            Categories(Blank).Initialize
            Categories(Blank).Name = Category
            Categories(Blank).AddSection HPI, Filename, Buffer
        Else
            ReDim Preserve Categories(UBound(Categories) + 1)
            Categories(UBound(Categories)).Initialize
            Categories(UBound(Categories)).Name = Category
            Categories(UBound(Categories)).AddSection HPI, Filename, Buffer
        End If
    End If
End Sub

Public Sub CreateTabs()
    Dim Index As Integer
    Dim Count As Integer
    
    With FrmAnnihilator
    For Index = 0 To UBound(Categories)
        If SelectedSectionCategory = "" Then
            SelectedSectionCategory = Trim(Categories(Index).Name)
        End If
        If Trim(Categories(Index).Name) <> "" Then
            Count = Count + 1
            .TabSectionCategory.Tabs.Add , tKey(Index), SCase(Categories(Index).Name)
            If LCase(SelectedSectionCategory) = LCase(Categories(Index).Name) Then
                Set .TabSectionCategory.SelectedItem = .TabSectionCategory.Tabs(.TabSectionCategory.Tabs.Count)
            End If
        End If
    Next
    
    If Count = 0 Then
        .TabSectionCategory.Visible = False
        .PicSections.Visible = False
    Else
        .TabSectionCategory.Visible = True
        .PicSections.Visible = True
    End If
    End With
End Sub

Public Sub CreatePalette()
    Dim Index As Integer
        
    For Index = 0 To UBound(Categories)
        If LCase(Categories(Index).Name) = LCase(SelectedSectionCategory) Then
            Categories(Index).CreatePalette
        End If
    Next
End Sub

Public Sub ClearMemory()
    Dim Index As Integer
    
    For Index = 0 To UBound(Categories)
        If LCase(Categories(Index).Name) = LCase(SelectedSectionCategory) Then
            Categories(Index).ClearMemory
        End If
    Next
End Sub

Public Sub LoadMemory()
    Dim Index As Integer
    
    For Index = 0 To UBound(Categories)
        If LCase(Categories(Index).Name) = LCase(SelectedSectionCategory) Then
            Categories(Index).LoadMemory
        End If
    Next
End Sub

Public Sub SelectSection(Index As Integer)
    On Error GoTo ERror
    Categories(tIndex(FrmAnnihilator.TabSectionCategory.SelectedItem.Key)).SelectSection Index
    Exit Sub
ERror:
    With FrmAnnihilator
    .PicSections.Picture = .PicSectionPalette.Picture
    .PicSections.Cls
    .ScrollSections.Visible = False
    End With
End Sub

Public Sub CreateTree(Tree As TreeView, Parent As String)
    Dim Index As Integer
    
    For Index = 0 To UBound(Categories)
        If Categories(Index).Name <> "" Then
            Tree.Nodes.Add Parent, tvwChild, Parent & "c" & CStr(Index), SCase(Categories(Index).Name), 1, 2
            Categories(Index).CreateTree Tree, Parent & "c" & CStr(Index)
        End If
    Next
End Sub

Public Function AddCategory(Category As String) As Long
    Dim Index As Integer, Flag As Long
    
    On Error Resume Next
    Flag = -1
    For Index = 0 To UBound(Categories)
        If Categories(Index).Name = "" Then
            Categories(Index).Initialize
            Categories(Index).Name = Category
            Flag = Index
            Exit For
        End If
    Next
    If Flag < 0 Then
        ReDim Preserve Categories(UBound(Categories) + 1)
        Categories(UBound(Categories)).Initialize
        Categories(UBound(Categories)).Name = Category
        Flag = UBound(Categories)
    End If
    AddCategory = Flag
End Function

Public Sub RemoveCategory(Category As Integer)
    On Error Resume Next
    Categories(Category).Initialize
End Sub

Public Sub RemoveSection(Category As Integer, Section As Integer)
    On Error Resume Next
    Categories(Category).RemoveSection Section
End Sub

Public Sub RenameCategory(Category As Integer, Buffer As String)
    On Error Resume Next
    Categories(Category).Name = Buffer
End Sub

Public Sub RenameSection(Category As Integer, Section As Integer, Buffer As String)
    On Error Resume Next
    Categories(Category).RenameSection Section, Buffer
End Sub

Public Sub ExportHPI(FileHandle As Long)
    Dim Index As Long
    
    For Index = 0 To UBound(Categories)
        FrmProgress.Update Index, UBound(Categories)
        If Categories(Index).Name <> "" Then
            Categories(Index).ExportHPI FileHandle, "sections\" & Name & "\"
        End If
    Next
End Sub

Public Sub ClearBuffer()
    Dim Index As Integer
    
    For Index = 0 To UBound(Categories)
        If Categories(Index).Name <> "" Then
            Categories(Index).ClearBuffer
        End If
    Next
End Sub

' Import a BMP file as a section, place in selected palette. '
Public Sub ImportBMP(Filename As String, Optional Greyscale As String = "")
    Dim Index As Integer
    
    On Error GoTo ERror
    Index = tIndex(FrmAnnihilator.TabSectionCategory.SelectedItem.Key)
    If Index < 0 Or Index > UBound(Categories) Then Exit Sub
    If Categories(Index).Name = "" Then Exit Sub
    Index = Categories(Index).ImportBMP(Filename, Greyscale)
    Sections.CreatePalette
    FrmAnnihilator.ScrollSections.Value = Index
ERror:
End Sub

Public Sub NewSection(Section As classSection)
    Dim Index As Integer
    
    On Error GoTo ERror
    Index = tIndex(FrmAnnihilator.TabSectionCategory.SelectedItem.Key)
    If Index < 0 Or Index > UBound(Categories) Then Exit Sub
    If Categories(Index).Name = "" Then Exit Sub
    Index = Categories(Index).NewSection(Section)
    Sections.CreatePalette
    FrmAnnihilator.ScrollSections.Value = Index
ERror:
End Sub
