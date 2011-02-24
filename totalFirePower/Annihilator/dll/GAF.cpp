// name: GAF.cpp
// project: Annihilator.dll

#include "gaf.h"

/* Load a GAF image from the specified position on a disk file. */
__declspec(dllexport) void WINAPI GAFImageLoad(char *Filename, long PTRFrameHeader, BYTE *Image)
{
	int i;
	int x, y;
	int RowPos;
	short Bytes;
	GAFFrame Frame;
	BYTE CH, Pixel;
	//BYTE *Buffer;

	// Initialize.
	//Buffer = new BYTE[0];
	FILE *hFile = fopen(Filename, "rb");
	if (!hFile)
		return;

	// Load the frame header.
	fseek(hFile, PTRFrameHeader, SEEK_SET);
	fread(&Frame, sizeof(GAFFrame), 1, hFile);
	if (Frame.FramePointers > 1)  
		return;

	// Reset the frame's pixels to color 100 (blue).
	for (i=0; i<(Frame.Width*Frame.Height); i++)
		Image[i] = 100;
	
	// Load the frame data.
	fseek(hFile, Frame.PTRFrameData, SEEK_SET);
	if (Frame.CompressFlag == 0) {
		fread(Image, (Frame.Width*Frame.Height), 1, hFile);
	} else if (Frame.CompressFlag == 1) {
		for (y=0; y<Frame.Height; y++) {
			fread(&Bytes, 2, 1, hFile);
			RowPos = 0;
			x = 0;
			while (RowPos < Bytes) {
				fread(&CH, 1, 1, hFile);
				++RowPos;
				if ((CH & 1) == 1) { // transparent
					x += (CH / 2);
				} else if ((CH & 2) == 2) { // repeat pixel
					fread(&Pixel, 1, 1, hFile);
					++RowPos;
					for (i=0; i<=(CH / 4); i++)
						Image[y * Frame.Width + x + i] = Pixel;
					x += (CH / 4) + 1;
				} else { // pixel dump
					for (i=0; i<=(CH / 4); i++) {
						fread(&Pixel, 1, 1, hFile);	
						++RowPos;
						Image[y * Frame.Width + x + i] = Pixel;
					}
					x += (CH / 4) + 1;
				}
			}
		}
	}

	fclose(hFile);
}
