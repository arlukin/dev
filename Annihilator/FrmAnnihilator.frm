VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.1#0"; "COMDLG32.OCX"
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.2#0"; "COMCTL32.OCX"
Object = "{FE0065C0-1B7B-11CF-9D53-00AA003C9CB6}#1.0#0"; "COMCT232.OCX"
Begin VB.Form FrmAnnihilator 
   Caption         =   "Annihilator"
   ClientHeight    =   7665
   ClientLeft      =   1020
   ClientTop       =   1575
   ClientWidth     =   10065
   Icon            =   "FrmAnnihilator.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   7665
   ScaleWidth      =   10065
   WindowState     =   2  'Maximized
   Begin ComctlLib.Toolbar Toolbar 
      Align           =   1  'Align Top
      Height          =   420
      Left            =   0
      TabIndex        =   2
      Top             =   0
      Width           =   10065
      _ExtentX        =   17754
      _ExtentY        =   741
      ButtonWidth     =   635
      ButtonHeight    =   582
      AllowCustomize  =   0   'False
      Wrappable       =   0   'False
      Appearance      =   1
      ImageList       =   "ImgToolbar"
      _Version        =   327682
      BeginProperty Buttons {0713E452-850A-101B-AFC0-4210102A8DA7} 
         NumButtons      =   26
         BeginProperty Button1 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Object.Visible         =   0   'False
            Caption         =   ""
            Key             =   ""
            Description     =   ""
            Object.ToolTipText     =   ""
            Object.Tag             =   ""
            Style           =   4
            MixedState      =   -1  'True
         EndProperty
         BeginProperty Button2 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "new"
            Object.ToolTipText     =   "New Map"
            Object.Tag             =   ""
            ImageIndex      =   1
         EndProperty
         BeginProperty Button3 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "open"
            Object.ToolTipText     =   "Open"
            Object.Tag             =   ""
            ImageIndex      =   2
         EndProperty
         BeginProperty Button4 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "save"
            Object.ToolTipText     =   "Save"
            Object.Tag             =   ""
            ImageIndex      =   3
         EndProperty
         BeginProperty Button5 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "options"
            Object.ToolTipText     =   "Annihilator Options"
            Object.Tag             =   ""
            ImageIndex      =   4
         EndProperty
         BeginProperty Button6 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   ""
            Object.Tag             =   ""
            Style           =   3
            MixedState      =   -1  'True
         EndProperty
         BeginProperty Button7 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "cut"
            Object.ToolTipText     =   "Cut"
            Object.Tag             =   ""
            ImageIndex      =   6
         EndProperty
         BeginProperty Button8 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "copy"
            Object.ToolTipText     =   "Copy"
            Object.Tag             =   ""
            ImageIndex      =   5
         EndProperty
         BeginProperty Button9 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "paste"
            Object.ToolTipText     =   "Paste"
            Object.Tag             =   ""
            ImageIndex      =   7
         EndProperty
         BeginProperty Button10 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   ""
            Object.Tag             =   ""
            Style           =   3
            MixedState      =   -1  'True
         EndProperty
         BeginProperty Button11 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "compress"
            Object.ToolTipText     =   "Compress Map"
            Object.Tag             =   ""
            ImageIndex      =   8
         EndProperty
         BeginProperty Button12 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "fill"
            Object.ToolTipText     =   "Fill Features"
            Object.Tag             =   ""
            ImageIndex      =   9
         EndProperty
         BeginProperty Button13 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "map"
            Object.ToolTipText     =   "Map Settings"
            Object.Tag             =   ""
            ImageIndex      =   10
         EndProperty
         BeginProperty Button14 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   ""
            Object.Tag             =   ""
            Style           =   3
            MixedState      =   -1  'True
         EndProperty
         BeginProperty Button15 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "overgrid"
            Object.ToolTipText     =   "View Grid"
            Object.Tag             =   ""
            ImageIndex      =   11
            Style           =   1
         EndProperty
         BeginProperty Button16 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "overheight"
            Object.ToolTipText     =   "View Heightfield"
            Object.Tag             =   ""
            ImageIndex      =   12
            Style           =   1
         EndProperty
         BeginProperty Button17 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "overcontour"
            Object.ToolTipText     =   "View Contour Map"
            Object.Tag             =   ""
            ImageIndex      =   13
            Style           =   1
         EndProperty
         BeginProperty Button18 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "gridsettings"
            Object.ToolTipText     =   "Grid Options"
            Object.Tag             =   ""
            ImageIndex      =   14
         EndProperty
         BeginProperty Button19 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "heightsettings"
            Object.ToolTipText     =   "Height Options"
            Object.Tag             =   ""
            ImageIndex      =   15
         EndProperty
         BeginProperty Button20 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   ""
            Object.Tag             =   ""
            Style           =   3
            MixedState      =   -1  'True
         EndProperty
         BeginProperty Button21 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "overfeatures"
            Object.ToolTipText     =   "View Map Features"
            Object.Tag             =   ""
            ImageIndex      =   16
            Style           =   1
            Value           =   1
         EndProperty
         BeginProperty Button22 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "overstarting"
            Object.ToolTipText     =   "View Starting Positions"
            Object.Tag             =   ""
            ImageIndex      =   17
            Style           =   1
            Value           =   1
         EndProperty
         BeginProperty Button23 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   ""
            Object.Tag             =   ""
            Style           =   3
            MixedState      =   -1  'True
         EndProperty
         BeginProperty Button24 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "default"
            Object.ToolTipText     =   "Default"
            Object.Tag             =   ""
            ImageIndex      =   18
            Style           =   2
            Value           =   1
         EndProperty
         BeginProperty Button25 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "region"
            Object.ToolTipText     =   "Selection"
            Object.Tag             =   ""
            ImageIndex      =   19
            Style           =   2
         EndProperty
         BeginProperty Button26 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "regionsettings"
            Object.ToolTipText     =   "Selection Filters"
            Object.Tag             =   ""
            ImageIndex      =   20
         EndProperty
      EndProperty
   End
   Begin VB.CommandButton CmdBtn 
      Caption         =   "Scroll SetFocus"
      Height          =   555
      Left            =   8940
      TabIndex        =   0
      Top             =   480
      Width           =   975
   End
   Begin VB.PictureBox PicToolSize 
      BorderStyle     =   0  'None
      Height          =   2895
      Left            =   2460
      MousePointer    =   9  'Size W E
      ScaleHeight     =   2895
      ScaleWidth      =   45
      TabIndex        =   31
      Top             =   420
      Width           =   45
   End
   Begin VB.PictureBox PicToolbox 
      Height          =   6195
      Left            =   0
      ScaleHeight     =   409
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   153
      TabIndex        =   8
      Top             =   420
      Width           =   2355
      Begin ComctlLib.Toolbar Toolbox 
         Height          =   390
         Left            =   0
         TabIndex        =   30
         Top             =   0
         Width           =   2295
         _ExtentX        =   4048
         _ExtentY        =   688
         ButtonWidth     =   635
         ButtonHeight    =   582
         AllowCustomize  =   0   'False
         ImageList       =   "ImgToolbox"
         _Version        =   327682
         BeginProperty Buttons {0713E452-850A-101B-AFC0-4210102A8DA7} 
            NumButtons      =   6
            BeginProperty Button1 {0713F354-850A-101B-AFC0-4210102A8DA7} 
               Object.Visible         =   0   'False
               Caption         =   ""
               Key             =   ""
               Description     =   ""
               Object.ToolTipText     =   ""
               Object.Tag             =   ""
               Style           =   3
               MixedState      =   -1  'True
            EndProperty
            BeginProperty Button2 {0713F354-850A-101B-AFC0-4210102A8DA7} 
               Key             =   "Sections"
               Object.ToolTipText     =   "Sections"
               Object.Tag             =   ""
               ImageIndex      =   1
               Style           =   2
               Value           =   1
            EndProperty
            BeginProperty Button3 {0713F354-850A-101B-AFC0-4210102A8DA7} 
               Key             =   "Features"
               Object.ToolTipText     =   "Features"
               Object.Tag             =   ""
               ImageIndex      =   2
               Style           =   2
            EndProperty
            BeginProperty Button4 {0713F354-850A-101B-AFC0-4210102A8DA7} 
               Key             =   "Height"
               Object.ToolTipText     =   "Height Editing"
               Object.Tag             =   ""
               ImageIndex      =   3
               Style           =   2
            EndProperty
            BeginProperty Button5 {0713F354-850A-101B-AFC0-4210102A8DA7} 
               Key             =   "Special"
               Object.ToolTipText     =   "Starting Positions"
               Object.Tag             =   ""
               ImageIndex      =   4
               Style           =   2
            EndProperty
            BeginProperty Button6 {0713F354-850A-101B-AFC0-4210102A8DA7} 
               Key             =   "Tiles"
               Object.ToolTipText     =   "Tiles"
               Object.Tag             =   ""
               ImageIndex      =   5
               Style           =   2
            EndProperty
         EndProperty
      End
      Begin VB.PictureBox PicTemp 
         AutoRedraw      =   -1  'True
         BackColor       =   &H00FFFFFF&
         Height          =   375
         Left            =   0
         ScaleHeight     =   21
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   313
         TabIndex        =   45
         Top             =   5760
         Visible         =   0   'False
         Width           =   4755
      End
      Begin VB.PictureBox PicFeaturePalette 
         AutoRedraw      =   -1  'True
         BorderStyle     =   0  'None
         Height          =   3285
         Left            =   2400
         ScaleHeight     =   219
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   153
         TabIndex        =   25
         Top             =   0
         Visible         =   0   'False
         Width           =   2295
         Begin VB.PictureBox FrameFeatureOptions 
            BorderStyle     =   0  'None
            Height          =   975
            Left            =   -60
            ScaleHeight     =   65
            ScaleMode       =   3  'Pixel
            ScaleWidth      =   161
            TabIndex        =   37
            Top             =   1920
            Visible         =   0   'False
            Width           =   2415
            Begin VB.Frame Frame2 
               Caption         =   "Radius"
               Height          =   675
               Left            =   1200
               TabIndex        =   41
               Top             =   180
               Width           =   975
               Begin VB.TextBox TxtRadius 
                  Height          =   315
                  Left            =   120
                  TabIndex        =   42
                  Text            =   "2"
                  Top             =   240
                  Width           =   435
               End
               Begin ComCtl2.UpDown ScrollRadius 
                  Height          =   315
                  Left            =   600
                  TabIndex        =   43
                  Top             =   240
                  Width           =   240
                  _ExtentX        =   423
                  _ExtentY        =   556
                  _Version        =   327681
                  Value           =   2
                  Enabled         =   -1  'True
               End
            End
            Begin VB.Frame Frame1 
               Caption         =   "Density"
               Height          =   675
               Left            =   120
               TabIndex        =   38
               Top             =   180
               Width           =   975
               Begin VB.TextBox TxtDensity 
                  Height          =   315
                  Left            =   120
                  TabIndex        =   39
                  Text            =   "5"
                  Top             =   240
                  Width           =   435
               End
               Begin ComCtl2.UpDown ScrollDensity 
                  Height          =   315
                  Left            =   600
                  TabIndex        =   40
                  Top             =   240
                  Width           =   240
                  _ExtentX        =   423
                  _ExtentY        =   556
                  _Version        =   327681
                  Value           =   5
                  Min             =   1
                  Enabled         =   -1  'True
               End
            End
            Begin VB.Line FeatureLine2 
               BorderColor     =   &H80000014&
               X1              =   0
               X2              =   156
               Y1              =   5
               Y2              =   5
            End
            Begin VB.Line FeatureLine1 
               BorderColor     =   &H80000010&
               X1              =   0
               X2              =   156
               Y1              =   4
               Y2              =   4
            End
         End
         Begin VB.PictureBox PicFeatures 
            AutoRedraw      =   -1  'True
            BackColor       =   &H00FFFFFF&
            Height          =   1455
            Left            =   60
            ScaleHeight     =   93
            ScaleMode       =   3  'Pixel
            ScaleWidth      =   141
            TabIndex        =   26
            Top             =   360
            Width           =   2175
            Begin VB.VScrollBar ScrollFeatures 
               Height          =   1035
               Left            =   1860
               TabIndex        =   27
               Top             =   360
               Visible         =   0   'False
               Width           =   255
            End
            Begin ComctlLib.TabStrip TabFeatureCategory 
               Height          =   345
               Left            =   0
               TabIndex        =   28
               Top             =   0
               Width           =   2115
               _ExtentX        =   3731
               _ExtentY        =   609
               Style           =   1
               _Version        =   327682
               BeginProperty Tabs {0713E432-850A-101B-AFC0-4210102A8DA7} 
                  NumTabs         =   1
                  BeginProperty Tab1 {0713F341-850A-101B-AFC0-4210102A8DA7} 
                     Key             =   ""
                     Object.Tag             =   ""
                     ImageVarType    =   2
                  EndProperty
               EndProperty
               BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
                  Name            =   "MS Sans Serif"
                  Size            =   8.25
                  Charset         =   0
                  Weight          =   400
                  Underline       =   0   'False
                  Italic          =   0   'False
                  Strikethrough   =   0   'False
               EndProperty
            End
         End
         Begin ComctlLib.TabStrip TabFeatureWorld 
            Height          =   1875
            Left            =   0
            TabIndex        =   29
            Top             =   0
            Width           =   2295
            _ExtentX        =   4048
            _ExtentY        =   3307
            _Version        =   327682
            BeginProperty Tabs {0713E432-850A-101B-AFC0-4210102A8DA7} 
               NumTabs         =   1
               BeginProperty Tab1 {0713F341-850A-101B-AFC0-4210102A8DA7} 
                  Caption         =   "Features"
                  Key             =   ""
                  Object.Tag             =   "0"
                  ImageVarType    =   2
               EndProperty
            EndProperty
            BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
               Name            =   "MS Sans Serif"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
         End
      End
      Begin VB.PictureBox PicSpecial 
         AutoRedraw      =   -1  'True
         BackColor       =   &H00FFFFFF&
         BorderStyle     =   0  'None
         Height          =   3795
         Left            =   6960
         ScaleHeight     =   253
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   85
         TabIndex        =   24
         Top             =   0
         Visible         =   0   'False
         Width           =   1275
         Begin VB.VScrollBar ScrollSpecial 
            Height          =   3795
            Left            =   1020
            Max             =   9
            TabIndex        =   36
            Top             =   0
            Width           =   255
         End
      End
      Begin VB.PictureBox PicTilePalette 
         AutoRedraw      =   -1  'True
         BorderStyle     =   0  'None
         Height          =   855
         Left            =   8340
         ScaleHeight     =   57
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   69
         TabIndex        =   22
         Top             =   0
         Visible         =   0   'False
         Width           =   1035
         Begin VB.VScrollBar ScrollTiles 
            Height          =   855
            Left            =   780
            TabIndex        =   23
            Top             =   0
            Visible         =   0   'False
            Width           =   255
         End
      End
      Begin VB.PictureBox PicHeightPalette 
         BorderStyle     =   0  'None
         Height          =   4215
         Left            =   4800
         ScaleHeight     =   281
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   133
         TabIndex        =   13
         Top             =   0
         Visible         =   0   'False
         Width           =   1995
         Begin VB.PictureBox PicHeightEditing 
            Height          =   3615
            Left            =   60
            ScaleHeight     =   3555
            ScaleWidth      =   1815
            TabIndex        =   14
            Top             =   360
            Width           =   1875
            Begin ComCtl2.UpDown ScrollHeightCursorSize 
               Height          =   315
               Left            =   1500
               TabIndex        =   51
               Top             =   300
               Width           =   240
               _ExtentX        =   423
               _ExtentY        =   556
               _Version        =   327681
               Value           =   1
               Max             =   16
               Min             =   1
               Enabled         =   -1  'True
            End
            Begin VB.TextBox TxtHeightCursorSize 
               Height          =   315
               Left            =   960
               Locked          =   -1  'True
               TabIndex        =   50
               Text            =   "1"
               Top             =   300
               Width           =   495
            End
            Begin VB.CheckBox ChkVoid 
               Caption         =   "&Void Height"
               Height          =   255
               Left            =   60
               TabIndex        =   44
               Top             =   2820
               Width           =   1155
            End
            Begin VB.OptionButton optSolid 
               Caption         =   "Solid"
               Height          =   255
               Left            =   60
               TabIndex        =   33
               Top             =   2400
               Value           =   -1  'True
               Width           =   675
            End
            Begin VB.OptionButton optOffset 
               Caption         =   "Offset"
               Height          =   255
               Left            =   780
               TabIndex        =   32
               Top             =   2400
               Width           =   855
            End
            Begin VB.TextBox TxtInterval 
               Height          =   315
               Left            =   60
               TabIndex        =   16
               Text            =   "4"
               Top             =   300
               Width           =   495
            End
            Begin VB.PictureBox PicSeaLevel 
               AutoRedraw      =   -1  'True
               Height          =   195
               Left            =   60
               ScaleHeight     =   9
               ScaleMode       =   3  'Pixel
               ScaleWidth      =   105
               TabIndex        =   15
               Top             =   1380
               Width           =   1635
            End
            Begin ComCtl2.UpDown ScrollInterval 
               Height          =   315
               Left            =   600
               TabIndex        =   17
               Top             =   300
               Width           =   240
               _ExtentX        =   423
               _ExtentY        =   556
               _Version        =   327681
               Value           =   4
               Max             =   255
               Enabled         =   -1  'True
            End
            Begin ComctlLib.Slider SliderSeaLevel 
               Height          =   255
               Left            =   0
               TabIndex        =   18
               Top             =   1080
               Width           =   1755
               _ExtentX        =   3096
               _ExtentY        =   450
               _Version        =   327682
               Max             =   255
               TickStyle       =   3
            End
            Begin ComctlLib.Slider ScrollHeight 
               Height          =   255
               Left            =   0
               TabIndex        =   34
               Top             =   2100
               Width           =   1755
               _ExtentX        =   3096
               _ExtentY        =   450
               _Version        =   327682
               Max             =   255
               TickStyle       =   3
               TickFrequency   =   0
            End
            Begin VB.Label Label3 
               Caption         =   "Cursor size"
               Height          =   255
               Left            =   960
               TabIndex        =   49
               Top             =   60
               Width           =   975
            End
            Begin VB.Label LblHeight 
               BorderStyle     =   1  'Fixed Single
               Caption         =   "0"
               Height          =   255
               Left            =   1020
               TabIndex        =   48
               Top             =   1800
               Width           =   435
            End
            Begin VB.Line HeightLine4 
               BorderColor     =   &H80000014&
               X1              =   0
               X2              =   1800
               Y1              =   2715
               Y2              =   2715
            End
            Begin VB.Line HeightLine3 
               BorderColor     =   &H80000010&
               X1              =   0
               X2              =   1800
               Y1              =   2700
               Y2              =   2700
            End
            Begin VB.Label Label1 
               Caption         =   "Area editing"
               Height          =   195
               Left            =   60
               TabIndex        =   35
               Top             =   1800
               Width           =   915
            End
            Begin VB.Line HeightLine5 
               BorderColor     =   &H80000010&
               X1              =   0
               X2              =   1800
               Y1              =   1680
               Y2              =   1680
            End
            Begin VB.Line HeightLine6 
               BorderColor     =   &H80000014&
               X1              =   0
               X2              =   1800
               Y1              =   1695
               Y2              =   1695
            End
            Begin VB.Line HeightLine1 
               BorderColor     =   &H80000010&
               X1              =   0
               X2              =   1800
               Y1              =   720
               Y2              =   720
            End
            Begin VB.Line HeightLine2 
               BorderColor     =   &H80000014&
               X1              =   0
               X2              =   1800
               Y1              =   735
               Y2              =   735
            End
            Begin VB.Label LblHeightInterval 
               Caption         =   "Interval"
               Height          =   195
               Left            =   60
               TabIndex        =   20
               Top             =   60
               Width           =   615
            End
            Begin VB.Label Label2 
               Caption         =   "Sea level"
               Height          =   195
               Left            =   60
               TabIndex        =   19
               Top             =   840
               Width           =   1335
            End
         End
         Begin ComctlLib.TabStrip TabHeight 
            Height          =   4035
            Left            =   0
            TabIndex        =   21
            Top             =   0
            Width           =   1995
            _ExtentX        =   3519
            _ExtentY        =   7117
            _Version        =   327682
            BeginProperty Tabs {0713E432-850A-101B-AFC0-4210102A8DA7} 
               NumTabs         =   1
               BeginProperty Tab1 {0713F341-850A-101B-AFC0-4210102A8DA7} 
                  Caption         =   "Height Editing"
                  Key             =   ""
                  Object.Tag             =   ""
                  ImageVarType    =   2
               EndProperty
            EndProperty
         End
      End
      Begin VB.PictureBox PicSectionPalette 
         BorderStyle     =   0  'None
         Height          =   2115
         Left            =   0
         ScaleHeight     =   141
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   149
         TabIndex        =   9
         Top             =   540
         Width           =   2235
         Begin VB.PictureBox PicSections 
            AutoRedraw      =   -1  'True
            BackColor       =   &H00FFFFFF&
            Height          =   1455
            Left            =   60
            ScaleHeight     =   93
            ScaleMode       =   3  'Pixel
            ScaleWidth      =   137
            TabIndex        =   10
            Top             =   360
            Width           =   2115
            Begin VB.VScrollBar ScrollSections 
               Height          =   1035
               Left            =   1800
               TabIndex        =   47
               Top             =   360
               Width           =   255
            End
            Begin VB.PictureBox PicSectionsTemp 
               AutoRedraw      =   -1  'True
               BackColor       =   &H00FFFFFF&
               Height          =   315
               Left            =   0
               ScaleHeight     =   17
               ScaleMode       =   3  'Pixel
               ScaleWidth      =   309
               TabIndex        =   46
               Top             =   1080
               Visible         =   0   'False
               Width           =   4695
            End
            Begin ComctlLib.TabStrip TabSectionCategory 
               Height          =   345
               Left            =   0
               TabIndex        =   11
               Top             =   0
               Width           =   2055
               _ExtentX        =   3625
               _ExtentY        =   609
               Style           =   1
               _Version        =   327682
               BeginProperty Tabs {0713E432-850A-101B-AFC0-4210102A8DA7} 
                  NumTabs         =   1
                  BeginProperty Tab1 {0713F341-850A-101B-AFC0-4210102A8DA7} 
                     Caption         =   ""
                     Key             =   ""
                     Object.Tag             =   ""
                     ImageVarType    =   2
                  EndProperty
               EndProperty
               BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
                  Name            =   "MS Sans Serif"
                  Size            =   8.25
                  Charset         =   0
                  Weight          =   400
                  Underline       =   0   'False
                  Italic          =   0   'False
                  Strikethrough   =   0   'False
               EndProperty
            End
         End
         Begin ComctlLib.TabStrip TabSectionWorld 
            Height          =   1875
            Left            =   0
            TabIndex        =   12
            Top             =   0
            Width           =   2235
            _ExtentX        =   3942
            _ExtentY        =   3307
            _Version        =   327682
            BeginProperty Tabs {0713E432-850A-101B-AFC0-4210102A8DA7} 
               NumTabs         =   1
               BeginProperty Tab1 {0713F341-850A-101B-AFC0-4210102A8DA7} 
                  Caption         =   "Sections"
                  Key             =   ""
                  Object.Tag             =   "0"
                  ImageVarType    =   2
               EndProperty
            EndProperty
            BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
               Name            =   "MS Sans Serif"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
         End
      End
      Begin VB.Line ToolboxLine2 
         BorderColor     =   &H80000014&
         X1              =   0
         X2              =   156
         Y1              =   29
         Y2              =   29
      End
      Begin VB.Line ToolboxLine1 
         BorderColor     =   &H80000010&
         X1              =   0
         X2              =   156
         Y1              =   28
         Y2              =   28
      End
   End
   Begin VB.PictureBox Canvas 
      AutoRedraw      =   -1  'True
      Height          =   5895
      Left            =   2580
      MouseIcon       =   "FrmAnnihilator.frx":0442
      ScaleHeight     =   389
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   369
      TabIndex        =   3
      Top             =   720
      Width           =   5595
      Begin VB.Timer AutoScroll 
         Enabled         =   0   'False
         Interval        =   100
         Left            =   1680
         Top             =   60
      End
      Begin VB.PictureBox PicScroll 
         BorderStyle     =   0  'None
         Height          =   255
         Left            =   5280
         ScaleHeight     =   255
         ScaleWidth      =   255
         TabIndex        =   6
         Top             =   5580
         Width           =   255
      End
      Begin VB.VScrollBar CanvasVScroll 
         Height          =   5595
         Left            =   5280
         MousePointer    =   1  'Arrow
         TabIndex        =   5
         Top             =   0
         Visible         =   0   'False
         Width           =   255
      End
      Begin VB.HScrollBar CanvasHScroll 
         Height          =   255
         Left            =   0
         MousePointer    =   1  'Arrow
         TabIndex        =   4
         Top             =   5580
         Visible         =   0   'False
         Width           =   5295
      End
      Begin VB.Shape Selected 
         BorderColor     =   &H00FFFFFF&
         BorderStyle     =   3  'Dot
         DrawMode        =   7  'Invert
         Height          =   480
         Left            =   1140
         Top             =   60
         Visible         =   0   'False
         Width           =   480
      End
      Begin VB.Shape CanvasCursor 
         BorderColor     =   &H00FFFFFF&
         DrawMode        =   7  'Invert
         Height          =   480
         Left            =   60
         Top             =   60
         Visible         =   0   'False
         Width           =   480
      End
      Begin VB.Shape Rubber 
         BorderColor     =   &H00FFFFFF&
         DrawMode        =   7  'Invert
         Height          =   480
         Left            =   600
         Top             =   60
         Visible         =   0   'False
         Width           =   480
      End
   End
   Begin MSComDlg.CommonDialog CommonDialog 
      Left            =   8280
      Top             =   3300
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   327681
      CancelError     =   -1  'True
   End
   Begin ComctlLib.StatusBar Status 
      Align           =   2  'Align Bottom
      Height          =   315
      Left            =   0
      TabIndex        =   1
      Top             =   7350
      Width           =   10065
      _ExtentX        =   17754
      _ExtentY        =   556
      SimpleText      =   ""
      _Version        =   327682
      BeginProperty Panels {0713E89E-850A-101B-AFC0-4210102A8DA7} 
         NumPanels       =   8
         BeginProperty Panel1 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            Object.Width           =   3528
            MinWidth        =   3528
            Text            =   "Ready"
            TextSave        =   "Ready"
            Key             =   ""
            Object.Tag             =   ""
         EndProperty
         BeginProperty Panel2 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            Alignment       =   2
            AutoSize        =   2
            Object.Width           =   2011
            MinWidth        =   176
            Text            =   " x: #, y: #, h: #"
            TextSave        =   " x: #, y: #, h: #"
            Key             =   ""
            Object.Tag             =   ""
         EndProperty
         BeginProperty Panel3 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            Alignment       =   2
            AutoSize        =   2
            Object.Width           =   1508
            MinWidth        =   176
            Text            =   " (512, 512)"
            TextSave        =   " (512, 512)"
            Key             =   ""
            Object.Tag             =   ""
         EndProperty
         BeginProperty Panel4 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            Alignment       =   1
            AutoSize        =   2
            Object.Width           =   794
            MinWidth        =   176
            Text            =   "none"
            TextSave        =   "none"
            Key             =   ""
            Object.Tag             =   ""
         EndProperty
         BeginProperty Panel5 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            AutoSize        =   1
            Object.Width           =   4101
            MinWidth        =   2646
            TextSave        =   ""
            Key             =   ""
            Object.Tag             =   ""
         EndProperty
         BeginProperty Panel6 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            Alignment       =   2
            AutoSize        =   2
            Object.Width           =   1164
            MinWidth        =   176
            Text            =   " 10 x 10"
            TextSave        =   " 10 x 10"
            Key             =   ""
            Object.Tag             =   ""
         EndProperty
         BeginProperty Panel7 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            Alignment       =   2
            AutoSize        =   2
            Object.Width           =   2249
            MinWidth        =   176
            Text            =   " Textures: 6.1mb"
            TextSave        =   " Textures: 6.1mb"
            Key             =   ""
            Object.Tag             =   ""
         EndProperty
         BeginProperty Panel8 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            Alignment       =   2
            AutoSize        =   2
            Object.Width           =   1720
            MinWidth        =   176
            Text            =   " Map: 6.5mb"
            TextSave        =   " Map: 6.5mb"
            Key             =   ""
            Object.Tag             =   ""
         EndProperty
      EndProperty
   End
   Begin ComctlLib.TabStrip TabMaps 
      Height          =   6195
      Left            =   2580
      TabIndex        =   7
      Top             =   420
      Width           =   5595
      _ExtentX        =   9869
      _ExtentY        =   10927
      _Version        =   327682
      BeginProperty Tabs {0713E432-850A-101B-AFC0-4210102A8DA7} 
         NumTabs         =   1
         BeginProperty Tab1 {0713F341-850A-101B-AFC0-4210102A8DA7} 
            Caption         =   ""
            Key             =   ""
            Object.Tag             =   ""
            ImageVarType    =   2
         EndProperty
      EndProperty
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin ComctlLib.ImageList ImgToolbox 
      Left            =   8280
      Top             =   1140
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   65280
      _Version        =   327682
      BeginProperty Images {0713E8C2-850A-101B-AFC0-4210102A8DA7} 
         NumListImages   =   5
         BeginProperty ListImage1 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":074C
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":085E
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":0970
            Key             =   ""
         EndProperty
         BeginProperty ListImage4 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":0A82
            Key             =   ""
         EndProperty
         BeginProperty ListImage5 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":0B94
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin ComctlLib.ImageList ImgPlayers 
      Left            =   8280
      Top             =   1800
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   10
      ImageHeight     =   10
      MaskColor       =   12632256
      _Version        =   327682
      BeginProperty Images {0713E8C2-850A-101B-AFC0-4210102A8DA7} 
         NumListImages   =   10
         BeginProperty ListImage1 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":0CA6
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":11F8
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":174A
            Key             =   ""
         EndProperty
         BeginProperty ListImage4 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":1C9C
            Key             =   ""
         EndProperty
         BeginProperty ListImage5 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":21EE
            Key             =   ""
         EndProperty
         BeginProperty ListImage6 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":2740
            Key             =   ""
         EndProperty
         BeginProperty ListImage7 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":2C92
            Key             =   ""
         EndProperty
         BeginProperty ListImage8 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":31E4
            Key             =   ""
         EndProperty
         BeginProperty ListImage9 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":3736
            Key             =   ""
         EndProperty
         BeginProperty ListImage10 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":3C88
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin ComctlLib.ImageList ImgToolbar 
      Left            =   8280
      Top             =   480
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   65280
      _Version        =   327682
      BeginProperty Images {0713E8C2-850A-101B-AFC0-4210102A8DA7} 
         NumListImages   =   20
         BeginProperty ListImage1 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":41DA
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":42EC
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":43FE
            Key             =   ""
         EndProperty
         BeginProperty ListImage4 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":4510
            Key             =   ""
         EndProperty
         BeginProperty ListImage5 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":4622
            Key             =   ""
         EndProperty
         BeginProperty ListImage6 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":4734
            Key             =   ""
         EndProperty
         BeginProperty ListImage7 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":4846
            Key             =   ""
         EndProperty
         BeginProperty ListImage8 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":4958
            Key             =   ""
         EndProperty
         BeginProperty ListImage9 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":4A6A
            Key             =   ""
         EndProperty
         BeginProperty ListImage10 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":4FBC
            Key             =   ""
         EndProperty
         BeginProperty ListImage11 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":50CE
            Key             =   ""
         EndProperty
         BeginProperty ListImage12 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":51E0
            Key             =   ""
         EndProperty
         BeginProperty ListImage13 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":52F2
            Key             =   ""
         EndProperty
         BeginProperty ListImage14 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":5404
            Key             =   ""
         EndProperty
         BeginProperty ListImage15 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":5516
            Key             =   ""
         EndProperty
         BeginProperty ListImage16 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":5628
            Key             =   ""
         EndProperty
         BeginProperty ListImage17 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":573A
            Key             =   ""
         EndProperty
         BeginProperty ListImage18 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":584C
            Key             =   ""
         EndProperty
         BeginProperty ListImage19 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":595E
            Key             =   ""
         EndProperty
         BeginProperty ListImage20 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "FrmAnnihilator.frx":5A70
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin VB.Menu mnuFile 
      Caption         =   "&File"
      Begin VB.Menu mnuFileNew 
         Caption         =   "&New Map..."
         Shortcut        =   ^N
      End
      Begin VB.Menu mnuFileOpen 
         Caption         =   "&Open Map..."
         Shortcut        =   ^O
      End
      Begin VB.Menu mnuFileBreak1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileSave 
         Caption         =   "&Save Map"
         Shortcut        =   ^S
      End
      Begin VB.Menu mnuFileSaveAs 
         Caption         =   "Save Map &As..."
      End
      Begin VB.Menu mnuFileExportMap 
         Caption         =   "&Export Map..."
      End
      Begin VB.Menu mnuFileBreak2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileClose 
         Caption         =   "&Close"
         Shortcut        =   {F5}
      End
      Begin VB.Menu mnuFileCloseAll 
         Caption         =   "Clos&e All"
         Shortcut        =   ^{F5}
      End
      Begin VB.Menu mnuFileBreak3 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileExit 
         Caption         =   "E&xit"
      End
   End
   Begin VB.Menu mnuEdit 
      Caption         =   "&Edit"
      Begin VB.Menu mnuEditCut 
         Caption         =   "C&ut"
         Shortcut        =   ^X
      End
      Begin VB.Menu mnuEditCopy 
         Caption         =   "&Copy"
         Shortcut        =   ^C
      End
      Begin VB.Menu mnuEditPaste 
         Caption         =   "&Paste"
         Shortcut        =   ^V
      End
      Begin VB.Menu mnuEditClear 
         Caption         =   "C&lear"
         Shortcut        =   {DEL}
      End
      Begin VB.Menu mnuEditDeselect 
         Caption         =   "&Deselect"
         Shortcut        =   ^D
      End
      Begin VB.Menu mnuEditSelectAll 
         Caption         =   "Select &All"
         Shortcut        =   ^A
      End
      Begin VB.Menu mnuEditBreak1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuEditFillMap 
         Caption         =   "&Fill Map"
         Shortcut        =   ^F
      End
      Begin VB.Menu mnuEditCopyRegion 
         Caption         =   "Copy &to Palette"
         Shortcut        =   ^P
      End
   End
   Begin VB.Menu mnuView 
      Caption         =   "&View"
      Begin VB.Menu mnuViewStatusBar 
         Caption         =   "&Status Bar"
         Checked         =   -1  'True
      End
      Begin VB.Menu mnuViewToolbox 
         Caption         =   "Tool&box"
         Checked         =   -1  'True
         Shortcut        =   ^T
      End
      Begin VB.Menu mnuViewMinimap 
         Caption         =   "&Minimap"
         Checked         =   -1  'True
         Shortcut        =   ^M
      End
      Begin VB.Menu mnuViewBreak2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuViewMinimapSize 
         Caption         =   "M&inimap Size"
         Begin VB.Menu mnuViewMiniMapSizeSmall 
            Caption         =   "&Small"
         End
         Begin VB.Menu mnuViewMiniMapSizeMedium 
            Caption         =   "&Medium"
            Checked         =   -1  'True
         End
         Begin VB.Menu mnuViewMiniMapSizeLarge 
            Caption         =   "&Large"
         End
         Begin VB.Menu mnuViewMinimapSizeHuge 
            Caption         =   "&Huge"
         End
      End
      Begin VB.Menu mnuViewMinimapFilters 
         Caption         =   "Minimap &Filters"
         Visible         =   0   'False
         Begin VB.Menu mnuViewMinimapFiltersStarting 
            Caption         =   "&Starting Positions"
         End
         Begin VB.Menu mnuViewMinimapFiltersFeatures 
            Caption         =   "Selected &Features"
         End
      End
      Begin VB.Menu mnuViewGridSize 
         Caption         =   "&Grid Size"
         Begin VB.Menu mnuViewGrid 
            Caption         =   "32 x 32"
            Checked         =   -1  'True
            Index           =   0
         End
         Begin VB.Menu mnuViewGrid 
            Caption         =   "64 x 64"
            Index           =   1
         End
         Begin VB.Menu mnuViewGrid 
            Caption         =   "128 x 128"
            Index           =   2
         End
         Begin VB.Menu mnuViewGrid 
            Caption         =   "256 x 256"
            Index           =   3
         End
         Begin VB.Menu mnuViewGrid 
            Caption         =   "512 x 512"
            Index           =   4
         End
         Begin VB.Menu mnuViewGridBreak1 
            Caption         =   "-"
         End
         Begin VB.Menu mnuViewGridCustom 
            Caption         =   "Custom..."
         End
      End
      Begin VB.Menu mnuViewBreak1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuViewOptions 
         Caption         =   "Annihilator &Options..."
      End
   End
   Begin VB.Menu mnuMap 
      Caption         =   "&Map"
      Begin VB.Menu mnuViewRedrawMiniMap 
         Caption         =   "Refresh &Draft Minimap"
         Shortcut        =   {F2}
      End
      Begin VB.Menu mnuSpecialCreateHighQualityMini 
         Caption         =   "Refresh &Final Minimap"
         Shortcut        =   ^{F2}
      End
      Begin VB.Menu mnuSpecialImportMinimap 
         Caption         =   "&Import Minimap..."
      End
      Begin VB.Menu mnuSpecialExportMinimap 
         Caption         =   "&Export Minimap..."
      End
      Begin VB.Menu mnuSpecialBreak1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuSpecialImportHeightMap 
         Caption         =   "Im&port Heightmap..."
      End
      Begin VB.Menu mnuMapExportHeightMap 
         Caption         =   "E&xport Heightmap..."
      End
      Begin VB.Menu mnuMapBreak2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuSpecialSaveMapBitmap 
         Caption         =   "Export Map as &BMP..."
      End
      Begin VB.Menu mnuMapBreak10 
         Caption         =   "-"
      End
      Begin VB.Menu mnuMapResize 
         Caption         =   "&Resize Map..."
      End
      Begin VB.Menu mnuMapCompress 
         Caption         =   "&Compress Map"
      End
      Begin VB.Menu mnuMapBreak1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuMapSchemas 
         Caption         =   "Schemas"
         Visible         =   0   'False
         Begin VB.Menu mnuMapSchemasEasy 
            Caption         =   "&Easy"
         End
         Begin VB.Menu mnuMapSchemasMedium 
            Caption         =   "&Medium"
         End
         Begin VB.Menu mnuMapSchemasHard 
            Caption         =   "&Hard"
         End
         Begin VB.Menu mnuMapSchemasMultiplayer 
            Caption         =   "Multi&player"
            Checked         =   -1  'True
         End
      End
      Begin VB.Menu mnuMapSettings 
         Caption         =   "Map &Settings..."
      End
   End
   Begin VB.Menu mnuSections 
      Caption         =   "&Sections"
      Begin VB.Menu mnuSectionsImportBMP 
         Caption         =   "&Import BMP..."
      End
      Begin VB.Menu mnuSectionsExportBMP 
         Caption         =   "&Export BMP..."
      End
      Begin VB.Menu mnuSectionsExport 
         Caption         =   "&Save Section..."
         Visible         =   0   'False
      End
      Begin VB.Menu mnuSectionsBreak1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuSectionsSetHeightOffset 
         Caption         =   "Set &Height Offset..."
      End
      Begin VB.Menu mnuSectionsBreak2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuSectionsEdit 
         Caption         =   "E&dit Section Groups..."
      End
      Begin VB.Menu mnuSectionsBreak3 
         Caption         =   "-"
      End
      Begin VB.Menu mnuSectionsImportTileset 
         Caption         =   "I&mport HPI Tileset..."
      End
      Begin VB.Menu mnuSectionsExportGroup 
         Caption         =   "E&xport HPI Tileset..."
      End
   End
   Begin VB.Menu mnuFeatures 
      Caption         =   "&Features"
      Begin VB.Menu mnuFeaturesDensity 
         Caption         =   "Feature Density"
         Begin VB.Menu mnuFeatureDensity 
            Caption         =   "10%"
            Index           =   1
         End
         Begin VB.Menu mnuFeatureDensity 
            Caption         =   "20%"
            Index           =   2
         End
         Begin VB.Menu mnuFeatureDensity 
            Caption         =   "30%"
            Index           =   3
         End
         Begin VB.Menu mnuFeatureDensity 
            Caption         =   "40%"
            Index           =   4
         End
         Begin VB.Menu mnuFeatureDensity 
            Caption         =   "50%"
            Checked         =   -1  'True
            Index           =   5
         End
         Begin VB.Menu mnuFeatureDensity 
            Caption         =   "60%"
            Index           =   6
         End
         Begin VB.Menu mnuFeatureDensity 
            Caption         =   "70%"
            Index           =   7
         End
         Begin VB.Menu mnuFeatureDensity 
            Caption         =   "80%"
            Index           =   8
         End
         Begin VB.Menu mnuFeatureDensity 
            Caption         =   "90%"
            Index           =   9
         End
         Begin VB.Menu mnuFeatureDensity 
            Caption         =   "100%"
            Index           =   10
         End
      End
      Begin VB.Menu mnuFeaturesCustomFill 
         Caption         =   "Fill &Options..."
      End
      Begin VB.Menu mnuFeaturesFill 
         Caption         =   "&Fill Selection"
      End
      Begin VB.Menu mnuFeaturesBreak1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFeaturesClearRegion 
         Caption         =   "&Clear Selection"
      End
      Begin VB.Menu mnuFeaturesRemove 
         Caption         =   "Clear &All"
      End
      Begin VB.Menu mnuFeaturesBreak2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFeaturesLoad 
         Caption         =   "&Load Features..."
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "&Help"
      Begin VB.Menu mnuOnlineTADD 
         Caption         =   "&TADD: TA Design Division"
      End
      Begin VB.Menu mnuOnlineAnnihilated 
         Caption         =   "A&nnihilated.com"
      End
      Begin VB.Menu mnuOnlineAnnihilation 
         Caption         =   "Annihilation C&enter"
      End
      Begin VB.Menu mnuOnlineCavedog 
         Caption         =   "&Cavedog Entertainment - Total Annihilation"
      End
      Begin VB.Menu mnuOnlineTAMEC 
         Caption         =   "TAMEC &Maps"
      End
      Begin VB.Menu mnuOnlineBreak2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileReportBug 
         Caption         =   "Report Annihilator &Bug..."
         Visible         =   0   'False
      End
      Begin VB.Menu mnuHelpAbout 
         Caption         =   "&About Annihilator Map Editor..."
      End
   End
End
Attribute VB_Name = "FrmAnnihilator"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public Flag As Integer

Private AutoScrollX As Long, AutoScrollY As Long
Public QuickLoad As Boolean
Private LoadFile As String

Private Sub CleanUp()
    Set SelectedSection = Nothing
    'ReDim Maps(0)
    'ReDim Features(0)
    'ReDim Sections(0)
    'ReDim HPI(0)
    FastWinFree
End Sub

Private Sub AutoScroll_Timer()
    Dim ScrollX As Long, ScrollY As Long
    
    On Error GoTo Error
    If Not MapLoaded Then Exit Sub
    If AutoScrollX < 16 Then ScrollX = -1
    If AutoScrollX > Canvas.ScaleWidth - 32 Then ScrollX = 2
    If AutoScrollY < 16 Then ScrollY = -1
    If AutoScrollY > Canvas.ScaleHeight - 32 Then ScrollY = 2
    
    If ScrollX + CanvasHScroll.Value < 0 Then ScrollX = 0
    If ScrollX + CanvasHScroll.Value > CanvasHScroll.Max Then ScrollX = 0
    If ScrollY + CanvasVScroll.Value < 0 Then ScrollY = 0
    If ScrollY + CanvasVScroll.Value > CanvasVScroll.Max Then ScrollY = 0
    Maps(SelectedMap).ScrollMap CanvasHScroll.Value + ScrollX, CanvasVScroll.Value + ScrollY
    If Rubberband.Dragging Then
        Rubberband.Reposition ScrollX * 32, ScrollY * 32
        Rubberband.Move AutoScrollX, AutoScrollY
    End If
Error:
End Sub

Private Sub CanvasHScroll_GotFocus()
    CmdBtn.SetFocus
End Sub

Private Sub CanvasHScroll_Scroll()
    On Error Resume Next
    If NoScroll Then Exit Sub
    If SelectedMap >= 0 Then
        Maps(SelectedMap).ScrollMap CanvasHScroll.Value, CanvasVScroll.Value
    End If
End Sub

Private Sub CanvasVScroll_GotFocus()
    CmdBtn.SetFocus
End Sub

Private Sub CanvasVScroll_Scroll()
    On Error Resume Next
    If NoScroll Then Exit Sub
    If SelectedMap >= 0 Then
        Maps(SelectedMap).ScrollMap CanvasHScroll.Value, CanvasVScroll.Value
    End If
End Sub

Private Sub ChkVoid_Click()
    HeightVoid = (ChkVoid.Value = vbChecked)
End Sub

Private Sub mnuEditClear_Click()
    On Error Resume Next
    Maps(SelectedMap).OverlayClear
End Sub

Private Sub mnuEditCopy_Click()
    On Error Resume Next
    Maps(SelectedMap).ClipCopy
End Sub

Private Sub mnuEditCopyRegion_Click()
    On Error Resume Next
    Maps(SelectedMap).CopySection
End Sub

Private Sub mnuEditCut_Click()
    On Error Resume Next
    Maps(SelectedMap).ClipCopy
    Maps(SelectedMap).OverlayClear
End Sub

Private Sub mnuEditDeselect_Click()
    On Error Resume Next
    Maps(SelectedMap).OverlayPaste
End Sub

Private Sub mnuEditFillMap_Click()
    Dim Response As Integer
    
    On Error Resume Next
    Response = MsgBox("This action with overwrite the entire map.  Do you want to continue?", vbInformation + vbYesNo, "Fill")
    If Response = vbYes Then
        Maps(SelectedMap).OverlayFill
    End If
End Sub

Private Sub mnuEditPaste_Click()
    On Error Resume Next
    Maps(SelectedMap).ClipPaste
End Sub

Private Sub mnuEditSelectAll_Click()
    On Error Resume Next
    Maps(SelectedMap).OverlaySelectAll
End Sub

Private Sub mnuFeatureDensity_Click(Index As Integer)
    Dim i As Integer
    
    FeatureDensity = Index
    ScrollDensity.Value = Index
    For i = 1 To 10
        If i <> Index Then
            mnuFeatureDensity(i).Checked = False
        Else
            mnuFeatureDensity(i).Checked = True
        End If
    Next
End Sub

Private Sub mnuFeaturesClearRegion_Click()
    On Error Resume Next
    Maps(SelectedMap).FeaturesRemoveRegion
End Sub

Private Sub mnuFeaturesCustomFill_Click()
    FrmFeatureFill.Show 1
End Sub

Private Sub mnuFeaturesFill_Click()
    On Error Resume Next
    Maps(SelectedMap).FeaturesFillOverlay
End Sub

Private Sub mnuFeaturesLoad_Click()
    On Error GoTo Error
    CommonDialog.Filter = "HPI files (*.hpi; *.ccx; *.gpf; *.gp3; *.ufo)|*.hpi; *.ccx; *.gpf; *.gp3; *.ufo"
    CommonDialog.DefaultExt = "hpi"
    CommonDialog.Filename = ""
    CommonDialog.InitDir = TALocation
    CommonDialog.ShowOpen
    If (CommonDialog.Filename <> "") And (Err.Number <> cdlCancel) Then
        NoUpdate = True
        FrmLoadFeatures.HPIFilename = CommonDialog.Filename
        FrmLoadFeatures.Show
    End If
Error:
End Sub

Private Sub mnuFeaturesRemove_Click()
    Dim Response As Integer
    
    On Error Resume Next
    Response = MsgBox("This will clear all the features from your map.  Do you want to continue?", vbQuestion + vbYesNo, "Clear Features")
    If Response = vbYes Then
        Maps(SelectedMap).FeaturesRemoveAll
    End If
End Sub

Private Sub mnuFileClose_Click()
    
    On Error Resume Next
    
    Flag = False
    FrmSaveChanges.MapIndex = SelectedMap
    FrmSaveChanges.Show
    Do While Flag = False
        DoEvents
    Loop
    
    If Flag = True Then
        CloseMap tIndex(TabMaps.SelectedItem.Key)
    End If
    On Error GoTo 0
End Sub

Private Sub mnuFileCloseAll_Click()
    Dim Index As Integer
    
    On Error GoTo Error
    
    Flag = False
    FrmSaveChanges.MapIndex = -1
    FrmSaveChanges.Show
    Do While Flag = False
        DoEvents
    Loop
    
    If Flag = True Then
        Screen.MousePointer = vbHourglass
        For Index = 0 To UBound(Maps)
            CloseMap Index
        Next
    End If
Error:
    Screen.MousePointer = vbNormal
End Sub

Private Sub mnuFileExportMap_Click()
    On Error Resume Next
    If SelectedMap < 0 Then Exit Sub
    CommonDialog.DefaultExt = "tnt"
    CommonDialog.Filter = "TNT map (*.tnt)|*.tnt"
    CommonDialog.Filename = ""
    CommonDialog.InitDir = InitFileSaveDir
    CommonDialog.ShowSave
    If (CommonDialog.Filename <> "") And (Err.Number <> cdlCancel) Then
        Status.Panels(1).Text = "Saving map..."
        Screen.MousePointer = vbHourglass
        EnableControls False
        Maps(SelectedMap).SaveTNT CommonDialog.Filename
        EnableControls True
        Screen.MousePointer = vbNormal
        Status.Panels(1).Text = "Ready"
    End If
    On Error GoTo 0
End Sub

Private Sub mnuFileSaveAs_Click()
    On Error Resume Next
    If SelectedMap < 0 Then Exit Sub
    CommonDialog.DefaultExt = "ufo"
    CommonDialog.Filter = "TA:CC map|*.ufo|TA map|*.ufo"
    CommonDialog.Filename = Maps(SelectedMap).MapFilename
    CommonDialog.InitDir = InitFileSaveDir
    CommonDialog.ShowSave
    If (CommonDialog.Filename <> "") And (Err.Number <> cdlCancel) Then
        InitFileSaveDir = GetDirectory(CommonDialog.Filename)
        Status.Panels(1).Text = "Saving map..."
        EnableControls False
        If CommonDialog.FilterIndex = 1 Then
            SaveMap CommonDialog.Filename
        Else
            SaveMap CommonDialog.Filename, LZ77_COMPRESSION
        End If
        EnableControls True
        Status.Panels(1).Text = "Ready"
    End If
    On Error GoTo 0
End Sub

Private Sub mnuMapCompress_Click()
    On Error GoTo Error
    EnableControls False
    CompressMap
Error:
    EnableControls True
End Sub

Private Sub mnuMapExportHeightMap_Click()
    On Error GoTo Error
    CommonDialog.DefaultExt = "bmp"
    CommonDialog.Filter = "Bitmap files (*.bmp)|*.bmp"
    CommonDialog.Filename = ""
    CommonDialog.ShowSave
    If (CommonDialog.Filename <> "") And (Err.Number <> cdlCancel) Then
        Maps(SelectedMap).HeightMapExport CommonDialog.Filename
    End If
Error:
End Sub

Private Sub mnuOnlineTADD_Click()
    Dim rc As Long
    
    rc = ShellExecute(hwnd, "open", "http://tadd.annihilated.org", vbNullString, vbNullString, SW_NORMAL)
End Sub

Private Sub mnuSectionsEdit_Click()
    FrmSectionGroups.Show 1
End Sub

Public Sub mnuSectionsExport_Click()
    On Error GoTo Error
    If SelectedSection.Name = "" Then Exit Sub
    CommonDialog.DefaultExt = "sct"
    CommonDialog.Filter = "SCT files (*.sct)|*.sct"
    CommonDialog.Filename = ""
    CommonDialog.ShowSave
    If (CommonDialog.Filename <> "") And (Err.Number <> cdlCancel) Then
        Screen.MousePointer = vbHourglass
        SelectedSection.ExportSCT CommonDialog.Filename
    End If
Error:
    Screen.MousePointer = vbNormal
End Sub

Public Sub mnuSectionsExportBMP_Click()
    On Error GoTo Error
    If SelectedSection.Name = "" Then Exit Sub
    CommonDialog.DefaultExt = "bmp"
    CommonDialog.Filter = "Bitmap files (*.bmp)|*.bmp"
    CommonDialog.Filename = ""
    CommonDialog.ShowSave
    If (CommonDialog.Filename <> "") And (Err.Number <> cdlCancel) Then
        Screen.MousePointer = vbHourglass
        SelectedSection.ExportBMP CommonDialog.Filename
    End If
Error:
    Screen.MousePointer = vbNormal
End Sub

Private Sub mnuSectionsExportGroup_Click()
    On Error GoTo Error
    CommonDialog.Filter = "HPI files (*.hpi)|*.hpi"
    CommonDialog.DefaultExt = "hpi"
    CommonDialog.Filename = ""
    CommonDialog.ShowSave
    If (CommonDialog.Filename <> "") And (Err.Number <> cdlCancel) Then
        Screen.MousePointer = vbHourglass
        Sections.ExportHPI CommonDialog.Filename
    End If
Error:
    Screen.MousePointer = vbNormal
End Sub

Private Sub mnuSectionsImportBMP_Click()
    FrmImportBMP.Show 1
End Sub

Private Sub mnuSectionsImportTileset_Click()
    On Error GoTo Error
    CommonDialog.Filter = "HPI files (*.hpi; *.ccx; *.gpf; *.gp3; *.ufo)|*.hpi; *.ccx; *.gpf; *.gp3; *.ufo"
    CommonDialog.DefaultExt = "hpi"
    CommonDialog.Filename = ""
    CommonDialog.ShowOpen
    If (CommonDialog.Filename <> "") And (Err.Number <> cdlCancel) Then
        Screen.MousePointer = vbHourglass
        NoUpdate = True
        HPI.Initialize
        HPI.LoadHPI CommonDialog.Filename
        LoadTASections
        Sections.CreateTabs
    End If
Error:
    Screen.MousePointer = vbNormal
End Sub

Private Sub mnuSectionsSetHeightOffset_Click()
    On Error Resume Next
    HeightOffset = Val(InputBox("Enter a value to offset the height of pasted sections (-255 to 255).", "Section Height Offset", CStr(HeightOffset)))
    If HeightOffset < -255 Then HeightOffset = -255
    If HeightOffset > 255 Then HeightOffset = 255
    If optOffset.Value Then
        ScrollHeight.Value = HeightOffset
        LblHeight = CStr(HeightOffset)
    End If
    RefreshMap
End Sub

Public Sub mnuSpecialCreateHighQualityMini_Click()
    Maps(SelectedMap).MiniMapCreateFinal
End Sub

Public Sub mnuSpecialExportMinimap_Click()
    On Error GoTo Error
    CommonDialog.DefaultExt = "bmp"
    CommonDialog.Filter = "Bitmap files (*.bmp)|*.bmp"
    CommonDialog.Filename = ""
    CommonDialog.ShowSave
    If (CommonDialog.Filename <> "") And (Err.Number <> cdlCancel) Then
        Maps(SelectedMap).MinimapExport CommonDialog.Filename
    End If
Error:
End Sub

Private Sub mnuSpecialImportHeightMap_Click()
    On Error GoTo Error
    CommonDialog.Filter = "Bitmap files (*.bmp)|*.bmp"
    CommonDialog.Filename = ""
    CommonDialog.ShowOpen
    If (CommonDialog.Filename <> "") And (Err.Number <> cdlCancel) Then
        Maps(SelectedMap).HeightMapImport CommonDialog.Filename
    End If
Error:
End Sub

Public Sub mnuSpecialImportMinimap_Click()
    On Error GoTo Error
    CommonDialog.Filter = "Bitmap files (*.bmp)|*.bmp"
    CommonDialog.Filename = ""
    CommonDialog.ShowOpen
    If (CommonDialog.Filename <> "") And (Err.Number <> cdlCancel) Then
        Maps(SelectedMap).MinimapImport CommonDialog.Filename
    End If
Error:
End Sub

Private Sub mnuSpecialSaveMapBitmap_Click()
    On Error GoTo Error
    CommonDialog.DefaultExt = "bmp"
    CommonDialog.Filter = "Bitmap files (*.bmp)|*.bmp"
    CommonDialog.Filename = ""
    CommonDialog.ShowSave
    If (CommonDialog.Filename <> "") And (Err.Number <> cdlCancel) Then
        Screen.MousePointer = vbHourglass
        EnableControls False
        Maps(SelectedMap).ExportMapAsBMP CommonDialog.Filename
    End If
Error:
    EnableControls True
    Screen.MousePointer = vbNormal
End Sub

Private Sub mnuViewGrid_Click(Index As Integer)
    Dim i As Integer
    
    For i = 0 To 4
        mnuViewGrid(i).Checked = False
    Next
    GridSizeX = 32 * 2 ^ Index
    GridSizeY = 32 * 2 ^ Index
    mnuViewGrid(Index).Checked = True
    RefreshMap
End Sub

Private Sub mnuViewGridCustom_Click()
    Dim i As Integer
    
    For i = 0 To 4
        mnuViewGrid(i).Checked = False
    Next
    mnuViewGridCustom.Checked = True
    FrmGridSize.Show 1
    RefreshMap
End Sub

Private Sub mnuViewMinimap_Click()
    On Error Resume Next
    ViewMinimap = Not ViewMinimap
    mnuViewMinimap.Checked = ViewMinimap
    If ViewMinimap Then
        FrmMiniMap.Show
        View.Visible = True
        Maps(SelectedMap).MiniMapRefresh
    Else
        Unload FrmMiniMap
    End If
End Sub

Private Sub mnuViewMinimapSizeHuge_Click()
    MiniSize = 512
    RefreshMiniSize
    mnuViewMiniMapSizeLarge.Checked = False
    mnuViewMiniMapSizeMedium.Checked = False
    mnuViewMiniMapSizeSmall.Checked = False
    mnuViewMinimapSizeHuge.Checked = True
End Sub

Private Sub mnuViewMiniMapSizeLarge_Click()
    MiniSize = 256
    RefreshMiniSize
    mnuViewMiniMapSizeLarge.Checked = True
    mnuViewMiniMapSizeMedium.Checked = False
    mnuViewMiniMapSizeSmall.Checked = False
    mnuViewMinimapSizeHuge.Checked = False
End Sub

Private Sub mnuViewMiniMapSizeMedium_Click()
    MiniSize = 128
    RefreshMiniSize
    mnuViewMiniMapSizeLarge.Checked = False
    mnuViewMiniMapSizeMedium.Checked = True
    mnuViewMiniMapSizeSmall.Checked = False
    mnuViewMinimapSizeHuge.Checked = False
End Sub

Private Sub mnuViewMiniMapSizeSmall_Click()
    MiniSize = 64
    RefreshMiniSize
    mnuViewMiniMapSizeLarge.Checked = False
    mnuViewMiniMapSizeMedium.Checked = False
    mnuViewMiniMapSizeSmall.Checked = True
    mnuViewMinimapSizeHuge.Checked = False
End Sub

Public Sub mnuViewRedrawMiniMap_Click()
    On Error Resume Next
    Maps(SelectedMap).MiniMapCreateDraft
End Sub

Private Sub mnuViewToolbox_Click()
    mnuViewToolbox.Checked = Not mnuViewToolbox.Checked
    ShowToolbox mnuViewToolbox.Checked
End Sub

Private Sub optOffset_Click()
    ScrollHeight.Min = -255
    ScrollHeight.Max = 255
    ScrollHeight.Value = HeightOffset
    LblHeight = CStr(HeightOffset)
End Sub

Private Sub optSolid_Click()
    ScrollHeight.Min = 0
    ScrollHeight.Max = 255
    LblHeight = CStr(ScrollHeight.Value)
End Sub

Private Sub PicSections_DblClick()
    FrmPopup.mnuSectionPaste_Click
End Sub

Private Sub PicSpecial_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    SelectedPlayer = ScrollSpecial.Value + Int(y / 62) + 1
    SpecialsCreatePalette
End Sub

Private Sub PicTilePalette_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    On Error Resume Next
    If Not MapLoaded Then Exit Sub
    If Button > 0 Then
        Maps(SelectedMap).TileSelect x, y
    End If
End Sub

Private Sub ScrollDensity_Change()
    Dim i As Integer
    
    TxtDensity.Text = CStr(ScrollDensity.Value)
    FeatureDensity = ScrollDensity.Value
    For i = 1 To 10
        If i <> FeatureDensity Then
            mnuFeatureDensity(i).Checked = False
        Else
            mnuFeatureDensity(i).Checked = True
        End If
    Next
End Sub

Private Sub ScrollFeatures_Change()
    Features.CreatePalette
End Sub

Private Sub ScrollFeatures_GotFocus()
    CmdBtn.SetFocus
End Sub

Private Sub ScrollFeatures_Scroll()
    Features.CreatePalette
End Sub

Private Sub Canvas_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    On Error Resume Next
    If (Not MapLoaded) Or (Button = 0) Then
        CanvasCursor.Visible = False
        Canvas.MousePointer = vbNormal
        Exit Sub
    End If
    
    Maps(SelectedMap).ToolsProcess x, y, Button
    Select Case SelectedTool
        Case ToolRegion
            Maps(SelectedMap).OverlayCheckMouseOver x, y
            If Maps(SelectedMap).RegionMouseOver Then
                Rubberband.StartMove Selected, x, y, 32
            Else
                Rubberband.Initialize Rubber, x, y, 32
            End If
    End Select
    
    AutoScrollX = x
    AutoScrollY = y
    AutoScroll.Enabled = True
End Sub

Private Sub Canvas_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
    On Error Resume Next
    If Not MapLoaded Then
        CanvasCursor.Visible = False
        Canvas.MousePointer = vbNormal
        Exit Sub
    End If
    
    ' Auto-Scroll. '
    AutoScrollX = x
    AutoScrollY = y
    
    Maps(SelectedMap).ToolsProcess x, y, Button, True
    Select Case SelectedTool
        Case ToolRegion, ToolDefault
        If SelectedTool = ToolRegion Or SelectedItem = ToolSections Or SelectedItem = ToolFeatures Then
            Maps(SelectedMap).OverlayCheckMouseOver x, y
            Rubberband.Move x, y
        End If
    End Select
End Sub

Private Sub Canvas_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
    On Error Resume Next
    AutoScroll.Enabled = False
    If Not MapLoaded Then Exit Sub
    
    Select Case SelectedTool
        Case ToolRegion, ToolDefault
            If Rubberband.Moving Then
                Rubberband.Done
                Maps(SelectedMap).OverlayReposition Rubberband
            ElseIf Rubberband.Dragging Then
                Rubberband.Done
                If SelectedItem = ToolSections Or SelectedTool = ToolRegion Then
                    If Rubberband.Usable Then
                        Maps(SelectedMap).OverlaySet Rubberband
                    Else
                        Maps(SelectedMap).OverlayPaste
                        Selected.Visible = False
                    End If
                ElseIf SelectedItem = ToolFeatures Then
                    Maps(SelectedMap).FeaturesSelect Rubberband
                    Selected.Visible = False
                End If
            End If
        Case ToolOddRegion
    End Select
End Sub

Sub InitializeTools()
    Dim Index As Integer
    
    For Index = 0 To 1023
        WhiteTile(Index) = 255
    Next
    
    ReDim AITypes(0)
    ReDim StartupLocations(1)
    StartupLocations(0) = TALocation
    StartupLocations(1) = App.Path & "\"
    
    ViewMinimap = True
    MiniSize = 128
    RefreshMiniSize
    ZoomValue = 1
    
    PasteTiles = True
    PasteHeight = True
    
    SelectedTool = ToolDefault
    SelectedItem = ToolSections
    ReDim SelectedFeatures(0)
    FeatureMinHeight = 0
    FeatureMaxHeight = 255
    ReDim IgnoreWorlds(0)
    
    GridSizeX = 32
    GridSizeY = 32
    OverGrid = False
    OverHeight = False
    OverContour = False
    OverFeatures = True
    OverSpecials = True
    
    CursorWidth = 1
    CursorHeight = 1
    FeatureDensity = 2
    FeatureRadius = 2
    CloneTiles = True
    CloneHeight = True
    CloneAnims = True
    SelectedPlayer = 1
    HeightMeshInterval = 6
    HeightInterval = 4
    HeightCursorSize = 1
    
    ' Initialize player colors. '
    Players(1) = 66
    Players(2) = 227
    Players(3) = 200
    Players(4) = 165
    Players(5) = 229
    Players(6) = 219
    Players(7) = 208
    Players(8) = 0
    Players(9) = 131
    Players(10) = 255
End Sub

' Allocate memory for the graphics windows. '
Sub InitializeGraphics()
    ReDim Screens(5)
    
    Set View = FrmMiniMap.View
    Set PicMiniMap = FrmMiniMap.PicMiniMap
    If Not Screens(Canvas).Initialize(2000, 2000, Canvas.hwnd) Then
        MsgBox "The memory for the graphics window could not be allocated.  Try clearing up memory, hard drive space, or rebooting.", vbInformation
        Unload Me
    End If
    If Not Screens(Minimap).Initialize(252, 252, PicMiniMap.hwnd) Then
        MsgBox "The memory for the graphics window could not be allocated.  Try clearing up memory, hard drive space, or rebooting.", vbInformation
        Unload Me
    End If
    If Not Screens(PaletteSections).Initialize(320, 320, PicSections.hwnd) Then
        MsgBox "The memory for the graphics window could not be allocated.  Try clearing up memory, hard drive space, or rebooting.", vbInformation
        Unload Me
    End If
    If Not Screens(PaletteFeatures).Initialize(640, 640, PicFeatures.hwnd) Then
        MsgBox "The memory for the graphics window could not be allocated.  Try clearing up memory, hard drive space, or rebooting.", vbInformation
        Unload Me
    End If
    If Not Screens(PaletteSpecials).Initialize(320, 320, PicSpecial.hwnd) Then
        MsgBox "The memory for the graphics window could not be allocated.  Try clearing up memory, hard drive space, or rebooting.", vbInformation
        Unload Me
    End If
    If Not Screens(PaletteTiles).Initialize(320, 320, PicTilePalette.hwnd) Then
        MsgBox "The memory for the graphics window could not be allocated.  Try clearing up memory, hard drive space, or rebooting.", vbInformation
        Unload Me
    End If
End Sub

Sub Initialize()
    Dim rc As Long
    
    ReDim TAList(0)
    Features.Initialize
    Sections.Initialize
    
    rc = RegisterFile("ufo", App.Path & "\" & App.EXEName & ".exe", , "Annihilator", "Annihilator")
    rc = RegisterFile("hpi", App.Path & "\" & App.EXEName & ".exe", , "Annihilator", "Annihilator")
    rc = RegisterFile("ccx", App.Path & "\" & App.EXEName & ".exe", , "Annihilator", "Annihilator")
    rc = RegisterFile("tnt", App.Path & "\" & App.EXEName & ".exe", , "Annihilator", "Annihilator")
    InitializeCommands
    InitializeMaps
    InitializePalette
    InitializeTools
    InitializeGraphics
    InitializeHeightPalette
    InitializeInterface
    SettingsLoad
End Sub

' Create the height palettes. '
Sub InitializeHeightPalette()
    ReDim HeightWater(9)
    ReDim HeightLand(9)
    HeightWater(0) = 105
    HeightWater(1) = 104
    HeightWater(2) = 103
    HeightWater(3) = 102
    HeightWater(4) = 101
    HeightWater(5) = 100
    HeightWater(6) = 99
    HeightWater(7) = 98
    HeightWater(8) = 97
    HeightWater(9) = 96
    HeightLand(0) = 192
    HeightLand(1) = 193
    HeightLand(2) = 194
    HeightLand(3) = 195
    HeightLand(4) = 196
    HeightLand(5) = 197
    HeightLand(6) = 198
    HeightLand(7) = 199
    HeightLand(8) = 200
    HeightLand(9) = 201
End Sub

' Parse the command line for files to open. '
Sub InitializeCommands()
    Dim Buffer As String
    Dim QuoteMark As String
    
    On Error Resume Next
    If Command = "" Then Exit Sub
    
    ' Remove " marks. '
    QuoteMark = """"
    Buffer = Command
    If Right(Command, 1) = QuoteMark Then
        Buffer = Left(Command, Len(Command) - 1)
    End If
    If Left(Buffer, 1) = QuoteMark Then
        Buffer = Right(Buffer, Len(Buffer) - 1)
    End If

    FrmStartupOption.Show 1
    LoadFile = Buffer
End Sub

Sub DoCommands()
    On Error GoTo Error
    Select Case LCase(Right(LoadFile, 3))
        Case "ufo", "hpi", "ccx", "gpf", "gp3"
            FrmHPIView.HPIFilename = LoadFile
            FrmHPIView.Show
        Case "tnt"
            If Not LoadMap(LoadFile) Then
                MsgBox "There was an error loading the map file you selected.", vbExclamation, "Open"
            Else
                InterfaceUpdate
            End If
    End Select
Error:
    LoadFile = ""
End Sub

Private Sub CanvasHScroll_Change()
    On Error Resume Next
    If NoScroll Then Exit Sub
    If SelectedMap >= 0 Then
        Maps(SelectedMap).ScrollMap CanvasHScroll.Value, CanvasVScroll.Value
    End If
End Sub

Private Sub CanvasVScroll_Change()
    On Error Resume Next
    If NoScroll Then Exit Sub
    If SelectedMap >= 0 Then
        Maps(SelectedMap).ScrollMap CanvasHScroll.Value, CanvasVScroll.Value
    End If
End Sub

Private Sub Form_Load()
    'FrmLogo.Show 1
    Initialize
    
    If Not QuickLoad Then
        FrmStartup.Show
    Else
        Sections.Initialize
        Features.Initialize
        Sections.CreateTabs
        Features.CreateTabs
    End If
    Me.Show
    DoCommands
End Sub

Public Sub Form_Resize()
    Dim Index As Integer

    On Error Resume Next
    If Me.WindowState = vbMinimized Then Exit Sub
    If Me.Width < 400 * Screen.TwipsPerPixelX Then Exit Sub
    If Me.Height < 400 * Screen.TwipsPerPixelY Then Exit Sub
    
    CmdBtn.Left = ScaleWidth + 1000
    
    ' Toolbox. '
    PicToolbox.Top = Toolbar.Top + Toolbar.Height
    PicToolbox.Width = PicToolSize.Left
    If Status.Visible Then
        PicToolbox.Height = ScaleHeight - PicToolbox.Top - Status.Height
        PicToolSize.Height = ScaleHeight - PicToolSize.Top - Status.Height
    Else
        PicToolbox.Height = ScaleHeight - PicToolbox.Top
        PicToolSize.Height = ScaleHeight - PicToolSize.Top
    End If
    Toolbox.Width = PicToolbox.ScaleWidth
    ToolboxLine1.x2 = PicToolbox.ScaleWidth
    ToolboxLine1.y1 = Toolbox.Height
    ToolboxLine1.y2 = Toolbox.Height
    ToolboxLine2.x2 = PicToolbox.ScaleWidth
    ToolboxLine2.y1 = Toolbox.Height + 1
    ToolboxLine2.y2 = Toolbox.Height + 1

    ' Tiles frame. '
    PicTilePalette.Left = 0
    PicTilePalette.Top = Toolbox.Height + 6
    PicTilePalette.Height = PicToolbox.ScaleHeight - PicTilePalette.Top
    PicTilePalette.Width = PicToolbox.ScaleWidth - PicTilePalette.Left
    ScrollTiles.Left = PicTilePalette.ScaleWidth - ScrollTiles.Width
    ScrollTiles.Height = PicTilePalette.ScaleHeight
    
    ' Specials frame. '
    PicSpecial.Left = 0
    PicSpecial.Top = Toolbox.Height + 6
    PicSpecial.Height = PicToolbox.ScaleHeight - PicSpecial.Top
    PicSpecial.Width = PicToolbox.ScaleWidth - PicSpecial.Left
    ScrollSpecial.Left = PicSpecial.ScaleWidth - ScrollSpecial.Width
    ScrollSpecial.Height = PicSpecial.ScaleHeight
        
    ' Features frame. '
    PicFeaturePalette.Left = 0
    PicFeaturePalette.Top = Toolbox.Height + 6
    PicFeaturePalette.Height = PicToolbox.ScaleHeight - PicFeaturePalette.Top
    PicFeaturePalette.Width = PicToolbox.ScaleWidth - PicFeaturePalette.Left
    FrameFeatureOptions.Top = PicFeaturePalette.ScaleHeight - FrameFeatureOptions.Height - 5
    FrameFeatureOptions.Width = PicFeaturePalette.ScaleWidth - FrameFeatureOptions.Left * 2
    FeatureLine1.x2 = FrameFeatureOptions.ScaleWidth
    FeatureLine2.x2 = FrameFeatureOptions.ScaleWidth
    If FrameFeatureOptions.Visible Then
        TabFeatureWorld.Height = PicFeaturePalette.ScaleHeight - FrameFeatureOptions.Height - 7
    Else
        TabFeatureWorld.Height = PicFeaturePalette.ScaleHeight
    End If
    TabFeatureWorld.Width = PicFeaturePalette.ScaleWidth
    PicFeatures.Width = PicFeaturePalette.ScaleWidth - PicFeatures.Left * 2
    PicFeatures.Height = TabFeatureWorld.Height - PicFeatures.Top * 2 + 20
    TabFeatureCategory.Width = PicFeatures.ScaleWidth
    ScrollFeatures.Left = PicFeatures.ScaleWidth - ScrollFeatures.Width
    ScrollFeatures.Top = TabFeatureCategory.Height
    ScrollFeatures.Height = PicFeatures.ScaleHeight - ScrollFeatures.Top

    ' Sections frame. '
    PicSectionPalette.Left = 0
    PicSectionPalette.Top = Toolbox.Height + 6
    PicSectionPalette.Width = PicToolbox.ScaleWidth - PicSectionPalette.Left
    PicSectionPalette.Height = PicToolbox.ScaleHeight - PicSectionPalette.Top
    TabSectionWorld.Width = PicSectionPalette.ScaleWidth
    TabSectionWorld.Height = PicSectionPalette.ScaleHeight
    PicSections.Width = PicSectionPalette.ScaleWidth - PicSections.Left * 2
    PicSections.Height = TabSectionWorld.Height - PicSections.Top * 2 + 20
    TabSectionCategory.Width = PicSections.ScaleWidth
    ScrollSections.Left = PicSections.ScaleWidth - ScrollSections.Width
    ScrollSections.Top = TabSectionCategory.Height
    ScrollSections.Height = PicSections.ScaleHeight - ScrollSections.Top
'    SectionLine1.y1 = ScrollSections.Top
'    SectionLine1.y2 = ScrollSections.Top
'    SectionLine2.y1 = ScrollSections.Top + 1
'    SectionLine2.y2 = ScrollSections.Top + 1
'    SectionLine1.x2 = PicSections.ScaleWidth
'    SectionLine2.x2 = PicSections.ScaleWidth
    
    ' Height frame. '
    PicHeightPalette.Left = 0
    PicHeightPalette.Top = Toolbox.Height + 6
    PicHeightPalette.Width = PicToolbox.ScaleWidth
    PicHeightPalette.Height = PicToolbox.ScaleHeight - PicHeightPalette.Top
    TabHeight.Width = PicHeightPalette.ScaleWidth
    TabHeight.Height = PicHeightPalette.ScaleHeight
    PicHeightEditing.Width = PicHeightPalette.ScaleWidth - PicHeightEditing.Left * 2
    PicHeightEditing.Height = TabHeight.Height - PicHeightEditing.Top * 2 + 20
    HeightLine1.x2 = PicHeightEditing.ScaleWidth - HeightLine1.x1 * 2
    HeightLine2.x2 = PicHeightEditing.ScaleWidth - HeightLine2.x1 * 2
    HeightLine3.x2 = PicHeightEditing.ScaleWidth - HeightLine3.x1 * 2
    HeightLine4.x2 = PicHeightEditing.ScaleWidth - HeightLine4.x1 * 2
    HeightLine5.x2 = PicHeightEditing.ScaleWidth - HeightLine5.x1 * 2
    HeightLine6.x2 = PicHeightEditing.ScaleWidth - HeightLine6.x1 * 2
    SliderSeaLevel.Width = PicHeightEditing.ScaleWidth - SliderSeaLevel.Left * 2
    PicSeaLevel.Width = PicHeightEditing.ScaleWidth - PicSeaLevel.Left * 2
    ScrollHeight.Width = PicHeightEditing.ScaleWidth - ScrollHeight.Left * 2
    
    ' Main view. '
    If TabMaps.Tabs.Count < 2 Then
        TabMaps.Visible = False
    Else
        TabMaps.Visible = True
        Index = 300
    End If
    If Toolbar.Visible Then
        TabMaps.Top = Toolbar.Top + Toolbar.Height
        Canvas.Top = Toolbar.Top + Toolbar.Height + Index
    Else
        TabMaps.Top = 0
        Canvas.Top = 0 + Index
    End If
    If PicToolSize.Visible = True Then
        Canvas.Left = PicToolSize.Left + PicToolSize.Width
        TabMaps.Left = PicToolSize.Left + PicToolSize.Width
    Else
        Canvas.Left = 0
        TabMaps.Left = 0
    End If
    Canvas.Width = ScaleWidth - Canvas.Left
    If Status.Visible Then
        Canvas.Height = ScaleHeight - Canvas.Top - Status.Height
    Else
        Canvas.Height = ScaleHeight - Canvas.Top
    End If
    
    ' Scroll bars. '
    CanvasVScroll.Left = Canvas.ScaleWidth - CanvasVScroll.Width
    CanvasVScroll.Height = Canvas.ScaleHeight - CanvasHScroll.Height
    CanvasHScroll.Top = Canvas.ScaleHeight - CanvasHScroll.Height
    CanvasHScroll.Width = Canvas.ScaleWidth - CanvasVScroll.Width
    PicScroll.Left = CanvasVScroll.Left
    PicScroll.Width = CanvasVScroll.Width
    PicScroll.Top = CanvasHScroll.Top
    PicScroll.Height = CanvasHScroll.Height
    
    ' Interface is now resized properlly, so update all the interface controls. '
    Features.CreatePalette
    Sections.CreatePalette
    SpecialsCreatePalette
    If MapLoaded Then ' Update interface. '
        InterfaceUpdate
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    On Error Resume Next
    
    Flag = False
    FrmSaveChanges.MapIndex = -1
    FrmSaveChanges.Show
    Do While Flag = False
        DoEvents
    Loop
    
    If Flag = True Then
        Unload FrmMiniMap
        
        SettingsSave
        CleanUp
        End
    Else
        Cancel = True
    End If
End Sub

Private Sub mnuFileExit_Click()
    On Error Resume Next
    
    Unload Me
End Sub

Private Sub mnuFileNew_Click()
    FrmNew.Show
End Sub

Private Sub mnuFileOpen_Click()
    On Error GoTo Error
    CommonDialog.DefaultExt = "ufo"
    CommonDialog.Filter = "TA Maps|*.tnt; *.ufo; *.hpi; *.ccx; *.gpf; *.gp3"
    CommonDialog.Filename = ""
    CommonDialog.InitDir = InitFileOpenDir
    CommonDialog.ShowOpen
    If (CommonDialog.Filename <> "") And (Err.Number <> cdlCancel) Then
        InitFileOpenDir = GetDirectory(CommonDialog.Filename)
        EnableControls False
        Status.Panels(1).Text = "Loading map..."
        Select Case LCase(Right(CommonDialog.Filename, 3))
            Case "tnt"
                If Not LoadMap(CommonDialog.Filename) Then
                    MsgBox "There was an error loading the map file you selected.", vbExclamation, "Open"
                Else
                    InterfaceUpdate
                End If
            Case Else
                FrmHPIView.HPIFilename = CommonDialog.Filename
                FrmHPIView.Show
        End Select
    End If
    On Error GoTo 0

Error:
    EnableDefaults
    Status.Panels(1).Text = "Ready"
    Screen.MousePointer = vbNormal
End Sub

Private Sub mnuFileReportBug_Click()
    'FrmBug.Show 1
End Sub

Public Sub mnuFileSave_Click()
    On Error Resume Next
    If SelectedMap < 0 Then Exit Sub
    If Maps(SelectedMap).MapFilename = "" Then
        mnuFileSaveAs_Click
        Exit Sub
    End If
    Status.Panels(1).Text = "Saving map..."
    EnableControls False
    SaveMap
    EnableControls True
    Status.Panels(1).Text = "Ready"
End Sub

Private Sub mnuHelpAbout_Click()
    FrmAbout.Show 1
End Sub

Private Sub mnuMapResize_Click()
    FrmMapResize.Show 1
End Sub

Private Sub mnuMapSettings_Click()
    FrmMapSettings.Show 1
End Sub

Private Sub mnuOnlineAnnihilated_Click()
    Dim rc As Long
    
    rc = ShellExecute(hwnd, "open", "http://www.annihilated.com", vbNullString, vbNullString, SW_NORMAL)
End Sub

Private Sub mnuOnlineAnnihilation_Click()
    Dim rc As Long
    
    rc = ShellExecute(hwnd, "open", "http://www.annihilationcenter.com", vbNullString, vbNullString, SW_NORMAL)
End Sub

Private Sub mnuOnlineCavedog_Click()
    Dim rc As Long
    
    rc = ShellExecute(hwnd, "open", "http://www.totalannihilation.com", vbNullString, vbNullString, SW_NORMAL)
End Sub

Private Sub mnuOnlineTAMEC_Click()
    Dim rc As Long
    
    rc = ShellExecute(hwnd, "open", "http://www.tamec.org", vbNullString, vbNullString, SW_NORMAL)
End Sub

Private Sub mnuViewOptions_Click()
    FrmOptions.Show 1
    'If TNTLoaded Then DrawCanvas
End Sub

Private Sub mnuViewStatusBar_Click()
    mnuViewStatusBar.Checked = Not mnuViewStatusBar.Checked
    Status.Visible = mnuViewStatusBar.Checked
    If Status.Visible Then
        Status.Height = 315
    Else
        Status.Height = 0
    End If
    Form_Resize
End Sub

' Load the palette. '
Sub InitializePalette()
    Dim FileHandle As Integer
    
    ' Load the Annihilator.bin file. '
    FileHandle = FreeFile
    Open App.Path & "\annihilator.bin" For Binary As FileHandle
    Get FileHandle, , TAPalette()
    Get FileHandle, , StartingTile()
    Close FileHandle
    'ExportPalette
End Sub

Sub ExportPalette()
    Dim File As Integer
    Dim i As Integer
    
    On Error GoTo Error
    File = FreeFile
    Open "c:\download\tapal.pal" For Output As File
    Print #File, "JASC-PAL"
    Print #File, "0100"
    Print #File, "256"
    For i = 0 To 255
        Print #File, CStr(TAPalette(i).rgbRed) & " " & CStr(TAPalette(i).rgbGreen) & " " & CStr(TAPalette(i).rgbBlue)
    Next
    Close File
    Exit Sub
Error:
    MsgBox Err.Description
End Sub

Private Sub PicFeatures_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    If Button > 0 Then
        Features.SelectFeature x, y, Button
        Features.CreatePalette
    End If
End Sub

Private Sub PicSections_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    Dim NewY As Long
    Static LastIndex As Integer
    
    NewY = y - TabSectionCategory.Height
    If (LastIndex <> ScrollSections.Value + Int(NewY / 158)) Or (SelectedSection.Name = "") Then
        Screen.MousePointer = vbHourglass
        SelectedSection.FreeSection
        Sections.SelectSection ScrollSections.Value + Int(NewY / 158)
        Sections.CreatePalette
        Screen.MousePointer = vbNormal
        LastIndex = ScrollSections.Value + Int(NewY / 158)
    End If
    If Button > 1 Then
        PopupMenu FrmPopup.mnuPopupSection, , , , FrmPopup.mnuSectionPaste
    End If
End Sub

Private Sub PicToolSize_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    If Button = vbLeftButton Then
        'change the splitter colour
        PicToolSize.BackColor = SPLT_COLOUR
        'set the current position to x
        currSplitPosX = CLng(x)
    Else
        'not the left button, so... if the current position <> default, cause a mouseup
        If currSplitPosX <> &H7FFFFFFF Then PicToolSize_MouseUp Button, Shift, x, y
        'set the current position to the default value
        currSplitPosX = &H7FFFFFFF
    End If
End Sub

Private Sub PicToolSize_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
    'if the splitter has been moved...
    If currSplitPosX& <> &H7FFFFFFF Then
        'if the current position <> default, reposition the splitter and set this as the current value
        If CLng(x) <> currSplitPosX Then
            If (PicToolSize.Left + x >= 2000) And (PicToolSize.Left + x <= Int(ScaleWidth / 3)) Then
                PicToolSize.Move PicToolSize.Left + x, CTRL_OFFSET, SPLT_WDTH, ScaleHeight - (CTRL_OFFSET * 2)
            ElseIf (PicToolSize.Left + x < 2000) Then
                PicToolSize.Move 2000, CTRL_OFFSET, SPLT_WDTH, ScaleHeight - (CTRL_OFFSET * 2)
            ElseIf (PicToolSize.Left + x > Int(ScaleWidth / 3)) Then
                PicToolSize.Move Int(ScaleWidth / 3), CTRL_OFFSET, SPLT_WDTH, ScaleHeight - (CTRL_OFFSET * 2)
            End If
            currSplitPosX = CLng(x)
        End If
    End If
End Sub

Private Sub PicToolSize_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
    'if the splitter has been moved...
    If currSplitPosX <> &H7FFFFFFF Then
        'if the current position <> the last position do a final move of the splitter
        If CLng(x) <> currSplitPosX Then
            If (PicToolSize.Left + x > 2000) And (PicToolSize.Left + x < Int(ScaleWidth / 2)) Then
                PicToolSize.Move PicToolSize.Left + x, CTRL_OFFSET, SPLT_WDTH, ScaleHeight - (CTRL_OFFSET * 2)
            End If
        End If
        ' The default position. '
        currSplitPosX = &H7FFFFFFF
        ' Restore the normal splitter color. '
        PicToolSize.BackColor = &H8000000F
        Form_Resize
    End If
End Sub

Private Sub ScrollHeight_Click()
    On Error GoTo Error
    LblHeight = CStr(ScrollHeight.Value)
    If optSolid.Value Then
        Maps(SelectedMap).OverlaySetHeight ScrollHeight.Value
    Else
        HeightOffset = ScrollHeight.Value
        RefreshMap
    End If
Error:
End Sub

Private Sub ScrollHeightCursorSize_Change()
    HeightCursorSize = ScrollHeightCursorSize.Value
    TxtHeightCursorSize = CStr(HeightCursorSize)
End Sub

Private Sub ScrollInterval_Change()
    HeightInterval = ScrollInterval.Value
    TxtInterval = CStr(HeightInterval)
End Sub

Private Sub ScrollRadius_Change()
    TxtRadius.Text = CStr(ScrollRadius.Value)
    FeatureRadius = ScrollRadius.Value
End Sub

Private Sub ScrollSections_Change()
    Sections.CreatePalette
End Sub

Private Sub ScrollSections_GotFocus()
    CmdBtn.SetFocus
End Sub

Private Sub ScrollSections_Scroll()
    Sections.CreatePalette
End Sub

Private Sub ScrollSpecial_Change()
    SpecialsCreatePalette
End Sub

Private Sub ScrollSpecial_GotFocus()
    CmdBtn.SetFocus
End Sub

Private Sub ScrollSpecial_Scroll()
    SpecialsCreatePalette
End Sub

Private Sub ScrollTiles_Change()
    On Error Resume Next
    Maps(SelectedMap).TileCreatePalette
End Sub

Private Sub ScrollTiles_GotFocus()
    CmdBtn.SetFocus
End Sub

Private Sub ScrollTiles_Scroll()
    On Error Resume Next
    Maps(SelectedMap).TileCreatePalette
End Sub

Private Sub SliderSeaLevel_Change()
    On Error Resume Next
    Maps(SelectedMap).SetSealevel SliderSeaLevel.Value
    Maps(SelectedMap).DrawSeaLevel
    Maps(SelectedMap).DrawMap
End Sub

Private Sub SliderSeaLevel_Scroll()
    On Error Resume Next
    Maps(SelectedMap).SetSealevel SliderSeaLevel.Value
    Maps(SelectedMap).DrawSeaLevel
End Sub

Private Sub TabFeatureCategory_Click()
    On Error Resume Next
    Screen.MousePointer = vbHourglass
    Features.ClearMemory
    SelectedFeatureCategory = TabFeatureCategory.SelectedItem.Caption
    Features.LoadMemory
    ScrollFeatures.Value = 0
    Features.CreatePalette
    PicFeatures.SetFocus
    Screen.MousePointer = vbNormal
End Sub

Private Sub TabFeatureWorld_Click()
    On Error Resume Next
    SelectedFeatureWorld = TabFeatureWorld.SelectedItem.Caption
    SelectedFeatureCategory = ""
    Features.CreateCategoryTabs
    PicFeatures.SetFocus
End Sub

Private Sub TabMaps_Click()
    SelectedMap = tIndex(TabMaps.SelectedItem.Key)
    InterfaceUpdate
End Sub

Private Sub TabSectionCategory_Click()
    On Error Resume Next
    Screen.MousePointer = vbHourglass
    Sections.ClearMemory
    SelectedSectionCategory = TabSectionCategory.SelectedItem.Caption
    Sections.LoadMemory
    ScrollSections.Value = 0
    Set SelectedSection = Nothing
    Sections.CreatePalette
    PicSections.SetFocus
    Screen.MousePointer = vbNormal
End Sub

Private Sub TabSectionWorld_Click()
    On Error Resume Next
    PicSections.Picture = PicSectionPalette.Picture
    PicSections.Cls
    ScrollSections.Visible = False
    SelectedSectionWorld = TabSectionWorld.SelectedItem.Caption
    SelectedSectionCategory = ""
    Sections.CreateCategoryTabs
    PicSections.SetFocus
End Sub

Private Sub Toolbar_ButtonClick(ByVal Button As ComctlLib.Button)
    On Error Resume Next
    
    Select Case Button.Key
        Case "new"
            mnuFileNew_Click
        Case "open"
            mnuFileOpen_Click
        Case "save"
            mnuFileSave_Click
        Case "options"
            FrmOptions.Show 1
        Case "compress"
            mnuMapCompress_Click
        Case "cut"
            mnuEditCut_Click
        Case "copy"
            mnuEditCopy_Click
        Case "paste"
            mnuEditPaste_Click
        Case "map"
            mnuMapSettings_Click
        Case "fill"
            mnuFeaturesFill_Click
        Case "overgrid"
            Toolbar.Buttons("overcontour").Value = tbrUnpressed
            Toolbar.Buttons("overheight").Value = tbrUnpressed
            OverGrid = (Toolbar.Buttons("overgrid").Value = tbrPressed)
            OverHeight = (Toolbar.Buttons("overheight").Value = tbrPressed)
            OverContour = (Toolbar.Buttons("overcontour").Value = tbrPressed)
            RefreshMap
        Case "overheight"
            Toolbar.Buttons("overgrid").Value = tbrUnpressed
            Toolbar.Buttons("overcontour").Value = tbrUnpressed
            OverGrid = (Toolbar.Buttons("overgrid").Value = tbrPressed)
            OverHeight = (Toolbar.Buttons("overheight").Value = tbrPressed)
            OverContour = (Toolbar.Buttons("overcontour").Value = tbrPressed)
            RefreshMap
        Case "overcontour"
            Toolbar.Buttons("overgrid").Value = tbrUnpressed
            Toolbar.Buttons("overheight").Value = tbrUnpressed
            OverGrid = (Toolbar.Buttons("overgrid").Value = tbrPressed)
            OverHeight = (Toolbar.Buttons("overheight").Value = tbrPressed)
            OverContour = (Toolbar.Buttons("overcontour").Value = tbrPressed)
            RefreshMap
        Case "gridsettings"
            PopupMenu mnuViewGridSize
        Case "heightsettings"
            PopupMenu FrmPopup.mnuHeightSettings
        Case "overfeatures"
            OverFeatures = Not OverFeatures
            RefreshMap
        Case "overstarting"
            OverSpecials = Not OverSpecials
            Maps(SelectedMap).MiniMapRefresh
            RefreshMap
        Case "default"
            SelectedTool = ToolDefault
        Case "region"
            SelectedTool = ToolRegion
        Case "regionsettings"
            PopupMenu FrmPopup.mnuRegionSettings
    End Select
End Sub

Sub SettingsLoad()
    Dim Buffer As Long, Temp As String
    
    Buffer = Val(GetSetting(ProgramName, "Startup", "SliderLeft", PicToolSize.Left))
    If Buffer <> 0 Then PicToolSize.Left = Buffer
    Buffer = Val(GetSetting(ProgramName, "Startup", "Left", Me.Left))
    If Buffer <> 0 Then Me.Left = Buffer
    Buffer = Val(GetSetting(ProgramName, "Startup", "Top", Me.Top))
    If Buffer <> 0 Then Me.Top = Buffer
    Buffer = Val(GetSetting(ProgramName, "Startup", "Width", Me.Width))
    If Buffer <> 0 Then Me.Width = Buffer
    Buffer = Val(GetSetting(ProgramName, "Startup", "Height", Me.Height))
    If Buffer <> 0 Then Me.Height = Buffer
    MiniSize = Val(GetSetting(ProgramName, "Startup", "Minisize", 128))
    RefreshMiniSizeMenu
    Buffer = Val(GetSetting(ProgramName, "Startup", "Status", 1))
    If Buffer = 1 Then
        Status.Visible = True
        mnuViewStatusBar.Checked = True
    Else
        Status.Visible = False
        mnuViewStatusBar.Checked = False
    End If
    Me.WindowState = Val(GetSetting(ProgramName, "Startup", "WindowState", Me.WindowState))
    
    ' Options. '
    Buffer = Val(GetSetting(ProgramName, "Options", "RetainFeatures", 0))
    RetainFeatures = (Buffer = 1)
    Buffer = Val(GetSetting(ProgramName, "Options", "HeightSwitchColors", 0))
    HeightSwitchColors = (Buffer = 1)
    
    Temp = GetSetting(ProgramName, "Locations", "Startup0", "")
    Do While Temp <> ""
        ReDim Preserve StartupLocations(2 + Buffer)
        StartupLocations(2 + Buffer) = Temp
        Buffer = Buffer + 1
        Temp = GetSetting(ProgramName, "Locations", "Startup" & CStr(Buffer), "")
    Loop
    
    ' Directories. '
    InitFileOpenDir = GetSetting(ProgramName, "Locations", "InitFileOpenDir", "")
    InitFileSaveDir = GetSetting(ProgramName, "Locations", "InitFileSaveDir", "")
    
    Form_Resize
End Sub

Sub SettingsSave()
    Dim Buffer As Long
    
    If WindowState = vbNormal Then
        SaveSetting ProgramName, "Startup", "Left", Me.Left
        SaveSetting ProgramName, "Startup", "Top", Me.Top
        SaveSetting ProgramName, "Startup", "Width", Me.Width
        SaveSetting ProgramName, "Startup", "Height", Me.Height
    End If
    SaveSetting ProgramName, "Startup", "WindowState", Me.WindowState
    SaveSetting ProgramName, "Startup", "SliderLeft", PicToolSize.Left
    If Status.Visible Then Buffer = 1 Else Buffer = 0
    SaveSetting ProgramName, "Startup", "Status", Buffer
    SaveSetting ProgramName, "Startup", "Minisize", MiniSize
    
    ' Options. '
    If RetainFeatures Then Buffer = 1 Else Buffer = 0
    SaveSetting ProgramName, "Options", "RetainFeatures", Buffer
    If HeightSwitchColors Then Buffer = 1 Else Buffer = 0
    SaveSetting ProgramName, "Options", "HeightSwitchColors", Buffer
    
    For Buffer = 2 To UBound(StartupLocations)
        SaveSetting ProgramName, "Locations", "Startup" & CStr(Buffer - 2), StartupLocations(Buffer)
    Next
    
    ' Directories. '
    SaveSetting ProgramName, "Locations", "InitFileOpenDir", InitFileOpenDir
    SaveSetting ProgramName, "Locations", "InitFileSaveDir", InitFileSaveDir
End Sub

Private Sub Toolbox_ButtonClick(ByVal Button As ComctlLib.Button)
    Select Case Button.Key
        Case "Sections"
            SelectedItem = ToolSections
        Case "Features"
            SelectedItem = ToolFeatures
        Case "Height"
            SelectedItem = ToolHeight
        Case "Special"
            SelectedItem = ToolSpecial
        Case "Tiles"
            SelectedItem = ToolTiles
    End Select
    ToolboxShowControls
End Sub

Private Sub TxtDensity_KeyPress(KeyAscii As Integer)
    KeyAscii = 0
End Sub

Private Sub TxtInterval_KeyPress(KeyAscii As Integer)
    KeyAscii = 0
End Sub

Private Sub TxtRadius_KeyPress(KeyAscii As Integer)
    KeyAscii = 0
End Sub
