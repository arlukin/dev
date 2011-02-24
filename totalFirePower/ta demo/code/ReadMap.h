// ReadMap.h: interface for the CReadMap class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_READMAP_H__3064C121_428C_11D4_9677_0050DADC9708__INCLUDED_)
#define AFX_READMAP_H__3064C121_428C_11D4_9677_0050DADC9708__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include <string>
#include <iostream>
#include <fstream>
#include <vector>
#include "globalstuff.h"

using namespace std;

class CReadMap  
{
public:
	virtual ~CReadMap();
	float* map;
	unsigned short int* tile;
	float3* normals;
	float3* facenormals;
	char* mapdata;
	unsigned int gtextures[66000]; 
	unsigned int bigtex,detailtex;
	int numtiles;
	static CReadMap* Instance();

	unsigned char* tileData[4];
private:
	CReadMap();
	static CReadMap* _instance;
	float3 groundCols[256];

};

extern CReadMap* readmap;

#endif // !defined(AFX_READMAP_H__3064C121_428C_11D4_9677_0050DADC9708__INCLUDED_)
