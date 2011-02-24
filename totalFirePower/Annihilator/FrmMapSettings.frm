VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.2#0"; "COMCTL32.OCX"
Object = "{FE0065C0-1B7B-11CF-9D53-00AA003C9CB6}#1.0#0"; "COMCT232.OCX"
Begin VB.Form FrmMapSettings 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Map Settings"
   ClientHeight    =   3015
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5850
   Icon            =   "FrmMapSettings.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3015
   ScaleWidth      =   5850
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.PictureBox FrameMap 
      BorderStyle     =   0  'None
      Height          =   1815
      Left            =   180
      ScaleHeight     =   1815
      ScaleWidth      =   5475
      TabIndex        =   52
      Top             =   480
      Width           =   5475
      Begin VB.ComboBox LstMemory 
         Height          =   315
         Left            =   3720
         TabIndex        =   64
         Top             =   420
         Width           =   1635
      End
      Begin VB.TextBox TxtMissionDescription 
         Height          =   315
         Left            =   1920
         TabIndex        =   57
         Top             =   420
         Width           =   1635
      End
      Begin VB.TextBox TxtMissionName 
         Height          =   315
         Left            =   120
         TabIndex        =   56
         Top             =   420
         Width           =   1635
      End
      Begin VB.ComboBox LstAIProfile 
         Height          =   315
         Left            =   120
         TabIndex        =   55
         Text            =   "LstAIProfile"
         Top             =   1320
         Width           =   1635
      End
      Begin VB.TextBox TxtPlayers 
         Height          =   315
         Left            =   3720
         TabIndex        =   54
         Top             =   1320
         Width           =   1635
      End
      Begin VB.ComboBox LstPlanet 
         Height          =   315
         Left            =   1920
         TabIndex        =   53
         Top             =   1320
         Width           =   1635
      End
      Begin VB.Label Label20 
         Caption         =   "Memory"
         Height          =   255
         Left            =   3720
         TabIndex        =   63
         Top             =   120
         Width           =   1275
      End
      Begin VB.Label Label2 
         Caption         =   "Mission description"
         Height          =   255
         Left            =   1920
         TabIndex        =   62
         Top             =   120
         Width           =   1635
      End
      Begin VB.Label Label1 
         Caption         =   "Mission name"
         Height          =   255
         Left            =   120
         TabIndex        =   61
         Top             =   120
         Width           =   1275
      End
      Begin VB.Line Line6 
         BorderColor     =   &H80000010&
         X1              =   120
         X2              =   5340
         Y1              =   900
         Y2              =   900
      End
      Begin VB.Line Line5 
         BorderColor     =   &H80000014&
         X1              =   120
         X2              =   5340
         Y1              =   915
         Y2              =   915
      End
      Begin VB.Label Label13 
         Caption         =   "AI profile"
         Height          =   195
         Left            =   120
         TabIndex        =   60
         Top             =   1020
         Width           =   855
      End
      Begin VB.Label Label15 
         Caption         =   "Players"
         Height          =   255
         Left            =   3720
         TabIndex        =   59
         Top             =   1020
         Width           =   915
      End
      Begin VB.Label Label16 
         Caption         =   "Planet"
         Height          =   255
         Left            =   1920
         TabIndex        =   58
         Top             =   1020
         Width           =   1335
      End
   End
   Begin VB.PictureBox FrameCampaign 
      Height          =   1815
      Left            =   180
      ScaleHeight     =   1755
      ScaleWidth      =   5415
      TabIndex        =   51
      Top             =   3720
      Visible         =   0   'False
      Width           =   5475
   End
   Begin VB.PictureBox FrameMission 
      Height          =   1815
      Left            =   540
      ScaleHeight     =   1755
      ScaleWidth      =   5415
      TabIndex        =   50
      Top             =   3720
      Visible         =   0   'False
      Width           =   5475
   End
   Begin VB.PictureBox FrameSpecial 
      BorderStyle     =   0  'None
      Height          =   1815
      Left            =   180
      ScaleHeight     =   1815
      ScaleWidth      =   5475
      TabIndex        =   28
      Top             =   480
      Visible         =   0   'False
      Width           =   5475
      Begin ComCtl2.UpDown ScrollWaterDamage 
         Height          =   315
         Left            =   4320
         TabIndex        =   35
         Top             =   1410
         Visible         =   0   'False
         Width           =   240
         _ExtentX        =   423
         _ExtentY        =   556
         _Version        =   327681
         Max             =   100
         Enabled         =   -1  'True
      End
      Begin VB.TextBox TxtWaterDamage 
         Height          =   315
         Left            =   3720
         TabIndex        =   34
         Text            =   "100%"
         Top             =   1410
         Visible         =   0   'False
         Width           =   555
      End
      Begin VB.Frame Frame1 
         Caption         =   "Map weapons"
         Height          =   1155
         Left            =   180
         TabIndex        =   33
         Top             =   120
         Width           =   5055
         Begin ComCtl2.UpDown ScrollMeteor 
            Height          =   315
            Index           =   3
            Left            =   4680
            TabIndex        =   49
            Top             =   660
            Width           =   240
            _ExtentX        =   423
            _ExtentY        =   556
            _Version        =   327681
            Enabled         =   -1  'True
         End
         Begin VB.TextBox TxtMeteorInterval 
            Height          =   315
            Left            =   4020
            TabIndex        =   48
            Top             =   660
            Width           =   615
         End
         Begin ComCtl2.UpDown ScrollMeteor 
            Height          =   315
            Index           =   2
            Left            =   4680
            TabIndex        =   46
            Top             =   240
            Width           =   240
            _ExtentX        =   423
            _ExtentY        =   556
            _Version        =   327681
            Enabled         =   -1  'True
         End
         Begin VB.TextBox TxtMeteorDuration 
            Height          =   315
            Left            =   4020
            TabIndex        =   45
            Top             =   240
            Width           =   615
         End
         Begin ComCtl2.UpDown ScrollMeteor 
            Height          =   315
            Index           =   1
            Left            =   2880
            TabIndex        =   43
            Top             =   660
            Width           =   240
            _ExtentX        =   423
            _ExtentY        =   556
            _Version        =   327681
            Enabled         =   -1  'True
         End
         Begin VB.TextBox TxtMeteorDensity 
            Height          =   315
            Left            =   2220
            TabIndex        =   42
            Top             =   660
            Width           =   615
         End
         Begin ComCtl2.UpDown ScrollMeteor 
            Height          =   315
            Index           =   0
            Left            =   2880
            TabIndex        =   40
            Top             =   240
            Width           =   240
            _ExtentX        =   423
            _ExtentY        =   556
            _Version        =   327681
            Enabled         =   -1  'True
         End
         Begin VB.TextBox TxtMeteorRadius 
            Height          =   315
            Left            =   2220
            TabIndex        =   39
            Top             =   240
            Width           =   615
         End
         Begin VB.ComboBox LstMeteorWeapon 
            Height          =   315
            Left            =   180
            TabIndex        =   37
            Text            =   "METEOR"
            Top             =   600
            Width           =   1275
         End
         Begin VB.Label Label19 
            Alignment       =   1  'Right Justify
            Caption         =   "Interval"
            Height          =   255
            Left            =   3180
            TabIndex        =   47
            Top             =   720
            Width           =   735
         End
         Begin VB.Label Label14 
            Alignment       =   1  'Right Justify
            Caption         =   "Duration"
            Height          =   255
            Left            =   3240
            TabIndex        =   44
            Top             =   300
            Width           =   675
         End
         Begin VB.Label Label12 
            Alignment       =   1  'Right Justify
            Caption         =   "Density"
            Height          =   255
            Left            =   1500
            TabIndex        =   41
            Top             =   720
            Width           =   615
         End
         Begin VB.Label Label11 
            Alignment       =   1  'Right Justify
            Caption         =   "Radius"
            Height          =   255
            Left            =   1500
            TabIndex        =   38
            Top             =   300
            Width           =   615
         End
         Begin VB.Label Label10 
            Caption         =   "Weapon"
            Height          =   255
            Left            =   180
            TabIndex        =   36
            Top             =   300
            Width           =   675
         End
      End
      Begin VB.CheckBox chkImpassibleWater 
         Caption         =   "&Impassible water"
         Height          =   255
         Left            =   180
         TabIndex        =   31
         Top             =   1440
         Width           =   1575
      End
      Begin VB.CheckBox chkWaterDoesDamage 
         Caption         =   "&Water does damage"
         Height          =   255
         Left            =   1860
         TabIndex        =   30
         Top             =   1440
         Width           =   1815
      End
   End
   Begin VB.CommandButton CmdCancel 
      Caption         =   "&Cancel"
      Height          =   375
      Left            =   4620
      TabIndex        =   27
      Top             =   2520
      Width           =   1095
   End
   Begin VB.PictureBox FrameSettings 
      BorderStyle     =   0  'None
      Height          =   1815
      Left            =   180
      ScaleHeight     =   1815
      ScaleWidth      =   5475
      TabIndex        =   10
      Top             =   480
      Visible         =   0   'False
      Width           =   5475
      Begin VB.TextBox TxtMohoMetal 
         Height          =   315
         Left            =   4140
         TabIndex        =   8
         Top             =   1200
         Width           =   855
      End
      Begin VB.TextBox TxtSurfaceMetal 
         Height          =   315
         Left            =   4140
         TabIndex        =   7
         Top             =   480
         Width           =   855
      End
      Begin VB.TextBox TxtSeaLevel 
         Height          =   315
         Left            =   2820
         TabIndex        =   5
         Top             =   480
         Width           =   855
      End
      Begin VB.TextBox TxtMinWindSpeed 
         Height          =   315
         Left            =   180
         TabIndex        =   1
         Top             =   480
         Width           =   855
      End
      Begin VB.TextBox TxtMaxWindSpeed 
         Height          =   315
         Left            =   180
         TabIndex        =   2
         Top             =   1200
         Width           =   855
      End
      Begin VB.TextBox TxtTidalStrength 
         Height          =   315
         Left            =   1500
         TabIndex        =   3
         Top             =   480
         Width           =   855
      End
      Begin VB.TextBox TxtSolarStrength 
         Height          =   315
         Left            =   1500
         TabIndex        =   4
         Top             =   1200
         Width           =   855
      End
      Begin VB.TextBox TxtGravity 
         Height          =   315
         Left            =   2820
         TabIndex        =   6
         Top             =   1200
         Width           =   855
      End
      Begin ComCtl2.UpDown Scroll 
         Height          =   315
         Index           =   0
         Left            =   1080
         TabIndex        =   11
         Top             =   480
         Width           =   240
         _ExtentX        =   423
         _ExtentY        =   556
         _Version        =   327681
         Max             =   20000
         Enabled         =   -1  'True
      End
      Begin ComCtl2.UpDown Scroll 
         Height          =   315
         Index           =   1
         Left            =   1080
         TabIndex        =   12
         Top             =   1200
         Width           =   240
         _ExtentX        =   423
         _ExtentY        =   556
         _Version        =   327681
         Max             =   20000
         Enabled         =   -1  'True
      End
      Begin ComCtl2.UpDown Scroll 
         Height          =   315
         Index           =   2
         Left            =   2400
         TabIndex        =   13
         Top             =   480
         Width           =   240
         _ExtentX        =   423
         _ExtentY        =   556
         _Version        =   327681
         Max             =   20000
         Enabled         =   -1  'True
      End
      Begin ComCtl2.UpDown Scroll 
         Height          =   315
         Index           =   3
         Left            =   2400
         TabIndex        =   14
         Top             =   1200
         Width           =   240
         _ExtentX        =   423
         _ExtentY        =   556
         _Version        =   327681
         Max             =   20000
         Enabled         =   -1  'True
      End
      Begin ComCtl2.UpDown Scroll 
         Height          =   315
         Index           =   4
         Left            =   3720
         TabIndex        =   15
         Top             =   480
         Width           =   240
         _ExtentX        =   423
         _ExtentY        =   556
         _Version        =   327681
         Max             =   255
         Enabled         =   -1  'True
      End
      Begin ComCtl2.UpDown Scroll 
         Height          =   315
         Index           =   5
         Left            =   3720
         TabIndex        =   16
         Top             =   1200
         Width           =   240
         _ExtentX        =   423
         _ExtentY        =   556
         _Version        =   327681
         Max             =   1000
         Enabled         =   -1  'True
      End
      Begin ComCtl2.UpDown Scroll 
         Height          =   315
         Index           =   6
         Left            =   5040
         TabIndex        =   25
         Top             =   480
         Width           =   240
         _ExtentX        =   423
         _ExtentY        =   556
         _Version        =   327681
         Max             =   255
         Enabled         =   -1  'True
      End
      Begin ComCtl2.UpDown Scroll 
         Height          =   315
         Index           =   7
         Left            =   5040
         TabIndex        =   26
         Top             =   1200
         Width           =   240
         _ExtentX        =   423
         _ExtentY        =   556
         _Version        =   327681
         Max             =   255
         Enabled         =   -1  'True
      End
      Begin VB.Label Label18 
         Caption         =   "Moho metal"
         Height          =   255
         Left            =   4140
         TabIndex        =   24
         Top             =   960
         Width           =   1095
      End
      Begin VB.Label Label17 
         Caption         =   "Surface metal"
         Height          =   255
         Left            =   4140
         TabIndex        =   23
         Top             =   240
         Width           =   1095
      End
      Begin VB.Label Label3 
         Caption         =   "Sea level"
         Height          =   255
         Left            =   2820
         TabIndex        =   22
         Top             =   240
         Width           =   855
      End
      Begin VB.Label Label4 
         Caption         =   "Min wind speed"
         Height          =   255
         Left            =   180
         TabIndex        =   21
         Top             =   240
         Width           =   1215
      End
      Begin VB.Label Label5 
         Caption         =   "Max wind speed"
         Height          =   255
         Left            =   180
         TabIndex        =   20
         Top             =   960
         Width           =   1215
      End
      Begin VB.Label Label6 
         Caption         =   "Tidal strength"
         Height          =   255
         Left            =   1500
         TabIndex        =   19
         Top             =   240
         Width           =   1095
      End
      Begin VB.Label Label7 
         Caption         =   "Solar strength"
         Height          =   255
         Left            =   1500
         TabIndex        =   18
         Top             =   960
         Width           =   1155
      End
      Begin VB.Label Label8 
         Caption         =   "Gravity"
         Height          =   255
         Left            =   2820
         TabIndex        =   17
         Top             =   960
         Width           =   795
      End
   End
   Begin ComctlLib.TabStrip TabSettings 
      Height          =   2235
      Left            =   120
      TabIndex        =   9
      Top             =   120
      Width           =   5595
      _ExtentX        =   9869
      _ExtentY        =   3942
      _Version        =   327682
      BeginProperty Tabs {0713E432-850A-101B-AFC0-4210102A8DA7} 
         NumTabs         =   3
         BeginProperty Tab1 {0713F341-850A-101B-AFC0-4210102A8DA7} 
            Caption         =   "Map"
            Key             =   "map"
            Object.Tag             =   ""
            ImageVarType    =   2
         EndProperty
         BeginProperty Tab2 {0713F341-850A-101B-AFC0-4210102A8DA7} 
            Caption         =   "Settings"
            Key             =   "settings"
            Object.Tag             =   ""
            ImageVarType    =   2
         EndProperty
         BeginProperty Tab3 {0713F341-850A-101B-AFC0-4210102A8DA7} 
            Caption         =   "Special"
            Key             =   "special"
            Object.Tag             =   ""
            ImageVarType    =   2
         EndProperty
      EndProperty
   End
   Begin VB.CommandButton CmdOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   3420
      TabIndex        =   0
      Top             =   2520
      Width           =   1095
   End
   Begin VB.Label LblSize 
      Height          =   255
      Left            =   600
      TabIndex        =   32
      Top             =   2580
      Width           =   915
   End
   Begin VB.Label Label9 
      Caption         =   "Size"
      Height          =   255
      Left            =   120
      TabIndex        =   29
      Top             =   2580
      Width           =   435
   End
End
Attribute VB_Name = "FrmMapSettings"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private otaInfo() As String
Private TempSealevel As Long

' Show the selected map's settings on the form. '
Sub ShowSettings()
    On Error GoTo Error
    Maps(SelectedMap).OTAGetSettings otaInfo()
    TempSealevel = Maps(SelectedMap).GetSealevel
    
    TxtMissionName = otaInfo(otaMissionName)
    TxtMissionDescription = otaInfo(otaMissionDescription)
    LstMemory.Text = otaInfo(otaMemory)
    LstAIProfile.Text = otaInfo(otaAIProfile)
    LstPlanet.Text = otaInfo(otaPlanet)
    TxtPlayers = otaInfo(otaNumPlayers)
    LblSize = otaInfo(otaSize)
    
    TxtMinWindSpeed = otaInfo(otaMinWindSpeed)
    TxtMinWindSpeed_LostFocus
    TxtMaxWindSpeed = otaInfo(otaMaxWindSpeed)
    TxtMaxWindSpeed_LostFocus
    TxtTidalStrength = otaInfo(otaTidalStrength)
    TxtTidalStrength_LostFocus
    TxtSolarStrength = otaInfo(otaSolarStrength)
    TxtSolarStrength_LostFocus
    TxtSealevel = CStr(TempSealevel)
    TxtSeaLevel_LostFocus
    TxtGravity = otaInfo(otaGravity)
    TxtGravity_LostFocus
    TxtSurfaceMetal = otaInfo(otaSurfaceMetal)
    TxtSurfaceMetal_LostFocus
    TxtMohoMetal = otaInfo(otaMohoMetal)
    TxtMohoMetal_LostFocus
    
    LstMeteorWeapon.Text = otaInfo(otaMeteorWeapon)
    TxtMeteorRadius = otaInfo(otaMeteorRadius)
    TxtMeteorRadius_LostFocus
    TxtMeteorDensity = otaInfo(otaMeteorDensity)
    TxtMeteorDensity_LostFocus
    TxtMeteorDuration = otaInfo(otaMeteorDuration)
    TxtMeteorDuration_LostFocus
    TxtMeteorInterval = otaInfo(otaMeteorInterval)
    TxtMeteorInterval_LostFocus
    ScrollWaterDamage.Value = Val(otaInfo(otaWaterDamage))
    
    If otaInfo(otaLavaWorld) = "1" Then
        chkImpassibleWater.Value = vbChecked
    Else
        chkImpassibleWater.Value = vbUnchecked
    End If
    If otaInfo(otaWaterDoesDamage) = "1" Then
        chkWaterDoesDamage.Value = vbChecked
    Else
        chkWaterDoesDamage.Value = vbUnchecked
    End If
    Exit Sub
    
Error:
   Unload Me
End Sub

Sub SaveSettings()
    On Error Resume Next
    otaInfo(otaMissionName) = TxtMissionName
    otaInfo(otaMissionDescription) = TxtMissionDescription
    otaInfo(otaMemory) = LstMemory.Text
    otaInfo(otaAIProfile) = LstAIProfile.Text
    otaInfo(otaPlanet) = LstPlanet.Text
    otaInfo(otaNumPlayers) = TxtPlayers
    otaInfo(otaSize) = LblSize
    
    otaInfo(otaMinWindSpeed) = TxtMinWindSpeed
    otaInfo(otaMaxWindSpeed) = TxtMaxWindSpeed
    otaInfo(otaTidalStrength) = TxtTidalStrength
    otaInfo(otaSolarStrength) = TxtSolarStrength
    TempSealevel = Val(TxtSealevel)
    otaInfo(otaGravity) = TxtGravity
    otaInfo(otaSurfaceMetal) = TxtSurfaceMetal
    otaInfo(otaMohoMetal) = TxtMohoMetal
    
    otaInfo(otaMeteorWeapon) = LstMeteorWeapon.Text
    otaInfo(otaMeteorRadius) = TxtMeteorRadius
    otaInfo(otaMeteorDensity) = TxtMeteorDensity
    otaInfo(otaMeteorDuration) = TxtMeteorDuration
    otaInfo(otaMeteorInterval) = TxtMeteorInterval
    otaInfo(otaWaterDamage) = CStr(ScrollWaterDamage.Value)
    
    If chkImpassibleWater.Value = vbChecked Then
        otaInfo(otaLavaWorld) = "1"
    Else
        otaInfo(otaLavaWorld) = "0"
    End If
    If chkWaterDoesDamage.Value = vbChecked Then
        otaInfo(otaWaterDoesDamage) = "1"
    Else
        otaInfo(otaWaterDoesDamage) = "0"
    End If

    Maps(SelectedMap).OTASetSettings otaInfo()
    Maps(SelectedMap).SetSealevel TempSealevel
End Sub

Sub UpdateInterface()
    If chkWaterDoesDamage.Value = vbChecked Then
        TxtWaterDamage.Visible = True
        ScrollWaterDamage.Visible = True
    Else
        TxtWaterDamage.Visible = False
        ScrollWaterDamage.Visible = False
    End If
End Sub

Sub Initialize()
    Dim Index As Integer
    
    ' Memory. '
    LstMemory.AddItem "16 mb"
    LstMemory.AddItem "32 mb"
    LstMemory.AddItem "48 mb"
    LstMemory.AddItem "64 mb"
    LstMemory.AddItem "128 mb"
    
    ' AI Profile. '
    For Index = 1 To UBound(AITypes)
        LstAIProfile.AddItem AITypes(Index)
    Next
        
    ' Planets. '
    LstPlanet.AddItem "Archipelago"
    LstPlanet.AddItem "Crystal"
    LstPlanet.AddItem "Darkside"
    LstPlanet.AddItem "Desert"
    LstPlanet.AddItem "Ice"
    LstPlanet.AddItem "Green Planet"
    LstPlanet.AddItem "Lava"
    LstPlanet.AddItem "Lunar"
    LstPlanet.AddItem "Lush"
    LstPlanet.AddItem "Metal"
    LstPlanet.AddItem "Red Planet"
    LstPlanet.AddItem "Slate"
    LstPlanet.AddItem "Urban"
    LstPlanet.AddItem "Wet Desert"
    
    ' Misc. '
    LstMeteorWeapon.AddItem "EARTHQUAKE"
    LstMeteorWeapon.AddItem "HAILSTORM"
    LstMeteorWeapon.AddItem "METEOR"
    
    ShowSettings
End Sub

Private Sub chkImpassibleWater_Click()
    If chkImpassibleWater.Value = vbChecked Then
        otaInfo(otaLavaWorld) = "1"
    Else
        otaInfo(otaLavaWorld) = "0"
    End If
End Sub

Private Sub chkWaterDoesDamage_Click()
    If chkWaterDoesDamage.Value = vbChecked Then
        otaInfo(otaWaterDoesDamage) = "1"
    Else
        otaInfo(otaWaterDoesDamage) = "0"
    End If
    UpdateInterface
End Sub

Private Sub CmdCancel_Click()
    Unload Me
End Sub

Private Sub CmdOK_Click()
    SaveSettings
    Unload Me
End Sub

Private Sub Form_Load()
    Initialize
End Sub

Private Sub Scroll_Change(Index As Integer)
    Dim Value As String

    Value = CStr(Scroll(Index).Value)
    Select Case Index
        Case 0
            TxtMinWindSpeed = Value
        Case 1
            TxtMaxWindSpeed = Value
        Case 2
            TxtTidalStrength = Value
        Case 3
            TxtSolarStrength = Value
        Case 4
            TxtSealevel = Value
        Case 5
            TxtGravity = Value
        Case 6
            TxtSurfaceMetal = Value
        Case 7
            TxtMohoMetal = Value
    End Select
End Sub

Private Sub ScrollMeteor_Change(Index As Integer)
    Dim Value As String
    
    Value = CStr(ScrollMeteor(Index).Value)
    Select Case Index
        Case 0
            TxtMeteorRadius = Value
        Case 1
            TxtMeteorDensity = Value
        Case 2
            TxtMeteorDuration = Value
        Case 3
            TxtMeteorInterval = Value
    End Select
End Sub

Private Sub ScrollWaterDamage_Change()
    TxtWaterDamage = CStr(ScrollWaterDamage.Value) & "%"
End Sub

Private Sub TabSettings_Click()
    Select Case TabSettings.SelectedItem.Key
        Case "map"
            FrameMap.Visible = True
            FrameSettings.Visible = False
            FrameMission.Visible = False
            FrameCampaign.Visible = False
            FrameSpecial.Visible = False
        Case "settings"
            FrameMap.Visible = False
            FrameSettings.Visible = True
            FrameMission.Visible = False
            FrameCampaign.Visible = False
            FrameSpecial.Visible = False
        Case "mission"
            FrameMap.Visible = False
            FrameSettings.Visible = False
            FrameMission.Visible = True
            FrameCampaign.Visible = False
            FrameSpecial.Visible = False
        Case "campaign"
            FrameMap.Visible = False
            FrameSettings.Visible = False
            FrameMission.Visible = False
            FrameCampaign.Visible = True
            FrameSpecial.Visible = False
        Case "special"
            FrameMap.Visible = False
            FrameSettings.Visible = False
            FrameMission.Visible = False
            FrameCampaign.Visible = False
            FrameSpecial.Visible = True
    End Select
End Sub

Private Sub TxtGravity_KeyPress(KeyAscii As Integer)
    If (KeyAscii < Asc("0") Or KeyAscii > Asc("9")) And (KeyAscii <> 8) Then
        KeyAscii = 0
    End If
End Sub

Private Sub TxtGravity_LostFocus()
    If Val(TxtGravity) < Scroll(5).Min Then
        Scroll(5).Value = Scroll(5).Min
    ElseIf Val(TxtGravity) > Scroll(5).Max Then
        Scroll(5).Value = Scroll(5).Max
    Else
        Scroll(5).Value = Val(TxtGravity)
    End If
End Sub

Private Sub TxtMaxWindSpeed_KeyPress(KeyAscii As Integer)
    If (KeyAscii < Asc("0") Or KeyAscii > Asc("9")) And (KeyAscii <> 8) Then
        KeyAscii = 0
    End If
End Sub

Private Sub TxtMaxWindSpeed_LostFocus()
    If Val(TxtMaxWindSpeed) < Scroll(1).Min Then
        Scroll(1).Value = Scroll(1).Min
    ElseIf Val(TxtMaxWindSpeed) > Scroll(1).Max Then
        Scroll(1).Value = Scroll(1).Max
    Else
        Scroll(1).Value = Val(TxtMaxWindSpeed)
    End If
End Sub

Private Sub TxtMeteorDensity_KeyPress(KeyAscii As Integer)
    If (KeyAscii < Asc("0") Or KeyAscii > Asc("9")) And (KeyAscii <> 8) Then
        KeyAscii = 0
    End If
End Sub

Private Sub TxtMeteorDensity_LostFocus()
    If Val(TxtMeteorDensity) < ScrollMeteor(1).Min Then
        ScrollMeteor(1).Value = ScrollMeteor(1).Min
    ElseIf Val(TxtMeteorDensity) > ScrollMeteor(1).Max Then
        ScrollMeteor(1).Value = ScrollMeteor(1).Max
    Else
        ScrollMeteor(1).Value = Val(TxtMeteorDensity)
    End If
End Sub

Private Sub TxtMeteorDuration_KeyPress(KeyAscii As Integer)
    If (KeyAscii < Asc("0") Or KeyAscii > Asc("9")) And (KeyAscii <> 8) Then
        KeyAscii = 0
    End If
End Sub

Private Sub TxtMeteorDuration_LostFocus()
    If Val(TxtMeteorDuration) < ScrollMeteor(2).Min Then
        ScrollMeteor(2).Value = ScrollMeteor(2).Min
    ElseIf Val(TxtMeteorDuration) > ScrollMeteor(2).Max Then
        ScrollMeteor(2).Value = ScrollMeteor(2).Max
    Else
        ScrollMeteor(2).Value = Val(TxtMeteorDuration)
    End If
End Sub

Private Sub TxtMeteorInterval_KeyPress(KeyAscii As Integer)
    If (KeyAscii < Asc("0") Or KeyAscii > Asc("9")) And (KeyAscii <> 8) Then
        KeyAscii = 0
    End If
End Sub

Private Sub TxtMeteorInterval_LostFocus()
    If Val(TxtMeteorInterval) < ScrollMeteor(3).Min Then
        ScrollMeteor(3).Value = ScrollMeteor(3).Min
    ElseIf Val(TxtMeteorInterval) > ScrollMeteor(3).Max Then
        ScrollMeteor(3).Value = ScrollMeteor(3).Max
    Else
        ScrollMeteor(3).Value = Val(TxtMeteorInterval)
    End If
End Sub

Private Sub TxtMeteorRadius_KeyPress(KeyAscii As Integer)
    If (KeyAscii < Asc("0") Or KeyAscii > Asc("9")) And (KeyAscii <> 8) Then
        KeyAscii = 0
    End If
End Sub

Private Sub TxtMeteorRadius_LostFocus()
    If Val(TxtMeteorRadius) < ScrollMeteor(0).Min Then
        ScrollMeteor(0).Value = ScrollMeteor(0).Min
    ElseIf Val(TxtMeteorRadius) > ScrollMeteor(0).Max Then
        ScrollMeteor(0).Value = ScrollMeteor(0).Max
    Else
        ScrollMeteor(0).Value = Val(TxtMeteorRadius)
    End If
End Sub

Private Sub TxtMinWindSpeed_KeyPress(KeyAscii As Integer)
    If (KeyAscii < Asc("0") Or KeyAscii > Asc("9")) And (KeyAscii <> 8) Then
        KeyAscii = 0
    End If
End Sub

Private Sub TxtMinWindSpeed_LostFocus()
    If Val(TxtMinWindSpeed) < Scroll(0).Min Then
        Scroll(0).Value = Scroll(0).Min
    ElseIf Val(TxtMinWindSpeed) > Scroll(0).Max Then
        Scroll(0).Value = Scroll(0).Max
    Else
        Scroll(0).Value = Val(TxtMinWindSpeed)
    End If
End Sub

Private Sub TxtMohoMetal_KeyPress(KeyAscii As Integer)
    If (KeyAscii < Asc("0") Or KeyAscii > Asc("9")) And (KeyAscii <> 8) Then
        KeyAscii = 0
    End If
End Sub

Private Sub TxtMohoMetal_LostFocus()
    If Val(TxtMohoMetal) < Scroll(7).Min Then
        Scroll(7).Value = Scroll(7).Min
    ElseIf Val(TxtMohoMetal) > Scroll(7).Max Then
        Scroll(7).Value = Scroll(7).Max
    Else
        Scroll(7).Value = Val(TxtMohoMetal)
    End If
End Sub

Private Sub TxtSeaLevel_KeyPress(KeyAscii As Integer)
    If (KeyAscii < Asc("0") Or KeyAscii > Asc("9")) And (KeyAscii <> 8) Then
        KeyAscii = 0
    End If
End Sub

Private Sub TxtSeaLevel_LostFocus()
    If Val(TxtSealevel) < Scroll(4).Min Then
        Scroll(4).Value = Scroll(4).Min
    ElseIf Val(TxtSealevel) > Scroll(4).Max Then
        Scroll(4).Value = Scroll(4).Max
    Else
        Scroll(4).Value = Val(TxtSealevel)
    End If
End Sub

Private Sub TxtSolarStrength_KeyPress(KeyAscii As Integer)
    If (KeyAscii < Asc("0") Or KeyAscii > Asc("9")) And (KeyAscii <> 8) Then
        KeyAscii = 0
    End If
End Sub

Private Sub TxtSolarStrength_LostFocus()
    If Val(TxtSolarStrength) < Scroll(3).Min Then
        Scroll(3).Value = Scroll(3).Min
    ElseIf Val(TxtSolarStrength) > Scroll(3).Max Then
        Scroll(3).Value = Scroll(3).Max
    Else
        Scroll(3).Value = Val(TxtSolarStrength)
    End If
End Sub

Private Sub TxtSurfaceMetal_KeyPress(KeyAscii As Integer)
    If (KeyAscii < Asc("0") Or KeyAscii > Asc("9")) And (KeyAscii <> 8) Then
        KeyAscii = 0
    End If
End Sub

Private Sub TxtSurfaceMetal_LostFocus()
    If Val(TxtSurfaceMetal) < Scroll(6).Min Then
        Scroll(6).Value = Scroll(6).Min
    ElseIf Val(TxtSurfaceMetal) > Scroll(6).Max Then
        Scroll(6).Value = Scroll(6).Max
    Else
        Scroll(6).Value = Val(TxtSurfaceMetal)
    End If
End Sub

Private Sub TxtTidalStrength_KeyPress(KeyAscii As Integer)
    If (KeyAscii < Asc("0") Or KeyAscii > Asc("9")) And (KeyAscii <> 8) Then
        KeyAscii = 0
    End If
End Sub

Private Sub TxtTidalStrength_LostFocus()
    If Val(TxtTidalStrength) < Scroll(2).Min Then
        Scroll(2).Value = Scroll(2).Min
    ElseIf Val(TxtTidalStrength) > Scroll(2).Max Then
        Scroll(2).Value = Scroll(2).Max
    Else
        Scroll(2).Value = Val(TxtTidalStrength)
    End If
End Sub

Private Sub TxtWaterDamage_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = vbKeyDelete Then KeyCode = 0
End Sub

Private Sub TxtWaterDamage_KeyPress(KeyAscii As Integer)
    KeyAscii = 0
End Sub
