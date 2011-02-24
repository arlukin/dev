// name: FastWin.cpp
// project: Annihilator.dll

#include "FastWin.h"

// Bitmap function variables.
BITMAPFILEHEADER FileHeader;
BITMAPINFOHEADER InfoHeader;
long Width, Height, ColorCount, BitCount;
enum { OpenErr = 0, Success, MemErr, ReadErr, ResErr, CompErr };

/* Graphics functions. */
__declspec(dllexport) void WINAPI WriteTile(long xPos, long yPos, long xWidth, long yWidth, long bmpWidth, long bmpHeight, unsigned char *pBitmap, unsigned char *TileData)
{
	int x, y;
	long Position, Max;
	
	Position = (yPos * bmpWidth) + xPos;
	Max = bmpWidth * bmpHeight - 1;
	for (y=0; y<yWidth; y++)
	{
		if (Position > Max)
			break;
		for (x=0; x<xWidth; x++)
		{	
			if (((Position+x) > Max) || ((Position+x) < 0))
				break;
			pBitmap[Position+x] = TileData[x+y*xWidth];
		}
		Position += bmpWidth;
	}
}

__declspec(dllexport) void WINAPI ClearTile(long xPos, long yPos, long xWidth, long yWidth, long bmpWidth, long bmpHeight, unsigned char *pBitmap, unsigned char *TileData, unsigned char MaskColor, unsigned char BackColor, long ClearFlag)
{
	int x, y;
	long Position, Max, Index;

	Max = bmpWidth * bmpHeight - 1;
	Position = (yPos * bmpWidth) + xPos;
	Index = 0;
	for (y=0; y<yWidth; y++)
	{
		for (x=0; x<xWidth; x++)
		{	
			if ((Position+x) > Max)
				break;
			if ((Position+x) > ((yPos+y+1)*bmpWidth))
				break;
			if ((Position+x) >= 0)
			{
				if ((TileData[Index] == MaskColor) && (!ClearFlag))
					pBitmap[Position+x] = BackColor;
				else if ((TileData[Index] != MaskColor) && (ClearFlag))
					pBitmap[Position+x] = TileData[Index];
				else if (!ClearFlag)
					pBitmap[Position+x] = TileData[Index];
			}
			++Index;
		}
		Position += bmpWidth;
		if (Position > Max)
			break;
	}
}

__declspec(dllexport) void WINAPI MaskTile(long xPos, long yPos, long xWidth, long yWidth, long bmpWidth, long bmpHeight, unsigned char *pBitmap, unsigned char *TileData, unsigned char MaskColor, unsigned char NewColor)
{
/*	int x, y;
	long StartPos;
	long Max;

	StartPos = (yPos * bmpWidth) + xPos;
	pBitmap += StartPos;
	for (x=0; x<xWidth; x++)
	{
		for (y=0; y<yWidth; y++)
		{	
			if (TileData[x*xWidth+y] != MaskColor)
			{
				*pBitmap = (TileData[x*xWidth+y] * NewColor);
			}
			++pBitmap;
		}
		pBitmap += (bmpWidth - xWidth);
	} */
	int x, y;
	long Position, Max;

	Position = (yPos * bmpWidth) + xPos;
	Max = bmpWidth * bmpHeight - 1;
	for (x=0; x<xWidth; x++)
	{
		for (y=0; y<yWidth; y++)
		{	
			if (((Position+y) <= Max) && ((Position+y) >= 0))
				if (TileData[x*xWidth+y] != MaskColor)
					pBitmap[Position+y] = TileData[x*yWidth+y] * NewColor;
		}
		Position += bmpWidth;
	}
}

__declspec(dllexport) void WINAPI DrawLine(long x1, long y1, long x2, long y2, unsigned char Color, long bmpWidth, long bmpHeight, unsigned char *pBitmap)
{
   int POSSLOPE;        // flag for slope
   int INC1;            // increment for unchanged
   int INC2;            // increment for changed
   int DX;              // delta X
   int DY;              // delta Y
   int R;               // row
   int C;               // column
   int F;               // final row or column
   int G;               // test value

/*   if (((x1 < 0) || (x1 >= bmpWidth) || (y1 < 0) || (y1 >= bmpHeight)) && ((x2 < 0) || (x2 >= bmpWidth) || (y2 < 0) || (y2 >= bmpHeight)))
		return;
   else if ((x1 < 0) || (x1 >= bmpWidth) || (y1 < 0) || (y1 >= bmpHeight)) {
		if (x1 < 0) {

		} else if (x1 >= bmpWidth) {

		} else if (y1 < 0) {

		} else if (y1 >= bmpHeight) {

		}
   } else if ((x2 < 0) || (x2 >= bmpWidth) || (y2 < 0) || (y2 >= bmpHeight)) {

   } */

   DX = x2 - x1;
   DY = y2 - y1;

   POSSLOPE = ( DX > 0 );
   if ( DY < 0 ) POSSLOPE = !POSSLOPE;

   if (abs(DX) > abs(DY)) // horizontal bias
   {
      if ( DX > 0 ) { C = x1; R = y1; F = x2; }
      else          { C = x2; R = y2; F = x1; }

      INC2 = (abs(DY)-abs(DX)) << 1;
      INC1 = (abs(DY))         << 1;
      G    = INC1-abs(DX);

      if ( POSSLOPE ) {

         while( C <= F )
         {
			if ((C >= 0) && (C < bmpWidth) && (R >= 0) && (R < bmpHeight))
				pBitmap[C + R * bmpWidth] = Color;
			++C;
			//DrawXOR( C++, R );
            if ( G >= 0 ) { ++R; G += INC2; }
            else          {      G += INC1; }
         }
      }
      else
      {
         while( C <= F )
         {
			if ((C >= 0) && (C < bmpWidth) && (R >= 0) && (R < bmpHeight))
				pBitmap[C + R * bmpWidth] = Color;
			++C;
            if ( G > 0 ) { --R; G += INC2; }
            else         {      G += INC1; }
         }
      }
   }
   else // vertical bias
   {
      if ( DY > 0 ) { C = y1; R = x1; F = y2; }
      else          { C = y2; R = x2; F = y1; }

      INC2 = (abs(DX)-abs(DY)) << 1;
      INC1 = (abs(DX))         << 1;
      G    = INC1-abs(DY);

      if ( POSSLOPE )
      {
         while( C <= F )
         {
			if ((R >= 0) && (R < bmpWidth) && (C >= 0) && (C < bmpHeight))
				pBitmap[R + C * bmpWidth] = Color;
			++C;
            if ( G >= 0 ) { ++R; G += INC2; }
            else          {      G += INC1; }
         }
      }
      else
      {
         while( C <= F )
         {
			if ((R >= 0) && (R < bmpWidth) && (C >= 0) && (C < bmpHeight))
				pBitmap[R + C * bmpWidth] = Color;
			++C;
            if ( G > 0 ) { --R; G += INC2; }
            else         {      G += INC1; }
         }
      }
   }
}

__declspec(dllexport) void WINAPI WritePixel(unsigned char *pBitmap, long Position, unsigned char Value)
{
	pBitmap += Position;
	*pBitmap = Value;
}


/* Bitmap functions. */
__declspec(dllexport) int WINAPI BMPInfo(char *FileName, long *BitSize, BITMAPINFOHEADER *bmpInfo)
{
	long ImageSize, ScanWidth, ScanPadding;
	FILE *InFile;


	if ((InFile = fopen (FileName, "rb")) == 0)
		return 0;

	// Load the file header data:
	if (fread(&FileHeader, sizeof FileHeader, 1, InFile) < 1)
		return 0;

	// Load the information header data:
	if (fread(&InfoHeader, sizeof InfoHeader, 1, InFile) < 1)
		return 0;
	*bmpInfo = InfoHeader;

	ColorCount = (long) pow(2.0F, InfoHeader.biBitCount);
	BitCount   = InfoHeader.biBitCount;

	Width       = InfoHeader.biWidth;
	Height      = InfoHeader.biHeight;
	ImageSize   = Width * Height;
	ScanWidth   = ((Width * (BitCount / 8)) + 3) & (~3);
	ScanPadding = ScanWidth - (Width * (BitCount / 8));

	*BitSize = ImageSize * (BitCount / 8);
	return 1;
  }


__declspec(dllexport) int WINAPI LoadBMP(char *FileName, unsigned char *Image, RGBQUAD *BmpPalette)
{
  FileName;
  long ImageSize, ScanWidth, ScanPadding, Y, YPos, i;
  FILE *InFile;
  RGBQUAD *Palette;

  if ( ( InFile = fopen ( FileName, "rb" ) ) == 0 )
     return OpenErr;

  // Load the file header data:
  if ( fread ( &FileHeader, sizeof FileHeader, 1, InFile ) 
       < 1 )
     return ReadErr;

  // Load the information header data:
  if ( fread ( &InfoHeader, sizeof InfoHeader, 1, InFile ) 
       < 1 )
     return ReadErr;

  ColorCount = ( long ) pow ( 2.0F, InfoHeader.biBitCount );
  BitCount   = InfoHeader.biBitCount;

  if ( BitCount <= 16 )
     {
     if ( ( Palette = new RGBQUAD [ ColorCount ] ) == 0 )
        return MemErr;
     if ( fread ( Palette, sizeof ( RGBQUAD ), ColorCount, InFile ) < ColorCount )
        return ReadErr;
     }

  Width       = InfoHeader.biWidth;
  Height      = InfoHeader.biHeight;
  ImageSize   = Width * Height;
  ScanWidth   = ( ( Width * ( BitCount / 8 ) ) + 3 ) & ( ~3 );
  ScanPadding = ScanWidth - ( Width * ( BitCount / 8 ) );

  // Load the bitmap:
  for ( Y = 0; Y < abs ( Height ); Y++ )
      {
      // Load a scan-line:
      switch ( InfoHeader.biCompression )
             {
             // Uncompressed image:
             case ( BI_RGB ):
                  {
                  switch ( BitCount )
                         {
                         // 256-color image:
                         case ( 8 ):
                              {
                              if ( Height < 0 )
                                 {
                                 YPos = Y * Width;
                                 }
                              else YPos = ( ( Height - Y ) * 
                                              Width ) - Width;

                              if ( fread ( &Image [ YPos ], 
                                   Width, 1, InFile ) < 1 )
                                 return 0;
							  for (i=0; i<256; i++)
							  {
									BmpPalette[i] = Palette[i];
							  }
                              break;
                              }
                         default: return 0;
                         }
                  break;
                  }
             default: return 0;
             }
      // Skip the padding possibly located at the end of each
      // scan-line:
      fseek ( InFile, ScanPadding, SEEK_CUR );
      }
  fclose ( InFile );
  Height = abs ( Height );
  delete [] Palette;
  return 1;
}

__declspec(dllexport) void WINAPI ConvertPalette(unsigned char *Image, long MaxValue, RGBQUAD *BmpPalette, RGBQUAD *TAPalette)
{
    long Lut[256]; // Look-up table.
    long Index, i;
    long r, g, b, Best;
    long br, bg, bb;
    
    for (Index=0; Index<256; Index++) {
        r = 10000;
        g = 10000;
        b = 10000;
        Best = 255;
        for (i=0; i<256; i++) {
            br = BmpPalette[Index].rgbRed;
            bg = BmpPalette[Index].rgbGreen;
            bb = BmpPalette[Index].rgbBlue;
            if ((abs(br - TAPalette[i].rgbRed) + abs(bg - TAPalette[i].rgbGreen) + abs(bb - TAPalette[i].rgbBlue)) < (r + g + b)) {
                Best = i;
                r = abs(br - TAPalette[i].rgbRed);
                g = abs(bg - TAPalette[i].rgbGreen);
                b = abs(bb - TAPalette[i].rgbBlue);
			}
        }
        Lut[Index] = Best;
    }
    
    for (Index=0; Index<=MaxValue; Index++)
        Image[Index] = Lut[Image[Index]];
}

__declspec(dllexport) void WINAPI CreateTilesFromBmp(unsigned char *pBitmap, unsigned char *pTiles, long bmpWidth, long bmpHeight)
{
	long Position = 0;
	long TileIndex = 0;
	long xIndex, yIndex;
	long Index, PositionOffset;
	long TileX, TileY;

    for (yIndex=0; yIndex<(bmpHeight/32); yIndex++)
	{
        for (xIndex=0; xIndex<(bmpWidth/32); xIndex++)
		{
            PositionOffset = 0;
            Index = 0;
            for (TileY=0; TileY<32; TileY++)
			{
                for (TileX=0; TileX<32; TileX++)
				{
                    pTiles[(TileIndex * 1024) + Index] = pBitmap[Position + TileX + PositionOffset + (xIndex * 32)];
                    ++Index;
                }
                PositionOffset = PositionOffset + bmpWidth;
            }
            ++TileIndex;
        }
        Position = Position + 32 * bmpWidth;
    }
}

__declspec(dllexport) void WINAPI GetRegion(long xPos, long yPos, long RegionWidth, long RegionHeight, long Width, long Height, unsigned char *pBitmap, unsigned char *Buffer)
{
	long x, y;

	for (y=yPos; y<yPos+RegionHeight; y++) {
		for (x=xPos; x<xPos+RegionWidth; x++) {
			Buffer[(x-xPos)+(y-yPos)*RegionWidth] = pBitmap[x+y*Width];
		}
	}
}
