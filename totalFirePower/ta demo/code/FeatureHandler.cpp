// FeatureHandler.cpp: implementation of the CFeatureHandler class.
//
//////////////////////////////////////////////////////////////////////

#include "FeatureHandler.h"
#include "globalstuff.h"
#include "mygl.h"
#include "gaf.h"
#include "tapalette.h"
#include "hpihandler.h"
#include "otareader.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CFeatureHandler featureHandler;
using namespace std;

CFeatureHandler::CFeatureHandler()
{
	mapFeatures=0;
	featureTable=0;
}

CFeatureHandler::~CFeatureHandler()
{
	return;
	for(int a=0;a<numFeatures;++a){
		if(featureTable[a].showInMapTex)
			for(int b=0;b<3;++b)
				delete[] featureTable[a].lods[b];
	}
	delete[] mapFeatures;
	delete[] featureTable;
}


void CFeatureHandler::LoadFeatures(unsigned char *fileBuf,int featurePos,int featureTablePos,int featureTableSize)
{
	PrintLoadMsg("Mapping tdf files");
	FindTDFFiles();

	return;
	PrintLoadMsg("Loading map features");

	mapFeatures=new unsigned short[g.mapx*g.mapy];
	for(int a=0;a<g.mapx*g.mapy;++a)
		mapFeatures[a]=0;//xffff;

	featureTable=new FeatureData[featureTableSize];
	numFeatures=featureTableSize;

	for(a=0;a<featureTableSize;++a){
		string name=(char*)&fileBuf[featureTablePos+a*0x84+4];
		string file=name2file[name];
		char res[50];
		char res2[64];

		int size=hpiHandler->GetFileSize(file);
		unsigned char* tdfBuf=new unsigned char[size+1];
		tdfBuf[size]=0;
		hpiHandler->LoadFile(file,tdfBuf);

		featureTable[a].showInMapTex=false;

		if(getOTAValue((char*)tdfBuf,(name+".indestructible").c_str(),res) && atoi(res)==1){
			if(getOTAValue((char*)tdfBuf,(name+".seqname").c_str(),res)){
				featureTable[a].showInMapTex=true;
				getOTAValue((char*)tdfBuf,(name+".filename").c_str(),res2);

				unsigned char* t=(unsigned char*)gafHandler->GetGaf(res,(string("anims\\")+res2+".gaf").c_str());
				if(t==0){
					MessageBox(0,"Couldnt find gaf",(char*)&fileBuf[featureTablePos+a*0x84+4],0);
					featureTable[a].xsize[0]=0;
					featureTable[a].ysize[0]=0;
					featureTable[a].lods[0]=0;
					featureTable[a].showInMapTex=false;
					delete[] t;
					continue;
				}

				featureTable[a].xsize[0]=gafHandler->Width;
				featureTable[a].ysize[0]=gafHandler->Height;

				featureTable[a].xoffset=gafHandler->xOffset;
				featureTable[a].yoffset=gafHandler->yOffset;

				featureTable[a].lods[0]=new unsigned char[gafHandler->Width*gafHandler->Height*4];
				for(int b=0;b<gafHandler->Width*gafHandler->Height;++b){
					featureTable[a].lods[0][b*4+0]=palette[t[b]][0];
					featureTable[a].lods[0][b*4+1]=palette[t[b]][1];
					featureTable[a].lods[0][b*4+2]=palette[t[b]][2];
					if(t[b]!=0)
						featureTable[a].lods[0][b*4+3]=255;
					else
						featureTable[a].lods[0][b*4+3]=0;
				}
				for(b=1;b<3;++b){
					featureTable[a].xsize[b]=featureTable[a].xsize[b-1]/2;
					featureTable[a].ysize[b]=featureTable[a].ysize[b-1]/2;
					featureTable[a].lods[b]=new unsigned char[featureTable[a].xsize[b]*featureTable[a].ysize[b]*4];
					
					for(int y=0;y<featureTable[a].ysize[b];++y){
						for(int x=0;x<featureTable[a].xsize[b];++x){
							int numCount=0;
							int red=0,green=0,blue=0;
							for(int y2=0;y2<2;++y2)
								for(int x2=0;x2<2;++x2)
									if(featureTable[a].lods[b-1][((y*2+y2)*featureTable[a].xsize[b-1]+(x*2+x2))*4+3]>0){
										red  +=featureTable[a].lods[b-1][((y*2+y2)*featureTable[a].xsize[b-1]+(x*2+x2))*4+0];
										green+=featureTable[a].lods[b-1][((y*2+y2)*featureTable[a].xsize[b-1]+(x*2+x2))*4+1];
										blue +=featureTable[a].lods[b-1][((y*2+y2)*featureTable[a].xsize[b-1]+(x*2+x2))*4+2];
										numCount++;
									}
							if(numCount>0){
								featureTable[a].lods[b][(y*featureTable[a].xsize[b]+x)*4+0]=red/numCount;
								featureTable[a].lods[b][(y*featureTable[a].xsize[b]+x)*4+1]=green/numCount;
								featureTable[a].lods[b][(y*featureTable[a].xsize[b]+x)*4+2]=blue/numCount;
								featureTable[a].lods[b][(y*featureTable[a].xsize[b]+x)*4+3]=255;
							} else {
								featureTable[a].lods[b][(y*featureTable[a].xsize[b]+x)*4+3]=0;
							}
						}
					}
				}
				delete[] t;
			}
		}
		delete[] tdfBuf;
	}
#pragma pack(push)
#pragma pack(1)
	struct fileBufInfo{
		unsigned char height;
		unsigned short feature;
		unsigned char none;
	};
#pragma pack(pop)

	fileBufInfo rad[4000];

	int Width=g.mapx-1;

	for(int y=0;y<g.mapy-1;y++){
		int place=featurePos+4*y*Width;
		memcpy(rad,&fileBuf[place],4*Width);
		for(int x=0;x<Width;x++){
			mapFeatures[y*g.mapx+x]=rad[x].feature;
		}
		mapFeatures[y*g.mapx+x]=rad[Width-1].feature;
	}
	for(int x=0;x<Width;x++){
		mapFeatures[y*g.mapx+x]=rad[x].feature;
	}
	mapFeatures[y*g.mapx+x]=rad[Width-1].feature;
}

void CFeatureHandler::FindTDFFiles()
{
	map<string,CHpiHandler::FileData>::iterator fi;

	for(fi=hpiHandler->files.begin();fi!=hpiHandler->files.end();++fi){
		if(fi->first.find("features\\")!=string::npos && fi->first.find(".tdf")!=string::npos){
			SearchTdfFile(fi->first);
		}
	}
}

void CFeatureHandler::SearchTdfFile(string name)
{
	int size=hpiHandler->GetFileSize(name.c_str());
	unsigned char* fileBuf=new unsigned char[size];
	hpiHandler->LoadFile(name.c_str(),fileBuf);

	int pos=0;
	string keyName;

	while(pos<size){
		if(fileBuf[pos]=='['){
			keyName="";
			while(fileBuf[++pos]!=']')
				keyName+=fileBuf[pos];
			MakeLower(keyName);
			name2file[keyName]=name;
			pos++;
		}
		pos++;
	}

	delete[] fileBuf;
}

void CFeatureHandler::MakeLower(string &s)
{
	for(int a=0;a<s.size();++a){
		if(s[a]>='A' && s[a]<='Z')
			s[a]=s[a]+'a'-'A';
	}
}

void CFeatureHandler::MakeLower(char *s)
{
	for(int a=0;s[a]!=0;++a)
		if(s[a]>='A' && s[a]<='Z')
			s[a]=s[a]+'a'-'A';
}
