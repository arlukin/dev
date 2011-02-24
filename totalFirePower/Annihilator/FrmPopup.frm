VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.1#0"; "COMDLG32.OCX"
Begin VB.Form FrmPopup 
   Caption         =   "Popup menus"
   ClientHeight    =   180
   ClientLeft      =   165
   ClientTop       =   735
   ClientWidth     =   5130
   LinkTopic       =   "Form1"
   ScaleHeight     =   180
   ScaleWidth      =   5130
   StartUpPosition =   3  'Windows Default
   Begin MSComDlg.CommonDialog CommonDialog 
      Left            =   60
      Top             =   60
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   327681
      CancelError     =   -1  'True
   End
   Begin VB.Menu mnuPopupMinimap 
      Caption         =   "MiniPopup"
      Begin VB.Menu mnuPopupMinimapRefreshDraft 
         Caption         =   "Refresh Draft Minimap"
      End
      Begin VB.Menu mnuPopupMinimapRefreshFinal 
         Caption         =   "Refresh Final Minimap"
      End
      Begin VB.Menu mnuPopupMinimapBreak1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuPopupMinimapImportMinimap 
         Caption         =   "Import Minimap..."
      End
      Begin VB.Menu mnuPopupMinimapExportMinimap 
         Caption         =   "Export Minimap..."
      End
   End
   Begin VB.Menu mnuPopupSection 
      Caption         =   "SectionPopup"
      Begin VB.Menu mnuSectionPaste 
         Caption         =   "Paste"
      End
      Begin VB.Menu mnuSectionFillMap 
         Caption         =   "Fill Map"
      End
      Begin VB.Menu mnuSectionFillRegion 
         Caption         =   "Fill Selection"
      End
      Begin VB.Menu mnuSectionBreak1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuSectionExportBMP 
         Caption         =   "Export BMP..."
      End
      Begin VB.Menu mnuSectionBreak2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuSectionImportHeight 
         Caption         =   "Import Heightmap..."
      End
      Begin VB.Menu mnuSectionExportHeight 
         Caption         =   "Export Heightmap..."
      End
   End
   Begin VB.Menu mnuRegionSettings 
      Caption         =   "RegionSettings"
      Begin VB.Menu mnuRegionTextures 
         Caption         =   "Textures"
         Checked         =   -1  'True
      End
      Begin VB.Menu mnuRegionBreak1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuRegionHeight 
         Caption         =   "Height Data"
         Checked         =   -1  'True
      End
   End
   Begin VB.Menu mnuHeightSettings 
      Caption         =   "HeightSettings"
      Begin VB.Menu mnuHeightSwitchColors 
         Caption         =   "Switch Colors"
      End
      Begin VB.Menu mnuHeightSettingsBreak1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuHeightSetContourInterval 
         Caption         =   "Set Contour Map Interval..."
      End
   End
End
Attribute VB_Name = "FrmPopup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub mnuHeightSetContourInterval_Click()
    Dim Buffer As Long
    
    Buffer = Val(InputBox("Enter the contour map interval (1-16):", "Contour Map", CStr(HeightMeshInterval)))
    If Buffer < 1 Then Buffer = 1
    If Buffer > 16 Then Buffer = 16
    HeightMeshInterval = Buffer
    RefreshMap
End Sub

Private Sub mnuHeightSwitchColors_Click()
    mnuHeightSwitchColors.Checked = Not mnuHeightSwitchColors.Checked
    HeightSwitchColors = mnuHeightSwitchColors.Checked
    RefreshMap
End Sub

Private Sub mnuPopupMinimapExportMinimap_Click()
    FrmAnnihilator.mnuSpecialExportMinimap_Click
End Sub

Private Sub mnuPopupMinimapImportMinimap_Click()
    FrmAnnihilator.mnuSpecialImportMinimap_Click
End Sub

Private Sub mnuPopupMinimapRefreshDraft_Click()
    FrmAnnihilator.mnuViewRedrawMiniMap_Click
End Sub

Private Sub mnuPopupMinimapRefreshFinal_Click()
    FrmAnnihilator.mnuSpecialCreateHighQualityMini_Click
End Sub

Private Sub mnuRegionHeight_Click()
    mnuRegionHeight.Checked = Not mnuRegionHeight.Checked
    PasteHeight = mnuRegionHeight.Checked
End Sub

Private Sub mnuRegionTextures_Click()
    mnuRegionTextures.Checked = Not mnuRegionTextures.Checked
    PasteTiles = mnuRegionTextures.Checked
End Sub

Private Sub mnuSectionExportBMP_Click()
    FrmAnnihilator.mnuSectionsExportBMP_Click
End Sub

Private Sub mnuSectionExportHeight_Click()
    On Error GoTo Error
    If SelectedSection.Name = "" Then Exit Sub
    CommonDialog.DefaultExt = "bmp"
    CommonDialog.Filter = "Bitmap files (*.bmp)|*.bmp"
    CommonDialog.Filename = ""
    CommonDialog.ShowSave
    If (CommonDialog.Filename <> "") And (Err.Number <> cdlCancel) Then
        Screen.MousePointer = vbHourglass
        SelectedSection.ExportHeight CommonDialog.Filename
    End If
Error:
    Screen.MousePointer = vbNormal
End Sub

Private Sub mnuSectionFillMap_Click()
    Dim Response As Integer
    
    On Error Resume Next
    If Not MapLoaded Then Exit Sub
    Response = MsgBox("This action with overwrite the entire map.  Do you want to continue?", vbInformation + vbYesNo, "Fill")
    If Response = vbYes Then
        Maps(SelectedMap).FillMap
    End If
End Sub

Private Sub mnuSectionFillRegion_Click()
    On Error Resume Next
    Maps(SelectedMap).FillOverlay
End Sub

Private Sub mnuSectionImportHeight_Click()
    On Error GoTo Error
    If SelectedSection.Name = "" Then Exit Sub
    CommonDialog.Filter = "Bitmap files (*.bmp)|*.bmp"
    CommonDialog.Filename = ""
    CommonDialog.ShowOpen
    If (CommonDialog.Filename <> "") And (Err.Number <> cdlCancel) Then
        Screen.MousePointer = vbHourglass
        SelectedSection.ImportHeight CommonDialog.Filename
    End If
Error:
    Screen.MousePointer = vbNormal
End Sub

Public Sub mnuSectionPaste_Click()
    On Error GoTo Error
    If SelectedSection.Name = "" Then Exit Sub
    Maps(SelectedMap).OverlayPut
Error:
End Sub
