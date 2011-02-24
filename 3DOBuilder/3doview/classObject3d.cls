VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "classObject3D"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' TA 3do object. '

Option Explicit

Private Header As Object3d
Private Vertexes() As Point3d

Private Child As New classObject3D
Private Sibling As New classObject3D
