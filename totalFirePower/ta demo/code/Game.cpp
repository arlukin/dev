// Game.cpp: implementation of the CGame class.
//
//////////////////////////////////////////////////////////////////////

#pragma warning(disable:4786)


#include "Game.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

#include "mygl.h"
#include <gl\glu.h>			// Header File For The GLu32 Library
#include <gl\glaux.h>		// Header File For The Glaux Library
#include <time.h>
#include <stdlib.h>
#include "glList.h"
#include <io.h>
#include "float3.h"
#include "winerror.h"
#include "float.h"
//#include "tracerprojectile.h"
#include "glfont.h"
#include "infoconsole.h"
#include "Camera.h"
#include "sky.h"
#include "ground.h"
#include "grounddrawer.h"
#include "guikeyreader.h"
#include "mousehandler.h"
#include "drawwater.h"
#include <fstream>
#include "bitmap.h"
#include "hpihandler.h"
#include "texturehandler.h"
#include "3doparser.h"
#include "unitdrawer.h"
#include "gaf.h"
#include "irenderer.h"
#include "timeprofiler.h"
#include "reghandler.h"
#include "drawui.h"
#include "minimap.h"
//#include "drawtree.h"

//#define DUMMYPLAYER

GLfloat LightDiffuseLand[]=	{ 0.7f, 0.7f, 0.7f, 1.0f };
GLfloat LightAmbientLand[]=	{ 0.3f, 0.3f, 0.3f, 1.0f };
GLfloat LightAmbientWreck[]=	{ 0.4f, 0.4f, 0.4f, 1.0f };
GLfloat LightPosition[]=	{ 0.71f, -0.71f, -0.0f, 0.0f };
GLfloat FogLand[]=			{ 0.7f,	0.7f, 0.8f, 1	 }; 
GLfloat FogWhite[]=			{ 1.0f,	1.0f, 1.0f, 0	 }; 
GLfloat FogBlack[]=			{ 0.0f,	0.0f, 0.0f, 0	 }; 

extern CProjectileHandler *ph;
extern bool quit;
extern CGame* game;

//CDrawTree* drawTree;

static void SelectCraftCallback(std::string craft)
{
}

CGame::CGame(bool server)
{
	time(&starttime);
	lastTick=clock();
	timeLeft=0;
	consumeSpeed=1;
	leastQue=0;
	que=0;
	speedFactor=1;
	showList=false;

	serverForward=false;

	int a;

	for(a=0;a<8;++a)
		camMove[a]=false;
	for(a=0;a<4;++a)
		camRot[a]=false;

	for(int b=0;b<256;b++)
		keys[b]=false;
	fps=0;
	thisFps=0;

	physicTime=0;
	physicPart=0;

	debugging=false;

	viewCam.rot.y=0;
	viewCam.rot.x=0;
	viewCam.pos.x=500;
	viewCam.pos.y=200;
	viewCam.pos.z=500;
	automovecamera=false;
	updateFov=true;
	
	moveSpeed=regHandler.GetInt("MoveSpeed",50)*15;
	g.viewRange=regHandler.GetInt("ViewDistance",4000);
	
	bRun=true;//false;
	bOneStep=false;

	commandMode=false;
	waitOnAddress=false;
	playing=true;
	allReady=true;
	imServer=true;

	inbufpos=0;
	inbuflength=0;

	userWriting=false;
	chatting=false;
	ignoreNextChar=false;
	userInput="";
	userPrompt="";

	playerNum=0;
	secondFov=false;
	sfx=0;
	sfy=0;
	sfWidth=320;
	sfHeight=200;

	info=new CInfoConsole();
	mouse=new CMouseHandler();
//	info->AddLine("Waiting for start");

	hpiHandler=new CHpiHandler();
	gafHandler=new CGaf();

	texturehandler=new CTextureHandler;
	unitparser=new C3DOParser;

	ground=new CGround();
	groundDrawer=new CGroundDrawer();
	sky=new CSky();
	guikeys=new CGuiKeyReader("uikeys.txt");
	water=new CDrawWater;
	uiDrawer=new CDrawUI;
//	drawTree=new CDrawTree();


	units=new CUnitDrawer;
	ph=new CProjectileHandler();

	minimap=new CMiniMap;
	for(a=0;a<16;++a)
		trackPos[a]=float3(0,0,0);

	if(RegCreateKey(HKEY_CURRENT_USER,"Software\\SJ\\Spring",&regkey)!=ERROR_SUCCESS)
		MessageBox(0,"Failed to crete registry key","Game error",0);
	userInput="";

	QueryPerformanceFrequency(&timeSpeed);

	glLightfv(GL_LIGHT1, GL_AMBIENT, LightAmbientLand);		// Setup The Ambient Light
	glLightfv(GL_LIGHT1, GL_DIFFUSE, LightDiffuseLand);		// Setup The Diffuse Light
	glLightfv(GL_LIGHT1, GL_SPECULAR, LightAmbientLand);		// Setup The Diffuse Light
	glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,0);
	glEnable(GL_LIGHT1);								// Enable Light One
	glLightModeli(GL_LIGHT_MODEL_TWO_SIDE,1);
	glFogfv(GL_FOG_COLOR,FogLand);
	glFogf(GL_FOG_START,/*MAX_VIEW_RANGE*/0.6f);
	glFogf(GL_FOG_END,/*MAX_VIEW_RANGE*/0.99f);
	glFogf(GL_FOG_DENSITY,0.6f);
//	glFogf(GL_FOG_DENSITY,0.0024f);
//	glFogi(GL_FOG_MODE,GL_EXP2);
	glFogi(GL_FOG_MODE,GL_LINEAR);
	glEnable(GL_FOG);
	glClearColor(0.7f,0.7f,0.8f,0);
}

CGame::~CGame()
{
	delete minimap;
	delete unitparser;
	delete texturehandler;

	delete uiDrawer;
	delete water;
	delete units;
	delete sky;
	numPlayers=0;
	
	delete ph;
	delete groundDrawer;
	delete ground;
	delete info;
	delete mouse;

	delete gafHandler;
	delete hpiHandler;
	RegCloseKey(regkey);
}
//called when the key is pressed by the user (can be called several times due to key repeat)
CGame::KeyPressed(unsigned char k)
{
	if(showList){					//are we currently showing a list?
		if(k==VK_UP)
			showList->UpOne();
		if(k==VK_DOWN)
			showList->DownOne();
		if(k==VK_RETURN){
			showList->Select();
			showList=0;
		}
		if(k==27 && playing){
			showList=0;
		}
		return 0;
	}
	if (userWriting){
		keys[k] = TRUE;
		if ((k=='V') && keys[VK_CONTROL]){
			OpenClipboard(0);
			void* p;
			if((p=GetClipboardData(CF_TEXT))!=0){
				userInput+=(char*)p;
			}
			CloseClipboard();
			return 0;
		}
		if(k==8){ //backspace
			if(userInput.size()!=0)
				userInput.erase(userInput.size()-1,1);
			return 0;
		}
		if(k==VK_RETURN){
			for(int a=0;a<10;++a){
				if(!g.shared->toDDraw.hasText[a]){
					info->AddLine(userInput);
					strcpy(g.shared->toDDraw.text[a],userInput.c_str());
					g.shared->toDDraw.hasText[a]=true;
					break;
				}
			}
			userWriting=false;
			return 0;
		}
		if(k==27 && chatting){
			userWriting=false;
			chatting=false;
		}
		return 0;
	}
	std::string s=guikeys->TranslateKey(k);

	if (s=="pause"){
		for(int a=0;a<10;++a){
			if(!g.shared->toDDraw.hasText[a]){
				strcpy(g.shared->toDDraw.text[a],"pause");
				g.shared->toDDraw.hasText[a]=true;
				break;
			}
		}
//		bRun=!bRun;
//		QueryPerformanceCounter(&lastframe);
//		timeLeft=0;
	}
	if (s=="singlestep"){
		bOneStep=true;
	}
	if (s=="chat"){
		userWriting=true;
		userPrompt="Say: ";
		userInput="";
		chatting=true;
		ignoreNextChar=false;
	}
	if (s=="commandmode"){
		commandMode=!commandMode;
		if(commandMode)
			mouse->ShowMouse();
	}
	if (s=="debug")
		g.drawdebug=!g.drawdebug;

	if (s=="updatefov")
		updateFov=!updateFov;

	if (s=="secondfov")
		secondFov=!secondFov;

	if (s=="drawnames")
		units->drawName=!units->drawName;

	if (s=="drawhealth")
		units->drawHealth=!units->drawHealth;

	if (s=="drawkills")
		units->drawKills=!units->drawKills;

	if (s=="drawresources")
		uiDrawer->drawRes=!uiDrawer->drawRes;

	if (s=="drawmap")
		minimap->show=!minimap->show;

	//	if (s=="drawtrees")
//		groundDrawer->drawTrees=!groundDrawer->drawTrees;

	if (s=="dynamicsky")
		sky->dynamicSky=!sky->dynamicSky;
/*
	if (s=="cloudshadows")
		sky->drawShadows=!sky->drawShadows;

	if (s=="cloudshafts")
		sky->drawShafts=!sky->drawShafts;
*/
	if (s=="increaseviewradius"){
		groundDrawer->viewRadius+=2;
		(*info) << "ViewRadius is now " << groundDrawer->viewRadius << "\n";
	}

	if (s=="decreaseviewradius"){
		groundDrawer->viewRadius-=2;
		(*info) << "ViewRadius is now " << groundDrawer->viewRadius << "\n";
	}

/*	if (s=="moretrees"){
		groundDrawer->baseTreeDistance+=0.2f;
		(*info) << "Base tree distance " << groundDrawer->baseTreeDistance*2*128 << "\n";
	}

	if (s=="lesstrees"){
		groundDrawer->baseTreeDistance-=0.2f;
		(*info) << "Base tree distance " << groundDrawer->baseTreeDistance*2*128 << "\n";
	}
*/
	if (s=="moreclouds"){
		sky->cloudDensity*=0.95f;
		(*info) << "Cloud density " << 1/sky->cloudDensity << "\n";
	}

	if (s=="lessclouds"){
		sky->cloudDensity*=1.05f;
		(*info) << "Cloud density " << 1/sky->cloudDensity << "\n";
	}

	if (s=="speedup"){
		for(int a=0;a<10;++a){
			if(!g.shared->toDDraw.hasText[a]){
				strcpy(g.shared->toDDraw.text[a],"speedup");
				g.shared->toDDraw.hasText[a]=true;
				break;
			}
		}
/*		if(speedFactor<1)
			speedFactor*=2;
		else 
			speedFactor++;
		(*info) << "Speed " << speedFactor << "\n";
*/	}

	if (s=="speeddown"){
		for(int a=0;a<10;++a){
			if(!g.shared->toDDraw.hasText[a]){
				strcpy(g.shared->toDDraw.text[a],"speeddown");
				g.shared->toDDraw.hasText[a]=true;
				break;
			}
		}
/*		if(speedFactor<=1)
			speedFactor*=0.5;
		else 
			speedFactor--;
		(*info) << "Speed " << speedFactor << "\n";
*/	}

	if (s=="quit")
		quit=true;

	if (s=="screenshot"){
		int x=g.screenx;
		if(g.screenx%4)
			g.screenx+=4-g.screenx%4;
		unsigned char* buf=new unsigned char[g.screenx*g.screeny*4];
		glReadPixels(0,0,g.screenx,g.screeny,GL_RGBA,GL_UNSIGNED_BYTE,buf);
		CBitmap b(buf,g.screenx,g.screeny);
		string name;
		for(int a=0;a<55;++a){
			char t[50];
			itoa(a,t,10);
			name=string("screen")+t+".bmp";
			ifstream ifs(name.c_str(),ios::in|ios::binary);
			if(!ifs.is_open())
				break;
		}
		b.Save(name);
		delete[] buf;
		g.screenx=x;
	}
	if (s=="moveforward")
		camMove[0]=true;

	if (s=="moveback")
		camMove[1]=true;

	if (s=="moveleft")
		camMove[2]=true;

	if (s=="moveright")
		camMove[3]=true;

	if (s=="moveup")
		camMove[4]=true;

	if (s=="movedown")
		camMove[5]=true;

	if (s=="movefast")
		camMove[6]=true;

	if (s=="moveslow")
		camMove[7]=true;

	if (keys[k] != true){
		keys[k] = true;
	}
	return 0;
}

//Called when a key is released by the user
CGame::KeyReleased(unsigned char k)				
{
	if ((userWriting) && (((k>=' ') && (k<='Z')) || (k==8) || (k==190) )){
		keys[k] = FALSE;					// If So, Mark It As FALSE
		return 0;
	}
	std::string s=guikeys->TranslateKey(k);

	if (s=="moveforward")
		camMove[0]=false;

	if (s=="moveback")
		camMove[1]=false;

	if (s=="moveleft")
		camMove[2]=false;

	if (s=="moveright")
		camMove[3]=false;

	if (s=="moveup")
		camMove[4]=false;

	if (s=="movedown")
		camMove[5]=false;

	if (s=="movefast")
		camMove[6]=false;

	if (s=="moveslow")
		camMove[7]=false;

	keys[k] = FALSE;					// If So, Mark It As FALSE
	if(playing){
	}
	return 0;
}

bool CGame::Update()
{

	time(&fpstimer);
	if 	(difftime(fpstimer,starttime)!=0){		//do once every second
		fps=thisFps;
		thisFps=0;

		physicPart=physicTime*100/difftime(fpstimer, starttime);
		physicTime=0;

		consumeSpeed=((float)(GAME_SPEED+leastQue-2));
		leastQue=10000;
		if(!imServer)
			timeLeft=0;

		starttime=fpstimer;
		oldframenum=g.frameNum;
	
		profiler.Update();
	}
	UpdateUI();

	if (playing && imServer){
		LARGE_INTEGER currentFrame;
		QueryPerformanceCounter(&currentFrame);
		
		double timeElapsed=((double)(currentFrame.QuadPart - lastframe.QuadPart)/timeSpeed.QuadPart);
		if(timeElapsed>1)
			timeElapsed=1;
		timeLeft+=GAME_SPEED*speedFactor*timeElapsed;
		lastframe=currentFrame;
		
		while((timeLeft>0) && (bRun || bOneStep)){
			bOneStep=false;
			SimFrame();
			timeLeft--;
		}
	}

	return true;
}

bool CGame::Draw()
{
	thisFps++;
	std::basic_string<char> tempstring;
				
	sky->UpdateClouds();
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);	// Clear Screen And Depth Buffer
	glLoadIdentity();									// Reset The Current Modelview Matrix
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

	sky->UpdateClouds();

	glDisable(GL_BLEND);
	glDisable(GL_TEXTURE_2D);

	//stop drawing text

	//set camera
	viewCam.up.x=0;
	viewCam.up.y=1;
	viewCam.up.z=0;
	viewCam.rot.z=0;
	viewCam.fov=45;

	viewCam.UpdateForward();

	viewCam.Update(!updateFov);

	glLightfv(GL_LIGHT1, GL_POSITION,LightPosition);	// Position The Light
	sky->Draw();
	groundDrawer->Draw();

	glDisable(GL_TEXTURE_2D);
	glColor3f(1,0,0);
	std::deque<EhaMarker>::iterator mi;
	glBegin(GL_LINES);
	for(mi=minimap->markers.begin();mi!=minimap->markers.end();++mi){
		float gHeight=ground->GetApproximateHeight(mi->x,mi->y);
		float size=(mi->time-g.frameNum+100)*10;
		if(size>72)
			size=72;
		glVertex3f(mi->x,0,mi->y);
		glVertex3f(mi->x,gHeight-16+size,mi->y);
	}
	glEnd();

//	drawTree->Draw();

//	if (playing){

		glEnable(GL_LIGHTING);
		glColorMaterial(GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE);
		glEnable(GL_COLOR_MATERIAL);
		units->Draw();
		glDisable(GL_LIGHTING);
		glDisable(GL_COLOR_MATERIAL);
	
		//transparent stuff
		glEnable(GL_BLEND);
		glDepthFunc(GL_LEQUAL);
		water->Draw();
		ph->Draw();
//		sky->DrawShafts();
//		sky->DrawSunFlare();

		mouse->Draw();

		glLoadIdentity();
		glDisable(GL_DEPTH_TEST );
//	}

	//reset fov
	glMatrixMode(GL_PROJECTION);						// Select The Projection Matrix
	glLoadIdentity();									// Reset The Projection Matrix
	gluOrtho2D(0,1,0,1);
	glMatrixMode(GL_MODELVIEW);							// Select The Modelview Matrix

	glEnable(GL_BLEND);
	glDisable(GL_DEPTH_TEST );
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glLoadIdentity();

	minimap->Draw();

	info->Draw();

	glEnable(GL_TEXTURE_2D);							// Enable Texture Mapping

	if(g.drawdebug){
		profiler.Draw();

		glPushMatrix();
		glColor4f(1,1,0.5f,0.8f);
		glTranslatef(0.03f,0.02f,0.0f);
		glScalef(0.03f,0.04f,0.1f);

		//skriv ut fps etc
		font->glPrint("FPS = %3.0d",fps);
		glPopMatrix();
		
		glPushMatrix();
		glTranslatef(0.03f,0.08f,0.0f);
		glScalef(0.02f,0.025f,0.1f);
		font->glPrint("xpos: %6.0f ypos: %6.0f zpos: %6.0f",camera.pos.x,camera.pos.y,camera.pos.z);
		glPopMatrix();
	} else {
		uiDrawer->Draw();	
	}

	if(userWriting){
		glPushMatrix();
		glColor4f(1,1,1,1);
		glTranslatef(0.03f,0.05f,0.0f);
		glScalef(0.03f,0.04f,0.1f);
		tempstring=userPrompt;
		tempstring+=userInput;
		font->glPrint("%s",tempstring.c_str());
		glPopMatrix();
	}	
/*
	if(showList)										//rita choose craft menyn
		showList->Draw();
*/

	glEnable(GL_DEPTH_TEST );

/*	if(playing && secondFov){
		glScissor(sfx,sfy,sfWidth,sfHeight);

		glEnable(GL_SCISSOR_TEST);
		glViewport(sfx,sfy,sfWidth,sfHeight);
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);	// Clear Screen And Depth Buffer
		glLoadIdentity();									// Reset The Current Modelview Matrix

		float3 tempcam=viewCam.pos;
		float3 tempdir=viewCam.forward;
		float3 tempright=viewCam.right;
		float tempfov=viewCam.fov;

		viewCam.Update(debugging);

		sky->Draw();
		groundDrawer->Draw();

		ph->Draw();
		glDisable(GL_SCISSOR_TEST);
		glViewport(0,0,g.screenx,g.screeny);
		if(!commandMode){
			viewCam.pos=tempcam;
			viewCam.forward=tempdir;
			viewCam.right=tempright;
		}
		viewCam.fov=tempfov;
	}
*/	glLoadIdentity();
	return true;
}

CGame::StartPlaying()
{
#ifdef DUMMYPLAYER
	numPlayers++;
	players[numPlayers-1].playerName="Dummy";
	//players[numPlayers-1].controls.keys[VK_SPACE]=true;
//	players[numPlayers-1].controls.keys['D']=true;
#endif
	playing=true;
	lastTick=clock();
	QueryPerformanceCounter(&lastframe);
}

CGame::SimFrame()
{
	g.frameNum++;

	info->Update();

	LARGE_INTEGER startPhysics;
	QueryPerformanceCounter(&startPhysics);

//	trackPos[g.frameNum&15]=players[playerNum].craft->aimpoint;
	_clearfp();
	
	ph->Update();
//	CPathFinder::Instance()->Update();	
	
	LARGE_INTEGER stopPhysics;
	QueryPerformanceCounter(&stopPhysics);
	physicTime += (double)(stopPhysics.QuadPart - startPhysics.QuadPart)/timeSpeed.QuadPart;

	bOneStep=false;	
}

void CGame::UpdateUI()
{
	for(int a=0;a<10;++a){
		if(g.shared->to3D.hasText[a]){
			info->AddLine(g.shared->to3D.text[a]);
			g.shared->to3D.hasText[a]=false;
		}
	}
	LARGE_INTEGER start;
	QueryPerformanceCounter(&start);
	float passedTime = (double)(start.QuadPart - lastMoveUpdate.QuadPart)/timeSpeed.QuadPart;
	lastMoveUpdate=start;

	//move camera if arrow keys pressed
	float cameraSpeed=moveSpeed*passedTime;
	if (camMove[7]){
		cameraSpeed*=0.1f;
	}
	if (camMove[6]){
		cameraSpeed*=10;
	}
	if(cameraSpeed>100)
		cameraSpeed=100;
	if (camMove[0]){
		automovecamera=false;
		viewCam.pos+=viewCam.forward*cameraSpeed;
		g.shared->updated=true;
	}
	if (camMove[1]){
		automovecamera=false;
		viewCam.pos-=viewCam.forward*cameraSpeed;
		g.shared->updated=true;
	}
	if (camMove[3]){
		automovecamera=false;
		viewCam.pos+=viewCam.right*cameraSpeed;
		g.shared->updated=true;
	}
	if (camMove[2]){
		automovecamera=false;
		viewCam.pos-=viewCam.right*cameraSpeed;
		g.shared->updated=true;
	}
	if(viewCam.pos.x<-200)
		viewCam.pos.x=-200;
	if(viewCam.pos.x>g.mapx*SQUARE_SIZE+200)
		viewCam.pos.x=g.mapx*SQUARE_SIZE+200;

	if(viewCam.pos.z<-200)
		viewCam.pos.z=-200;
	if(viewCam.pos.z>g.mapy*SQUARE_SIZE+200)
		viewCam.pos.z=g.mapy*SQUARE_SIZE+200;

	g.shared->camX=viewCam.pos.x;
	g.shared->camY=viewCam.pos.z;

}


/*
unsigned int crcTable[256];

unsigned int Calculate_CRC(char *first,char *last)
{  int length = ((int) (last - first));  unsigned int crc = 0xFFFFFFFF;
  for(int i=0; i<length; i++)
    {
    crc = (crc>>8) & 0x00FFFFFF ^ crcTable[(crc^first[i]) & 0xFF];
    }  return(crc);}



void InitCRCTable()
{
  unsigned int crc;
  for (int i=0; i<256; i++)
    {
    crc = i;
    for(int j=8; j>0; j--)
      {
      if (crc&1)
        {
        crc = (crc >> 1) ^ 0xEDB88320;
        }
      else
        {
        crc >>= 1;
        }
     }
     crcTable[i] = crc;
   }
  }

  */
