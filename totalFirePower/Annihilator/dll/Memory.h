// name: Memory.h
// project: Annihilator.dll

#ifndef MEMORY_h
#define MEMORY_h

#include <io.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <windows.h>

/* Memory block functions */
__declspec(dllexport) void WINAPI BlockCreate(long Size);
__declspec(dllexport) void WINAPI BlockWrite(unsigned char *data, long Position, long DataSize);
__declspec(dllexport) unsigned char * WINAPI BlockGet();
__declspec(dllexport) long WINAPI BlockExport(char *Filename);
__declspec(dllexport) void WINAPI BlockFree();

/* Misc memory functions */
__declspec(dllexport) void WINAPI CopyArray(unsigned char *ArrayDest, unsigned char *ArraySrc, long Size);

#endif