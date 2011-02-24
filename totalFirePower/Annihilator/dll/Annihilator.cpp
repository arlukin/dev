// Title: Annihilator.cpp
// Project: Annihilator.dll
// Copyright (C) 1997-1998 Adam Swensen

#include "annihilator.h"

__declspec(dllexport) void WINAPI MiniGenerateDraft(long *MapData, unsigned char *TileData, unsigned char *MiniMap, long MapWidth, long MapHeight)
{
	long TNTMapWidth, TNTMapHeight;
	long MiniMapWidth, MiniMapHeight;
	long MiniIndex, MiniStepX, MiniStepY;
	long IndexX, IndexY, StepX, StepY, i;
	long AvgR, AvgG, AvgB, AvgCount;
	long difR, difG, difB, dif, difIndex;
	long TileIndex, PosX, PosY;
	long TempX, TempY;

	// initialize.
	TNTMapWidth = (MapWidth * 16) - 32;
    TNTMapHeight = (MapHeight  * 16) - 128;
    if (TNTMapWidth > TNTMapHeight) { // It will be 252 across.
        MiniMapWidth = 252;
        MiniMapHeight = ((MiniMapWidth * TNTMapHeight) / TNTMapWidth);
	}
    else if (TNTMapHeight > TNTMapWidth) {
        MiniMapHeight = 252;
        MiniMapWidth = ((MiniMapHeight * TNTMapWidth) / TNTMapHeight);
	}
    else if (TNTMapWidth == TNTMapHeight) {
        MiniMapWidth = 252;
        MiniMapHeight = 252;
    }
    
	for (i=0; i<252*252; i++) {
		MiniMap[i] = 100;
	}

}

/* Generate a high quality resampled minimap image of a map. */
__declspec(dllexport) void WINAPI MiniGenerateFinal(long *MapData, unsigned char *TileData, unsigned char *MiniMap, long MapWidth, long MapHeight, RGBQUAD *TAPalette, STATUSCALLBACK Callback, long MaxTile)
{
	long TNTMapWidth, TNTMapHeight;
	long MiniMapWidth, MiniMapHeight;
	long MiniIndex, MiniIndexX, MiniStepX, MiniStepY;
	long IndexX, IndexY, StepX, StepY, i;
	long AvgR[128*128], AvgG[128*128], AvgB[128*128], AvgCount[128*128];
	long difR, difG, difB, dif, difIndex;
	long TileIndex, PosX, PosY;
	long TempX, TempY;
	long MapIndex;
	unsigned char PaletteIndex;
	
	// initialize.
	TNTMapWidth = (MapWidth * 16) - 32;
    TNTMapHeight = (MapHeight  * 16) - 128;
    if (TNTMapWidth > TNTMapHeight) { // It will be 252 across.
        MiniMapWidth = 252;
        MiniMapHeight = ((MiniMapWidth * TNTMapHeight) / TNTMapWidth);
	}
    else if (TNTMapHeight > TNTMapWidth) {
        MiniMapHeight = 252;
        MiniMapWidth = ((MiniMapHeight * TNTMapWidth) / TNTMapHeight);
	}
    else if (TNTMapWidth == TNTMapHeight) {
        MiniMapWidth = 252;
        MiniMapHeight = 252;
    }
    
	for (i=0; i<252*252; i++) {
		MiniMap[i] = 100;
	}

	PosY = 0;
	MiniIndex = 0;
    MiniStepX = (TNTMapWidth / MiniMapWidth);
    MiniStepY = (TNTMapHeight / MiniMapHeight);
	for (IndexY=0; IndexY < TNTMapHeight; IndexY++) {
		PosX = 0;
		TileIndex = IndexY / 32;
		TileIndex *= (MapWidth/2);
        MiniIndex = (IndexY / MiniStepY) * 252;
		if (MiniIndex >= (252*252)) break;
		Callback(IndexY*TNTMapWidth, TNTMapWidth*TNTMapHeight);
        for (IndexX=0; IndexX < TNTMapWidth; IndexX++) {
			MiniIndexX = (IndexX / MiniStepX);
			if (MiniIndexX >= 252) MiniIndexX = 251;

			MapIndex = MapData[TileIndex] * 1024 + PosY * 32 + PosX;
			if ((MapIndex < MaxTile) && (MapIndex >= 0)) {
				PaletteIndex = TileData[MapIndex];
				AvgR[MiniIndex+MiniIndexX] += TAPalette[PaletteIndex].rgbRed;
				AvgG[MiniIndex+MiniIndexX] += TAPalette[PaletteIndex].rgbGreen;
				AvgB[MiniIndex+MiniIndexX] += TAPalette[PaletteIndex].rgbBlue;
				++AvgCount[MiniIndex+MiniIndexX];
			}
			++PosX;
			if (PosX == 32) {
				PosX = 0;
				++TileIndex;
			}
		}
		++PosY;
		if (PosY == 32) PosY = 0;
	}

	/*for (i=0; i<(252*252); i++) {
		Callback(i, 252*252);
		AvgR[i] /= AvgCount[i];
		AvgG[i] /= AvgCount[i];
		AvgB[i] /= AvgCount[i];
		dif = 10000;
		difIndex = 0;
		for (i=0; i<256; i++) {
			difR = abs(AvgR[i] - TAPalette[i].rgbRed);
			difG = abs(AvgG[i] - TAPalette[i].rgbGreen);
			difB = abs(AvgB[i] - TAPalette[i].rgbBlue);
			if ((difR + difG + difB) < dif) {
				dif = difR + difG + difB;
				difIndex = i;
			}
		}
		MiniMap[i] = difIndex;
	}*/
}

/* Create a map-tile checksum list. */
__declspec(dllexport) void WINAPI CreateTileChecksumList(unsigned char *TileData, long *TileList, long MaxTileList)
{
    long Index, i;
    
    for (Index=0; Index<=MaxTileList; Index++)
	{
        TileList[Index] = 0;
        for (i=0; i<1024; i++)
			TileList[Index] = TileList[Index] + TileData[Index * 1024 + i];
	}
}

