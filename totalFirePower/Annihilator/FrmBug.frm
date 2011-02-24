VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Begin VB.Form FrmBug 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Bug Report"
   ClientHeight    =   5235
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5535
   ControlBox      =   0   'False
   Icon            =   "FrmBug.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5235
   ScaleWidth      =   5535
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin MSWinsockLib.Winsock Winsock1 
      Left            =   2280
      Top             =   4740
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   327681
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   4140
      TabIndex        =   11
      Top             =   4740
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Send"
      Default         =   -1  'True
      Height          =   375
      Left            =   2820
      TabIndex        =   10
      Top             =   4740
      Width           =   1215
   End
   Begin VB.TextBox TxtComment 
      Height          =   1095
      Left            =   180
      MultiLine       =   -1  'True
      TabIndex        =   9
      Text            =   "FrmBug.frx":000C
      Top             =   3480
      Width           =   5175
   End
   Begin VB.TextBox TxtMailServer 
      Height          =   315
      Left            =   180
      TabIndex        =   7
      Text            =   "mail.yourserver.com"
      Top             =   2700
      Width           =   2535
   End
   Begin VB.TextBox TxtEmail 
      Height          =   315
      Left            =   2820
      TabIndex        =   5
      Text            =   "your@return.email"
      Top             =   2040
      Width           =   2535
   End
   Begin VB.TextBox TxtName 
      Height          =   315
      Left            =   180
      TabIndex        =   2
      Text            =   "Your Name"
      Top             =   2040
      Width           =   2535
   End
   Begin VB.TextBox TxtError 
      Height          =   975
      Left            =   180
      MultiLine       =   -1  'True
      TabIndex        =   1
      Text            =   "FrmBug.frx":005E
      Top             =   660
      Width           =   5175
   End
   Begin VB.Label LblStatus 
      Height          =   255
      Left            =   180
      TabIndex        =   12
      Top             =   4800
      Width           =   2475
   End
   Begin VB.Label Label5 
      Caption         =   "Comments for the authors"
      Height          =   255
      Left            =   180
      TabIndex        =   8
      Top             =   3180
      Width           =   2535
   End
   Begin VB.Label Label4 
      Caption         =   "Mail Server"
      Height          =   255
      Left            =   180
      TabIndex        =   6
      Top             =   2460
      Width           =   2535
   End
   Begin VB.Label Label3 
      Caption         =   "Return e-mail address"
      Height          =   255
      Left            =   2820
      TabIndex        =   4
      Top             =   1800
      Width           =   1575
   End
   Begin VB.Label Label2 
      Caption         =   "Name"
      Height          =   255
      Left            =   180
      TabIndex        =   3
      Top             =   1800
      Width           =   1935
   End
   Begin VB.Label Label1 
      Caption         =   "An error has occurred in Annihilator.  Please submit the following information to us so that the error can be fixed."
      Height          =   435
      Left            =   180
      TabIndex        =   0
      Top             =   180
      Width           =   5175
   End
End
Attribute VB_Name = "FrmBug"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim TransferPoint As Integer
Const TP_NONE = 0
Const TP_HELO = 1
Const TP_FROM = 2
Const TP_TO = 3
Const TP_DATA = 4
Const TP_CONTENT = 5
Const TP_QUIT = 6

Private Sub Command1_Click()
On Error GoTo Error:

    Command1.Enabled = False
    TransferPoint = 0
    Winsock1.LocalPort = 0
    Winsock1.RemotePort = 25
    Winsock1.RemoteHost = Trim$(TxtMailServer.Text)
    Winsock1.Connect
    LblStatus.Caption = "Connecting to server."
    
Exit Sub
Error:
MsgBox "Error: " & Trim(Str(Err.Number)) & " " & Err.Description, , "Error Initializing"
Command1.Enabled = True
End Sub


Private Sub Command2_Click()
Unload Me
End Sub


Private Sub Winsock1_DataArrival(ByVal bytesTotal As Long)
Dim Buffer As String
Dim sendstring As String
Dim spcpos As Integer

Winsock1.GetData Buffer, vbString, bytesTotal

If TransferPoint = TP_NONE Then
    '220 is normal response, 2XX is a go response'
    If Buffer Like "2?? *" Then
        spcpos = InStr(TxtMailServer.Text, ".")
        If Len(TxtMailServer.Text) > spcpos Then
            Winsock1.SendData "HELO " & Right(TxtMailServer.Text, Len(TxtMailServer.Text) - spcpos) & Chr$(13) & Chr$(10)
            LblStatus.Caption = "Saying hello to server..."
            TransferPoint = TP_HELO
            'noticed with ms winsock control that a doevents make this send right away'
            DoEvents
        End If
    Else
        LblStatus.Caption = "Error sending..."
        Winsock1.Close
        Exit Sub
    End If
ElseIf TransferPoint = TP_HELO Then
    'expect 250, but will go with 2XX
    If Buffer Like "2?? *" Then
        Winsock1.SendData "MAIL FROM:<" & TxtEmail.Text & ">" & Chr$(13) & Chr$(10)
        LblStatus.Caption = "Sending from information..."
        TransferPoint = TP_FROM
        DoEvents
    Else
        LblStatus.Caption = "Error sending..."
        Winsock1.Close
        Exit Sub
    End If
ElseIf TransferPoint = TP_FROM Then
    'expect 250, but will go with 2XX
    If Buffer Like "2?? *" Then
        Winsock1.SendData "RCPT TO:<" & "annihilator@annihilated.com" & ">" & Chr$(13) & Chr$(10)
        LblStatus.Caption = "Sending to information..."
        TransferPoint = TP_TO
        DoEvents
    Else
        LblStatus.Caption = "Error sending..."
        Winsock1.Close
        Exit Sub
    End If
ElseIf TransferPoint = TP_TO Then
    'expect 250, but will go with 2XX
    If Buffer Like "2?? *" Then
        Winsock1.SendData "DATA" & Chr$(13) & Chr$(10)
        LblStatus.Caption = "Sending data request..."
        TransferPoint = TP_DATA
        DoEvents
    Else
        LblStatus.Caption = "Error sending..."
        Winsock1.Close
        Exit Sub
    End If
ElseIf TransferPoint = TP_DATA Then
    'expect 354, but will go with 3XX
    If Buffer Like "3?? *" Then
        sendstring = "Date: " & Date$ & Chr$(13) & Chr$(10)
        sendstring = sendstring & "From: " & Trim(TxtName.Text) & "<" & Trim$(TxtEmail.Text) & ">" & Chr$(13) & Chr$(10)
        sendstring = sendstring & "To: " & "Annihilator <Annihilator@Annihilated.com>" & Chr$(13) & Chr$(10)
        sendstring = sendstring & "Subject: Annihilator v0.25 Error" & Chr$(13) & Chr$(10)
        sendstring = sendstring & Chr$(13) & Chr$(10)
        sendstring = sendstring & "User had these errors: " & Chr$(13) & Chr$(10)
        sendstring = sendstring & TxtError.Text & Chr$(13) & Chr$(10)
        sendstring = sendstring & Chr$(13) & Chr$(10)
        sendstring = sendstring & "Comments:" & Chr$(13) & Chr$(10)
        sendstring = sendstring & TxtComment.Text & Chr$(13) & Chr$(10)
        sendstring = sendstring & "." & Chr$(13) & Chr$(10)
        Winsock1.SendData sendstring
        LblStatus.Caption = "Sending data..."
        TransferPoint = TP_CONTENT
        DoEvents
    Else
        LblStatus.Caption = "Error sending..."
        Winsock1.Close
        Exit Sub
    End If
ElseIf TransferPoint = TP_CONTENT Then
    'expect 250, but will go with 2XX
    If Buffer Like "2?? *" Then
        Winsock1.SendData "QUIT" & Chr$(13) & Chr$(10)
        LblStatus.Caption = "Sending quit..."
        TransferPoint = TP_QUIT
        DoEvents
        'Unload Me
    Else
        LblStatus.Caption = "Error sending..."
        Winsock1.Close
        Exit Sub
    End If
End If


End Sub

Private Sub Winsock1_Error(ByVal Number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)

If Number = 10054 Then
    Command1.Enabled = True
    Exit Sub
End If
MsgBox "Error: " & Trim(Str(Number)) & " " & Description, , "Winsock Error"
Winsock1.Close
Command1.Enabled = True
End Sub


Private Sub Winsock1_SendComplete()
If TransferPoint = TP_QUIT Then
    Winsock1.Close
    TransferPoint = 0
    Command1.Enabled = True
    Unload Me
End If
End Sub


