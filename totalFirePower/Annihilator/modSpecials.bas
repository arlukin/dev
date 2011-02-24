Attribute VB_Name = "modSpecials"
' Special tools module. '

Option Explicit

Public Sub SpecialsCreatePalette()
    Dim Index As Integer
    Dim xPos As Integer, yPos As Integer
    Dim rc As Long
    Dim Blank() As Byte
    
    With FrmAnnihilator
    .ScrollSpecial.Visible = True
    
    ReDim Blank(64 * 64 - 1)
    For Index = 0 To UBound(Blank)
        Blank(Index) = 255
    Next
    
    xPos = 2
    yPos = 2
    .PicSpecial.Picture = .PicToolbox.Picture
    .PicSpecial.Cls
    Screens(PaletteSpecials).TileDraw 0, 0, 64, 64, Blank()
    For Index = .ScrollSpecial.Value + 1 To 10
        Screens(PaletteSpecials).MaskTileDraw 0, 0, 32, 32, StartingTile(), 255, Players(Index)
        Screens(PaletteSpecials).Show .PicSpecial.hdc, xPos, yPos, 32, 32, 0, 0
        .PicTemp.Cls
        .PicTemp.Print "Player " & CStr(Index)
        rc = BitBlt(.PicSpecial.hdc, xPos, yPos + 32 + 5, .PicTemp.ScaleWidth, .PicTemp.ScaleHeight, .PicTemp.hdc, 0, 0, SRCCOPY)
        If SelectedPlayer = Index Then
            .PicSpecial.Line (xPos - 1, yPos - 1)-(xPos + 32 + 1, yPos - 1), &HFF8080
            .PicSpecial.Line (xPos - 1, yPos - 1)-(xPos - 1, yPos + 32 + 1), &HFF8080
            .PicSpecial.Line (xPos - 1, yPos + 32 + 1)-(xPos + 32 + 2, yPos + 32 + 1), &HFF8080
            .PicSpecial.Line (xPos + 32 + 1, yPos - 1)-(xPos + 32 + 1, yPos + 32 + 1), &HFF8080
        End If
        yPos = yPos + 62
        If yPos > .PicSpecial.ScaleHeight Then Exit For
    Next
    .PicFeatures.Refresh
    End With
End Sub
