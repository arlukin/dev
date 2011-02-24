VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "classRubberband"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' Properties. '
Public Left As Long
Public Top As Long
Public Width As Long
Public Height As Long
Public Usable As Boolean

Public Moving As Boolean
Public Dragging As Boolean
Private ScaleTo As Long
Private ShapePTR As Shape
Private AncorX As Long
Private AncorY As Long
Private StartX As Long
Private StartY As Long

Public Sub Initialize(Rubberband As Shape, ByVal x As Long, ByVal y As Long, Optional InitScaleTo As Long = 1)
    Set ShapePTR = Rubberband
    ShapePTR.Visible = False
    Width = 0
    Height = 0
    Dragging = True
    Moving = False
    If InitScaleTo < 1 Then InitScaleTo = 1
    ScaleTo = InitScaleTo
    Left = ScaleTo * CInt(x / ScaleTo)
    Top = ScaleTo * CInt(y / ScaleTo)
    AncorX = Left
    AncorY = Top
    ShapePTR.Left = Left
    ShapePTR.Top = Top
    ShapePTR.Width = 0
    ShapePTR.Height = 0
    ShapePTR.Visible = True
End Sub

Public Sub Reposition(ByVal x As Long, ByVal y As Long)
    AncorX = AncorX - x '* ScaleTo
    AncorY = AncorY - y '* ScaleTo
    Left = Left - x '* ScaleTo
    Top = Top - y '* ScaleTo
'    ShapePTR.Left = Left
'    ShapePTR.Top = Top
End Sub

Public Sub Move(ByVal x As Long, ByVal y As Long)
    Dim SelectedX As Long, SelectedY As Long
    Dim NewX As Long, NewY As Long
    Static CornerX As Integer, CornerY As Integer
    
    If Dragging Then
        NewX = x
        NewY = y
        'If NewX > Canvas.ScaleWidth Then NewX = Canvas.ScaleWidth
        'If NewY > Canvas.ScaleHeight Then NewY = Canvas.ScaleHeight
        'If NewX < 0 Then NewX = 0
        'If NewY < 0 Then NewY = 0
        NewX = ScaleTo * CInt(NewX / ScaleTo)
        NewY = ScaleTo * CInt(NewY / ScaleTo)
        If (NewX >= (Left + Width)) Then
            Width = (NewX - Left)
            Left = AncorX
            CornerX = 0
        ElseIf (NewX >= Left) And (NewX < (Left + Width)) And (CornerX = 0) Then
            Width = (NewX - Left)
            Left = AncorX
        ElseIf (NewX > Left) And (CornerX = 1) Then
            Left = NewX
            Width = Abs(AncorX - NewX)
        ElseIf (NewX < Left) Then
            Left = NewX
            Width = Abs(AncorX - NewX)
            CornerX = 1
        End If
        If (NewY >= (Top + Height)) Then
            Height = (NewY - Top)
            Top = AncorY
            CornerY = 0
        ElseIf (NewY >= Top) And (NewY < (Top + Height)) And (CornerY = 0) Then
            Height = (NewY - Top)
            Top = AncorY
        ElseIf (NewY > Top) And (CornerY = 1) Then
            Top = NewY
            Height = Abs(AncorY - NewY)
        ElseIf (NewY < Top) Then
            Top = NewY
            Height = Abs(AncorY - NewY)
            CornerY = 1
        End If
        ShapePTR.Left = Left
        ShapePTR.Top = Top
        ShapePTR.Width = Width
        ShapePTR.Height = Height
    ElseIf Moving Then
        ShapePTR.Left = AncorX + (ScaleTo * Int(x / ScaleTo) - StartX)
        ShapePTR.Top = AncorY + (ScaleTo * Int(y / ScaleTo) - StartY)
    End If
End Sub

Public Sub Done()
    If Dragging Then
        ShapePTR.Visible = False
        'If Left < 0 Then Left = 0
        'If Top < 0 Then Top = 0
        If (Width < ScaleTo) Or (Height < ScaleTo) Or ((Width = ScaleTo) And (Height = ScaleTo)) Then
            Usable = False
        Else
            Usable = True
        End If
        Dragging = False
    ElseIf Moving Then
        Moving = False
        Left = ShapePTR.Left
        Top = ShapePTR.Top
    End If
End Sub

Public Sub SetShape(Selected As Shape)
    If Usable Then
        Selected.Left = Left
        Selected.Top = Top
        Selected.Width = Width
        Selected.Height = Height
        Selected.Visible = True
    End If
End Sub

Public Sub StartMove(SetShape As Shape, ByVal x As Long, ByVal y As Long, ByVal SetScale As Long)
    Set ShapePTR = SetShape
    ScaleTo = SetScale
    AncorX = ShapePTR.Left
    AncorY = ShapePTR.Top
    StartX = ScaleTo * Int(x / ScaleTo)
    StartY = ScaleTo * Int(y / ScaleTo)
    Moving = True
    Dragging = False
End Sub
