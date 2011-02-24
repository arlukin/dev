VERSION 5.00
Begin VB.Form FrmStartup 
   BackColor       =   &H00000000&
   BorderStyle     =   1  'Fixed Single
   ClientHeight    =   2175
   ClientLeft      =   15
   ClientTop       =   15
   ClientWidth     =   6705
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   145
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   447
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.CheckBox LblFeatures 
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      Caption         =   "Features"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   255
      Left            =   2220
      TabIndex        =   10
      ToolTipText     =   "Deselect to skip auto-loading of TA features."
      Top             =   1500
      Value           =   1  'Checked
      Width           =   975
   End
   Begin VB.CheckBox LblSections 
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      Caption         =   "Sections"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   255
      Left            =   2220
      TabIndex        =   9
      ToolTipText     =   "Deselect to skip auto-loading of TA sections."
      Top             =   1020
      Value           =   1  'Checked
      Width           =   975
   End
   Begin VB.PictureBox PicGreen 
      AutoRedraw      =   -1  'True
      BorderStyle     =   0  'None
      Height          =   255
      Left            =   660
      Picture         =   "FrmStartup.frx":0000
      ScaleHeight     =   17
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   13
      TabIndex        =   8
      Top             =   2580
      Visible         =   0   'False
      Width           =   195
   End
   Begin VB.PictureBox PicRed 
      AutoRedraw      =   -1  'True
      BorderStyle     =   0  'None
      Height          =   255
      Left            =   360
      Picture         =   "FrmStartup.frx":04EA
      ScaleHeight     =   17
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   13
      TabIndex        =   7
      Top             =   2580
      Visible         =   0   'False
      Width           =   195
   End
   Begin VB.PictureBox PicBlack 
      AutoRedraw      =   -1  'True
      BorderStyle     =   0  'None
      Height          =   255
      Left            =   60
      Picture         =   "FrmStartup.frx":09D4
      ScaleHeight     =   17
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   13
      TabIndex        =   6
      Top             =   2580
      Visible         =   0   'False
      Width           =   195
   End
   Begin VB.PictureBox ProgressFeatures 
      AutoRedraw      =   -1  'True
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      Height          =   210
      Left            =   3240
      ScaleHeight     =   14
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   181
      TabIndex        =   5
      Top             =   1500
      Width           =   2715
   End
   Begin VB.PictureBox ProgressSections 
      AutoRedraw      =   -1  'True
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      Height          =   210
      Left            =   3240
      ScaleHeight     =   14
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   143
      TabIndex        =   4
      Top             =   1020
      Width           =   2145
   End
   Begin VB.PictureBox ProgressFiles 
      AutoRedraw      =   -1  'True
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      Height          =   210
      Left            =   3240
      ScaleHeight     =   14
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   116
      TabIndex        =   3
      Top             =   540
      Width           =   1740
   End
   Begin VB.Timer Timer 
      Enabled         =   0   'False
      Interval        =   1500
      Left            =   900
      Top             =   2580
   End
   Begin VB.Line Line8 
      BorderColor     =   &H00404040&
      X1              =   430
      X2              =   0
      Y1              =   140
      Y2              =   140
   End
   Begin VB.Line Line7 
      BorderColor     =   &H00404040&
      X1              =   430
      X2              =   430
      Y1              =   114
      Y2              =   141
   End
   Begin VB.Line Line6 
      BorderColor     =   &H00404040&
      X1              =   316
      X2              =   430
      Y1              =   0
      Y2              =   114
   End
   Begin VB.Line Line5 
      BorderColor     =   &H00808080&
      X1              =   424
      X2              =   424
      Y1              =   114
      Y2              =   137
   End
   Begin VB.Line Line3 
      BorderColor     =   &H00808080&
      X1              =   310
      X2              =   424
      Y1              =   0
      Y2              =   114
   End
   Begin VB.Line Line4 
      BorderColor     =   &H00808080&
      X1              =   144
      X2              =   0
      Y1              =   8
      Y2              =   8
   End
   Begin VB.Line Line2 
      BorderColor     =   &H00808080&
      X1              =   144
      X2              =   424
      Y1              =   136
      Y2              =   136
   End
   Begin VB.Line Line1 
      BorderColor     =   &H00808080&
      X1              =   144
      X2              =   144
      Y1              =   8
      Y2              =   136
   End
   Begin VB.Label LblFiles 
      Alignment       =   1  'Right Justify
      BackColor       =   &H00000000&
      Caption         =   "Files"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   255
      Left            =   2340
      TabIndex        =   2
      Top             =   540
      Width           =   735
   End
   Begin VB.Label Label2 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      Caption         =   "written by kinboat, 1998."
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   195
      Left            =   120
      TabIndex        =   1
      Top             =   1740
      Width           =   1875
   End
   Begin VB.Label Label1 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      Caption         =   "Annihilator 1.5"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   195
      Left            =   120
      TabIndex        =   0
      Top             =   1500
      Width           =   1815
   End
   Begin VB.Image Image1 
      Height          =   1020
      Left            =   120
      Picture         =   "FrmStartup.frx":0EBE
      Top             =   300
      Width           =   1800
   End
End
Attribute VB_Name = "FrmStartup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Const UnitWidth = 9
Private Const UnitHeight = 14

Private Const progFiles = 0
Private Const progSections = 1
Private Const progFeatures = 2

Public pFiles As Single
Public pSections As Single
Public pFeatures As Single

Private Sub Form_Load()
    Dim hRgn As Long, hWindow As Long
    Dim Points(4) As POINTAPI
    
    LoadSettings
    
    pFiles = 0
    pSections = 0
    pFeatures = 0
    
    Points(0).x = 0
    Points(0).y = 0
    Points(1).x = 320
    Points(1).y = 0
    Points(2).x = 434
    Points(2).y = ProgressFeatures.Top + ProgressFeatures.Height
    Points(3).x = 434
    Points(3).y = ScaleHeight
    Points(4).x = 0
    Points(4).y = ScaleHeight
    
    hRgn = CreatePolygonRgn(Points(0), 5, 0)
    hWindow = SetWindowRgn(Me.hwnd, hRgn, True)
    DrawPercents
    
    Screen.MousePointer = vbHourglass
    Me.Visible = True
    DoEvents
    Initialize
End Sub

Sub Initialize()
    ' Initialize files. '
    CreateHPIList
        
    ' Initialize sections. '
    If LblSections.Value = vbChecked Then
        LoadSections
    End If
    Sections.CreateTabs
    
    ' Initialize features. '
    If LblFeatures.Value = vbChecked Then
        LoadFeatures
    End If
    Features.CreateTabs
    
    ' Close dialog. '
    Timer.Enabled = True
End Sub

Public Sub Update(pType As Integer, Value As Long, Max As Long)
    On Error Resume Next
    If pType = progFiles Then
        If Max = 0 Then
            pFiles = 100
        Else
            pFiles = 100 * Value / Max
        End If
    ElseIf pType = progSections Then
        If Max = 0 Then
            pSections = 100
        Else
            pSections = 100 * Value / Max
        End If
    ElseIf pType = progFeatures Then
        If Max = 0 Then
            pFeatures = 100
        Else
            pFeatures = 100 * Value / Max
        End If
    End If
    
    DrawPercents
End Sub

Public Sub RefreshForm()
    DoEvents
End Sub

Private Sub Form_Unload(Cancel As Integer)
    SaveSettings
    Screen.MousePointer = vbNormal
End Sub

Private Sub Timer_Timer()
    Unload Me
End Sub

Private Sub DrawPercents()
    Dim xIndex As Long
    Dim rc As Long
    
    If pFiles = 0 Then
        LblFiles.ForeColor = RGB(0, 0, 255)
        xIndex = 0
        Do While xIndex < ProgressFiles.ScaleWidth
            rc = BitBlt(ProgressFiles.hdc, xIndex, 0, UnitWidth, UnitHeight, PicBlack.hdc, 0, 0, SRCCOPY)
            xIndex = xIndex + UnitWidth
        Loop
        ProgressFiles.Refresh
    ElseIf pFiles = 100 Then
        LblFiles.ForeColor = &H808080
        xIndex = 0
        Do While xIndex < ProgressFiles.ScaleWidth
            rc = BitBlt(ProgressFiles.hdc, xIndex, 0, UnitWidth, UnitHeight, PicGreen.hdc, 0, 0, SRCCOPY)
            xIndex = xIndex + UnitWidth
        Loop
        ProgressFiles.Refresh
    Else
        LblFiles.ForeColor = RGB(0, 0, 255)
        xIndex = 0
        Do While xIndex < ProgressFiles.ScaleWidth
            If pFiles >= (100 * xIndex / ProgressFiles.ScaleWidth) Then
                rc = BitBlt(ProgressFiles.hdc, xIndex, 0, UnitWidth, UnitHeight, PicRed.hdc, 0, 0, SRCCOPY)
            Else
                rc = BitBlt(ProgressFiles.hdc, xIndex, 0, UnitWidth, UnitHeight, PicBlack.hdc, 0, 0, SRCCOPY)
            End If
            xIndex = xIndex + UnitWidth
        Loop
        ProgressFiles.Refresh
    End If
    
    If pSections = 0 Then
        LblSections.ForeColor = RGB(0, 0, 255)
        xIndex = 0
        Do While xIndex < ProgressSections.ScaleWidth
            rc = BitBlt(ProgressSections.hdc, xIndex, 0, UnitWidth, UnitHeight, PicBlack.hdc, 0, 0, SRCCOPY)
            xIndex = xIndex + UnitWidth
        Loop
        ProgressSections.Refresh
    ElseIf pSections = 100 Then
        LblSections.ForeColor = &H808080
        xIndex = 0
        Do While xIndex < ProgressSections.ScaleWidth
            rc = BitBlt(ProgressSections.hdc, xIndex, 0, UnitWidth, UnitHeight, PicGreen.hdc, 0, 0, SRCCOPY)
            xIndex = xIndex + UnitWidth
        Loop
        ProgressSections.Refresh
    Else
        LblSections.ForeColor = RGB(0, 0, 255)
        xIndex = 0
        Do While xIndex < ProgressSections.ScaleWidth
            If pSections >= (100 * xIndex / ProgressSections.ScaleWidth) Then
                rc = BitBlt(ProgressSections.hdc, xIndex, 0, UnitWidth, UnitHeight, PicRed.hdc, 0, 0, SRCCOPY)
            Else
                rc = BitBlt(ProgressSections.hdc, xIndex, 0, UnitWidth, UnitHeight, PicBlack.hdc, 0, 0, SRCCOPY)
            End If
            xIndex = xIndex + UnitWidth
        Loop
        ProgressSections.Refresh
    End If

    If pFeatures = 0 Then
        LblFeatures.ForeColor = RGB(0, 0, 255)
        xIndex = 0
        Do While xIndex < ProgressFeatures.ScaleWidth
            rc = BitBlt(ProgressFeatures.hdc, xIndex, 0, UnitWidth, UnitHeight, PicBlack.hdc, 0, 0, SRCCOPY)
            xIndex = xIndex + UnitWidth
        Loop
        ProgressFeatures.Refresh
    ElseIf pFeatures = 100 Then
        LblFiles.ForeColor = &H808080
        xIndex = 0
        Do While xIndex < ProgressFeatures.ScaleWidth
            rc = BitBlt(ProgressFeatures.hdc, xIndex, 0, UnitWidth, UnitHeight, PicGreen.hdc, 0, 0, SRCCOPY)
            xIndex = xIndex + UnitWidth
        Loop
        ProgressFeatures.Refresh
    Else
        LblFeatures.ForeColor = RGB(0, 0, 255)
        xIndex = 0
        Do While xIndex < ProgressFeatures.ScaleWidth
            If pFeatures >= (100 * xIndex / ProgressFeatures.ScaleWidth) Then
                rc = BitBlt(ProgressFeatures.hdc, xIndex, 0, UnitWidth, UnitHeight, PicRed.hdc, 0, 0, SRCCOPY)
            Else
                rc = BitBlt(ProgressFeatures.hdc, xIndex, 0, UnitWidth, UnitHeight, PicBlack.hdc, 0, 0, SRCCOPY)
            End If
            xIndex = xIndex + UnitWidth
        Loop
        ProgressFeatures.Refresh
    End If
    DoEvents
End Sub

Sub LoadSettings()
    LblFeatures.Value = Val(GetSetting(ProgramName, "Startup", "LoadFeatures", vbChecked))
    LblSections.Value = Val(GetSetting(ProgramName, "Startup", "LoadSections", vbChecked))
End Sub

Sub SaveSettings()
    SaveSetting ProgramName, "Startup", "LoadFeatures", LblFeatures.Value
    SaveSetting ProgramName, "Startup", "LoadSections", LblSections.Value
End Sub
