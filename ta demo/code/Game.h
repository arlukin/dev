// Game.h: interface for the CGame class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_GAME_H__10D2D641_3483_11D4_AD55_0080ADA84DE3__INCLUDED_)
#define AFX_GAME_H__10D2D641_3483_11D4_AD55_0080ADA84DE3__INCLUDED_

#include "float3.h"	// Added by ClassView
#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include <windows.h>		// Header File For Windows
#include <time.h>
#include <string>
#include "GlobalStuff.h"
#include "ProjectileHandler.h"
#include "winreg.h"

class CglList;
class CGuiKeyReader;
class CDrawWater;
class CUnitDrawer;
class CDrawUI;
class CGame  
{
public:
	void UpdateUI();

	bool debugging;
	int que;
	SimFrame();
	bool serverForward;
	StartPlaying();
	bool Draw();
	bool Update();
	KeyReleased(unsigned char k);
	KeyPressed(unsigned char k);
	CGame(bool server);
	virtual ~CGame();

	unsigned int oldframenum;
	unsigned int fps;
	unsigned int thisFps;

	time_t   fpstimer,starttime;
	clock_t	 startPhysic,stopPhysic;
	double	 physicTime,physicPart;

	int playerNum;						//my number 0=server 1=first client ...
	int numPlayers;						//total number of players 

	unsigned char netbuf[8000];
	unsigned char inbuf[9000];
	int inbufpos;
	int inbuflength;

	bool automovecamera;
	bool updateFov;

	bool bRun;							//running (normal mode =true, single step->false)
	bool bOneStep;						//do a single step in single step mode

	bool imServer;						
	bool userWriting;						//true if user is writing
	bool ignoreNextChar;
	std::basic_string<char> userInput;
	std::basic_string<char> userPrompt;

	CDrawWater* water;
	CUnitDrawer* units;
	CDrawUI* uiDrawer;


	bool commandMode;
	float3 trackPos[16];
private:
	int leastQue;

	int lastTick;
	int lastLength;
	float timeLeft;
	float consumeSpeed;

	bool waitOnAddress;
	bool waitOnName;
	bool playing;
	bool allReady;
	bool chatting;
	bool keys[256];			// Array Used For The Keyboard Routine
	bool camMove[8];
	bool camRot[4];
	
	float moveSpeed;
public:
	bool secondFov;
	int sfx,sfy;
	int sfWidth,sfHeight;
	float speedFactor;

	CglList* showList;
	LARGE_INTEGER lastframe;
	LARGE_INTEGER timeSpeed;

	LARGE_INTEGER lastMoveUpdate;
	HKEY regkey;

	CGuiKeyReader* guikeys;
};

extern CGame* game;

#endif // !defined(AFX_GAME_H__10D2D641_3483_11D4_AD55_0080ADA84DE3__INCLUDED_)
