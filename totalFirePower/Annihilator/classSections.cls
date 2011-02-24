VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "classSections"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Global section handler. '

Option Explicit

Private Worlds() As New classSectionWorld

Public Sub Initialize()
    ReDim Worlds(0)
    Worlds(0).Initialize
End Sub

' Add a section to the list. '
Public Sub AddSection(HPI As String, ByVal Filename As String)
    Dim World As String
    Dim Buffer As String
    Dim Flag As Boolean
    Dim Blank As Integer
    Dim Index As Integer
    
    Buffer = Filename
    If LCase(Left(Buffer, 9)) = "sections\" Then
        Buffer = Right(Buffer, Len(Buffer) - 9)
    End If
    World = ParseDirName(Buffer)
    
    Blank = -1
    For Index = 0 To UBound(Worlds)
        If LCase(Worlds(Index).Name) = LCase(World) Then
            Worlds(Index).AddSection HPI, Filename, Buffer
            Flag = True
            Exit For
        End If
        If Trim(Worlds(Index).Name) = "" Then Blank = Index
    Next
    If Not Flag Then
        If Blank >= 0 Then
            Worlds(Blank).Initialize
            Worlds(Blank).Name = World
            Worlds(Blank).AddSection HPI, Filename, Buffer
        Else
            ReDim Preserve Worlds(UBound(Worlds) + 1)
            Worlds(UBound(Worlds)).Initialize
            Worlds(UBound(Worlds)).Name = World
            Worlds(UBound(Worlds)).AddSection HPI, Filename, Buffer
        End If
    End If
End Sub

' Create the tabs for all section worlds. '
Public Sub CreateTabs()
    Dim Index As Integer
    Dim Count As Integer
    
    On Error GoTo Error
    
    With FrmAnnihilator
    .TabSectionWorld.Tabs.Clear
    .TabSectionCategory.Tabs.Clear
    For Index = 0 To UBound(Worlds)
        If SelectedSectionWorld = "" Then
            SelectedSectionWorld = Trim(Worlds(Index).Name)
        End If
        If Trim(Worlds(Index).Name) <> "" Then
            Count = Count + 1
            .TabSectionWorld.Tabs.Add , tKey(Index), SCase(Worlds(Index).Name)
            If LCase(SelectedSectionWorld) = LCase(Worlds(Index).Name) Then
                Set .TabSectionWorld.SelectedItem = .TabSectionWorld.Tabs(.TabSectionWorld.Tabs.Count)
            End If
        End If
    Next
    
Error:
    If Count = 0 Then
        .TabSectionWorld.Visible = False
        .TabSectionCategory.Visible = False
        .PicSections.Visible = False
    Else
        .TabSectionWorld.Visible = True
        .TabSectionCategory.Visible = True
        .PicSections.Visible = True
    End If
    End With
End Sub

' Create the tabs for the categories of the selected section world. '
Public Sub CreateCategoryTabs()
    Dim Index As Integer
    
    With FrmAnnihilator
    .TabSectionCategory.Tabs.Clear
    For Index = 0 To UBound(Worlds)
        If SelectedSectionWorld = "" Then
            SelectedSectionWorld = Trim(Worlds(Index).Name)
        End If
        If Trim(Worlds(Index).Name) <> "" Then
            If LCase(SelectedSectionWorld) = LCase(Worlds(Index).Name) Then
                Worlds(Index).CreateTabs
            End If
        End If
    Next
    End With
End Sub

' Draw the selected palette. '
Public Sub CreatePalette()
    Dim Index As Integer
    
    If SelectedSectionWorld = "" Or SelectedSectionCategory = "" Then Exit Sub
    For Index = 0 To UBound(Worlds)
        If LCase(Worlds(Index).Name) = LCase(SelectedSectionWorld) Then
            Worlds(Index).CreatePalette
        End If
    Next
End Sub

' Free the memory for the sections in the selected palette. '
Public Sub ClearMemory()
    Dim Index As Integer
    
    If SelectedSectionWorld = "" Or SelectedSectionCategory = "" Then Exit Sub
    For Index = 0 To UBound(Worlds)
        If LCase(Worlds(Index).Name) = LCase(SelectedSectionWorld) Then
            Worlds(Index).ClearMemory
        End If
    Next
End Sub

' Load the memory for the sections in the selected palette. '
Public Sub LoadMemory()
    Dim Index As Integer
    
    If SelectedSectionWorld = "" Or SelectedSectionCategory = "" Then Exit Sub
    For Index = 0 To UBound(Worlds)
        If LCase(Worlds(Index).Name) = LCase(SelectedSectionWorld) Then
            Worlds(Index).LoadMemory
        End If
    Next
End Sub

' Select a section specified by an index. '
Public Sub SelectSection(Index As Integer)
    Worlds(tIndex(FrmAnnihilator.TabSectionWorld.SelectedItem.Key)).SelectSection Index
End Sub

' Export an HPI archive for the selected world. '
Public Sub ExportHPI(Filename As String)
    Dim FileHandle As Long
    Dim Index As Integer
    
    On Error GoTo Error
    FrmProgress.Captions "Initializing...", "Export Sections"
    FrmProgress.Show
    DoEvents
    FileHandle = HPICreate(Filename, AddressOf HPICallBack)
    If FileHandle = 0 Then Exit Sub

    Index = tIndex(FrmAnnihilator.TabSectionWorld.SelectedItem.Key)
    If Index < 0 Or Index > UBound(Worlds) Then Exit Sub
    If Worlds(Index).Name = "" Then Exit Sub
    
    Worlds(Index).ExportHPI FileHandle
    FrmProgress.Progress.Value = 0
    FrmProgress.Show
    FrmProgress.Captions "Writing file...", "Export Sections"
    DoEvents
    If HPIPackArchive(FileHandle, ZLIB_COMPRESSION) = 0 Then GoTo Error

    Worlds(Index).ClearBuffer
    Unload FrmProgress
    CreatePalette
    Exit Sub
    
Error:
    Unload FrmProgress
    MsgBox Err.Description & "  There was an error exporting the section archive."
End Sub

' Import a BMP file as a section, place in selected palette. '
Public Sub ImportBMP(Filename As String, Optional Greyscale As String = "")
    Dim Index As Integer
    
    On Error GoTo Error
    Index = tIndex(FrmAnnihilator.TabSectionWorld.SelectedItem.Key)
    If Index < 0 Or Index > UBound(Worlds) Then Exit Sub
    If Worlds(Index).Name = "" Then Exit Sub
    Worlds(Index).ImportBMP Filename, Greyscale
Error:
End Sub

Public Sub NewSection(Section As classSection)
    Dim Index As Integer
    
    On Error GoTo Error
    Index = tIndex(FrmAnnihilator.TabSectionWorld.SelectedItem.Key)
    If Index < 0 Or Index > UBound(Worlds) Then Exit Sub
    If Worlds(Index).Name = "" Then Exit Sub
    Worlds(Index).NewSection Section
Error:
End Sub

Public Function AddWorld(World As String) As Long
    Dim Index As Integer, Flag As Long
    
    On Error Resume Next
    Flag = -1
    For Index = 0 To UBound(Worlds)
        If Worlds(Index).Name = "" Then
            Worlds(Index).Initialize
            Worlds(Index).Name = World
            Flag = Index
            Exit For
        End If
    Next
    If Flag < 0 Then
        ReDim Preserve Worlds(UBound(Worlds) + 1)
        Worlds(UBound(Worlds)).Initialize
        Worlds(UBound(Worlds)).Name = World
        Flag = UBound(Worlds)
    End If
    AddWorld = Flag
End Function

Public Function AddCategory(Category As String, World As Integer) As Long
    On Error Resume Next
    AddCategory = Worlds(World).AddCategory(Category)
End Function

Public Sub RemoveWorld(World As Integer)
    On Error Resume Next
    Worlds(World).Initialize
End Sub

Public Sub RemoveCategory(World As Integer, Category As Integer)
    On Error Resume Next
    Worlds(World).RemoveCategory Category
End Sub

Public Sub RemoveSection(World As Integer, Category As Integer, Section As Integer)
    On Error Resume Next
    Worlds(World).RemoveSection Category, Section
End Sub

Public Sub RenameWorld(World As Integer, Buffer As String)
    On Error Resume Next
    Worlds(World).Name = Buffer
End Sub

Public Sub RenameCategory(World As Integer, Category As Integer, Buffer As String)
    On Error Resume Next
    Worlds(World).RenameCategory Category, Buffer
End Sub

Public Sub RenameSection(World As Integer, Category As Integer, Section As Integer, Buffer As String)
    On Error Resume Next
    Worlds(World).RenameSection Category, Section, Buffer
End Sub

' Create a tree-view of the sections. '
Public Sub CreateTree(Tree As TreeView)
    Dim Index As Integer
    
    Tree.Nodes.Clear
    For Index = 0 To UBound(Worlds)
        If Worlds(Index).Name <> "" Then
            Tree.Nodes.Add , , "w" & CStr(Index), SCase(Worlds(Index).Name), 1, 2
            Worlds(Index).CreateTree Tree, "w" & CStr(Index)
        End If
    Next
End Sub
