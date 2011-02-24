// name: GAF.h
// project: Annihilator.dll

#ifndef GAF_h
#define GAF_h

#include <io.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <windows.h>

// Define GAF structures.
struct GAFHeader {
	long Version;
	long Entries;
	long Unknown;
};

struct GAFEntry {
	short Frames;
	short Unknown1;
	char EntryName[32];
	long PTRFrameTable;
	long Unknown2;
};

struct GAFFrame {
	short Width;
	short Height;
	short PositionX;
	short PositionY;
	BYTE Unknown1;
	BYTE CompressFlag;
	short FramePointers;
	long Unknown2;
	long PTRFrameData;
	long Unknown3;
};

// GAF functions.
__declspec(dllexport) void WINAPI GAFImageLoad(char *Filename, long PTRFrameHeader, BYTE *Image);

#endif