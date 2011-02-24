// name: Memory.cpp
// project: Annihilator.dll

#include "memory.h"

// Memory block.
unsigned char *Block;
long BlockSize;

/* Memory block functions. */
__declspec(dllexport) void WINAPI BlockCreate(long Size)
{
	Block = new unsigned char[Size];
	BlockSize = Size;
}

__declspec(dllexport) void WINAPI BlockWrite(unsigned char *data, long Position, long DataSize)
{
	long i;

	for (i=Position; i<(Position+DataSize); i++)
		if (Position < BlockSize)
			Block[i] = data[i-Position];
}

__declspec(dllexport) unsigned char * WINAPI BlockGet()
{
	return (Block);
}

__declspec(dllexport) long WINAPI BlockExport(char *Filename)
{
	FILE *hFile = fopen(Filename, "wb");
	long value = fwrite(Block, BlockSize, 1, hFile);
	fclose(hFile);
	return value;
}

__declspec(dllexport) void WINAPI BlockFree()
{
	delete [] Block;
}

/* Copy from one array to another. */
__declspec(dllexport) void WINAPI CopyArray(unsigned char *ArrayDest, unsigned char *ArraySrc, long Size)
{
	long i;

	for (i=0; i<Size; i++) {
		ArrayDest[i] = ArraySrc[i];
	}
}
