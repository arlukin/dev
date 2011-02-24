VERSION 5.00
Begin VB.Form FrmMiniMap 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Minimap"
   ClientHeight    =   1890
   ClientLeft      =   10650
   ClientTop       =   2340
   ClientWidth     =   1890
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   126
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   126
   ShowInTaskbar   =   0   'False
   Begin VB.PictureBox PicMiniMap 
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      Height          =   1890
      Left            =   0
      ScaleHeight     =   122
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   122
      TabIndex        =   0
      Top             =   0
      Width           =   1890
      Begin VB.Shape View 
         BackColor       =   &H00FFFFFF&
         BorderColor     =   &H00FFFFFF&
         DrawMode        =   7  'Invert
         Height          =   375
         Left            =   0
         Top             =   0
         Visible         =   0   'False
         Width           =   495
      End
   End
End
Attribute VB_Name = "FrmMiniMap"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public Sub SettingsLoad()
    Dim Buffer As Long
    
    Buffer = Val(GetSetting(ProgramName, "Startup", "MiniLeft", FrmAnnihilator.Left + FrmAnnihilator.Canvas.Left + 250))
    If Buffer > Screen.Width Then Buffer = Screen.Width - Width - 100
    If Buffer <> 0 Then Me.Left = Buffer
    Buffer = Val(GetSetting(ProgramName, "Startup", "MiniTop", FrmAnnihilator.Left + FrmAnnihilator.Canvas.Top + 300))
    If Buffer > Screen.Height Then Buffer = Screen.Height - Height - 500
    If Buffer <> 0 Then Me.Top = Buffer
End Sub

Public Sub SettingsSave()
    SaveSetting ProgramName, "Startup", "MiniLeft", Me.Left
    SaveSetting ProgramName, "Startup", "MiniTop", Me.Top
End Sub

Private Sub Form_Load()
    On Error Resume Next
    If Not ViewMinimap Then Me.Visible = False
    OriginalParenthWndMiniMap = SetWindowLong(Me.hwnd, GWW_HWNDPARENT, FrmAnnihilator.hwnd)
    SettingsLoad
    RefreshMiniSize
    If MapLoaded Then
        Maps(SelectedMap).MiniMapRefresh
        Me.Visible = True
    Else
        Me.Visible = False
    End If
End Sub

Private Sub Form_Resize()
    PicMiniMap.Width = ScaleWidth
    PicMiniMap.Height = ScaleHeight
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Dim rc As Long
    
    If OriginalParenthWndMiniMap <> 0 Then
        rc = SetWindowLong(FrmMiniMap.hwnd, GWW_HWNDPARENT, OriginalParenthWndMiniMap)
    End If
    SettingsSave
    
    ViewMinimap = False
    FrmAnnihilator.mnuViewMinimap.Checked = False
End Sub

Private Sub PicMiniMap_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    If Not ControlsEnabled Then Exit Sub
    If Button = 1 Then
        If MapLoaded Then
            Maps(SelectedMap).MiniMapUpdateView x, y
        End If
    Else
        ' Popup menu. '
        PopupMenu FrmPopup.mnuPopupMinimap, , , , FrmPopup.mnuPopupMinimapRefreshDraft
    End If
End Sub

Private Sub PicMiniMap_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
    ' Redraw the view. '
    If Not ControlsEnabled Then Exit Sub
    If Button = 1 Then
        If MapLoaded Then
            Maps(SelectedMap).MiniMapUpdateView x, y
        End If
    End If
End Sub

