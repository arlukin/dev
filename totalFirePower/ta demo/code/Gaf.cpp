#include "Gaf.h"
#include "hash.h"
#include "hpihandler.h"
#include "mygl.h"
#include "infoconsole.h"
//---------------------------------------------------------------------------
using namespace std;
CGaf* gafHandler;

CGaf::CGaf()
{
	PrintLoadMsg("Mapping gaf files");

  GafTable = hash_new(1, hash_function, hash_compare);

	map<string,CHpiHandler::FileData>::iterator fi;

	for(fi=hpiHandler->files.begin();fi!=hpiHandler->files.end();++fi){
		if(fi->first.find(".gaf")!=string::npos){
			PutGafs(fi->first.c_str());
		}
	}

/*  
	GafDir=GafDira;
  GafTable = hash_new(1, hash_function, hash_compare);

  //ffblk ffblk;
  std::string SearchDir;
  SearchDir=GafDir+"*.gaf";
  WIN32_FIND_DATA FindFileData;
  HANDLE Find = FindFirstFile(SearchDir.c_str(), &FindFileData);//findfirst(SearchDir, &ffblk, 0);
  PutGafs((GafDir+FindFileData.cFileName).c_str());
  while(FindNextFile(Find, &FindFileData))
  {
    PutGafs((GafDir+FindFileData.cFileName).c_str());
  }
  FindClose(Find);
*/
}

CGaf::~CGaf()
{

  hash_for_each(hash_freea_alla, GafTable);
  hash_free(GafTable);

}

unsigned char *CGaf::GetGaf(const char *Name, const char *File,int SubFrame)
{
  unsigned char *ReturnData;

  cGaf TempGaf;
  strcpy(TempGaf.GafName, Name);
	MakeLower(TempGaf.GafName);

	int size=hpiHandler->GetFileSize(File);
	unsigned char* fileBuf=new unsigned char[size];
	hpiHandler->LoadFile(File,fileBuf);

  _GAFHEADER GafHeader;
	memcpy(&GafHeader,&fileBuf[0],sizeof(GafHeader));
  long *EntryPTR = new long[GafHeader.Entries];
	memcpy(EntryPTR,&fileBuf[sizeof(GafHeader)],GafHeader.Entries*sizeof(EntryPTR));

	long offset=0;

	_GAFENTRY GafEntry;

  for(int i=0; i<GafHeader.Entries; i++){
		memcpy(&GafEntry,&fileBuf[EntryPTR[i]],sizeof(GafEntry));

		char gname[64];
    strcpy(gname, GafEntry.Name);
		MakeLower(gname);

		if(strcmp(gname,TempGaf.GafName)==0){
			offset=EntryPTR[i]+sizeof(GafEntry);
			break;
		}
  }
  delete[] EntryPTR;
	if(offset==0)
		return 0;

	int curOffset=offset;

  _GAFFRAMEENTRY GafFrameEntry;

  if(GafEntry.Frames< (2>(SubFrame+1) ? 2:(SubFrame+1))){
    SubFrames = false;
  } else {
    for(int i=0; i<SubFrame; i++){
			curOffset+=sizeof(GafFrameEntry);
		}
    SubFrames = true;
  }
	memcpy(&GafFrameEntry,&fileBuf[curOffset],sizeof(GafFrameEntry));

  _GAFFRAMEDATA GafFrameData;
	memcpy(&GafFrameData,&fileBuf[GafFrameEntry.PtrFrameTable],sizeof(GafFrameData));

  Height = GafFrameData.Height;
  Width = GafFrameData.Width;
	xOffset=GafFrameData.XPos;
	yOffset=GafFrameData.YPos;

  if(GafFrameData.FramePointers!=0){
    int pp=*(int*)&fileBuf[GafFrameData.PtrFrameData];

		memcpy(&GafFrameData,&fileBuf[pp],sizeof(GafFrameData));
  }

  if(GafFrameData.Compressed == 0){
    //no compression, just copy bytes
    ReturnData = new unsigned char[Width * Height];
		memcpy(ReturnData,&fileBuf[GafFrameData.PtrFrameData],Width * Height);
  } else {
		ReturnData=DecodeGaf(fileBuf,&GafFrameData);
  }

	delete[] fileBuf;
  return ReturnData;

}

unsigned char *CGaf::GetGaf(const char *Name, int SubFrame)
{
  unsigned char *ReturnData;

	if(Name[0]==0)
		return 0;

  cGaf TempGaf;
  strcpy(TempGaf.GafName, Name);
	MakeLower(TempGaf.GafName);
  cGaf *GafEntry = (cGaf*)hash_search((void*)&TempGaf, GafTable);
  if(GafEntry == NULL)
    return NULL;

	int size=hpiHandler->GetFileSize(GafEntry->FileName);
	unsigned char* fileBuf=new unsigned char[size];
	hpiHandler->LoadFile(GafEntry->FileName,fileBuf);
//  ifstream GAF(GafEntry->FileName, ios::binary);

//  GAF.seekg(GafEntry->Offset);
	int curOffset=GafEntry->Offset;

  _GAFFRAMEENTRY GafFrameEntry;
/*
  if(strcmpi(GafEntry->FileName + (strlen(GafEntry->FileName)-9), "logos.gaf")!=0)
    SubFrame = 0;
*/
  if(GafEntry->GafEntry.Frames< (2>(SubFrame+1) ? 2:(SubFrame+1))){
    SubFrames = false;
  } else {
    for(int i=0; i<SubFrame; i++){
      //GAF.read((char*)&GafFrameEntry, sizeof(GafFrameEntry));
			curOffset+=sizeof(GafFrameEntry);
		}
    SubFrames = true;
  }
/*
  if(strcmpi(GafEntry->FileName + (strlen(GafEntry->FileName)-9), "logos.gaf")!=0)
    SubFrames = false;
*/    
// GAF.read((char*)&GafFrameEntry, sizeof(GafFrameEntry));
	memcpy(&GafFrameEntry,&fileBuf[curOffset],sizeof(GafFrameEntry));

  _GAFFRAMEDATA GafFrameData;
//  GAF.seekg(GafFrameEntry.PtrFrameTable);
 // GAF.read((char*)&GafFrameData, sizeof(GafFrameData));
	memcpy(&GafFrameData,&fileBuf[GafFrameEntry.PtrFrameTable],sizeof(GafFrameData));

  Height = GafFrameData.Height;
  Width = GafFrameData.Width;
	xOffset=GafFrameData.XPos;
	yOffset=GafFrameData.YPos;

  if(GafFrameData.FramePointers!=0){
    //put only first subframe
//    GAF.seekg(GafFrameData.PtrFrameData);
 //   GAF.read((char*)&pp, sizeof(pp));
    int pp=*(int*)&fileBuf[GafFrameData.PtrFrameData];

//    GAF.seekg(pp);
  //  GAF.read((char*)&GafFrameData, sizeof(GafFrameData));
		memcpy(&GafFrameData,&fileBuf[pp],sizeof(GafFrameData));
  }

  if(GafFrameData.Compressed == 0){
    //no compression, just copy bytes
    ReturnData = new unsigned char[Width * Height];
//    GAF.seekg(GafFrameData.PtrFrameData);
//    GAF.read(ReturnData, Width * Height);
//    GAF.close();
		memcpy(ReturnData,&fileBuf[GafFrameData.PtrFrameData],Width * Height);
		if(GafFrameData.Unknown1!=9){
			for(int a=0;a<Width*Height;++a){
				if(ReturnData[a]==GafFrameData.Unknown1)
					ReturnData[a]=9;
			}
		}
  } else {
		ReturnData=DecodeGaf(fileBuf,&GafFrameData);
//		MessageBox(0,"Compressed gafs not supported","Lazy eha",0);
//    return NULL;
  }

	delete[] fileBuf;
  return ReturnData;
}

unsigned char *CGaf::DecodeGaf(unsigned char *fileBuf, _GAFFRAMEDATA *GafFrameData)
{
  Height = GafFrameData->Height;
  Width = GafFrameData->Width;

//  ifstream GAF(FileName, ios::binary);

  unsigned char *ReturnData = new unsigned char[Height * Width];
//  GAF.seekg(GafFrameData->PtrFrameData);
	int fileOffset=GafFrameData->PtrFrameData;

  for(int i=0; i<Height; i++){
    unsigned short Count=*(unsigned short*)&fileBuf[fileOffset];
		fileOffset+=2;
    int offset = i*Width;
    unsigned char Byte;
    unsigned char mask;
    while(Count){
			mask=fileBuf[fileOffset++];
      Count--;
      if((mask & 0x01) == 0x01){
        for(int k=0; k<(mask >> 1); k++){
          ReturnData[offset] = 0x0;
          offset++;// += (mask >> 1);
        }
      } else if((mask & 0x02) == 0x02) {
        Byte=fileBuf[fileOffset++];
        Count--;
        for(int k=0; k<(mask >> 2)+1; k++){
          ReturnData[offset] = Byte;
          offset++;
        }
      } else {
        for(int k=0; k<(mask >> 2)+1; k++) {
          Byte=fileBuf[fileOffset++];
          Count--;
          ReturnData[offset] = Byte;
          offset++;
        }
      }
    }
		for(;offset<(i+1)*Width;++offset)
			ReturnData[offset]=0;
  }
  return ReturnData;
}

void CGaf::PutGafs(const char *FileName)
{
//  ifstream GAF(FileName, ios::binary);
	int size=hpiHandler->GetFileSize(FileName);
	unsigned char* fileBuf=new unsigned char[size];
	hpiHandler->LoadFile(FileName,fileBuf);

  _GAFHEADER GafHeader;
//  GAF.read((char*)&GafHeader, sizeof(GafHeader));
	memcpy(&GafHeader,&fileBuf[0],sizeof(GafHeader));
  long *EntryPTR = new long[GafHeader.Entries];
//  GAF.read((char*)EntryPTR, GafHeader.Entries*sizeof(EntryPTR));
	memcpy(EntryPTR,&fileBuf[sizeof(GafHeader)],GafHeader.Entries*sizeof(EntryPTR));

  for(int i=0; i<GafHeader.Entries; i++)
    {
    cGaf *GafStruct = new cGaf;
    _GAFENTRY GafEntry;
//    GAF.seekg(EntryPTR[i]);
//    GAF.read((char*)&GafEntry, sizeof(GafEntry));
		memcpy(&GafEntry,&fileBuf[EntryPTR[i]],sizeof(GafEntry));

    strcpy(GafStruct->FileName, FileName);
    strcpy(GafStruct->GafName, GafEntry.Name);
		MakeLower(GafStruct->GafName);

//    GafStruct->Offset = GAF.tellg();
		GafStruct->Offset=EntryPTR[i]+sizeof(GafEntry);

//    char FileTMP[MAX_PATH];
//    strcpy(FileTMP, GafDir);
//	  strcpy(FileTMP, FileName);

    memcpy(&(GafStruct->GafEntry), &GafEntry, sizeof(_GAFENTRY));

    hash_insert((void *)GafStruct, GafTable);
  }
//  GAF.close();
	delete[] fileBuf;
  delete[] EntryPTR;
}

void CGaf::MakeLower(char *s)
{
	for(int a=0;s[a]!=0;++a)
		if(s[a]>='A' && s[a]<='Z')
			s[a]+='a'-'A';
}

int hash_function(void *element, int storlek)
{
  cGaf *E = (cGaf*)element;
  int Value = 0;
  for(int i=0; i<(int)strlen((*E).GafName); i++)
    Value += (*E).GafName[i];
  return Value % storlek;
}

int hash_compare(void *el1, void *el2)
{
   cGaf *E1 = (cGaf*)el1;
   cGaf *E2 = (cGaf*)el2;
   return strcmp((*E1).GafName, (*E2).GafName);
}

void hash_freea_alla (void *elem)
{
  delete elem;
}

