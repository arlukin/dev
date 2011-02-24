Attribute VB_Name = "modInterface"
' Main Annihilator interface module. '

Option Explicit

' Rubberband. '
Global Rubberband As New classRubberband

' AutoScroll values. '
Global AutoScrollX As Long
Global AutoScrollY As Long
Global AutoScrollButton As Long
Global Const AutoScrollSpeed = 250

' Splitters. '
Global CTRL_OFFSET As Integer ' Hold the horizontal & vertical offsets of the 2 controls. '
Global SPLT_COLOUR As Long ' Hold the Splitter bar color. '
Global currSplitPosX As Long ' Vertical splitter, holds the last sized position. '
Global Const SPLT_WDTH As Integer = 45
Global currSplitPosY As Long ' Horizontal splitter. '
Global Const SPLT_HEIGHT As Integer = 45

Global ControlsEnabled As Boolean

' Enable interface based on flag. '
Public Sub EnableControls(Flag As Boolean)
    Dim Index As Integer
    
    On Error Resume Next
    
    ControlsEnabled = Flag
    
    With FrmAnnihilator
    .PicToolbox.Enabled = Flag
    .Canvas.Enabled = Flag
    .mnuFileNew.Enabled = Flag
    .mnuFileOpen.Enabled = Flag
    .mnuFileSave.Enabled = Flag
    .mnuFileSaveAs.Enabled = Flag
    .mnuFileExportMap.Enabled = Flag
    .mnuFileClose.Enabled = Flag
    .mnuFileCloseAll.Enabled = Flag
    .mnuEditCopy.Enabled = Flag
    .mnuEditCut.Enabled = Flag
    .mnuEditPaste.Enabled = Flag
    .mnuEditClear.Enabled = Flag
    .mnuEditDeselect.Enabled = Flag
    .mnuEditSelectAll.Enabled = Flag
    .mnuEditFillMap.Enabled = Flag
    .mnuEditCopyRegion.Enabled = Flag
    .mnuViewMinimap.Enabled = Flag
    .mnuViewRedrawMiniMap.Enabled = Flag
    .mnuSpecialImportMinimap.Enabled = Flag
    .mnuSpecialExportMinimap.Enabled = Flag
    .mnuSpecialImportHeightMap.Enabled = Flag
    .mnuMapExportHeightMap.Enabled = Flag
    .mnuSpecialSaveMapBitmap.Enabled = Flag
    .mnuSpecialCreateHighQualityMini.Enabled = Flag
    .mnuMapResize.Enabled = Flag
    .mnuMapCompress.Enabled = Flag
    .mnuMapSettings.Enabled = Flag
    .mnuSectionsImportBMP.Enabled = Flag
    .mnuSectionsExportBMP.Enabled = Flag
    .mnuSectionsEdit.Enabled = Flag
    .mnuSectionsExport.Enabled = Flag
    .mnuSectionsSetHeightOffset.Enabled = Flag
    .mnuSectionsExportGroup.Enabled = Flag
    .mnuSectionsImportTileset.Enabled = Flag
    .mnuFeaturesFill.Enabled = Flag
    .mnuFeaturesCustomFill.Enabled = Flag
    .mnuFeaturesRemove.Enabled = Flag
    .mnuFeaturesClearRegion.Enabled = Flag
    .mnuFeaturesLoad.Enabled = Flag
    
    For Index = 1 To 26
        .Toolbar.Buttons(Index).Enabled = Flag
    Next
    End With
End Sub

Sub EnableDefaults()
    Dim Index As Integer
    
    With FrmAnnihilator
    .mnuFileNew.Enabled = True
    .mnuFileOpen.Enabled = True
    .mnuSectionsExport.Enabled = True
    .mnuSectionsImportBMP.Enabled = True
    .mnuSectionsExportBMP.Enabled = True
    .mnuSectionsEdit.Enabled = True
    .mnuSectionsSetHeightOffset.Enabled = True
    .mnuSectionsImportTileset.Enabled = True
    .mnuSectionsExportGroup.Enabled = True
    .mnuFeaturesLoad.Enabled = True
    .mnuFeaturesCustomFill.Enabled = True
    
    FrmAnnihilator.PicToolbox.Enabled = True
    FrmAnnihilator.Toolbar.Buttons(2).Enabled = True ' New map. '
    FrmAnnihilator.Toolbar.Buttons(3).Enabled = True ' Open map. '
    FrmAnnihilator.Toolbar.Buttons(5).Enabled = True ' Options. '
    For Index = 15 To 26
        FrmAnnihilator.Toolbar.Buttons(Index).Enabled = True
    Next
    End With
End Sub

Sub ShowToolbox(Flag As Boolean)
    With FrmAnnihilator
    .PicToolbox.Visible = Flag
    .PicToolSize.Visible = Flag
    .Form_Resize
    End With
End Sub

Sub ToolboxShowControls()
    With FrmAnnihilator
    If (SelectedItem = ToolSections) Then
        .PicSectionPalette.Visible = True
    Else
        .PicSectionPalette.Visible = False
    End If
    If (SelectedItem = ToolFeatures) Then
        .PicFeaturePalette.Visible = True
    Else
        .PicFeaturePalette.Visible = False
    End If
    If SelectedItem = ToolHeight Then
        .PicHeightPalette.Visible = True
    Else
        .PicHeightPalette.Visible = False
    End If
    If (SelectedItem = ToolSpecial) Then
        .PicSpecial.Visible = True
    Else
        .PicSpecial.Visible = False
    End If
    If (SelectedItem = ToolTiles) Then
        .PicTilePalette.Visible = True
    Else
        .PicTilePalette.Visible = False
    End If
    End With
End Sub

' Initialize the startup interface. '
Sub InitializeInterface()
   Dim Style As Long
   Dim hToolbar As Long
   Dim rc As Long

    ' Splitters. '
    With FrmAnnihilator
    CTRL_OFFSET = 5
    SPLT_COLOUR = &H808080
    currSplitPosX = &H7FFFFFFF
    currSplitPosY = &H7FFFFFFF
    
    ' Toolbar. '
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
    
    ' Get the handle of the toolbar. '
    hToolbar = FindWindowEx(.Toolbox.hwnd, 0&, "ToolbarWindow32", vbNullString)
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
    .Toolbox.Refresh

    EnableControls False
    EnableDefaults
    UpdateStatusbar
    UpdateCaption
    End With
End Sub
    
' Return a key 't0' for a tab. '
Function tKey(ByVal Index As Long) As String
    tKey = "t" & CStr(Index)
End Function

' Return an index for a tab key. '
Function tIndex(Key As String) As Long
    If Key = "" Then
        tIndex = 0
    Else
        tIndex = Val(Right(Key, Len(Key) - 1))
    End If
End Function

' Refresh the controls on Annihilator. '
Sub InterfaceUpdate()
    With FrmAnnihilator
    On Error Resume Next
    If MapLoaded Then
        EnableControls True
        Maps(SelectedMap).Refresh
        If ViewMinimap Then
            RefreshMiniSize
            If Not FrmMiniMap.Visible Then
                FrmMiniMap.Show
                View.Visible = True
            End If
        End If
        FrmAnnihilator.Show
    Else
        .PicTilePalette.Cls
        .ScrollTiles.Visible = False
        .CanvasCursor.Visible = False
        .Selected.Visible = False
        .Canvas.Picture = .PicToolbox.Picture
        .Canvas.Cls
        PicMiniMap.Picture = .PicToolbox.Picture
        PicMiniMap.Cls
        View.Visible = False
        .CanvasHScroll.Visible = False
        .CanvasVScroll.Visible = False
        EnableControls False
        EnableDefaults
        .Form_Resize
        FrmMiniMap.Visible = False
        .PicSeaLevel.Cls
        .SliderSeaLevel.Value = 0
    End If
    UpdateCaption
    UpdateStatusbar
    End With
End Sub

Sub UpdateMapTabs()
    Dim Index As Integer
    
    With FrmAnnihilator
    .TabMaps.Tabs.Clear
    For Index = 0 To UBound(Maps)
        If Maps(Index).MapLoaded Then
            If Maps(Index).MapFilename = "" Then
                .TabMaps.Tabs.Add , tKey(Index), "Untitled" & CStr(Index + 1) & ".ufo"
            Else
                .TabMaps.Tabs.Add , tKey(Index), GetFilename(Maps(Index).MapFilename) & ".ufo"
            End If
        End If
    Next
    If SelectedMap >= 0 Then
        Set .TabMaps.SelectedItem = .TabMaps.Tabs(tKey(SelectedMap))
    End If
    .Form_Resize
    End With
End Sub

Public Sub UpdateStatusbar(Optional Update As Integer = -1, Optional ByVal x As Long = 0, Optional ByVal y As Long = 0, Optional ByVal h As Long = 0, Optional ByVal Bandwidth As Long = 0, Optional ByVal Bandheight As Long = 0, Optional ByVal Feature As String = "")
    Dim Index As Integer
    
    On Error Resume Next
    With FrmAnnihilator
    .Status.Panels(1).Text = "Ready"
    If MapLoaded Then
        For Index = 2 To 8
            If Not .Status.Panels(Index).Visible Then
                If Index = 4 And Feature = "" Then
                    .Status.Panels(Index).Visible = False
                Else
                    .Status.Panels(Index).Visible = True
                End If
            End If
        Next
        If .Status.Panels(2).Text <> "x: " & CStr(x) & ", y: " & CStr(y) & ", h: " & CStr(h) & " " Then
            .Status.Panels(2).Text = "x: " & CStr(x) & ", y: " & CStr(y) & ", h: " & CStr(h) & " "
        End If
        If .Status.Panels(3).Text <> "(" & CStr(Bandwidth) & ", " & CStr(Bandheight) & ") " Then
            .Status.Panels(3).Text = "(" & CStr(Bandwidth) & ", " & CStr(Bandheight) & ") "
        End If
        If .Status.Panels(4).Text <> Feature & " " Then
            .Status.Panels(4).Text = Feature & " "
            If Feature = "" Then .Status.Panels(4).Visible = False
        End If
        If Update = -1 Or Update = 6 Then
            .Status.Panels(6).Text = CStr(Maps(SelectedMap).WidthUnit) & " x " & CStr(Maps(SelectedMap).HeightUnit) & " "
        End If
        If Update = -1 Or Update = 7 Then
            .Status.Panels(7).Text = "Textures: " & Format(Maps(SelectedMap).MapTextureSize, "0.0") & "mb "
        End If
        If Update = -1 Or Update = 8 Then
            .Status.Panels(8).Text = "Map: " & Format(Maps(SelectedMap).MapFileSize, "0.0") & "mb "
        End If
    Else
        For Index = 2 To 8
            .Status.Panels(Index).Visible = False
        Next
        .Status.Panels(5).Visible = True
    End If
    End With
End Sub

Public Sub UpdateCaption()
    If SelectedMap > -1 Then
        If Maps(SelectedMap).MapFilename = "" Then
            FrmAnnihilator.Caption = "Annihilator - Untitled" & CStr(SelectedMap + 1) & ".ufo"
        Else
            FrmAnnihilator.Caption = "Annihilator - " & Maps(SelectedMap).MapFilename & ".ufo"
        End If
    Else
        FrmAnnihilator.Caption = "Annihilator"
    End If
End Sub

Public Sub RefreshMiniSize()
    On Error Resume Next
    If Not ViewMinimap Then Exit Sub
    FrmMiniMap.Width = Screen.TwipsPerPixelX * MiniSize
    FrmMiniMap.Height = Screen.TwipsPerPixelY * (MiniSize + 15)
    If MapLoaded Then
        Maps(SelectedMap).MiniMapRefresh
    End If
End Sub

Public Sub RefreshMiniSizeMenu()
    With FrmAnnihilator
    .mnuViewMiniMapSizeLarge.Checked = False
    .mnuViewMiniMapSizeMedium.Checked = False
    .mnuViewMiniMapSizeSmall.Checked = False
    .mnuViewMinimapSizeHuge.Checked = False
    Select Case MiniSize
        Case 64
            .mnuViewMiniMapSizeSmall.Checked = True
        Case 128
            .mnuViewMiniMapSizeMedium.Checked = True
        Case 256
            .mnuViewMiniMapSizeLarge.Checked = True
        Case 512
            .mnuViewMinimapSizeHuge.Checked = True
    End Select
    End With
End Sub

Public Sub AddLastDoc(Filename As String)
    Dim Index As Integer
    
End Sub
