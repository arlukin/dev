Attribute VB_Name = "modHPIUtil"
Option Explicit

Public Const NO_COMPRESSION = 0
Public Const LZ77_COMPRESSION = 1
Public Const ZLIB_COMPRESSION = 2

'
' Used to accept string values passed to the callback routine.
' See notes below.
'
Public Type CString
  Data(255) As Byte
End Type
'
' GetTADirectory - Returns the directory that TA is installed in
' Arguments:
'   DirName - String variable to hold the returned directory
'
Declare Sub GetTADirectory Lib "HPIUTIL.DLL" (ByRef DirName As CString)
'
' HPIOpen - Opens an HPI archive
' Arguments:
'   FileName - The name of the HPI file
' Returns:
'   If not successful, returns 0
'      Either the file does not exist, or it's not a valid
'      HPI file
'   Otherwise, return a handle to the HPI file that is
'   used in the other functions
'
' When finished, use HPIClose to close the archive
'
Declare Function HPIOpen Lib "HPIUTIL.DLL" (ByVal FileName As String) As Long
'
' HPIGetFiles - Enumerate all of the files in the HPI archive
' Arguments:
'   HPI - handle to open HPI file returned by HPIOpen
'   NextEntry - Set to 0 if this is the start of the search.
'               Oterwise, set to the return value of the last
'               HPIGetFiles call
'   Name - String variable to hold the returned file name
'          The name includes the complete path of the file in
'          the HPI archive.
'   FileType - Long variable to hold the file type
'              0 = File, 1 = Directory
'   Size - Long variable to hold the file size
'          If the file is a directory, this is the number
'          of files in the directory.
'          Otherwise, it is the uncompressed size of the file.
' Returns:
'   Returns 0 if there are no more files to enumerate.
'   Otherwise, returns a value to use as the 'NextEntry' argument
'   for the next call to HPIGetFiles.
'   Name, FileType, and Size are set to the appropriate values.
'
Declare Function HPIGetFiles Lib "HPIUTIL.DLL" (ByVal HPI As Long, ByVal NextEntry As Long, ByVal Name As String, FileType As Long, Size As Long) As Long
'
' HPIDir - Enumerate all of the files in a subdirectory in the HPI archive
' Arguments:
'   HPI - handle to open HPI file returned by HPIOpen
'   NextEntry - Set to 0 if this is the start of the search.
'              Oterwise, set to the return value of the last
'              HPIDir call
'   DirName - The directory name whose files you want to list
'   Name - String variable to hold the returned file name
'          The name does not include any path information.
'   FileType - Long variable to hold the file type
'              0 = File, 1 = Directory
'   Size - Long variable to hold the file size
'          If the file is a directory, this is the number
'          of files in the directory.
'          Otherwise, it is the uncompressed size of the file.
' Returns:
'   Returns 0 if there are no more files to enumerate.
'   Otherwise, returns a value to use as the 'NextEntry' argument
'   for the next call to HPIDir.
'   Name, FileType, and Size are set to the appropriate values.
'
Declare Function HPIDir Lib "HPIUTIL.DLL" (ByVal HPI As Long, ByVal NextEntry As Long, ByVal DirName As String, ByVal Name As String, FileType As Long, Size As Long) As Long
'
' HPIClose - Close an open HPI archive
' Arguments:
'   HPI - handle to open HPI file returned by HPIOpen
' Returns:
'   Always returns 0
'
' Always close the archive with HPIClose.
'
Declare Function HPIClose Lib "HPIUTIL.DLL" (ByVal HPI As Long) As Long
'
' HPIOpenFile - Decode a file inside an HPI archive to memory
' Arguments:
'   HPI - handle to open HPI file returned by HPIOpen
'   FileName - Fully qualified file name to open
' Returns:
'   0 if not successful
'   else returns pointer to memory block holding entire file.
'   Note: This can be a big chunk of memory, especially for large maps.
'         When finished, use HPICloseFile to deallocate the memory
'
Declare Function HPIOpenFile Lib "HPIUTIL.DLL" (ByVal HPI As Long, ByVal FileName As String) As Long
'
' HPIGet - Extract data from file extracted by HPIOpenFile
' Arguments:
'    Dest - Destination address
'    FileHandle - Pointer returned by HPIOpenFile
'    offset - offset within FileHandle
'    bytecount - number of bytes to copy
'
Declare Sub HPIGet Lib "HPIUTIL.DLL" (ByRef Dest As Any, ByVal FileHandle As Long, ByVal offset As Long, ByVal ByteCount As Long)
'
' HPICloseFile - Closes a file opened with HPIOpenFile
' Arguments:
'   FileHandle - pointer previously returned by HPIOpenFile
' Returns:
'   Always returns 0
'
Declare Function HPICloseFile Lib "HPIUTIL.DLL" (ByVal FileHandle As Long) As Long
'
' HPIExtractFile - Extract a file from an HPI file to disk
' Arguments:
'   HPI - handle to open HPI file returned by HPIOpen
'   FileName - Fully qualified file name to extract
'   ExtractName - File name to extract it to
' Returns:
'   0 if not successful
'   non-zero if successful
'
Declare Function HPIExtractFile Lib "HPIUTIL.DLL" (ByVal HPI As Long, ByVal FileName As String, ByVal ExtractName As String) As Long
'
' HPICreate - Create an HPI archive
' Arguments:
'   FileName - The name of the HPI file to create
'   Callback - The address of a callback function (see notes)
'              If there is no callback function, use 0
' Returns:
'   0 if not successful
'   else returns handle to be used in
'   HPICreateDirectory, HPIAddFile, and/or HPIPackFile
' Note:
'   Any existing HPI archive with this name will be overwritten.
'
'   This function prepares a new HPI archive.  After this, call
'   HPIAddFile and/or HPICreateDirectory for each file you want to add.
'   When all files have been added, call HPIPackFile to actually create
'   the HPI archive.
'
'   The callback function is called periodically during the pack process
'   so that the program can display progress information.
'   It's defined thusly:
'   Function HPICallBack(ByVal FileName As CString, ByVal HPIName As CString, FileCount As Long, FileCountTotal As Long, FileBytes As Long, FileBytesTotal As Long, TotalBytes As Long, TotalBytesTotal As Long) as Long
'   Arguments:
'     FileName - the file name being packed.
'     HPIName - the name in the HPI file that it's being packed into
'     FileCount - the number of the file being packed
'     FileCountTotal - the total number of files to pack
'        (use these to display 'File 1 of 20' type messages)
'     FileBytes - The amount of the file that has been packed
'     FileBytesTotal - The file size to be packed
'     TotalBytes - The total amount of data that's been packed
'     TotalBytesTotal - The total amount of data to be packed
'   Return value:
'     Return non-zero to stop the pack process
'     return 0 to continue the pack process
'
'   If you don't want to use a callback function, pass 'vbNullString' as
'   the Callback argument.
'
'   More notes:
'     The FileName and HPIName arguments are C-style NULL-terminated strings.
'     VB has problems interpreting these, as its internal string format is
'     different.  If you need to access these values, use the included
'     MakeVBString function to convert them to VB-style strings.
'
Declare Function HPICreate Lib "HPIUTIL.DLL" (ByVal FileName As String, ByVal Callback As Any) As Long
'
' HPICreateDirectory - Create a directory in an HPI archive
' Arguments:
'   Pack - the handle returned by HPICreate
'   DirName - the complete directory name to create
' Returns:
'   0 if not successful
'   non-zero if successful
' Note:
'   This function is the only way to create an empty supdirectory in the
'   HPI archive.
'
Declare Function HPICreateDirectory Lib "HPIUTIL.DLL" (ByVal Pack As Long, ByVal DirName As String) As Long
'
' HPIAddFile - Add a file to an HPI archive
' Arguments:
'   Pack - the handle returned by HPICreate
'   HPIName - the complete path and file name to create in the HPI archive
'   FileName - the file name on disk to add
' Returns:
'   0 if not successful
'   non-zero if successful
' Note:
'   Directories in the HPI archive will be created as necessary.
'
Declare Function HPIAddFile Lib "HPIUTIL.DLL" (ByVal Pack As Long, ByVal HPIName As String, ByVal FileName As String) As Long
'
' HPIAddFileFromMemory - Add a file in memory to an HPI archive
' Arguments:
'   Pack - the handle returned by HPICreate
'   HPIName - the complete path and file name to create in the HPI archive
'   FileBlock - pointer to file in memory to add
'   FSize - length of FileBlock
' Returns:
'   0 if not successful
'   non-zero if successful
' Note:
'   Directories in the HPI archive will be created as necessary.
'
Declare Function HPIAddFileFromMemory Lib "HPIUTIL.DLL" (ByVal Pack As Long, ByVal HPIName As String, ByVal FileBlock As Long, ByVal FSize As Long) As Long
'
' HPIPackArchive - Pack the HPI archive
' Arguments:
'   Pack - the handle returned by HPICreate
'   CMethod - One of LZ77_COMPRESSION or ZLIB_COMPRESSION
' Returns:
'   0 if not successful
'   non-zero if successful
' Note:
'   The 'Pack' handle is no longer valid after this call.
'   The Callback function specified in the HPICreate function is called
'     periodically during the pack process.
'   This function will not return until the packing is complete, which can
'   take awhile for large amounts of data.
'
Declare Function HPIPackArchive Lib "HPIUTIL.DLL" (ByVal Pack As Long, ByVal CMethod As Long) As Long
'
' HPIPackFile - Pack the HPI archive
' Arguments:
'   Pack - the handle returned by HPICreate
' Returns:
'   0 if not successful
'   non-zero if successful
' Note:
'   The 'Pack' handle is no longer valid after this call.
'   The Callback function specified in the HPICreate function is called
'     periodically during the pack process.
'   This function will not return until the packing is complete, which can
'   take awhile for large amounts of data.
'
Declare Function HPIPackFile Lib "HPIUTIL.DLL" (ByVal Pack As Long) As Long

Function MakeVBString(x As CString) As String
'
' Converts a C-style null-terminated string to a VB-style string
'
Dim I As Integer
Dim Result As String

Result = ""

I = 0
While x.Data(I) <> 0
  Result = Result + Chr$(x.Data(I))
  I = I + 1
Wend

MakeVBString = Result

End Function
Private Function StripNull(TStr As String) As String

Dim x As Integer
Dim XStr As String

x = InStr(TStr, Chr$(0))
If x <> 0 Then
  XStr = Left$(TStr, x - 1)
Else
  XStr = RTrim$(TStr)
End If


StripNull = XStr

End Function



