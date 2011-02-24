# Microsoft Developer Studio Generated NMAKE File, Format Version 40001
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Dynamic-Link Library" 0x0102

!IF "$(CFG)" == ""
CFG=Annihilator - Win32 Debug
!MESSAGE No configuration specified.  Defaulting to Annihilator - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "Annihilator - Win32 Release" && "$(CFG)" !=\
 "Annihilator - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE on this makefile
!MESSAGE by defining the macro CFG on the command line.  For example:
!MESSAGE 
!MESSAGE NMAKE /f "Annihilator.mak" CFG="Annihilator - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "Annihilator - Win32 Release" (based on\
 "Win32 (x86) Dynamic-Link Library")
!MESSAGE "Annihilator - Win32 Debug" (based on\
 "Win32 (x86) Dynamic-Link Library")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 
################################################################################
# Begin Project
# PROP Target_Last_Scanned "Annihilator - Win32 Release"
RSC=rc.exe
MTL=mktyplib.exe
CPP=cl.exe

!IF  "$(CFG)" == "Annihilator - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Annihila"
# PROP BASE Intermediate_Dir "Annihila"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Annihila"
# PROP Intermediate_Dir "Annihila"
# PROP Target_Dir ""
OUTDIR=.\Annihila
INTDIR=.\Annihila

ALL : "$(OUTDIR)\Annihilator.dll"

CLEAN : 
	-@erase ".\Annihila\Annihilator.dll"
	-@erase ".\Annihila\GAF.obj"
	-@erase ".\Annihila\Annihilator.obj"
	-@erase ".\Annihila\Memory.obj"
	-@erase ".\Annihila\FastWin.obj"
	-@erase ".\Annihila\Undo.obj"
	-@erase ".\Annihila\Annihilator.lib"
	-@erase ".\Annihila\Annihilator.exp"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /MT /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /YX /c
# ADD CPP /nologo /MT /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /YX /c
CPP_PROJ=/nologo /MT /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS"\
 /Fp"$(INTDIR)/Annihilator.pch" /YX /Fo"$(INTDIR)/" /c 
CPP_OBJS=.\Annihila/
CPP_SBRS=
# ADD BASE MTL /nologo /D "NDEBUG" /win32
# ADD MTL /nologo /D "NDEBUG" /win32
MTL_PROJ=/nologo /D "NDEBUG" /win32 
# ADD BASE RSC /l 0x409 /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/Annihilator.bsc" 
BSC32_SBRS=
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib /nologo /subsystem:windows /dll /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib /nologo /subsystem:windows /dll /machine:I386
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib\
 advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib /nologo\
 /subsystem:windows /dll /incremental:no /pdb:"$(OUTDIR)/Annihilator.pdb"\
 /machine:I386 /def:".\Annihilator.def" /out:"$(OUTDIR)/Annihilator.dll"\
 /implib:"$(OUTDIR)/Annihilator.lib" 
DEF_FILE= \
	".\Annihilator.def"
LINK32_OBJS= \
	"$(INTDIR)/GAF.obj" \
	"$(INTDIR)/Annihilator.obj" \
	"$(INTDIR)/Memory.obj" \
	"$(INTDIR)/FastWin.obj" \
	"$(INTDIR)/Undo.obj"

"$(OUTDIR)\Annihilator.dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "Annihilator - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Target_Dir ""
OUTDIR=.\Debug
INTDIR=.\Debug

ALL : "$(OUTDIR)\Annihilator.dll"

CLEAN : 
	-@erase ".\Debug\vc40.pdb"
	-@erase ".\Debug\vc40.idb"
	-@erase ".\Debug\Annihilator.dll"
	-@erase ".\Debug\GAF.obj"
	-@erase ".\Debug\Annihilator.obj"
	-@erase ".\Debug\Memory.obj"
	-@erase ".\Debug\FastWin.obj"
	-@erase ".\Debug\Undo.obj"
	-@erase ".\Debug\Annihilator.ilk"
	-@erase ".\Debug\Annihilator.lib"
	-@erase ".\Debug\Annihilator.exp"
	-@erase ".\Debug\Annihilator.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /MTd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /YX /c
# ADD CPP /nologo /MTd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /YX /c
CPP_PROJ=/nologo /MTd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS"\
 /Fp"$(INTDIR)/Annihilator.pch" /YX /Fo"$(INTDIR)/" /Fd"$(INTDIR)/" /c 
CPP_OBJS=.\Debug/
CPP_SBRS=
# ADD BASE MTL /nologo /D "_DEBUG" /win32
# ADD MTL /nologo /D "_DEBUG" /win32
MTL_PROJ=/nologo /D "_DEBUG" /win32 
# ADD BASE RSC /l 0x409 /d "_DEBUG"
# ADD RSC /l 0x409 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/Annihilator.bsc" 
BSC32_SBRS=
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib /nologo /subsystem:windows /dll /debug /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib /nologo /subsystem:windows /dll /debug /machine:I386
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib\
 advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib /nologo\
 /subsystem:windows /dll /incremental:yes /pdb:"$(OUTDIR)/Annihilator.pdb"\
 /debug /machine:I386 /def:".\Annihilator.def" /out:"$(OUTDIR)/Annihilator.dll"\
 /implib:"$(OUTDIR)/Annihilator.lib" 
DEF_FILE= \
	".\Annihilator.def"
LINK32_OBJS= \
	"$(INTDIR)/GAF.obj" \
	"$(INTDIR)/Annihilator.obj" \
	"$(INTDIR)/Memory.obj" \
	"$(INTDIR)/FastWin.obj" \
	"$(INTDIR)/Undo.obj"

"$(OUTDIR)\Annihilator.dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 

.c{$(CPP_OBJS)}.obj:
   $(CPP) $(CPP_PROJ) $<  

.cpp{$(CPP_OBJS)}.obj:
   $(CPP) $(CPP_PROJ) $<  

.cxx{$(CPP_OBJS)}.obj:
   $(CPP) $(CPP_PROJ) $<  

.c{$(CPP_SBRS)}.sbr:
   $(CPP) $(CPP_PROJ) $<  

.cpp{$(CPP_SBRS)}.sbr:
   $(CPP) $(CPP_PROJ) $<  

.cxx{$(CPP_SBRS)}.sbr:
   $(CPP) $(CPP_PROJ) $<  

################################################################################
# Begin Target

# Name "Annihilator - Win32 Release"
# Name "Annihilator - Win32 Debug"

!IF  "$(CFG)" == "Annihilator - Win32 Release"

!ELSEIF  "$(CFG)" == "Annihilator - Win32 Debug"

!ENDIF 

################################################################################
# Begin Source File

SOURCE=.\Annihilator.def

!IF  "$(CFG)" == "Annihilator - Win32 Release"

!ELSEIF  "$(CFG)" == "Annihilator - Win32 Debug"

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\Annihilator.cpp
DEP_CPP_ANNIH=\
	".\Annihilator.h"\
	

"$(INTDIR)\Annihilator.obj" : $(SOURCE) $(DEP_CPP_ANNIH) "$(INTDIR)"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\GAF.cpp
DEP_CPP_GAF_C=\
	".\GAF.h"\
	

"$(INTDIR)\GAF.obj" : $(SOURCE) $(DEP_CPP_GAF_C) "$(INTDIR)"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\Memory.cpp
DEP_CPP_MEMOR=\
	".\memory.h"\
	

"$(INTDIR)\Memory.obj" : $(SOURCE) $(DEP_CPP_MEMOR) "$(INTDIR)"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\FastWin.cpp
DEP_CPP_FASTW=\
	".\FastWin.h"\
	

"$(INTDIR)\FastWin.obj" : $(SOURCE) $(DEP_CPP_FASTW) "$(INTDIR)"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\Undo.cpp
DEP_CPP_UNDO_=\
	".\undo.h"\
	

"$(INTDIR)\Undo.obj" : $(SOURCE) $(DEP_CPP_UNDO_) "$(INTDIR)"


# End Source File
# End Target
# End Project
################################################################################
