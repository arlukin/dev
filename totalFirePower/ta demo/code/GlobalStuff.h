// GlobalStuff1.h: interface for the CGlobalStuff class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_GLOBALSTUFF1_H__2B3603E2_4EBE_11D4_AD55_0080ADA84DE3__INCLUDED_)
#define AFX_GLOBALSTUFF1_H__2B3603E2_4EBE_11D4_AD55_0080ADA84DE3__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000


#define PI 3.141592f
#define MAX_WORLD_SIZE 1000000;
#define GRAVITY -0.0035f
#define SQUARE_SIZE 16
#define GAME_SPEED 30
#define MYRAND_MAX 0x7fff

#include "float3.h"

void SendChat(char* c);
int myrand(void);

#include <list>
#include "object.h"

struct int2 {
	int x;
	int y;
};

struct RecorderShare;
struct SharedMem;
struct FeatureDefStruct;
struct FeatureStruct;
struct WreckageInfoStruct;

class CGlobalStuff  
{
public:
	CGlobalStuff();
	virtual ~CGlobalStuff();
	int frameNum;
	int mapx;
	int mapy;
	int screenx;
	int screeny;
	int myTeam;
	bool testmode;
	bool drawdebug;
	float seaLevel;
	RecorderShare* fromRec;
	SharedMem* shared;
	FeatureDefStruct* featureDef;
	WreckageInfoStruct* wreckInfo;
	FeatureStruct* features;
	bool sharedShared;
	float viewRange;
	
};

extern CGlobalStuff g;
extern int myseed;

#endif // !defined(AFX_GLOBALSTUFF1_H__2B3603E2_4EBE_11D4_AD55_0080ADA84DE3__INCLUDED_)
