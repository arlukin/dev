Attribute VB_Name = "mod3DOBuilder"
' Program module. '

Option Explicit

Public Const ProgramName = "3DOBuilder"
Public Const ProgramVersion = "1.0"

' Graphics functions. '
Declare Sub WriteTile Lib "3dobuilder.dll" (ByVal xPos As Long, ByVal yPos As Long, ByVal xWidth As Long, ByVal yWidth As Long, ByVal BmpWidth As Long, ByVal BmpHeight As Long, ByVal pBitmap As Long, TileData As Byte)
Declare Sub ClearTile Lib "3dobuilder.dll" (ByVal xPos As Long, ByVal yPos As Long, ByVal xWidth As Long, ByVal yWidth As Long, ByVal BmpWidth As Long, ByVal BmpHeight As Long, ByVal pBitmap As Long, TileData As Byte, ByVal MaskColor As Byte, ByVal BackColor As Byte, ByVal ClearFlag As Long)
Declare Sub MaskTile Lib "3dobuilder.dll" (ByVal xPos As Long, ByVal yPos As Long, ByVal xWidth As Long, ByVal yWidth As Long, ByVal BmpWidth As Long, ByVal BmpHeight As Long, ByVal pBitmap As Long, TileData As Byte, ByVal MaskColor As Byte, ByVal NewColor As Byte)
Declare Sub DrawLine Lib "3dobuilder.dll" (ByVal x1 As Long, ByVal y1 As Long, ByVal x2 As Long, ByVal y2 As Long, ByVal Color As Byte, ByVal BmpWidth As Long, ByVal BmpHeight As Long, ByVal pBitmap As Long)
Declare Sub WritePixel Lib "3dobuilder.dll" (ByVal pBitmap As Long, ByVal Position As Long, ByVal Value As Byte)
Declare Sub GetRegion Lib "3dobuilder.dll" (ByVal xPos As Long, ByVal yPos As Long, ByVal RegionWidth As Long, ByVal RegionHeight As Long, ByVal Width As Long, ByVal Height As Long, ByVal pBitmap As Long, ByRef Buffer As Byte)

' Open default viewer application. '
Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long
Public Const SW_SHOWDEFAULT = 10

Declare Function ShowWindow Lib "user32" (ByVal hwnd As Long, ByVal nCmdShow As Long) As Long
Declare Function GetNextWindow Lib "user32" Alias "GetWindow" (ByVal hwnd As Long, ByVal wFlag As Long) As Long
Declare Function GetWindowText Lib "user32" Alias "GetWindowTextA" (ByVal hwnd As Long, ByVal lpString As String, ByVal cch As Long) As Long
Public Const SW_HIDE = 0
Public Const SW_SHOWNORMAL = 1
Public Const SW_NORMAL = 1
Public Const SW_SHOWMINIMIZED = 2
Public Const SW_SHOWMAXIMIZED = 3
Public Const SW_MAXIMIZE = 3
Public Const SW_SHOWNOACTIVATE = 4
Public Const SW_SHOW = 5

' GetWindow() Constants
Public Const GW_HWNDFIRST = 0
Public Const GW_HWNDLAST = 1
Public Const GW_HWNDNEXT = 2
Public Const GW_HWNDPREV = 3
Public Const GW_OWNER = 4
Public Const GW_CHILD = 5
Public Const GW_MAX = 5

Declare Function SetWindowPos Lib "user32" (ByVal hwnd As Long, ByVal hWndInsertAfter As Long, ByVal x As Long, ByVal y As Long, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long) As Long
Global Const HWND_TOPMOST = -1
Public Const HWND_NOTOPMOST = -2
Public Const SWP_SHOWWINDOW = &H40
Global Const FLAGS = SWP_NOMOVE Or SWP_NOSIZE

' Child window function. '
Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long, ByVal wNewLong As Long) As Long
Global Const GWW_HWNDPARENT = (-8)

' Globals. '
Public TAPalette(255) As RGBQUAD
Public TexturePalette As New classFastWin
Public ViewType As Integer
Public ScaleConstant As Single
Public CRLF As String
Public OpenFile As String
Public SelectedColor As Integer
Public DirectoryReturn As String

' Settings. '
Public FirstLoad As Integer

Public Open3doDir As String
Public Save3doDir As String
Public OpenCobDir As String
Public OpenFbiDir As String
Public OpenDxfDir As String
Public SaveDxfDir As String
Public OpenCobFile As String
Public OpenFbiFile As String
Public SetTALocation As String

Public Const ColorBack = 0
Public Const ColorGrid = 1
Public Const ColorModel = 2
Public Const ColorObject = 3
Public Const ColorFace = 4
Public Const ColorPoint = 5
Public Colors(5) As Long
Public OpenGLColor As Integer
Public OpenGLType As Long

Public GridInterval As Integer
Public ShowGrid As Boolean
Public AutoCenter As Boolean
Public ShowPoints As Boolean
Public DisableGL As Boolean
Public TipShow As Boolean

Public Const LaunchBuilder = 1
Public Const LaunchViewer = 2
Public Launch As Integer

' Constants. '
Public Const PaletteLocation = "\palette.dat"
Public Const ViewType3D = 0
Public Const ViewTypeFront = 1
Public Const ViewTypeSide = 2
Public Const ViewTypeTop = 3
Public Const ViewFront = 1
Public Const ViewTop = 2
Public Const ViewSide = 3
Public Const ViewView = 4

Public ViewFull As Integer

' Tools. '
Public Const ToolDefault = 0
Public Const ToolMove = 1
Public SelectedTool As Integer

' Splitters. '
Global CTRL_OFFSET As Integer ' Hold the horizontal & vertical offsets of the 2 controls. '
Global SPLT_COLOUR As Long ' Hold the Splitter bar color. '
Global currSplitPosX As Long ' Vertical splitter, holds the last sized position. '
Global Const SPLT_WDTH As Integer = 45

Public Sub InterfaceSetColors()
    With Frm3do
    .PicFront.BackColor = Colors(ColorBack)
    .PicTop.BackColor = Colors(ColorBack)
    .PicRight.BackColor = Colors(ColorBack)
    .PicView.BackColor = Colors(ColorBack)
    .LblTop.ForeColor = Colors(ColorModel)
    .LblFront.ForeColor = Colors(ColorModel)
    .LblSide.ForeColor = Colors(ColorModel)
    Render
    End With
End Sub

Public Sub InitializeInterface()
    Dim Style As Long
    Dim hToolbar As Long
    Dim rc As Long
    
    With Frm3do
        
    ' Initialize splictters. '
    CTRL_OFFSET = 5
    SPLT_COLOUR = &H808080
    currSplitPosX = &H7FFFFFFF
    
    ' Get the handle of the toolbar. '
    hToolbar = FindWindowEx(.Toolbar.hwnd, 0&, "ToolbarWindow32", vbNullString)
    ' Retrieve the toolbar styles. '
    Style = SendMessageLong(hToolbar, TB_GETSTYLE, 0&, 0&)
    ' Set the new style flag. '
    If Style And TBSTYLE_FLAT Then
        Style = Style Xor TBSTYLE_FLAT
    Else
        Style = Style Or TBSTYLE_FLAT
    End If
    
    ' Apply the new style to the toolbar. '
    rc = SendMessageLong(hToolbar, TB_SETSTYLE, 0, Style)
    .Toolbar.Refresh

    End With
End Sub

' Create the interface for a new model. '
Public Sub CreateInterface()
    On Error GoTo Error
    Set SelectedObject = File3DO
    CreateModelTree
    CreateOpenGLModel
    UpdateInterface
Error:
End Sub

Public Sub UpdateStatusbar()
    With Frm3do
    On Error Resume Next
    .Status.Panels(1).Text = "Ready"
    .Status.Panels(2).Text = SelectedObject.Name
    End With
End Sub

' Get the location of TA. '
Public Function TALocation() As String
    Dim Buffer As CString, Location As String
    
    If SetTALocation <> "" Then
        TALocation = SetTALocation
        Exit Function
    End If
    
    GetTADirectory Buffer
    Location = MakeVBString(Buffer)
    If (Right(Location, 1) <> "\") And (Location <> "") Then
        TALocation = Location & "\"
    Else
        TALocation = Location
    End If
End Function

' Load the palette for the tiles, and mini-map. '
Sub LoadPalette()
    Dim FileHandle As Integer ' Handle to a file. '
    Dim Buffer(767) As Byte ' Palette data. '
    Dim PaletteIndex As Integer
    Dim Index As Integer
    
    FileHandle = FreeFile
    Open App.Path & PaletteLocation For Binary As FileHandle
    Get FileHandle, , Buffer()
    PaletteIndex = 0
    For Index = 0 To 767 Step 3
        TAPalette(PaletteIndex).rgbRed = Buffer(Index)
        TAPalette(PaletteIndex).rgbGreen = Buffer(Index + 1)
        TAPalette(PaletteIndex).rgbBlue = Buffer(Index + 2)
        TAPalette(PaletteIndex).rgbReserved = 0
        PaletteIndex = PaletteIndex + 1
    Next
    Close FileHandle
End Sub

Public Sub UpdateInterface()
    On Error Resume Next
    SelectedPrimitive = 0
    Frm3do.ScrollPrimitive.Max = SelectedObject.PrimitiveCount - 1
    If SelectedObject.PrimitiveCount - 1 = 0 Then
        Frm3do.ScrollPrimitive.Max = 1
        Frm3do.ScrollPrimitive.Enabled = False
    Else
        Frm3do.ScrollPrimitive.Enabled = True
    End If
    Frm3do.ScrollPrimitive.Value = 0
    RefreshFace
    RefreshObject
    UpdateCaption
    UpdateStatusbar
    
    GetCenterModel
    Render
End Sub

Public Sub RefreshObject()
    Dim Vertex As New class3dVertex
    
    On Error Resume Next
    SelectedObject.GetOffset Vertex
    Frm3do.TxtOffsetX = CStr(Vertex.x)
    Frm3do.TxtOffsetY = CStr(Vertex.y)
    Frm3do.TxtOffsetZ = CStr(Vertex.z)
End Sub

Public Sub RefreshFace()
    Dim Texture As String
    Dim Color As Integer
    Dim Angle As Integer
    Dim rc As Long
    
    On Error Resume Next
    Frm3do.TxtPrimitive.Text = CStr(Frm3do.ScrollPrimitive.Value) & ":" & CStr(SelectedObject.PrimitiveCount - 1)
    SelectedPrimitive = Frm3do.ScrollPrimitive.Value
    
    Texture = SelectedObject.GetTextureName(SelectedPrimitive)
    Color = SelectedObject.GetColor(SelectedPrimitive)
    
    If Texture = "" And Color > -1 Then
        Texture = "color" '& CStr(Color)
        Frm3do.PicTexture.BackColor = RGB(TAPalette(Color).rgbRed, TAPalette(Color).rgbGreen, TAPalette(Color).rgbBlue)
    Else
        Frm3do.PicTexture.BackColor = &H8000000F
        DisplayTexture Texture
    End If
    
    Frm3do.LblTexture = Texture
    If Frm3do.LblTexture = "" Then Frm3do.LblTexture = "none"
    
    Angle = SelectedObject.GetAngle(SelectedPrimitive)
    Frm3do.LstOrientation.ListIndex = Angle / 90
    
    DoEvents
    Render
End Sub

Public Sub UpdateCaption()
    If OpenFile = "" Then
        Frm3do.Caption = "3DO Builder"
    Else
        Frm3do.Caption = OpenFile & " - 3DO Builder"
    End If
End Sub

' Return the directory from path. '
Public Function GetDirectory(Path As String) As String
    Dim rc As Long
    Dim i As Integer
    
    For i = 1 To Len(Path)
        If Mid(Path, i, 1) = "\" Then rc = i
    Next
    If rc > 0 Then
        GetDirectory = Left(Path, rc - 1)
    Else
        GetDirectory = Path
    End If
End Function

Public Sub ToolsUpdateMouse(ByVal x As Long, ByVal y As Long, ByVal ViewType As Integer)
    Dim FrontCenterX As Long, FrontCenterY As Long, RightCenterX As Long, RightCenterY As Long, TopCenterX As Long, TopCenterY As Long
    Dim NewX As Long, NewY As Long
    
    With Frm3do
    
    FrontCenterX = .PicFront.ScaleWidth / 2 - ZoomFactor * Center.x
    FrontCenterY = .PicFront.ScaleHeight / 2 + ZoomFactor * Center.y
    RightCenterX = .PicRight.ScaleWidth / 2 - ZoomFactor * Center.z
    RightCenterY = .PicRight.ScaleHeight / 2 + ZoomFactor * Center.y
    TopCenterX = .PicTop.ScaleWidth / 2 - ZoomFactor * Center.x
    TopCenterY = .PicTop.ScaleHeight / 2 - ZoomFactor * Center.z
    Select Case ViewType
        Case ViewFront
            NewX = -(FrontCenterX - x) / ZoomFactor
            NewY = (FrontCenterY - y) / ZoomFactor
            .Status.Panels(3).Text = "(" & CStr(NewX) & ", " & CStr(NewY) & ", 0) "
        Case ViewSide
            NewX = -(RightCenterX - x) / ZoomFactor
            NewY = (RightCenterY - y) / ZoomFactor
            .Status.Panels(3).Text = "(0, " & CStr(NewY) & ", " & CStr(NewX) & ") "
        Case ViewTop
            NewX = -(TopCenterX - x) / ZoomFactor
            NewY = -(TopCenterY - y) / ZoomFactor
            .Status.Panels(3).Text = "(" & CStr(NewX) & ", 0, " & CStr(NewY) & ") "
    End Select
    
    Select Case SelectedTool
        Case ToolDefault
            .PicFront.MousePointer = vbNormal
            .PicTop.MousePointer = vbNormal
            .PicRight.MousePointer = vbNormal
        Case ToolMove
            .PicFront.MousePointer = 2
            .PicTop.MousePointer = 2
            .PicRight.MousePointer = 2
    End Select
    End With
End Sub

Sub SetOnTop(hwnd As Long)
  Dim SetWinOnTop As Long
  
  SetWinOnTop = SetWindowPos(hwnd, HWND_TOPMOST, 0, 0, 0, 0, FLAGS)
End Sub

Sub RemoveOnTop(hwnd As Long)
    Dim rc As Long
    
    rc = SetWindowPos(hwnd, HWND_NOTOPMOST, 0, 0, 0, 0, FLAGS)
End Sub

Sub UpdateViewMenu()
    With Frm3do
    .mnuViewFront.Checked = False
    .mnuViewTop.Checked = False
    .mnuViewSide.Checked = False
    .mnuViewOpenGLView.Checked = False
    .mnuViewAll.Checked = False
    If ViewFull = 0 Then
        .mnuViewAll.Checked = True
    ElseIf ViewFull = ViewFront Then
        .mnuViewFront.Checked = True
    ElseIf ViewFull = ViewTop Then
        .mnuViewTop.Checked = True
    ElseIf ViewFull = ViewSide Then
        .mnuViewSide.Checked = True
    ElseIf ViewFull = ViewView Then
        .mnuViewOpenGLView.Checked = True
    End If
    End With
End Sub
