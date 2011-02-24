VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.3#0"; "COMCTL32.OCX"
Begin VB.Form Frm3do 
   Appearance      =   0  'Flat
   Caption         =   "3DO Builder"
   ClientHeight    =   7590
   ClientLeft      =   165
   ClientTop       =   735
   ClientWidth     =   10245
   Icon            =   "Frm3do.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   7590
   ScaleWidth      =   10245
   StartUpPosition =   3  'Windows Default
   Begin ComctlLib.Toolbar Toolbar 
      Align           =   1  'Align Top
      Height          =   420
      Left            =   0
      TabIndex        =   1
      Top             =   0
      Width           =   10245
      _ExtentX        =   18071
      _ExtentY        =   741
      ButtonWidth     =   635
      ButtonHeight    =   582
      Appearance      =   1
      ImageList       =   "ImgToolbar"
      _Version        =   327682
      BeginProperty Buttons {0713E452-850A-101B-AFC0-4210102A8DA7} 
         NumButtons      =   15
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
            Key             =   "new"
            Object.ToolTipText     =   "New"
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
            Key             =   "unitpic"
            Object.ToolTipText     =   "Create Unit Picture"
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
            Key             =   "createobject"
            Object.ToolTipText     =   "Create Object"
            Object.Tag             =   ""
            ImageIndex      =   5
         EndProperty
         BeginProperty Button8 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "importdxf"
            Object.ToolTipText     =   "Import Object"
            Object.Tag             =   ""
            ImageIndex      =   6
         EndProperty
         BeginProperty Button9 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "exportdxf"
            Object.ToolTipText     =   "Export Object"
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
            Key             =   "zoomin"
            Object.ToolTipText     =   "Zoom In"
            Object.Tag             =   ""
            ImageIndex      =   8
         EndProperty
         BeginProperty Button12 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "zoomout"
            Object.ToolTipText     =   "Zoom Out"
            Object.Tag             =   ""
            ImageIndex      =   9
         EndProperty
         BeginProperty Button13 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   ""
            Object.Tag             =   ""
            Style           =   3
            MixedState      =   -1  'True
         EndProperty
         BeginProperty Button14 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "tooldefault"
            Object.ToolTipText     =   "Default"
            Object.Tag             =   ""
            ImageIndex      =   10
            Style           =   2
            Value           =   1
         EndProperty
         BeginProperty Button15 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "toolmove"
            Object.ToolTipText     =   "Move Object"
            Object.Tag             =   ""
            ImageIndex      =   11
            Style           =   2
         EndProperty
      EndProperty
   End
   Begin VB.PictureBox PicTextureSize 
      BorderStyle     =   0  'None
      Height          =   2895
      Left            =   8520
      MousePointer    =   9  'Size W E
      ScaleHeight     =   2895
      ScaleWidth      =   45
      TabIndex        =   38
      Top             =   420
      Width           =   45
   End
   Begin VB.PictureBox PicTemp 
      AutoRedraw      =   -1  'True
      BackColor       =   &H00FFFFFF&
      Height          =   375
      Left            =   2700
      ScaleHeight     =   21
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   191
      TabIndex        =   19
      Top             =   6540
      Visible         =   0   'False
      Width           =   2925
   End
   Begin VB.ComboBox LstTextures 
      Height          =   315
      Left            =   8640
      Style           =   2  'Dropdown List
      TabIndex        =   18
      Top             =   420
      Width           =   1575
   End
   Begin VB.PictureBox PicTextures 
      AutoRedraw      =   -1  'True
      BackColor       =   &H00FFFFFF&
      Height          =   5655
      Left            =   8640
      ScaleHeight     =   373
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   101
      TabIndex        =   16
      Top             =   780
      Width           =   1575
      Begin VB.VScrollBar ScrollTextures 
         Height          =   5595
         Left            =   1260
         TabIndex        =   17
         Top             =   0
         Width           =   255
      End
   End
   Begin MSComDlg.CommonDialog CommonDialog 
      Left            =   660
      Top             =   6540
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
      CancelError     =   -1  'True
   End
   Begin VB.PictureBox PicViews 
      BorderStyle     =   0  'None
      Height          =   6015
      Left            =   2700
      ScaleHeight     =   6015
      ScaleWidth      =   5715
      TabIndex        =   7
      Top             =   420
      Width           =   5715
      Begin VB.PictureBox PicFront 
         AutoRedraw      =   -1  'True
         BackColor       =   &H00FFFFFF&
         Height          =   2955
         Left            =   0
         ScaleHeight     =   193
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   193
         TabIndex        =   11
         Top             =   0
         Width           =   2955
         Begin VB.Label LblFront 
            BackStyle       =   0  'Transparent
            Caption         =   "Front"
            ForeColor       =   &H00000000&
            Height          =   195
            Left            =   0
            TabIndex        =   25
            Top             =   0
            Width           =   555
         End
      End
      Begin VB.PictureBox PicView 
         BackColor       =   &H00FFFFFF&
         Height          =   2955
         Left            =   3060
         ScaleHeight     =   193
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   197
         TabIndex        =   10
         Top             =   0
         Width           =   3015
         Begin VB.Timer TmrAnimate 
            Enabled         =   0   'False
            Interval        =   10
            Left            =   2160
            Top             =   2400
         End
      End
      Begin VB.PictureBox PicTop 
         AutoRedraw      =   -1  'True
         BackColor       =   &H80000009&
         Height          =   2955
         Left            =   0
         ScaleHeight     =   193
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   193
         TabIndex        =   9
         Top             =   3060
         Width           =   2955
         Begin VB.Label LblTop 
            BackStyle       =   0  'Transparent
            Caption         =   "Top"
            ForeColor       =   &H00000000&
            Height          =   195
            Left            =   0
            TabIndex        =   26
            Top             =   0
            Width           =   555
         End
      End
      Begin VB.PictureBox PicRight 
         AutoRedraw      =   -1  'True
         BackColor       =   &H00FFFFFF&
         Height          =   2955
         Left            =   3060
         ScaleHeight     =   193
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   193
         TabIndex        =   8
         Top             =   3060
         Width           =   2955
         Begin VB.Label LblSide 
            BackStyle       =   0  'Transparent
            Caption         =   "Side"
            ForeColor       =   &H00000000&
            Height          =   195
            Left            =   0
            TabIndex        =   27
            Top             =   0
            Width           =   435
         End
      End
   End
   Begin VB.PictureBox PicToolbox 
      Height          =   6015
      Left            =   0
      ScaleHeight     =   5955
      ScaleWidth      =   2595
      TabIndex        =   2
      Top             =   420
      Width           =   2655
      Begin ComctlLib.TreeView Tree3do 
         Height          =   2475
         Left            =   60
         TabIndex        =   4
         Top             =   60
         Width           =   2475
         _ExtentX        =   4366
         _ExtentY        =   4366
         _Version        =   327682
         Indentation     =   353
         LineStyle       =   1
         Style           =   7
         Appearance      =   1
      End
      Begin VB.PictureBox PicFaces 
         AutoRedraw      =   -1  'True
         Height          =   2955
         Left            =   60
         ScaleHeight     =   193
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   161
         TabIndex        =   6
         Top             =   2940
         Width           =   2475
         Begin ComctlLib.Slider ScrollPrimitive 
            Height          =   255
            Left            =   120
            TabIndex        =   37
            Top             =   480
            Width           =   2175
            _ExtentX        =   3836
            _ExtentY        =   450
            _Version        =   327682
            LargeChange     =   1
            Max             =   1
            TickStyle       =   3
         End
         Begin VB.PictureBox PicTexture 
            AutoRedraw      =   -1  'True
            Height          =   1155
            Left            =   120
            ScaleHeight     =   73
            ScaleMode       =   3  'Pixel
            ScaleWidth      =   73
            TabIndex        =   28
            Top             =   1680
            Width           =   1155
         End
         Begin VB.TextBox LblTexture 
            BackColor       =   &H8000000F&
            BorderStyle     =   0  'None
            Height          =   255
            Left            =   1380
            Locked          =   -1  'True
            TabIndex        =   23
            Top             =   960
            Width           =   915
         End
         Begin VB.ComboBox LstOrientation 
            Height          =   315
            Left            =   1380
            Style           =   2  'Dropdown List
            TabIndex        =   21
            Top             =   1260
            Width           =   915
         End
         Begin VB.CommandButton CmdColor 
            Caption         =   "C&olor..."
            Height          =   315
            Left            =   1380
            TabIndex        =   15
            Top             =   2520
            Width           =   915
         End
         Begin VB.CommandButton CmdApply 
            Caption         =   "&Apply..."
            Height          =   315
            Left            =   1380
            TabIndex        =   14
            Top             =   2100
            Width           =   915
         End
         Begin VB.CommandButton CmdClearTexture 
            Caption         =   "&Clear"
            Height          =   315
            Left            =   1380
            TabIndex        =   13
            Top             =   1680
            Width           =   915
         End
         Begin VB.TextBox TxtPrimitive 
            Height          =   315
            Left            =   1380
            TabIndex        =   12
            Text            =   "0:0"
            Top             =   120
            Width           =   915
         End
         Begin VB.Label LblFaces 
            Alignment       =   1  'Right Justify
            Caption         =   "Face"
            Height          =   255
            Left            =   120
            TabIndex        =   24
            Top             =   180
            Width           =   1155
         End
         Begin VB.Label Label2 
            Alignment       =   1  'Right Justify
            Caption         =   "Texture"
            Height          =   255
            Left            =   120
            TabIndex        =   22
            Top             =   960
            Width           =   1095
         End
         Begin VB.Label Label1 
            Alignment       =   1  'Right Justify
            Caption         =   "Orientation"
            Height          =   195
            Left            =   120
            TabIndex        =   20
            Top             =   1320
            Width           =   1095
         End
         Begin VB.Line Line2 
            BorderColor     =   &H80000014&
            X1              =   0
            X2              =   160
            Y1              =   53
            Y2              =   53
         End
         Begin VB.Line Line1 
            BorderColor     =   &H80000010&
            X1              =   0
            X2              =   160
            Y1              =   52
            Y2              =   52
         End
      End
      Begin VB.PictureBox PicObject 
         Height          =   2955
         Left            =   60
         ScaleHeight     =   2895
         ScaleWidth      =   2415
         TabIndex        =   5
         Top             =   2940
         Visible         =   0   'False
         Width           =   2475
         Begin VB.CommandButton CmdApplyOffset 
            Caption         =   "Apply"
            Height          =   315
            Left            =   1380
            TabIndex        =   36
            Top             =   420
            Width           =   915
         End
         Begin VB.TextBox TxtOffsetZ 
            Height          =   315
            Left            =   300
            TabIndex        =   35
            Text            =   "0.0"
            Top             =   1260
            Width           =   975
         End
         Begin VB.TextBox TxtOffsetY 
            Height          =   315
            Left            =   300
            TabIndex        =   34
            Text            =   "0.0"
            Top             =   840
            Width           =   975
         End
         Begin VB.TextBox TxtOffsetX 
            Height          =   315
            Left            =   300
            TabIndex        =   33
            Text            =   "0.0"
            Top             =   420
            Width           =   975
         End
         Begin VB.TextBox TxtScale 
            Height          =   315
            Left            =   120
            TabIndex        =   30
            Text            =   "1.0"
            Top             =   2160
            Width           =   1155
         End
         Begin VB.CommandButton CmdApplyScale 
            Caption         =   "Apply"
            Height          =   315
            Left            =   1380
            TabIndex        =   29
            Top             =   2160
            Width           =   915
         End
         Begin VB.Label Label6 
            Caption         =   "z"
            Height          =   255
            Left            =   120
            TabIndex        =   41
            Top             =   1320
            Width           =   195
         End
         Begin VB.Label Label5 
            Caption         =   "y"
            Height          =   255
            Left            =   120
            TabIndex        =   40
            Top             =   900
            Width           =   195
         End
         Begin VB.Label Label4 
            Caption         =   "x"
            Height          =   255
            Left            =   120
            TabIndex        =   39
            Top             =   480
            Width           =   195
         End
         Begin VB.Label Label9 
            Caption         =   "Object Offset"
            Height          =   255
            Left            =   120
            TabIndex        =   32
            Top             =   120
            Width           =   1095
         End
         Begin VB.Label Label8 
            Caption         =   "Scale Object Size"
            Height          =   255
            Left            =   120
            TabIndex        =   31
            Top             =   1860
            Width           =   1395
         End
         Begin VB.Line Line10 
            BorderColor     =   &H80000010&
            X1              =   0
            X2              =   2400
            Y1              =   2580
            Y2              =   2580
         End
         Begin VB.Line Line9 
            BorderColor     =   &H80000014&
            X1              =   0
            X2              =   2400
            Y1              =   2595
            Y2              =   2595
         End
         Begin VB.Line Line8 
            BorderColor     =   &H80000010&
            X1              =   0
            X2              =   2400
            Y1              =   1680
            Y2              =   1680
         End
         Begin VB.Line Line7 
            BorderColor     =   &H80000014&
            X1              =   0
            X2              =   2400
            Y1              =   1695
            Y2              =   1695
         End
      End
      Begin ComctlLib.TabStrip TabToolbox 
         Height          =   3375
         Left            =   0
         TabIndex        =   3
         Top             =   2580
         Width           =   2595
         _ExtentX        =   4577
         _ExtentY        =   5953
         _Version        =   327682
         BeginProperty Tabs {0713E432-850A-101B-AFC0-4210102A8DA7} 
            NumTabs         =   2
            BeginProperty Tab1 {0713F341-850A-101B-AFC0-4210102A8DA7} 
               Caption         =   "Faces"
               Key             =   ""
               Object.Tag             =   ""
               ImageVarType    =   2
            EndProperty
            BeginProperty Tab2 {0713F341-850A-101B-AFC0-4210102A8DA7} 
               Caption         =   "Object"
               Key             =   ""
               Object.Tag             =   ""
               ImageVarType    =   2
            EndProperty
         EndProperty
      End
   End
   Begin ComctlLib.StatusBar Status 
      Align           =   2  'Align Bottom
      Height          =   315
      Left            =   0
      TabIndex        =   0
      Top             =   7275
      Width           =   10245
      _ExtentX        =   18071
      _ExtentY        =   556
      SimpleText      =   ""
      _Version        =   327682
      BeginProperty Panels {0713E89E-850A-101B-AFC0-4210102A8DA7} 
         NumPanels       =   4
         BeginProperty Panel1 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            Text            =   "Ready"
            TextSave        =   "Ready"
            Key             =   ""
            Object.Tag             =   ""
         EndProperty
         BeginProperty Panel2 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            AutoSize        =   2
            Object.Width           =   1323
            MinWidth        =   1323
            TextSave        =   ""
            Key             =   ""
            Object.Tag             =   ""
         EndProperty
         BeginProperty Panel3 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            AutoSize        =   2
            Object.Width           =   1323
            MinWidth        =   1323
            Text            =   "(0, 0, 0) "
            TextSave        =   "(0, 0, 0) "
            Key             =   ""
            Object.Tag             =   ""
         EndProperty
         BeginProperty Panel4 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            AutoSize        =   1
            Object.Width           =   12303
            TextSave        =   ""
            Key             =   ""
            Object.Tag             =   ""
         EndProperty
      EndProperty
   End
   Begin ComctlLib.ImageList ImgToolbar 
      Left            =   0
      Top             =   6540
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   65280
      _Version        =   327682
      BeginProperty Images {0713E8C2-850A-101B-AFC0-4210102A8DA7} 
         NumListImages   =   11
         BeginProperty ListImage1 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Frm3do.frx":030A
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Frm3do.frx":041C
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Frm3do.frx":052E
            Key             =   ""
         EndProperty
         BeginProperty ListImage4 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Frm3do.frx":0640
            Key             =   ""
         EndProperty
         BeginProperty ListImage5 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Frm3do.frx":0752
            Key             =   ""
         EndProperty
         BeginProperty ListImage6 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Frm3do.frx":0864
            Key             =   ""
         EndProperty
         BeginProperty ListImage7 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Frm3do.frx":0976
            Key             =   ""
         EndProperty
         BeginProperty ListImage8 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Frm3do.frx":0A88
            Key             =   ""
         EndProperty
         BeginProperty ListImage9 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Frm3do.frx":0B9A
            Key             =   ""
         EndProperty
         BeginProperty ListImage10 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Frm3do.frx":0CAC
            Key             =   ""
         EndProperty
         BeginProperty ListImage11 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Frm3do.frx":0DBE
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin VB.Menu mnuFile 
      Caption         =   "&File"
      Begin VB.Menu mnuFileNew 
         Caption         =   "&New"
         Shortcut        =   ^N
      End
      Begin VB.Menu mnuFileOpen 
         Caption         =   "&Open..."
         Shortcut        =   ^O
      End
      Begin VB.Menu mnuFileSave 
         Caption         =   "&Save"
         Shortcut        =   ^S
      End
      Begin VB.Menu mnuFileSaveAs 
         Caption         =   "Save &As..."
         Shortcut        =   ^A
      End
      Begin VB.Menu mnuFileBreak1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileImport 
         Caption         =   "&Import Model..."
      End
      Begin VB.Menu mnuFileExport 
         Caption         =   "&Export Model..."
      End
      Begin VB.Menu mnuFileBreak4 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileExportUnitViewer 
         Caption         =   "Export to &Unit Viewer..."
         Shortcut        =   {F5}
      End
      Begin VB.Menu mnuFileExportUnitViewCustom 
         Caption         =   "Export to Unit Viewer (Custom)..."
      End
      Begin VB.Menu mnuFileBreak3 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileImportTextures 
         Caption         =   "Import &Textures..."
      End
      Begin VB.Menu mnuFileExportTextures 
         Caption         =   "E&xport Textures..."
         Visible         =   0   'False
      End
      Begin VB.Menu mnuFileBreak2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileExit 
         Caption         =   "E&xit"
      End
   End
   Begin VB.Menu mnuView 
      Caption         =   "&View"
      Begin VB.Menu mnuViewGrid 
         Caption         =   "&Grid"
      End
      Begin VB.Menu mnuViewGridSize 
         Caption         =   "Grid &Size..."
      End
      Begin VB.Menu mnuViewBreak1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuViewZoomIn 
         Caption         =   "Zoom &In"
         Shortcut        =   {F7}
      End
      Begin VB.Menu mnuViewZoomOut 
         Caption         =   "Zoom &Out"
         Shortcut        =   {F8}
      End
      Begin VB.Menu mnuViewAutoCenter 
         Caption         =   "&Auto-Center View"
         Checked         =   -1  'True
      End
      Begin VB.Menu mnuViewBreak2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuViewView 
         Caption         =   "&View"
         Begin VB.Menu mnuViewFront 
            Caption         =   "&Front"
         End
         Begin VB.Menu mnuViewTop 
            Caption         =   "&Top"
         End
         Begin VB.Menu mnuViewSide 
            Caption         =   "&Side"
         End
         Begin VB.Menu mnuViewOpenGLView 
            Caption         =   "&OpenGL View"
         End
         Begin VB.Menu mnuViewViewBreak1 
            Caption         =   "-"
         End
         Begin VB.Menu mnuViewAll 
            Caption         =   "&All"
            Checked         =   -1  'True
         End
      End
      Begin VB.Menu mnuViewOpenGL 
         Caption         =   "&OpenGL View"
         Begin VB.Menu mnuViewOpenGLWireframe 
            Caption         =   "Wireframe"
         End
         Begin VB.Menu mnuViewOpenGLGouraud 
            Caption         =   "Gouraud Shaded"
         End
         Begin VB.Menu mnuViewOpenGLBreak1 
            Caption         =   "-"
         End
         Begin VB.Menu mnuViewRefreshGL 
            Caption         =   "Refresh Model..."
            Shortcut        =   {F6}
         End
      End
      Begin VB.Menu mnuViewBreak5 
         Caption         =   "-"
      End
      Begin VB.Menu mnuViewStartupOptions 
         Caption         =   "S&tartup Options..."
      End
      Begin VB.Menu mnuSpecialTALocation 
         Caption         =   "Set Custom &TA Location..."
      End
      Begin VB.Menu mnuViewBreak6 
         Caption         =   "-"
      End
      Begin VB.Menu mnuViewOptions 
         Caption         =   "&Display Options..."
      End
   End
   Begin VB.Menu mnuObjects 
      Caption         =   "&Objects"
      Begin VB.Menu mnuObjectsImportDXF 
         Caption         =   "&Import Object..."
         Shortcut        =   ^I
      End
      Begin VB.Menu mnuObjectsExportDXF 
         Caption         =   "&Export Object..."
         Shortcut        =   ^E
      End
      Begin VB.Menu mnuObjectsExportAll 
         Caption         =   "Export &All Objects..."
      End
      Begin VB.Menu mnuObjectsBreak1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuObjectsCreate 
         Caption         =   "&Create Object..."
         Shortcut        =   ^C
      End
      Begin VB.Menu mnuObjectsRemove 
         Caption         =   "&Remove Object"
         Shortcut        =   {DEL}
      End
      Begin VB.Menu mnuObjectsBreak2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuObjectsImportScaleValue 
         Caption         =   "Import &Scale Value..."
      End
   End
   Begin VB.Menu mnuSpecial 
      Caption         =   "&Special"
      Begin VB.Menu mnuSpecialInverseFace 
         Caption         =   "Inverse &Face"
         Shortcut        =   {F2}
      End
      Begin VB.Menu mnuSpecialInverseObjectFaces 
         Caption         =   "Inverse &Object Faces"
         Shortcut        =   {F3}
      End
      Begin VB.Menu mnuSpecialInverseAllFaces 
         Caption         =   "&Inverse All Faces"
         Shortcut        =   {F4}
      End
      Begin VB.Menu mnuSpecialBreak1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuSpecialCreateBase 
         Caption         =   "&Add Unit Ground Plate"
      End
      Begin VB.Menu mnuSpecialSetBase 
         Caption         =   "&Set Face as Unit Ground Plate"
         Shortcut        =   ^G
      End
      Begin VB.Menu mnuSpecialBaseSize 
         Caption         =   "&Change Ground Plate Size..."
      End
      Begin VB.Menu mnuSpecialBreak2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuSpecialScaleAll 
         Caption         =   "Sca&le All Objects..."
      End
      Begin VB.Menu mnuSpecialBreak3 
         Caption         =   "-"
      End
      Begin VB.Menu mnuSpecialCreateUnitpic 
         Caption         =   "Create &Unit Picture..."
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "&Help"
      Begin VB.Menu mnuHelpTips 
         Caption         =   "3DO Builder &Tips..."
         Shortcut        =   {F1}
      End
      Begin VB.Menu mnuHelpBreak1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileAbout 
         Caption         =   "&About 3DO Builder..."
      End
   End
End
Attribute VB_Name = "Frm3do"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private StartX As Long, StartY As Long
Private LoadFile As String
Public TreeMove As Boolean ' Tree item move flag. '

Public Function FindViewer() As Long
    Dim Buffer As String * 64
    Dim NewHwnd As Long
    Dim rc As Long
    
    NewHwnd = GetNextWindow(hwnd, GW_HWNDFIRST)
    Do While NewHwnd <> 0
        rc = GetWindowText(NewHwnd, Buffer, 63)
        If Left(Buffer, Len("Total Annihilation Unit Viewer")) = "Total Annihilation Unit Viewer" Then
            FindViewer = NewHwnd
            Exit Do
        End If
        NewHwnd = GetNextWindow(NewHwnd, GW_HWNDNEXT)
    Loop
End Function

Private Sub CmdApply_Click()
    FrmTextureApply.Show 1
End Sub

Private Sub CmdApplyOffset_Click()
    Dim Vertex As New class3dVertex
    
    On Error Resume Next
    Vertex.x = Val(TxtOffsetX)
    Vertex.y = Val(TxtOffsetY)
    Vertex.z = Val(TxtOffsetZ)
    SelectedObject.SetOffset Vertex
    GetCenterModel
    Render
End Sub

Private Sub CmdApplyScale_Click()
    On Error Resume Next
    SelectedObject.ScaleObject Val(TxtScale)
    TxtScale = "1.0"
    GetCenterModel
    Render
End Sub

Private Sub CmdClearTexture_Click()
    SelectedObject.SetTextureName SelectedPrimitive, ""
    SelectedObject.SetColor SelectedPrimitive, -1
    RefreshFace
End Sub

Private Sub CmdColor_Click()
    On Error Resume Next
    FrmColorPalette.Show 1
    If SelectedColor <> -1 Then
        SelectedObject.SetTextureName SelectedPrimitive, ""
        SelectedObject.SetColor SelectedPrimitive, SelectedColor
        RefreshFace
    End If
End Sub

Private Sub Form_Load()
    On Error Resume Next
    Initialize
    Show
    CreateTexturePalette
    If LoadFile <> "" Then ' Open the file on the command line. '
        Load3do LoadFile
        LoadFile = ""
    End If
    frmTip.Show
End Sub

Public Sub Initialize()
    Dim rc As Boolean
    
    LoadSettings
    rc = RegisterFile("3do", App.Path & "\" & App.EXEName & ".exe", , "3DOBuilder", "3DO Builder")
    InitializeCommands
    FrmStartup.Show 1
    
    ' Initialize values. '
    ZoomFactor = 2
    ScaleConstant = 1
    CRLF = Chr(13) & Chr(10)
    New3do
    
    If TALocation <> "\" Then
        CreateHPIList
        LoadTextures
    End If
    InitializeGraphics
    InitializeInterface
    
    LstOrientation.Clear
    LstOrientation.AddItem "0°"
    LstOrientation.AddItem "90°"
    LstOrientation.AddItem "180°"
    LstOrientation.AddItem "270°"
    LstOrientation.ListIndex = 0
End Sub

' Parse the command line for files to open. '
Sub InitializeCommands()
    Dim Buffer As String
    Dim QuoteMark As String
    Dim rc As Long
    
    On Error Resume Next
    If Command = "" Then Exit Sub
    If Dir(App.Path & "\unitview.exe") = "" Then
        'MsgBox "You must have the unit viewer installed in your 3do builder directory to use this option.", vbInformation
        Exit Sub
    End If
    
    ' Remove " marks. '
    QuoteMark = """"
    Buffer = Command
    If Right(Command, 1) = QuoteMark Then
        Buffer = Left(Command, Len(Command) - 1)
    End If
    If Left(Buffer, 1) = QuoteMark Then
        Buffer = Right(Buffer, Len(Buffer) - 1)
    End If
    
    Select Case LCase(Right(Buffer, 3))
        Case "3do"
            If Launch = 0 Then FrmStartupOption.Show 1
            Select Case Launch
                Case LaunchBuilder
                    LoadFile = Buffer
                Case LaunchViewer
                    Screen.MousePointer = vbHourglass
                    If Not SaveTestHPI(App.Path & "\cor3doBuilderUnit.ufo", "cor", , , Buffer) Then Exit Sub
                    If Not SaveTestHPI(App.Path & "\arm3doBuilderUnit.ufo", "arm", , , Buffer) Then Exit Sub
                    ChDir App.Path
                    rc = ShellExecute(0, "open", App.Path & "\unitview.exe", "", App.Path, SW_SHOWDEFAULT)
                    Screen.MousePointer = vbNormal
                    Unload Me
            End Select
    End Select
End Sub

Public Sub InitializeGraphics()
    LoadPalette
    If Not TexturePalette.Initialize(640, 640, PicTextures.hwnd) Then
        MsgBox "The memory for the graphics window could not be allocated.  Try clearing up memory, hard drive space, or rebooting.", vbInformation
        Unload Me
    End If
    
    If Initialize3D(TAPalette()) = 0 Then MsgBox "Initialize3D failed", vbExclamation, "Error"
    CreateView PicView.hwnd, PicView.ScaleWidth, PicView.ScaleHeight
    Set3DView OpenGLType, OpenGLColor
    'CreateFront PicFront.hwnd, PicFront.ScaleWidth, PicFront.ScaleHeight
    'CreateTop PicTop.hwnd, PicTop.ScaleWidth, PicTop.ScaleHeight
    'CreateRight PicRight.hwnd, PicRight.ScaleWidth, PicRight.ScaleHeight
    'SetView 2, 255      ' background should be white
End Sub

Public Sub FreeGraphics()
    Dim rc As Long
    
    If TexturePalette.hBitmap <> 0 Then
        rc = DeleteObject(TexturePalette.hBitmap)
    End If
End Sub

Private Sub Form_Resize()
    On Error Resume Next
    DoEvents
    If WindowState = vbMinimized Then Exit Sub
    PicToolbox.Height = ScaleHeight - PicToolbox.Top - Status.Height
    TabToolbox.Top = PicToolbox.ScaleHeight - TabToolbox.Height
    PicObject.Top = TabToolbox.Top + 350
    PicFaces.Top = TabToolbox.Top + 350
    Tree3do.Height = TabToolbox.Top - Tree3do.Top - 60
    
    PicTextures.Left = ScaleWidth - PicTextures.Width
    PicTextureSize.Left = PicTextures.Left - PicTextureSize.Width
    PicTextureSize.Height = ScaleHeight - PicTextureSize.Top - Status.Height
    LstTextures.Left = PicTextures.Left
    LstTextures.Width = PicTextures.Width
    PicTextures.Height = ScaleHeight - PicTextures.Top - Status.Height
    ScrollTextures.Left = PicTextures.ScaleWidth - ScrollTextures.Width
    ScrollTextures.Height = PicTextures.ScaleHeight
    
    PicViews.Width = ScaleWidth - PicViews.Left - (ScaleWidth - PicTextureSize.Left) - 2
    PicViews.Height = ScaleHeight - PicToolbox.Top - Status.Height
    If ViewFull = 0 Then
        PicFront.Visible = True
        PicTop.Visible = True
        PicRight.Visible = True
        PicView.Visible = True
        If (ScaleWidth - PicViews.Left) > 100 And (ScaleHeight - PicToolbox.Top - Status.Height) > 100 Then
            PicFront.Width = Int(PicViews.ScaleWidth / 2) - 20
            PicFront.Height = Int(PicViews.ScaleHeight / 2) - 20
            PicView.Width = PicFront.Width
            PicView.Height = PicFront.Height
            PicTop.Width = PicFront.Width
            PicTop.Height = PicFront.Height
            PicRight.Width = PicFront.Width
            PicRight.Height = PicFront.Height
            PicView.Left = PicViews.ScaleWidth - PicView.Width
            PicTop.Top = PicViews.ScaleHeight - PicTop.Height
            PicRight.Left = PicViews.ScaleWidth - PicRight.Width
            PicRight.Top = PicViews.ScaleHeight - PicRight.Height
        End If
    ElseIf ViewFull = ViewFront Then
        PicFront.Visible = True
        PicTop.Visible = False
        PicRight.Visible = False
        PicView.Visible = False
        PicFront.Left = 0
        PicFront.Top = 0
        PicFront.Width = PicViews.ScaleWidth
        PicFront.Height = PicViews.ScaleHeight
    ElseIf ViewFull = ViewTop Then
        PicFront.Visible = False
        PicTop.Visible = True
        PicRight.Visible = False
        PicView.Visible = False
        PicTop.Left = 0
        PicTop.Top = 0
        PicTop.Width = PicViews.ScaleWidth
        PicTop.Height = PicViews.ScaleHeight
    ElseIf ViewFull = ViewSide Then
        PicFront.Visible = False
        PicTop.Visible = False
        PicRight.Visible = True
        PicView.Visible = False
        PicRight.Left = 0
        PicRight.Top = 0
        PicRight.Width = PicViews.ScaleWidth
        PicRight.Height = PicViews.ScaleHeight
    ElseIf ViewFull = ViewView Then
        PicFront.Visible = False
        PicTop.Visible = False
        PicRight.Visible = False
        PicView.Visible = True
        PicView.Left = 0
        PicView.Top = 0
        PicView.Width = PicViews.ScaleWidth
        PicView.Height = PicViews.ScaleHeight
    End If
    
    Render
    CreateTexturePalette
    
    ResizeView PicView.ScaleWidth, PicView.ScaleHeight
    ResizeFront PicFront.ScaleWidth, PicFront.ScaleHeight
    ResizeTop PicTop.ScaleWidth, PicTop.ScaleHeight
    ResizeRight PicRight.ScaleWidth, PicRight.ScaleHeight
End Sub

Private Sub Form_Unload(Cancel As Integer)
    SaveSettings
    FreeGraphics
    Cleanup3D
    End
End Sub

Private Sub LstOrientation_Click()
    On Error Resume Next
    SelectedObject.SetAngle SelectedPrimitive, Val(LstOrientation.Text)
End Sub

Private Sub LstTextures_Click()
    On Error Resume Next
    ScrollTextures.Value = 0
    Set SelectedPalette = Textures(LstTextures.ListIndex)
    SelectedPalette.LoadImages
    CreateTexturePalette
End Sub

Private Sub mnuFileAbout_Click()
    FrmAbout.Show 1
End Sub

Private Sub mnuFileExit_Click()
    Unload Me
End Sub

Private Sub mnuFileExport_Click()
    On Error GoTo Error
    CommonDialog.Filter = "DXF files (*.dxf)|*.dxf"
    CommonDialog.DefaultExt = "dxf"
    CommonDialog.Filename = ""
    CommonDialog.InitDir = SaveDxfDir
    CommonDialog.ShowSave
    If (CommonDialog.Filename <> "") And (Not Err) Then
        SaveDxfDir = GetDirectory(CommonDialog.Filename)
        Screen.MousePointer = vbHourglass
        SaveDXF CommonDialog.Filename
    End If
Error:
    Screen.MousePointer = vbNormal
End Sub

Private Sub mnuFileExportUnitViewCustom_Click()
    If Dir(App.Path & "\unitview.exe") = "" Then
        MsgBox "You must have the unit viewer installed in your 3do builder directory to use this option.", vbInformation
        Exit Sub
    End If
    
    FrmExportUnitViewer.Show
End Sub

Private Sub mnuFileExportUnitViewer_Click()
    Dim rc As Long
    
    On Error Resume Next
    If Dir(App.Path & "\unitview.exe") = "" Then
        MsgBox "You must have the unit viewer installed in your 3do builder directory to use this option.", vbInformation
        Exit Sub
    End If
    
    Screen.MousePointer = vbHourglass
    Kill App.Path & "\arm3doBuilderUnit.ufo"
    Kill App.Path & "\cor3doBuilderUnit.ufo"
    If Not SaveTestHPI(App.Path & "\cor3doBuilderUnit.ufo", "cor") Then Exit Sub
    If Not SaveTestHPI(App.Path & "\arm3doBuilderUnit.ufo", "arm") Then Exit Sub
        
    ChDir App.Path
    'rc = Shell(App.Path & "\unitview.exe", vbNormalFocus)
    rc = ShellExecute(0, "open", App.Path & "\unitview.exe", "", App.Path, SW_SHOWDEFAULT)
    Screen.MousePointer = vbNormal
End Sub

Private Sub mnuFileImport_Click()
    On Error Resume Next
    CommonDialog.Filter = "DXF files (*.dxf)|*.dxf"
    CommonDialog.Filename = ""
    CommonDialog.InitDir = OpenDxfDir
    CommonDialog.ShowOpen
    If (CommonDialog.Filename <> "") And (Not Err) Then
        OpenDxfDir = GetDirectory(CommonDialog.Filename)
        Screen.MousePointer = vbHourglass
        New3do
        ImportDXF CommonDialog.Filename
        Screen.MousePointer = vbNormal
    End If
End Sub

Private Sub mnuFileImportTextures_Click()
    FrmImportTextures.Show
End Sub

Private Sub mnuFileNew_Click()
    New3do
End Sub

Private Sub mnuFileOpen_Click()
    On Error GoTo Error
    CommonDialog.Filter = "3do files (*.3do)|*.3do"
    CommonDialog.Filename = ""
    CommonDialog.InitDir = Open3doDir
    CommonDialog.ShowOpen
    If (CommonDialog.Filename <> "") And (Not Err) Then
        Open3doDir = GetDirectory(CommonDialog.Filename)
        Screen.MousePointer = vbHourglass
        Load3do CommonDialog.Filename
    End If
Error:
    Screen.MousePointer = vbNormal
End Sub

Private Sub mnuFileSave_Click()
    On Error GoTo Error
    Screen.MousePointer = vbHourglass
    Save3do OpenFile
Error:
    Screen.MousePointer = vbNormal
End Sub

Private Sub mnuFileSaveAs_Click()
    On Error GoTo Error
    CommonDialog.Filter = "3do files (*.3do)|*.3do"
    CommonDialog.DefaultExt = "3do"
    CommonDialog.Filename = OpenFile
    CommonDialog.InitDir = Save3doDir
    CommonDialog.ShowSave
    If (CommonDialog.Filename <> "") And (Not Err) Then
        Save3doDir = GetDirectory(CommonDialog.Filename)
        Screen.MousePointer = vbHourglass
        Save3do CommonDialog.Filename
        OpenFile = CommonDialog.Filename
        UpdateCaption
    End If
Error:
    Screen.MousePointer = vbNormal
End Sub

Private Sub mnuHelpTips_Click()
    On Error Resume Next
    TipShow = True
    frmTip.Show
End Sub

Private Sub mnuObjectsCreate_Click()
    Dim Buffer As String
    
    On Error Resume Next
    Buffer = InputBox("Enter a name for the object:", "Create Object")
    If Buffer = "" Then Exit Sub
    SelectedObject.CreateChild Buffer
End Sub

Private Sub mnuObjectsExportAll_Click()
    Screen.MousePointer = vbHourglass
    ExportAllDXF
    Screen.MousePointer = vbNormal
End Sub

Private Sub mnuObjectsExportDXF_Click()
    On Error Resume Next
    CommonDialog.Filter = "3d object files (*.dxf)|*.dxf"
    CommonDialog.DefaultExt = "dxf"
    CommonDialog.Filename = ""
    CommonDialog.InitDir = SaveDxfDir
    CommonDialog.ShowSave
    If (CommonDialog.Filename <> "") And (Not Err) Then
        SaveDxfDir = GetDirectory(CommonDialog.Filename)
        Screen.MousePointer = vbHourglass
        ExportDXF CommonDialog.Filename
        Screen.MousePointer = vbNormal
    End If
End Sub

Private Sub mnuObjectsImportDXF_Click()
    On Error Resume Next
    CommonDialog.Filter = "3D object files (*.dxf, *.lwo, *.obj)|*.dxf; *.lwo; *.obj"
    CommonDialog.Filename = ""
    CommonDialog.InitDir = OpenDxfDir
    CommonDialog.ShowOpen
    If (CommonDialog.Filename <> "") And (Not Err) Then
        OpenDxfDir = GetDirectory(CommonDialog.Filename)
        Screen.MousePointer = vbHourglass
        Select Case LCase(Right(CommonDialog.Filename, 3))
            Case "dxf"
                ImportDXF CommonDialog.Filename
            Case "lwo"
                ImportLWO CommonDialog.Filename
            Case "obj"
                ImportOBJ CommonDialog.Filename
        End Select
        Screen.MousePointer = vbNormal
    End If
End Sub

Private Sub mnuObjectsImportScaleValue_Click()
    ScaleConstant = Val(InputBox("Enter a value to scale all imported objects.", "Scale Constant", CStr(ScaleConstant)))
    If ScaleConstant <= 0 Then ScaleConstant = 1
End Sub

Private Sub mnuObjectsRemove_Click()
    Dim Response As Integer
    
    On Error Resume Next
    If SelectedObject.Name = File3do.Name Then
        MsgBox "You cannot remove the base object.", vbInformation, "Remove Object"
        Exit Sub
    End If
    
    File3do.RemoveObject SelectedObject.Name
    CreateInterface
End Sub

Private Sub mnuSpecialBaseSize_Click()
    FrmBaseSize.Show
End Sub

Private Sub mnuSpecialCreateBase_Click()
    File3do.CreateBase
    UpdateInterface
End Sub

Private Sub mnuSpecialCreateUnitpic_Click()
    FrmUnitPic.Show
End Sub

Private Sub mnuSpecialInverseAllFaces_Click()
    On Error Resume Next
    File3do.InverseFaces True
End Sub

Private Sub mnuSpecialInverseFace_Click()
    On Error Resume Next
    SelectedObject.InverseFace SelectedPrimitive
End Sub

Private Sub mnuSpecialInverseObjectFaces_Click()
    On Error Resume Next
    SelectedObject.InverseFaces
    Render
End Sub

Private Sub mnuSpecialScaleAll_Click()
    Dim ScaleValue As Single
    
    ScaleValue = Val(InputBox("Enter a value to scale all objects.", "Scale Objects", "1.0"))
    If ScaleValue <= 0 Then ScaleValue = 1
    File3do.ScaleAll ScaleValue
    UpdateInterface
End Sub

Private Sub mnuSpecialSetBase_Click()
    File3do.SetBase SelectedPrimitive
    Render
End Sub

Private Sub mnuSpecialTALocation_Click()
    FrmDirectory.Show 1
    SetTALocation = DirectoryReturn
End Sub

Private Sub mnuViewAll_Click()
    ViewFull = 0
    Form_Resize
    UpdateViewMenu
End Sub

Private Sub mnuViewAutoCenter_Click()
    mnuViewAutoCenter.Checked = Not mnuViewAutoCenter.Checked
    AutoCenter = mnuViewAutoCenter.Checked
    UpdateInterface
End Sub

Private Sub mnuViewFront_Click()
    ViewFull = ViewFront
    Form_Resize
    UpdateViewMenu
End Sub

Private Sub mnuViewGrid_Click()
    mnuViewGrid.Checked = Not mnuViewGrid.Checked
    ShowGrid = mnuViewGrid.Checked
    Render
End Sub

Private Sub mnuViewGridSize_Click()
    FrmGridSize.Show 1
    Render
End Sub

Private Sub mnuViewOpenGLGouraud_Click()
    OpenGLType = DisplayGouraud
    Set3DView OpenGLType, OpenGLColor
    DrawView
    mnuViewOpenGLWireframe.Checked = False
    mnuViewOpenGLGouraud.Checked = True
End Sub

Private Sub mnuViewOpenGLView_Click()
    ViewFull = ViewView
    Form_Resize
    UpdateViewMenu
End Sub

Private Sub mnuViewOpenGLWireframe_Click()
    OpenGLType = DisplayWireframe
    Set3DView OpenGLType, OpenGLColor
    DrawView
    mnuViewOpenGLWireframe.Checked = True
    mnuViewOpenGLGouraud.Checked = False
End Sub

Private Sub mnuViewOptions_Click()
    FrmOptions.Show 1
End Sub

Private Sub mnuViewRefreshGL_Click()
    CreateOpenGLModel
End Sub

Private Sub mnuViewSide_Click()
    ViewFull = ViewSide
    Form_Resize
    UpdateViewMenu
End Sub

Private Sub mnuViewStartupOptions_Click()
    FrmStartupOption.Show 1
End Sub

Private Sub mnuViewTop_Click()
    ViewFull = ViewTop
    Form_Resize
    UpdateViewMenu
End Sub

Private Sub mnuViewZoomIn_Click()
    If ZoomFactor + 0.5 < 6 Then
        ZoomFactor = ZoomFactor + 0.5
    End If
    Render
End Sub

Private Sub mnuViewZoomOut_Click()
    If ZoomFactor - 0.5 > 0 Then
        ZoomFactor = ZoomFactor - 0.5
    End If
    Render
End Sub

Private Sub PicFront_DblClick()
    If ViewFull = 0 Then
        ViewFull = ViewFront
    Else
        ViewFull = 0
    End If
    UpdateViewMenu
    Form_Resize
End Sub

Private Sub PicFront_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    On Error GoTo Error
    
    Select Case SelectedTool
        Case ToolDefault
            'SelectFront X, Y, SelObj, SelFace
        Case ToolMove
            File3do.ChangeOffset SelectedObject.Name, x, y, -1, 0, 0, 0
            RefreshObject
            Render
    End Select
Error:
End Sub

Private Sub PicFront_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
    ToolsUpdateMouse x, y, ViewFront
End Sub

Private Sub PicFront_Paint()
    'DrawFront
End Sub

Private Sub PicRight_DblClick()
    If ViewFull = 0 Then
        ViewFull = ViewSide
    Else
        ViewFull = 0
    End If
    UpdateViewMenu
    Form_Resize
End Sub

Private Sub PicRight_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    'SelectRight X, Y, SelObj, SelFace
    On Error GoTo Error
    
    Select Case SelectedTool
        Case ToolMove
            File3do.ChangeOffset SelectedObject.Name, -1, y, x, 0, 0, 0
            RefreshObject
            Render
            'UpdateInterface
    End Select
Error:
End Sub

Private Sub PicRight_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
    ToolsUpdateMouse x, y, ViewSide
End Sub

Private Sub PicRight_Paint()
    'DrawRight
End Sub

Private Sub PicTexture_Click()
    SetTexture LblTexture
End Sub

Private Sub PicTextures_DblClick()
    On Error Resume Next
    SelectedObject.SetTextureName SelectedPrimitive, SelectedTexture.Name
    SelectedObject.SetColor SelectedPrimitive, -1
    LblTexture = SelectedTexture.Name
    If LblTexture = "" Then LblTexture = "none"
    DisplayTexture SelectedTexture.Name
End Sub

Private Sub PicTextures_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    On Error Resume Next
    Textures(LstTextures.ListIndex).SelectTexture y
End Sub

Private Sub PicTextureSize_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    If Button = vbLeftButton Then
        'change the splitter colour
        PicTextureSize.BackColor = SPLT_COLOUR
        'set the current position to x
        currSplitPosX = CLng(x)
    Else
        'not the left button, so... if the current position <> default, cause a mouseup
        If currSplitPosX <> &H7FFFFFFF Then PicTextureSize_MouseUp Button, Shift, x, y
        'set the current position to the default value
        currSplitPosX = &H7FFFFFFF
    End If
End Sub

Private Sub PicTextureSize_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
    'if the splitter has been moved...
    If currSplitPosX& <> &H7FFFFFFF Then
        'if the current position <> default, reposition the splitter and set this as the current value
        If CLng(x) <> currSplitPosX Then
            If (PicTextureSize.Left + x <= ScaleWidth - 1000) And (PicTextureSize.Left + x >= ScaleWidth - Int(ScaleWidth / 3)) Then
                PicTextureSize.Move PicTextureSize.Left + x, CTRL_OFFSET, SPLT_WDTH, ScaleHeight - (CTRL_OFFSET * 2)
            ElseIf (PicTextureSize.Left + x > ScaleWidth - 1000) Then
                PicTextureSize.Move ScaleWidth - 1000, CTRL_OFFSET, SPLT_WDTH, ScaleHeight - (CTRL_OFFSET * 2)
            ElseIf (PicTextureSize.Left + x < ScaleWidth - Int(ScaleWidth / 3)) Then
                PicTextureSize.Move ScaleWidth - Int(ScaleWidth / 3), CTRL_OFFSET, SPLT_WDTH, ScaleHeight - (CTRL_OFFSET * 2)
            End If
            currSplitPosX = CLng(x)
        End If
    End If
End Sub

Private Sub PicTextureSize_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
    'if the splitter has been moved...
    If currSplitPosX <> &H7FFFFFFF Then
        'if the current position <> the last position do a final move of the splitter
        If CLng(x) <> currSplitPosX Then
            If (PicTextureSize.Left + x < ScaleWidth - 1000) And (PicTextureSize.Left + x > ScaleWidth - Int(ScaleWidth / 2)) Then
                PicTextureSize.Move PicTextureSize.Left + x, CTRL_OFFSET, SPLT_WDTH, ScaleHeight - (CTRL_OFFSET * 2)
            End If
        End If
        ' The default position. '
        currSplitPosX = &H7FFFFFFF
        ' Restore the normal splitter color. '
        PicTextureSize.BackColor = &H8000000F
        PicTextures.Width = ScaleWidth - PicTextureSize.Left + PicTextureSize.Width
        Form_Resize
    End If
End Sub

Private Sub PicTop_DblClick()
    If ViewFull = 0 Then
        ViewFull = ViewTop
    Else
        ViewFull = 0
    End If
    UpdateViewMenu
    Form_Resize
End Sub

Private Sub PicTop_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    'SelectTop X, Y, SelObj, SelFace
    On Error GoTo Error
    
    Select Case SelectedTool
        Case ToolMove
            File3do.ChangeOffset SelectedObject.Name, x, -1, y, 0, 0, 0
            RefreshObject
            Render
            'UpdateInterface
    End Select
Error:
End Sub

Private Sub PicTop_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
    ToolsUpdateMouse x, y, ViewTop
End Sub

Private Sub PicTop_Paint()
    'DrawTop
End Sub

Private Sub PicView_DblClick()
    If ViewFull = 0 Then
        ViewFull = ViewView
    Else
        ViewFull = 0
    End If
    UpdateViewMenu
    Form_Resize
End Sub

Private Sub PicView_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    ' Rotate mode. '
    If Button = 1 Then
        'SelectView X, Y, SelObj, SelFace
    End If
    
    If Button > 0 Then
        StartX = x
        StartY = y
    End If
End Sub

Private Sub PicView_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
    ' Rotate mode. '
    On Error Resume Next
    If Button > 0 Then
        If (StartX - x) > 0 Then
            RotateView 0, -Abs(StartX - x) / 30, 0
        Else
            RotateView 0, Abs(StartX - x) / 30, 0
        End If
        If (StartY - y) > 0 Then
            RotateView Abs(StartY - y) / 30, 0, 0
        Else
            RotateView -Abs(StartY - y) / 30, 0, 0
        End If
        StartX = x
        StartY = y
        DrawView
    End If
End Sub

Private Sub PicView_Paint()
    DrawView
End Sub

Private Sub ScrollPrimitive_Change()
    RefreshFace
End Sub

Private Sub ScrollPrimitive_Scroll()
    On Error Resume Next
    TxtPrimitive.Text = CStr(ScrollPrimitive.Value) & ":" & CStr(SelectedObject.PrimitiveCount - 1)
End Sub

Private Sub ScrollTextures_Change()
    CreateTexturePalette
End Sub

Private Sub ScrollTextures_Scroll()
    CreateTexturePalette
End Sub

Private Sub TabToolbox_Click()
    On Error Resume Next
    Select Case TabToolbox.SelectedItem.Caption
        Case "Faces"
            PicObject.Visible = False
            PicFaces.Visible = True
        Case "Object"
            PicObject.Visible = True
            PicFaces.Visible = False
    End Select
End Sub

Private Sub TmrAnimate_Timer()
    'RotateView 0, 0.1, 0
    'DrawView
End Sub

Private Sub Toolbar_ButtonClick(ByVal Button As ComctlLib.Button)
    Select Case Button.Key
        Case "new"
            mnuFileNew_Click
        Case "open"
            mnuFileOpen_Click
        Case "save"
            mnuFileSaveAs_Click
        Case "unitpic"
            FrmUnitPic.Show
        Case "createobject"
            mnuObjectsCreate_Click
        Case "importdxf"
            mnuObjectsImportDXF_Click
        Case "exportdxf"
            mnuObjectsExportDXF_Click
        Case "zoomin"
            If ZoomFactor + 0.5 < 6 Then
                ZoomFactor = ZoomFactor + 0.5
            End If
            Render
        Case "zoomout"
            If ZoomFactor - 0.5 > 0 Then
                ZoomFactor = ZoomFactor - 0.5
            End If
            Render
        Case "tooldefault"
            SelectedTool = ToolDefault
        Case "toolmove"
            SelectedTool = ToolMove
    End Select
End Sub

Private Sub Tree3do_AfterLabelEdit(Cancel As Integer, NewString As String)
    On Error Resume Next
    If NewString <> "" Then
        SelectedObject.Name = NewString
        Tree3do.SelectedItem.Key = NewString
    End If
End Sub

Private Sub Tree3do_Click()
    On Error Resume Next
    If TreeMove And ((SelectedObject.Name = File3do.Name) Or (SelectedObject.Name = Tree3do.SelectedItem.Key)) Then
        TreeMove = False
        Tree3do.MousePointer = ccArrow
    End If
    If TreeMove Then
        File3do.MoveObject Tree3do.SelectedItem.Key, SelectedObject.Name
        TreeMove = False
        Tree3do.MousePointer = ccArrow
        Exit Sub
    End If
    If SelectedObject.Name = Tree3do.SelectedItem.Key Then Exit Sub
    Set SelectedObject = New class3do
    File3do.SelectObject Tree3do.SelectedItem.Key
    UpdateInterface
    Render
End Sub

Sub SaveSettings()
    Dim Buffer As Long
    
    SaveSetting ProgramName, "Startup", "Loaded", "0"
    If WindowState = vbNormal Then
        SaveSetting ProgramName, "Startup", "Left", Me.Left
        SaveSetting ProgramName, "Startup", "Top", Me.Top
        SaveSetting ProgramName, "Startup", "Width", Me.Width
        SaveSetting ProgramName, "Startup", "Height", Me.Height
    End If
    SaveSetting ProgramName, "Startup", "WindowState", Me.WindowState
    SaveSetting ProgramName, "Startup", "TextureWidth", PicTextures.Width
    
    SaveSetting ProgramName, "Locations", "Open3doDir", Open3doDir
    SaveSetting ProgramName, "Locations", "Save3doDir", Save3doDir
    SaveSetting ProgramName, "Locations", "OpenCobDir", OpenCobDir
    SaveSetting ProgramName, "Locations", "OpenFbiDir", OpenFbiDir
    SaveSetting ProgramName, "Locations", "OpenDxfDir", OpenDxfDir
    SaveSetting ProgramName, "Locations", "SaveDxfDir", SaveDxfDir
    SaveSetting ProgramName, "Locations", "OpenCobFile", OpenCobFile
    SaveSetting ProgramName, "Locations", "OpenFbiFile", OpenFbiFile
    SaveSetting ProgramName, "Locations", "TALocation", SetTALocation
    
    SaveSetting ProgramName, "Colors", "ColorBack", Colors(ColorBack)
    SaveSetting ProgramName, "Colors", "ColorGrid", Colors(ColorGrid)
    SaveSetting ProgramName, "Colors", "ColorModel", Colors(ColorModel)
    SaveSetting ProgramName, "Colors", "ColorObject", Colors(ColorObject)
    SaveSetting ProgramName, "Colors", "ColorFace", Colors(ColorFace)
    SaveSetting ProgramName, "Colors", "ColorPoint", Colors(ColorPoint)
    SaveSetting ProgramName, "Colors", "OpenGLColor", OpenGLColor
    
    SaveSetting ProgramName, "Display", "OpenGLType", OpenGLType
    SaveSetting ProgramName, "Display", "GridInterval", GridInterval
    If DisableGL Then
        Buffer = 1
    Else
        Buffer = 0
    End If
    SaveSetting ProgramName, "Display", "DisableGL", Buffer
    If ShowGrid Then
        Buffer = 1
    Else
        Buffer = 0
    End If
    SaveSetting ProgramName, "Display", "ShowGrid", Buffer
    If AutoCenter Then
        Buffer = 1
    Else
        Buffer = 0
    End If
    SaveSetting ProgramName, "Display", "AutoCenter", Buffer
    
    SaveSetting ProgramName, "Startup", "Launch", Launch
'    If Status.Visible Then Buffer = 1 Else Buffer = 0
'    SaveSetting ProgramName, "Startup", "Status", Buffer
End Sub

Sub LoadSettings()
    Dim Buffer As Long
    
    On Error Resume Next
    FirstLoad = Val(GetSetting(ProgramName, "Startup", "Loaded", 1))
    Buffer = Val(GetSetting(ProgramName, "Startup", "Left", Me.Left))
    If Buffer <> 0 Then Me.Left = Buffer
    Buffer = Val(GetSetting(ProgramName, "Startup", "Top", Me.Top))
    If Buffer <> 0 Then Me.Top = Buffer
    Buffer = Val(GetSetting(ProgramName, "Startup", "Width", Me.Width))
    If Buffer <> 0 Then Me.Width = Buffer
    Buffer = Val(GetSetting(ProgramName, "Startup", "Height", Me.Height))
    If Buffer <> 0 Then Me.Height = Buffer
    Me.WindowState = Val(GetSetting(ProgramName, "Startup", "WindowState", Me.WindowState))
    Buffer = Val(GetSetting(ProgramName, "Startup", "TextureWidth", PicTextures.Width))
    If Buffer <> 0 Then PicTextures.Width = Buffer
    
    Open3doDir = GetSetting(ProgramName, "Locations", "Open3doDir", "")
    Save3doDir = GetSetting(ProgramName, "Locations", "Save3doDir", "")
    OpenCobDir = GetSetting(ProgramName, "Locations", "OpenCobDir", "")
    OpenFbiDir = GetSetting(ProgramName, "Locations", "OpenFbiDir", "")
    OpenDxfDir = GetSetting(ProgramName, "Locations", "OpenDxfDir", "")
    SaveDxfDir = GetSetting(ProgramName, "Locations", "SaveDxfDir", "")
    OpenCobFile = GetSetting(ProgramName, "Locations", "OpenCobFile", "")
    OpenFbiFile = GetSetting(ProgramName, "Locations", "OpenFbiFile", "")
    SetTALocation = GetSetting(ProgramName, "Locations", "TALocation", "")
    
    Colors(ColorBack) = Val(GetSetting(ProgramName, "Colors", "ColorBack", &HFFFFFF))
    Colors(ColorGrid) = Val(GetSetting(ProgramName, "Colors", "ColorGrid", &H808080))
    Colors(ColorModel) = Val(GetSetting(ProgramName, "Colors", "ColorModel", RGB(0, 0, 0)))
    Colors(ColorObject) = Val(GetSetting(ProgramName, "Colors", "ColorObject", RGB(0, 0, 255)))
    Colors(ColorFace) = Val(GetSetting(ProgramName, "Colors", "ColorFace", RGB(255, 0, 0)))
    Colors(ColorPoint) = Val(GetSetting(ProgramName, "Colors", "ColorPoint", RGB(255, 0, 255)))
    OpenGLColor = Val(GetSetting(ProgramName, "Colors", "OpenGLColor", 255))
    InterfaceSetColors
    
    OpenGLType = Val(GetSetting(ProgramName, "Display", "OpenGLType", DisplayWireframe))
    If OpenGLType = DisplayWireframe Then
        mnuViewOpenGLWireframe.Checked = True
    Else
        OpenGLType = DisplayGouraud
        mnuViewOpenGLGouraud.Checked = True
    End If
    DisableGL = (Val(GetSetting(ProgramName, "Display", "DisableGL", 0)) = 1)
    GridInterval = Val(GetSetting(ProgramName, "Display", "GridInterval", 5))
    ShowGrid = (Val(GetSetting(ProgramName, "Display", "ShowGrid", 1)) = 1)
    mnuViewGrid.Checked = ShowGrid
    AutoCenter = (Val(GetSetting(ProgramName, "Display", "AutoCenter", 1)) = 1)
    mnuViewAutoCenter.Checked = AutoCenter
    
    Launch = Val(GetSetting(ProgramName, "Startup", "Launch", 0))
    
'    Buffer = Val(GetSetting(ProgramName, "Startup", "Status", 1))
'    If Buffer = 1 Then
'        Status.Visible = True
'        mnuViewStatusBar.Checked = True
'    Else
'        Status.Visible = False
'        mnuViewStatusBar.Checked = False
'    End If
    Form_Resize
End Sub

Private Sub Tree3do_DblClick()
    'Set TabToolbox.SelectedItem = TabToolbox.Tabs(3)
End Sub

Private Sub Tree3do_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    If Button > 1 Then
        TreeMove = Not TreeMove
        If TreeMove Then
            Tree3do.MousePointer = ccUpArrow
        End If
    End If
End Sub

Private Sub TxtOffsetX_KeyPress(KeyAscii As Integer)
    If KeyAscii = 13 Then
        CmdApplyOffset_Click
    End If
End Sub

Private Sub TxtOffsetY_KeyPress(KeyAscii As Integer)
    If KeyAscii = 13 Then
        CmdApplyOffset_Click
    End If
End Sub

Private Sub TxtOffsetZ_KeyPress(KeyAscii As Integer)
    If KeyAscii = 13 Then
        CmdApplyOffset_Click
    End If
End Sub

Private Sub TxtPrimitive_LostFocus()
    Dim Value As Long
    
    On Error Resume Next
    Value = Val(TxtPrimitive)
    If Value > ScrollPrimitive.Max Then Value = ScrollPrimitive.Max
    If Value < ScrollPrimitive.Min Then Value = ScrollPrimitive.Min
    ScrollPrimitive.Value = Value
End Sub

Private Sub TxtScale_KeyPress(KeyAscii As Integer)
    If KeyAscii = 13 Then
        CmdApplyScale_Click
    End If
End Sub



