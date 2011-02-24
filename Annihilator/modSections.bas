Attribute VB_Name = "modSections"
' Annihilator sections module. '

Option Explicit

Global Sections As New classSections
Global Clip As New classSection

' SCT file constants. '
Public Const SCTVersion = 0
Public Const SCTPTRMini = 1
Public Const SCTNumTiles = 2
Public Const SCTPTRTiles = 3
Public Const SCTWidth = 4
Public Const SCTHeight = 5
Public Const SCTPTRData = 6

Public HeightOffset As Integer

Public Sub LoadSections()
    ' Load the list of all the sections in the TA dir. '
    Sections.Initialize
    LoadTASections
End Sub

Public Sub LoadTASections()
    Dim HPIFiles() As String
    Dim SectionFiles() As String
    Dim Index As Long
    
    ' Get all the files from HPIs in the TA dir. '
    HPI.CopyArrays HPISections, HPIFiles(), SectionFiles()
    
    For Index = 0 To UBound(SectionFiles)
        If Not NoUpdate Then
            FrmStartup.Update 1, Index, UBound(SectionFiles)
        End If
        If Trim(HPIFiles(Index)) <> "" And Trim(SectionFiles(Index)) <> "" Then
            Sections.AddSection HPIFiles(Index), SectionFiles(Index)
        End If
    Next
End Sub

