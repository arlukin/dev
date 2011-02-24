Attribute VB_Name = "mod3d"
' 3d rendering module. '

Option Explicit

' 3d types. '
'Public Type Point2D
'    x As Long
'    y As Long
'End Type

Public Type Point3D
    x As Single
    y As Single
    z As Single
End Type

' Constants. '
Public Const ProjectScale = 1500
Public Const Pi = 3.14159265
Public TransEye As Point3D
Public RotEye As Point3D

Public CenterX As Long
Public CenterY As Long

' Project this 3D point to a 2D screen. '
Public Function Project(p() As class3dVertex, pDest() As Point2D, OffsetX As Single, OffsetY As Single, OffsetZ As Single)
    Dim Index As Integer
    Dim Temp3D As New class3dVertex
    Dim Temp As Point3D
    
    On Error GoTo Error
    For Index = 0 To UBound(p)
        ' Perform eye transformations. '
        Temp3D.x = p(Index).x + OffsetX
        Temp3D.y = p(Index).y + OffsetY
        Temp3D.z = p(Index).z + OffsetZ
    
        Rotate Temp3D, RotEye
        Translate Temp3D, TransEye
    
        ' Standard projection. '
        pDest(Index).x = Temp3D.x * ProjectScale / (Temp3D.z + ProjectScale) + CenterX
        pDest(Index).y = -(Temp3D.y * ProjectScale / (Temp3D.z + ProjectScale)) + CenterY
    Next
Error:
End Function

' Rotate the vertex. '
Public Sub Rotate(p As class3dVertex, Angle As Point3D)
    Dim Ang As Point3D
    
    Ang.x = Angle.x * (Pi / 180)
    Ang.y = Angle.y * (Pi / 180)
    Ang.z = Angle.z * (Pi / 180)
    If Angle.x > 0 Then
        p.x = p.x
        p.y = (p.y * Cos(Ang.x)) - (p.z * Sin(Ang.x))
        p.z = (p.y * Sin(Ang.x)) + (p.z * Cos(Ang.x))
    End If
    
    If Angle.y > 0 Then
        p.x = (p.z * Sin(Ang.y)) + (p.x * Cos(Ang.y))
        p.y = p.y
        p.z = (p.z * Cos(Ang.y)) - (p.x * Sin(Ang.y))
    End If
    
    If Angle.z > 0 Then
        p.x = (p.x * Cos(Ang.z)) - (p.y * Sin(Ang.z))
        p.y = (p.x * Sin(Ang.z)) + (p.y * Cos(Ang.z))
        p.z = p.z
    End If
End Sub

' Translate the vertex. '
Public Sub Translate(p As class3dVertex, Vector As Point3D)
    p.x = p.x + Vector.x
    p.y = p.y + Vector.y
    p.z = p.z + Vector.z
End Sub

