// GlobalStuff.cpp: implementation of the CGlobalStuff class.
//
//////////////////////////////////////////////////////////////////////

#include "GlobalStuff.h"
#include "projectilehandler.h"
#include <windows.h>
#include <time.h>
#include "irenderer.h"
#include "tamem.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CGlobalStuff g;

int myseed=235;
int lastrandframe=0;

int myrand(void)
{
	myseed = (myseed * 214013L + 2531011L) >> 16;
#ifdef TRACE_SYNC
	if(lastrandframe!=g.frameNum){
		lastrandframe=g.frameNum;
		tracefile << "Rand: ";
		tracefile << g.frameNum << " " << (myseed & 0x7fff) << "\n";
	}
#endif
	return myseed & 0x7FFF;
}

CGlobalStuff::CGlobalStuff()
{
	frameNum=0;
	screenx=100;
	screeny=100;
	myTeam=1;
	testmode=true;
	drawdebug=false;

	myseed= (unsigned)time( NULL );

	HANDLE h=OpenFileMapping(FILE_MAP_ALL_ACCESS,FALSE,"TADemo-MKChat");
	fromRec=(RecorderShare*)MapViewOfFile(h,FILE_MAP_ALL_ACCESS,0,0,0);

	h=OpenFileMapping(FILE_MAP_ALL_ACCESS,FALSE,"TA3D");
	shared=(SharedMem*)MapViewOfFile(h,FILE_MAP_ALL_ACCESS,0,0,0);
	sharedShared=true;
	if(shared==0){
		sharedShared=false;
		shared=new SharedMem;
		memset(shared,0,sizeof(shared));
		strcpy(shared->mapname,"maps\\greenhaven.tnt");
		shared->numPlayers=1;
		shared->maxUnits=500;
		shared->players[0].maxUsedUnit=1;
		shared->players[0].color=4;
		shared->units[0].active=true;
		shared->units[0].pos.x=200*64000;
		shared->units[0].pos.y=400*64000;
		shared->units[0].pos.z=200*64000;
		shared->units[0].turn.x=0;
		shared->units[0].turn.y=0;
		shared->units[0].turn.z=0;
		strcpy(shared->units[0].name,"armhawk");
		for(int a=0;a<32;++a){
			shared->units[0].parts[a].offset.x=0;
			shared->units[0].parts[a].offset.y=0;
			shared->units[0].parts[a].offset.z=0;

			shared->units[0].parts[a].turn.x=0;
			shared->units[0].parts[a].turn.y=0;
			shared->units[0].parts[a].turn.z=0;

			shared->units[0].parts[a].visible=true;
		}
	};
	h=OpenFileMapping(FILE_MAP_ALL_ACCESS,FALSE,"FeatureDef");
	featureDef=(FeatureDefStruct*)MapViewOfFile(h,FILE_MAP_ALL_ACCESS,0,0,0);

	h=OpenFileMapping(FILE_MAP_ALL_ACCESS,FALSE,"Features");
	features=(FeatureStruct*)MapViewOfFile(h,FILE_MAP_ALL_ACCESS,0,0,0);

	h=OpenFileMapping(FILE_MAP_ALL_ACCESS,FALSE,"WreckageInfo");
	wreckInfo=(WreckageInfoStruct*)MapViewOfFile(h,FILE_MAP_ALL_ACCESS,0,0,0);

}

CGlobalStuff::~CGlobalStuff()
{
	if(sharedShared){
		UnmapViewOfFile(shared);
	} else {
		delete shared;
	}
}
