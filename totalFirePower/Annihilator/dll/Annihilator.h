// Title: Annihilator.h
// Project: Annihilator.dll
// Copyright (C) 1997-1998 Adam Swensen

#ifndef ANNIHILATOR_H
#define ANNIHILATOR_H

#include <windows.h>

/* Misc declarations */
typedef void (__stdcall *STATUSCALLBACK)(long Value, long Max);

/* Misc functions */
__declspec(dllexport) void WINAPI MiniGenerateDraft(long *MapData, unsigned char *TileData, unsigned char *MiniMap, long MapWidth, long MapHeight);
__declspec(dllexport) void WINAPI MiniGenerateFinal(long *MapData, unsigned char *TileData, unsigned char *MiniMap, long MapWidth, long MapHeight, RGBQUAD *TAPalette, STATUSCALLBACK Callback, long MaxTile);
__declspec(dllexport) void WINAPI CreateTileChecksumList(unsigned char *TileData, long *TileList, long MaxTileList);

#endif