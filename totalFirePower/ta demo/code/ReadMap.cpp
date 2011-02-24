// ReadMap.cpp: implementation of the CReadMap class.
//
//////////////////////////////////////////////////////////////////////

#include "windows.h"
#include "mygl.h"
#include <gl\glu.h>			// Header file for the gLu32 library
#include <gl\glaux.h>		// Header File For The Glaux Library
#include "ReadMap.h"
#include <stdlib.h>
#include <math.h>
#include "float3.h"
#include <ostream>
#include "tapalette.h"
#include "hpihandler.h"
#include "irenderer.h"
#include "bitmap.h"
#include "featurehandler.h"
#include "reghandler.h"

using namespace std;
//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////
CReadMap* readmap;
CReadMap* CReadMap::_instance=0;

CReadMap* CReadMap::Instance()
{
	if(_instance==0){
		_instance=new CReadMap();
		readmap=_instance;
	}
	return _instance;
}

CReadMap::CReadMap()
{
	int y;
	PrintLoadMsg("Opening map file");

	string mapname="maps\\tetra.tnt";
	if(g.shared){
		mapname=g.shared->mapname;
	}
	int fsize=hpiHandler->GetFileSize(mapname);
	if(fsize==0){
		char t[700];
		if(mapname=="")
			sprintf(t,"The map name is empty. Make sure 3dta har been initilized correctly inside TA");
		else
			sprintf(t,"Couldnt find the file %s. Make sure that the regkey HKEY_LOCAL_MACHINE\\Software\\Microsoft\\DirectPlay\\Applications\\Total Annihilation\\path is setup correctly and that all files resides inside container files in your TA root folder (ie not on CD or unpacked in subfolders) and that the container files have the extensions gp3/ccx/ufo/hpi",mapname.c_str());

		MessageBox(0,t,"Error opening map",0);
		return;
	}
	unsigned char* fileBuf=new unsigned char[fsize+1];
	hpiHandler->LoadFile(mapname,fileBuf);

	int IDversion=*(int*)&fileBuf[0];
	int Width=*(int*)&fileBuf[4];
	int Height=*(int*)&fileBuf[8];
	int PTRmapdata=*(int*)&fileBuf[12];
	int PTRmapattr=*(int*)&fileBuf[16];
	int PTRtilegfx=*(int*)&fileBuf[20];
	int tiles     =*(int*)&fileBuf[24];
	int tileanims =*(int*)&fileBuf[28];
	int PTRtileanim=*(int*)&fileBuf[32];
	int sealevel   =*(int*)&fileBuf[36]-1;
	int PTRminimap =*(int*)&fileBuf[40];

	g.mapx=Width+1;
	g.mapy=Height+1;
	g.seaLevel=sealevel;
/*
	char rt[500];
	sprintf(rt,"%d %d",Width,Height);
	MessageBox(0,rt,"",0);
*/
	int mapsize=(g.mapx+1)*(g.mapy+9);
	if(mapsize<513*513)
		mapsize=513*513;

	map=new float[mapsize];
	normals=new float3[mapsize];
	facenormals=new float3[mapsize*2];
	tile=new unsigned short[mapsize/4];

	int heightStart=PTRmapattr;
	int tileStart=PTRmapdata;
	numtiles=tiles;

	union mapInfo{
		int data;
		unsigned char height;
	};
	mapInfo rad[4000];

	PrintLoadMsg("Loading height+feature data");
	for(y=0;y<Height;y++){
		int place=heightStart+4*((y)*Width);
		memcpy(rad,&fileBuf[place],4*Width);
		for(int x=0;x<Width;x++){
			map[y*g.mapx+x]=rad[x].height;
		}
		map[y*g.mapx+Width]=rad[Width-1].height;
	}
	for(int x=0;x<Width;x++){
		map[y*g.mapx+x]=rad[x].height;
	}
	map[y*g.mapx+Width]=rad[Width-1].height;
	

	if(regHandler.GetInt("FilterMap",1)){
		float* map2=new float[mapsize];
		for(int a=0;a<mapsize;++a)
			map2[a]=map[a];

		int h;
		for(y=1;y<g.mapy-1;y++){
			for(int x=0;x<g.mapx-1;x++){
				h =map2[(y-1)*g.mapx+x-1];
				h+=map2[(y-1)*g.mapx+x];
				h+=map2[(y-1)*g.mapx+x+1];
				h+=map2[(y)*g.mapx+x-1];
				h+=map2[(y)*g.mapx+x]*2;
				h+=map2[(y)*g.mapx+x+1];
				h+=map2[(y+1)*g.mapx+x-1];
				h+=map2[(y+1)*g.mapx+x];
				h+=map2[(y+1)*g.mapx+x+1];
				map[(y)*g.mapx+x]=h*0.1;
			}
		}

		delete[] map2;
	}

	PrintLoadMsg("Loading tiles");

	int place=tileStart;
	memcpy(tile,&fileBuf[place],g.mapx*(g.mapy>>1));

	PrintLoadMsg("Creating tile textures");

	unsigned char* memtex=new unsigned char[32*32*tiles+1];

	tileData[0]=new unsigned char[32*32*4*tiles];

	memcpy(memtex,&fileBuf[PTRtilegfx],32*32*tiles);

	for(int a=0;a<32*32*tiles;++a){
		tileData[0][a*4+0]=palette[memtex[a]][0];
		tileData[0][a*4+1]=palette[memtex[a]][1];
		tileData[0][a*4+2]=palette[memtex[a]][2];
		tileData[0][a*4+3]=255;
	}
	int tsize=32*32*tiles*4;
	int rowsize=32;
	for(a=1;a<4;++a){
		tsize/=4;
		rowsize/=2;
		tileData[a]=new unsigned char[tsize];

		for(int row=0;row<tsize/rowsize/4;++row){
			int rowstart=row*rowsize;
			int rowstart2=row*rowsize*4;
			int rowstart3=row*rowsize*4+rowsize*2;
			for(int b=0;b<rowsize;++b)
				for(int c=0;c<4;++c)
					tileData[a][(rowstart+b)*4+c]=((int)tileData[a-1][(rowstart2+b*2)*4+c]+(int)tileData[a-1][(rowstart2+b*2+1)*4+c]+(int)tileData[a-1][(rowstart3+b*2)*4+c]+(int)tileData[a-1][(rowstart3+b*2+1)*4+c])/4;
		}
	}

	PrintLoadMsg("Creating overhead texture");

	char* bt=new char[1024*1024*4];

	int xpixs=Width*16/1024/2;
	int ypixs=Height*16/1024/2;

	for(y=0;y<1024;y++){
		for(int x=0;x<1024;x++){
			unsigned int col[]={0,0,0};
			for(int y2=0;y2<ypixs;++y2){
				for(int x2=0;x2<xpixs;++x2){
					unsigned int ypix=(y*Height*16/1024/2+y2);
					unsigned int xpix=(x*Width*16/1024/2+x2);
					unsigned int t=tile[(ypix/16)*(Width>>1)+(xpix/16)];
					unsigned int ypixel=ypix&15;
					unsigned int xpixel=xpix&15;

					for(int c=0;c<3;++c)
						col[c]+=tileData[1][(t*16*16+ypixel*16+xpixel)*4+c];
				}
			}
			for(int c=0;c<3;++c)
				bt[((y)*1024+x)*4+c]=col[c]/(xpixs*ypixs);
		}
	}

	glGenTextures(1, &bigtex);
	glBindTexture(GL_TEXTURE_2D, bigtex);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_CLAMP);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_CLAMP);
	glTexImage2D(GL_TEXTURE_2D,0, 4,1024, 1024,0, GL_RGBA, GL_UNSIGNED_BYTE, bt);
	delete[] memtex;
	delete[] bt;

	featureHandler.LoadFeatures(fileBuf,PTRmapattr,PTRtileanim,tileanims);

	delete[] fileBuf;

	PrintLoadMsg("Creating surface normals");

  float3 n1,n2,n3,n4;

  for(y=0;y<g.mapy;y++)
    for(int x=0;x<g.mapx;x++)
			normals[y*g.mapx+x]=float3(0,1,0);

  for(y=0;y<g.mapy-1;y++)
    for(int x=0;x<g.mapx-1;x++){
			facenormals[(y*(g.mapx-1)+x)*2]=float3(0,1,0);
			facenormals[(y*(g.mapx-1)+x)*2+1]=float3(0,1,0);
		}

	for(y=1;y<g.mapy-1;y++){
    for(int x=1;x<g.mapx-1;x++){

      float myz=map[y*g.mapx+x];

			float3 e1(-SQUARE_SIZE,map[y*g.mapx+x-1]-myz,0);
			float3 e2( SQUARE_SIZE,map[y*g.mapx+x+1]-myz,0);
			float3 e3(0,map[(y-1)*g.mapx+x]-myz,-SQUARE_SIZE);
			float3 e4(0,map[(y+1)*g.mapx+x]-myz, SQUARE_SIZE);

      n1=e3.cross(e1);
      n1.Normalize();
      		
      n2=e4.cross(e2);
      n2.Normalize();
      
      n3=e2.cross(e3);
      n3.Normalize();
      
      n4=e1.cross(e4);
      n4.Normalize();
      			
      facenormals[(y*(g.mapx-1)+x)*2]=n2;
//      if((x-1>=0) && (y-1>=0)) 
			facenormals[((y-1)*(g.mapx-1)+x-1)*2+1]=n1;
      
      normals[y*g.mapx+x]=n1+n2+n3+n4;
      normals[y*g.mapx+x].Normalize();      		
    }
  }
	PrintLoadMsg("Loading detail texture");

	glGenTextures(1, &detailtex);
	CBitmap bm("bitmaps\\detailtex.jpg");

	// create mipmapped texture
	glBindTexture(GL_TEXTURE_2D, detailtex);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_NEAREST);
	gluBuild2DMipmaps(GL_TEXTURE_2D,4 ,bm.xsize, bm.ysize, GL_RGBA, GL_UNSIGNED_BYTE, bm.mem);
}

CReadMap::~CReadMap()
{
	glDeleteTextures (1, &bigtex);
	glDeleteTextures (1, &detailtex);

	delete[] map;
	delete[] tile;
	delete[] normals;
	delete[] facenormals;

	for(int a=0;a<4;++a)
		delete[] tileData[a];
}
