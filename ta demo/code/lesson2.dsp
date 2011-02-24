# Microsoft Developer Studio Project File - Name="lesson2" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Application" 0x0101

CFG=lesson2 - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "lesson2.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "lesson2.mak" CFG="lesson2 - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "lesson2 - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "lesson2 - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE "lesson2 - Win32 Profile" (based on "Win32 (x86) Application")
!MESSAGE "lesson2 - Win32 Sphere Projection" (based on "Win32 (x86) Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
MTL=midl.exe
RSC=rc.exe

!IF  "$(CFG)" == "lesson2 - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "release"
# PROP Intermediate_Dir "Release"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /YX /FD /c
# ADD CPP /nologo /G6 /W3 /GR /GX /O2 /Ob2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /FR /YX /FD /c
# ADD BASE MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x1009 /d "NDEBUG"
# ADD RSC /l 0x1009 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /machine:I386
# ADD LINK32 dsound.lib Dxguid.lib winmm.lib dinput.lib opengl32.lib glu32.lib glaux.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib jpeg.lib /nologo /subsystem:windows /debug /machine:I386 /out:"bagge/spring.exe"
# SUBTRACT LINK32 /pdb:none /map

!ELSEIF  "$(CFG)" == "lesson2 - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /YX /FD /GZ /c
# ADD CPP /nologo /W3 /Gm /GR /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /FR /YX /FD /GZ /c
# ADD BASE MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x1009 /d "_DEBUG"
# ADD RSC /l 0x1009 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /debug /machine:I386 /pdbtype:sept
# ADD LINK32 ws2_32.lib dsound.lib Dxguid.lib winmm.lib dinput.lib opengl32.lib glu32.lib glaux.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib jpeg.lib /nologo /subsystem:windows /debug /machine:I386 /out:"bagge/lesson2.exe" /pdbtype:sept

!ELSEIF  "$(CFG)" == "lesson2 - Win32 Profile"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "lesson2___Win32_Profile"
# PROP BASE Intermediate_Dir "lesson2___Win32_Profile"
# PROP BASE Ignore_Export_Lib 0
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Profile"
# PROP Intermediate_Dir "Profile"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /G6 /W3 /GX /O2 /Ob2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /FR /YX /FD /c
# ADD CPP /nologo /G6 /W3 /GR /GX /O2 /Ob2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /FR /YX /FD /c
# ADD BASE MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x1009 /d "NDEBUG"
# ADD RSC /l 0x1009 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 opengl32.lib glu32.lib glaux.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib ws2_32.lib /nologo /subsystem:windows /machine:I386 /out:"bagge/spring.exe"
# SUBTRACT BASE LINK32 /pdb:none
# ADD LINK32 ws2_32.lib dsound.lib Dxguid.lib winmm.lib dinput.lib opengl32.lib glu32.lib glaux.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib jpeg.lib /nologo /subsystem:windows /profile /machine:I386

!ELSEIF  "$(CFG)" == "lesson2 - Win32 Sphere Projection"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "lesson2___Win32_Sphere_Projection"
# PROP BASE Intermediate_Dir "lesson2___Win32_Sphere_Projection"
# PROP BASE Ignore_Export_Lib 0
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "lesson2___Win32_Sphere_Projection"
# PROP Intermediate_Dir "lesson2___Win32_Sphere_Projection"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /G6 /W3 /GR /GX /O2 /Ob2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /FR /YX /FD /c
# ADD CPP /nologo /G6 /W3 /GR /GX /O2 /Ob2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /D "SPICLOPS" /FR /YX /FD /c
# ADD BASE MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x1009 /d "NDEBUG"
# ADD RSC /l 0x1009 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 dsound.lib Dxguid.lib winmm.lib dinput.lib opengl32.lib glu32.lib glaux.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib ws2_32.lib /nologo /subsystem:windows /debug /machine:I386 /out:"bagge/spring.exe"
# SUBTRACT BASE LINK32 /pdb:none
# ADD LINK32 spiclops.lib ws2_32.lib dsound.lib Dxguid.lib winmm.lib dinput.lib opengl32.lib glu32.lib glaux.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib jpeg.lib /nologo /subsystem:windows /machine:I386 /out:"bagge/spispring.exe"
# SUBTRACT LINK32 /pdb:none /debug

!ENDIF 

# Begin Target

# Name "lesson2 - Win32 Release"
# Name "lesson2 - Win32 Debug"
# Name "lesson2 - Win32 Profile"
# Name "lesson2 - Win32 Sphere Projection"
# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat"
# Begin Source File

SOURCE=.\3DOParser.cpp
# End Source File
# Begin Source File

SOURCE=.\Bitmap.cpp
# End Source File
# Begin Source File

SOURCE=.\Camera.cpp
# End Source File
# Begin Source File

SOURCE=.\DrawTree.cpp
# End Source File
# Begin Source File

SOURCE=.\DrawUI.cpp
# End Source File
# Begin Source File

SOURCE=.\DrawWater.cpp
# End Source File
# Begin Source File

SOURCE=.\FeatureHandler.cpp
# End Source File
# Begin Source File

SOURCE=.\float3.cpp
# End Source File
# Begin Source File

SOURCE=.\Gaf.cpp
# End Source File
# Begin Source File

SOURCE=.\Game.cpp
# End Source File
# Begin Source File

SOURCE=.\glFont.cpp
# End Source File
# Begin Source File

SOURCE=.\glList.cpp
# End Source File
# Begin Source File

SOURCE=.\GlobalStuff.cpp
# End Source File
# Begin Source File

SOURCE=.\Ground.cpp
# End Source File
# Begin Source File

SOURCE=.\GroundDrawer.cpp
# End Source File
# Begin Source File

SOURCE=.\GuiKeyReader.cpp
# End Source File
# Begin Source File

SOURCE=.\hash.cpp
# End Source File
# Begin Source File

SOURCE=.\HpiHandler.cpp
# End Source File
# Begin Source File

SOURCE=.\InfoConsole.cpp
# End Source File
# Begin Source File

SOURCE=.\Lesson2.cpp
# End Source File
# Begin Source File

SOURCE=.\MemPool.cpp
# End Source File
# Begin Source File

SOURCE=.\MiniMap.cpp
# End Source File
# Begin Source File

SOURCE=.\MouseHandler.cpp
# End Source File
# Begin Source File

SOURCE=.\myGL.cpp
# End Source File
# Begin Source File

SOURCE=.\Object.cpp
# End Source File
# Begin Source File

SOURCE=.\otareader.cpp
# End Source File
# Begin Source File

SOURCE=.\ProjectileHandler.cpp
# End Source File
# Begin Source File

SOURCE=.\ReadMap.cpp
# End Source File
# Begin Source File

SOURCE=.\RegHandler.cpp
# End Source File
# Begin Source File

SOURCE=.\Sky.cpp
# End Source File
# Begin Source File

SOURCE=.\TAPalette.cpp
# End Source File
# Begin Source File

SOURCE=.\TextureHandler.cpp
# End Source File
# Begin Source File

SOURCE=.\TimeProfiler.cpp
# End Source File
# Begin Source File

SOURCE=.\TreeDrawer.cpp
# End Source File
# Begin Source File

SOURCE=.\UnitDrawer.cpp
# End Source File
# Begin Source File

SOURCE=.\VertexArray.cpp
# End Source File
# Begin Source File

SOURCE=.\VertexArrayRange.cpp
# End Source File
# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl"
# Begin Source File

SOURCE=.\3DOParser.h
# End Source File
# Begin Source File

SOURCE=.\Bitmap.h
# End Source File
# Begin Source File

SOURCE=.\Camera.h
# End Source File
# Begin Source File

SOURCE=.\DrawTree.h
# End Source File
# Begin Source File

SOURCE=.\DrawUI.h
# End Source File
# Begin Source File

SOURCE=.\DrawWater.h
# End Source File
# Begin Source File

SOURCE=.\FeatureHandler.h
# End Source File
# Begin Source File

SOURCE=.\float3.h
# End Source File
# Begin Source File

SOURCE=.\Gaf.h
# End Source File
# Begin Source File

SOURCE=.\Game.h
# End Source File
# Begin Source File

SOURCE=.\Glext.h
# End Source File
# Begin Source File

SOURCE=.\glFont.h
# End Source File
# Begin Source File

SOURCE=.\glh_genext.h
# End Source File
# Begin Source File

SOURCE=.\glList.h
# End Source File
# Begin Source File

SOURCE=.\GlobalStuff.h
# End Source File
# Begin Source File

SOURCE=.\Ground.h
# End Source File
# Begin Source File

SOURCE=.\GroundDrawer.h
# End Source File
# Begin Source File

SOURCE=.\GuiKeyReader.h
# End Source File
# Begin Source File

SOURCE=.\HpiHandler.h
# End Source File
# Begin Source File

SOURCE=.\HPIUtil.h
# End Source File
# Begin Source File

SOURCE=.\InfoConsole.h
# End Source File
# Begin Source File

SOURCE=.\IRenderer.h
# End Source File
# Begin Source File

SOURCE=.\MemPool.h
# End Source File
# Begin Source File

SOURCE=.\MiniMap.h
# End Source File
# Begin Source File

SOURCE=.\MouseHandler.h
# End Source File
# Begin Source File

SOURCE=.\mygl.h
# End Source File
# Begin Source File

SOURCE=.\Object.h
# End Source File
# Begin Source File

SOURCE=.\otareader.h
# End Source File
# Begin Source File

SOURCE=.\ProjectileHandler.h
# End Source File
# Begin Source File

SOURCE=.\ReadMap.h
# End Source File
# Begin Source File

SOURCE=.\RegHandler.h
# End Source File
# Begin Source File

SOURCE=.\resource.h
# End Source File
# Begin Source File

SOURCE=.\Sky.h
# End Source File
# Begin Source File

SOURCE=.\TAPalette.h
# End Source File
# Begin Source File

SOURCE=.\TextureHandler.h
# End Source File
# Begin Source File

SOURCE=.\TimeProfiler.h
# End Source File
# Begin Source File

SOURCE=.\TreeDrawer.h
# End Source File
# Begin Source File

SOURCE=.\UnitDrawer.h
# End Source File
# Begin Source File

SOURCE=.\VertexArray.h
# End Source File
# Begin Source File

SOURCE=.\VertexArrayRange.h
# End Source File
# End Group
# Begin Group "Resource Files"

# PROP Default_Filter "ico;cur;bmp;dlg;rc2;rct;bin;rgs;gif;jpg;jpeg;jpe"
# End Group
# End Target
# End Project
