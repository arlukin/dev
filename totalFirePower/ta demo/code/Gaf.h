//---------------------------------------------------------------------------
#ifndef GafH
#define GafH

#include "hash.h"
#include <fstream>
#include <windows.h>
#include <string>

//#include <dir.h>
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------

class CGaf
{
	public:
	struct _GAFHEADER {
	  long IDVersion;  /* Version stamp - always 0x00010100 */
	  long Entries;    /* Number of items contained in this file */
	  long Unknown1;   /* Always 0 */
	};

	struct _GAFENTRY {
	  short Frames;    /* Number of frames in this entry */
	  short Unknown1;  /* Unknown - always 1 */
	  long Unknown2;   /* Unknown - always 0 */
	  char Name[32];   /* Name of the entry */
	};

	struct _GAFFRAMEENTRY {
	  long PtrFrameTable;  /* Pointer to frame data */
	  long Unknown1;       /* Unknown - varies */
	};

	struct _GAFFRAMEDATA {
	  short Width;         /* Width of the frame */
	  short Height;        /* Height of the frame */
	  short XPos;          /* X offset */
	  short YPos;          /* Y offset */
	  char Unknown1;       /* Unknown - always 9 */
	  char Compressed;     /* Compression flag */
	  short FramePointers;  /* Count of subframes */
	  long Unknown2;       /* Unknown - always 0 */
	  long PtrFrameData;   /* Pointer to pixels or subframes */
	  long Unknown3;       /* Unknown - value varies */
	};
  private:
	std::string GafDir;
    hashtab *GafTable;
    void PutGafs(const char *FileName);
    unsigned char *DecodeGaf(unsigned char *fileBuf, _GAFFRAMEDATA *GafFrameData);
  public:
	  void MakeLower(char* s);

    CGaf();
    ~CGaf();
    unsigned char *GetGaf(const char *Name, int SubFrame=0);
		unsigned char* GetGaf(const char *Name,const char *File,int SubFrame=0);
    int Width;
    int Height;
		int xOffset;
		int yOffset;
    bool SubFrames;
};

int hash_function(void *elementet, int storlek);
int hash_compare(void *el1, void *el2);
void hash_freea_alla(void *elem);

struct cGaf
{
	char GafName[32];
	CGaf::_GAFENTRY GafEntry;
	char FileName[MAX_PATH];
  int Offset;
};

extern CGaf* gafHandler;
//---------------------------------------------------------------------------
#endif
