VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "classGAF"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' GAF class. '

Option Explicit

Private GAFHeader(2) As Long

' GAF Animations. (Sequences) '
Private GAFAnimations() As New classGAFSequence
Private GAFAnimPtrs() As Long

' Initialize a new, blank GAF file. '
Public Sub Initialize()
    ReDim GAFAnimations(0)
    ReDim GAFAnimPtrs(0)
End Sub

' Save the GAF file. '
Public Function SaveGAF(FileName As String)
    Dim File As Integer
    Dim Entries As Long
    Dim Index As Long
    
    ' Initialize. '
    On Error GoTo Error
    Initialize
    File = FreeFile
    Open FileName For Binary As File
    
    ' Write header. '
    Entries = FrmImportTextures.LstImport.ListCount
    If Entries < 0 Then Exit Function
    GAFHeader(0) = &H10100
    GAFHeader(1) = Entries
    GAFHeader(2) = 0
    Put File, , GAFHeader()
    
    ' Write GAF anim pointers. '
    ReDim GAFAnimPtrs(Entries - 1)
    Put File, , GAFAnimPtrs()
    
    ' Write the GAF frames. '
    ReDim GAFAnimations(Entries - 1)
    For Index = 0 To UBound(GAFAnimations)
        GAFAnimPtrs(Index) = Seek(File) - 1
        GAFAnimations(Index).SaveBMP File, FrmImportTextures.LstImport.List(Index)
    Next
    
    ' Rewrite anim pointers. '
    Seek File, 13
    Put File, , GAFAnimPtrs()
    
    ' Cleanup. '
    Close File
    Exit Function
Error:
    MsgBox "There was an error saving this GAF file."
End Function

