Attribute VB_Name = "modFeatures"
Option Explicit

' Global feature list. '
Global Features As New classFeatures
Global TAList() As New classFeatureLoad

' Get the features list and update the feature archive as needed. '
Sub LoadFeatures()
    ' Initialize. '
    ReDim TAList(0)
    
    ' Load the list of all the features in the TA dir. '
    Screen.MousePointer = vbHourglass
    Features.Initialize
    LoadTAFeatures
    
    Screen.MousePointer = vbNormal
End Sub

' Load the feature list from TA's TDF files. '
Public Sub LoadTAFeatures()
    Dim FeatureFiles() As String
    Dim HPIFiles() As String
    Dim OpenFile As String
    Dim HPIFile As Long
    Dim rc As Long
    Dim Index As Long
        
    ' Get all the files from HPIs in the TA dir. '
    HPI.CopyArrays HPIFeatures, HPIFiles(), FeatureFiles()

    ' Create a list of every feature in the TA dir. '
    For Index = 0 To UBound(FeatureFiles)
        If Not NoUpdate Then
            FrmStartup.Update 2, Index, UBound(FeatureFiles)
        End If
        If LCase(OpenFile) <> LCase(HPIFiles(Index)) Then
            If HPIFile <> 0 Then rc = HPIClose(HPIFile)
            HPIFile = HPIOpen(HPIFiles(Index))
            If HPIFile > 0 Then
                OpenFile = HPIFiles(Index)
            Else
                OpenFile = ""
            End If
        End If
        If HPIFile <> 0 Then
            LoadTDFFeatureNames2 HPIFile, FeatureFiles(Index)
        End If
    Next
End Sub

' Load all the names of features to the TA list. '
Private Sub LoadTDFFeatureNames(HPI As Long, Filename As String)
    Dim rc As Long
    Dim TempFile As String
    Dim FileHandle As Integer
    Dim Index As Long, TempIndex As Long
    Dim StartIndex As Long
    Dim EndIndex As Long
    Dim Flag As Boolean
    Dim Buffer As String
    Dim FileBuf As String
    Dim BufferIndex As Integer
    Dim FeatureWorld As String
    Dim FeatureCategory As String
    Dim FeatureName As String
    Dim FootprintX As Integer
    Dim FootprintY As Integer
    Dim FeatureFilename As String
    Dim FeatureSeqName As String
    Dim FeatureObjName As String
    
    On Error Resume Next
        
    ' Extract the TDF file. '
    TempFile = App.Path
    If Right(App.Path, 1) <> "\" Then TempFile = TempFile & "\"
    TempFile = TempFile & "temp.tdf"
    Kill TempFile
    rc = HPIExtractFile(HPI, Filename, TempFile)
    If rc = 0 Then
        Exit Sub
    End If
        
    FeatureWorld = Filename
    If LCase(Left(FeatureWorld, 9)) = "features\" Then
        FeatureWorld = Right(FeatureWorld, Len(FeatureWorld) - 9)
    End If
    FeatureWorld = ParseDirName(FeatureWorld)
    
    ' Parse the TDF file. '
    FileHandle = FreeFile
    Index = FileLen(TempFile)
    Open TempFile For Binary As FileHandle
    FileBuf = String(Index, " ")
    Get FileHandle, , FileBuf
    FileBuf = LCase(FileBuf)
    
    ' Parse the file buffer. '
    StartIndex = 1
    StartIndex = InStr(StartIndex, FileBuf, "[")
    Do While StartIndex <> 0
        EndIndex = InStr(StartIndex, FileBuf, "}")
        If EndIndex = 0 Then EndIndex = Len(FileBuf)
        
        Index = InStr(StartIndex, FileBuf, "category=", 1)
        If (Index > 0) And (Index < EndIndex) Then
            TempIndex = InStr(Index, FileBuf, ";")
            If TempIndex <> 0 Then
                TAList(0).Category = Mid(FileBuf, Index + 9, TempIndex - Index - 9)
                'MsgBox TAList(0).Category
            End If
        End If
        StartIndex = InStr(StartIndex + 1, FileBuf, "[")
'        Buffer = GetLine(FileBuf, Index)
'        Buffer = StripNull(Trim(Buffer))
'            If Right(Buffer, 1) = "}" Then ' End of feature. '
'                If (FeatureName <> "") And (FeatureWorld <> "") And (FeatureCategory <> "") And (FootprintX <> 0) And (FootprintY <> 0) Then
'                    ' Check the TA list, update. '
'                    Flag = False
'                    For Index = 0 To UBound(TAList)
'                        If Not TAList(Index).Used Then
'                            Flag = True
'                            TAList(Index).World = FeatureWorld
'                            TAList(Index).Category = FeatureCategory
'                            TAList(Index).Feature = FeatureName
'                            TAList(Index).FootprintX = FootprintX
'                            TAList(Index).FootprintY = FootprintY
'                            TAList(Index).Seqname = FeatureSeqName
'                            TAList(Index).Filename = FeatureFilename
'                            TAList(Index).Objectname = FeatureObjName
'                            TAList(Index).Used = True
'                            Features.AddFeature TAList(Index)
'                            Exit For
'                        End If
'                    Next
'                    If Not Flag Then
'                        ReDim Preserve TAList(Index)
'                        TAList(Index).World = FeatureWorld
'                        TAList(Index).Category = FeatureCategory
'                        TAList(Index).Feature = FeatureName
'                        TAList(Index).FootprintX = FootprintX
'                        TAList(Index).FootprintY = FootprintY
'                        TAList(Index).Seqname = FeatureSeqName
'                        TAList(Index).Filename = FeatureFilename
'                        TAList(Index).Objectname = FeatureObjName
'                        TAList(Index).Used = True
'                        Features.AddFeature TAList(Index)
'                    End If
'                    'FeatureWorld = ""
'                    FeatureCategory = ""
'                    FeatureName = ""
'                    FootprintX = 0
'                    FootprintY = 0
'                    FeatureSeqName = ""
'                    FeatureFilename = ""
'                    FeatureObjName = ""
'                End If
'            End If
'            If Left(Buffer, 1) = "[" Then ' a new feature. '
'                BufferIndex = InStr(1, Buffer, "]")
'                If BufferIndex <> 0 Then
'                    FeatureName = Left(Buffer, BufferIndex - 1)
'                    FeatureName = (Right(FeatureName, Len(FeatureName) - 1))
'                End If
'            End If
'            'BufferIndex = InStr(1, LCase(Buffer), "world=")
'            'If BufferIndex <> 0 Then
'            '    FeatureWorld = (Mid(Buffer, BufferIndex + 6, Len(Buffer) - BufferIndex - 6))
'            'End If
'            BufferIndex = InStr(1, LCase(Buffer), "category=")
'            If BufferIndex <> 0 Then
'                FeatureCategory = (Mid(Buffer, BufferIndex + 9, Len(Buffer) - BufferIndex - 9))
'            End If
'            BufferIndex = InStr(1, LCase(Buffer), "footprintx=")
'            If BufferIndex <> 0 Then
'                FootprintX = Val(Mid(Buffer, BufferIndex + 11, Len(Buffer) - BufferIndex - 11))
'            End If
'            BufferIndex = InStr(1, LCase(Buffer), "footprintz=")
'            If BufferIndex <> 0 Then
'                FootprintY = Val(Mid(Buffer, BufferIndex + 11, Len(Buffer) - BufferIndex - 11))
'            End If
'            BufferIndex = InStr(1, LCase(Buffer), "filename=")
'            If BufferIndex <> 0 Then
'                FeatureFilename = (Mid(Buffer, BufferIndex + 9, Len(Buffer) - BufferIndex - 9))
'            End If
'            BufferIndex = InStr(1, LCase(Buffer), "seqname=")
'            If BufferIndex <> 0 Then
'                FeatureSeqName = (Mid(Buffer, BufferIndex + 8, Len(Buffer) - BufferIndex - 8))
'            End If
'            BufferIndex = InStr(1, LCase(Buffer), "object=")
'            If BufferIndex <> 0 Then
'                FeatureObjName = (Mid(Buffer, BufferIndex + 7, Len(Buffer) - BufferIndex - 7))
'            End If
    Loop
    
    Close FileHandle
    Kill TempFile
End Sub

' Load all the names of features to the TA list. '
Private Sub LoadTDFFeatureNames2(HPI As Long, Filename As String)
    Dim rc As Long
    Dim TempFile As String
    Dim FileHandle As Integer
    Dim Index As Long
    Dim Flag As Boolean
    Dim Buffer As String
    Dim BufferIndex As Integer
    Dim FeatureWorld As String
    Dim FeatureCategory As String
    Dim FeatureName As String
    Dim FootprintX As Integer
    Dim FootprintY As Integer
    Dim FeatureFilename As String
    Dim FeatureSeqName As String
    Dim FeatureObjName As String
    
    On Error Resume Next
        
    ' Extract the TDF file. '
    TempFile = App.Path
    If Right(App.Path, 1) <> "\" Then TempFile = TempFile & "\"
    TempFile = TempFile & "temp.tdf"
    Kill TempFile
    rc = HPIExtractFile(HPI, Filename, TempFile)
    If rc = 0 Then
        Exit Sub
    End If
        
    FeatureWorld = Filename
    If LCase(Left(FeatureWorld, 9)) = "features\" Then
        FeatureWorld = Right(FeatureWorld, Len(FeatureWorld) - 9)
    End If
    FeatureWorld = ParseDirName(FeatureWorld)
    
    ' Parse the TDF file. '
    FileHandle = FreeFile
    Open TempFile For Binary As FileHandle
        Do While Not EOF(FileHandle)
            Line Input #FileHandle, Buffer
            Buffer = StripNull(Trim(Buffer))
            BufferIndex = InStr(1, LCase(Buffer), "}")
            If BufferIndex <> 0 Then ' End of feature. '
                If (FeatureName <> "") And (FeatureWorld <> "") And (FeatureCategory <> "") And (FootprintX <> 0) And (FootprintY <> 0) Then
                    ' Check the TA list, update. '
                    Flag = False
                    For Index = 0 To UBound(TAList)
                        If Not TAList(Index).Used Then
                            Flag = True
                            TAList(Index).World = FeatureWorld
                            TAList(Index).Category = FeatureCategory
                            TAList(Index).Feature = FeatureName
                            TAList(Index).FootprintX = FootprintX
                            TAList(Index).FootprintY = FootprintY
                            TAList(Index).Seqname = FeatureSeqName
                            TAList(Index).Filename = FeatureFilename
                            TAList(Index).Objectname = FeatureObjName
                            TAList(Index).Used = True
                            Features.AddFeature TAList(Index)
                            Exit For
                        End If
                    Next
                    If Not Flag Then
                        ReDim Preserve TAList(Index)
                        'Index = 0
                        TAList(Index).World = FeatureWorld
                        TAList(Index).Category = FeatureCategory
                        TAList(Index).Feature = FeatureName
                        TAList(Index).FootprintX = FootprintX
                        TAList(Index).FootprintY = FootprintY
                        TAList(Index).Seqname = FeatureSeqName
                        TAList(Index).Filename = FeatureFilename
                        TAList(Index).Objectname = FeatureObjName
                        TAList(Index).Used = True
                        Features.AddFeature TAList(Index)
                        DoEvents
                    End If
                    'FeatureWorld = ""
                    FeatureCategory = ""
                    FeatureName = ""
                    FootprintX = 0
                    FootprintY = 0
                    FeatureSeqName = ""
                    FeatureFilename = ""
                    FeatureObjName = ""
                End If
            End If
            If Left(Buffer, 1) = "[" Then ' a new feature. '
                BufferIndex = InStr(1, Buffer, "]")
                If BufferIndex <> 0 Then
                    FeatureName = Left(Buffer, BufferIndex - 1)
                    FeatureName = (Right(FeatureName, Len(FeatureName) - 1))
                End If
            End If
            'BufferIndex = InStr(1, LCase(Buffer), "world=")
            'If BufferIndex <> 0 Then
            '    FeatureWorld = (Mid(Buffer, BufferIndex + 6, Len(Buffer) - BufferIndex - 6))
            'End If
            BufferIndex = InStr(1, LCase(Buffer), "category=")
            If BufferIndex <> 0 Then
                FeatureCategory = (Mid(Buffer, BufferIndex + 9, Len(Buffer) - BufferIndex - 9))
            End If
            BufferIndex = InStr(1, LCase(Buffer), "footprintx=")
            If BufferIndex <> 0 Then
                FootprintX = Val(Mid(Buffer, BufferIndex + 11, Len(Buffer) - BufferIndex - 11))
            End If
            BufferIndex = InStr(1, LCase(Buffer), "footprintz=")
            If BufferIndex <> 0 Then
                FootprintY = Val(Mid(Buffer, BufferIndex + 11, Len(Buffer) - BufferIndex - 11))
            End If
            BufferIndex = InStr(1, LCase(Buffer), "filename=")
            If BufferIndex <> 0 Then
                FeatureFilename = (Mid(Buffer, BufferIndex + 9, Len(Buffer) - BufferIndex - 9))
            End If
            BufferIndex = InStr(1, LCase(Buffer), "seqname=")
            If BufferIndex <> 0 Then
                FeatureSeqName = (Mid(Buffer, BufferIndex + 8, Len(Buffer) - BufferIndex - 8))
            End If
            BufferIndex = InStr(1, LCase(Buffer), "object=")
            If BufferIndex <> 0 Then
                FeatureObjName = (Mid(Buffer, BufferIndex + 7, Len(Buffer) - BufferIndex - 7))
            End If
        Loop
    Close FileHandle
    Kill TempFile
End Sub

Function GetLine(Buffer As String, Index As Long) As String
    Dim Key As String
    Dim i As Integer
    
    On Error GoTo Error
    Key = Chr(13) & Chr(10)
    i = InStr(Index, Buffer, Key)
    If i = 0 Then i = Len(Buffer)
    Key = Mid(Buffer, Index, i - Index)
    'MsgBox Key
    Index = Index + (i - Index) + 2
    If Index > Len(Buffer) Then Index = -1
    GetLine = Key
    Exit Function
Error:
    Index = -1
End Function
