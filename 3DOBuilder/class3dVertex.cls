VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "class3dVertex"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' 3d vertex class. '

Option Explicit

Public x As Single
Public y As Single
Public z As Single

' Set the vertex to another. '
Public Sub SetVertex(xSet As Single, ySet As Single, zSet As Single)
    x = xSet
    y = ySet
    z = zSet
End Sub
