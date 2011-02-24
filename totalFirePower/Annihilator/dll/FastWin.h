// name: FastWin.h
// project: Annihilator.dll

#ifndef FASTWIN_h
#define FASTWIN_h

#include <windows.h>
#include <math.h>
#include <stdio.h>

#define sgn(x) ((x<0)?-1:((x>0)?1:0)) // Macro to return the sign of a number.

/* Graphics functions. */
__declspec(dllexport) void WINAPI WriteTile(long xPos, long yPos, long xWidth, long yWidth, long bmpWidth, long bmpHeight, unsigned char *pBitmap, unsigned char *TileData);
__declspec(dllexport) void WINAPI ClearTile(long xPos, long yPos, long xWidth, long yWidth, long bmpWidth, long bmpHeight, unsigned char *pBitmap, unsigned char *TileData, unsigned char MaskColor, unsigned char BackColor, long ClearFlag);
__declspec(dllexport) void WINAPI MaskTile(long xPos, long yPos, long xWidth, long yWidth, long bmpWidth, long bmpheight, unsigned char *pBitmap, unsigned char *TileData, unsigned char MaskColor, unsigned char NewColor);
__declspec(dllexport) void WINAPI DrawLine(long x1, long y1, long x2, long y2, unsigned char Color, long bmpWidth, long bmpHeight, unsigned char *pBitmap);
__declspec(dllexport) void WINAPI WritePixel(unsigned char *pBitmap, long Position, unsigned char Value);
__declspec(dllexport) void WINAPI GetRegion(long xPos, long yPos, long RegionWidth, long RegionHeight, long Width, long Height, unsigned char *pBitmap, unsigned char *Buffer);

/* Bitmap functions. */
__declspec(dllexport) int WINAPI BMPInfo(char *FileName, long BitSize, BITMAPINFOHEADER *bmpInfo);
__declspec(dllexport) int WINAPI LoadBMP(char *FileName, unsigned char *Image, RGBQUAD *BmpPalette);
__declspec(dllexport) void WINAPI ConvertPalette(unsigned char *Image, long MaxValue, RGBQUAD *BmpPalette, RGBQUAD *TAPalette);
__declspec(dllexport) void WINAPI CreateTilesFromBmp(unsigned char *pBitmap, unsigned char *pTiles, long bmpWidth, long bmpHeight);

#endif