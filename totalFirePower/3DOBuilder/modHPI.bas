Attribute VB_Name = "modHPI"
' HPI interface. '

Option Explicit

Public HPI As New classHPI
Public HPINames() As String

Public Const HPITextures = 0

Public HPILocations() As String

' Parse the TA directory for HPI files. '
Public Sub CreateHPIList()
    Dim Index As Long
    Dim Path As String, Name As String

    ReDim HPINames(0)

    ' Parse the TA directory. '
    Screen.MousePointer = vbHourglass
    FrmProgress.Show
    FrmProgress.Status = "Finding texture files..."
    FrmProgress.Progress = 0
    Path = TALocation
    Name = Dir(Path, vbNormal)   ' Retrieve the first entry.
    Do While Name <> ""   ' Start the loop.
        Name = LCase(Name)
        ' Ignore the current directory and the encompassing directory. '
        If Name <> "." And Name <> ".." Then
            If (GetAttr(Path & Name) And vbNormal) = vbNormal Then
                If Right(Name, 3) = "hpi" Or Right(Name, 3) = "ufo" Or Right(Name, 3) = "gpf" Or Right(Name, 3) = "ccx" Or Right(Name, 3) = "gp3" Then
                    ReDim Preserve HPINames(UBound(HPINames) + 1)
                    HPINames(UBound(HPINames)) = TALocation & Name
                End If
            End If
        End If
        Name = Dir ' Get the next entry. '
    Loop

    HPI.Initialize
    For Index = 1 To UBound(HPINames)
        FrmProgress.Update Index, UBound(HPINames)
        HPI.LoadHPI HPINames(Index)
    Next
    Unload FrmProgress
    Screen.MousePointer = vbNormal
End Sub

Public Function StripNull(TStr As String) As String
    Dim I As Integer

    I = InStr(TStr, Chr(0))
    If I <> 0 Then
        TStr = Left(TStr, I - 1)
    End If
    StripNull = TStr
End Function

