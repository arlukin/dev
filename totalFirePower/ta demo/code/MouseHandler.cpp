// MouseHandler.cpp: implementation of the CMouseHandler class.
//
//////////////////////////////////////////////////////////////////////

#include "MouseHandler.h"
#include <winsock2.h>
#include <windows.h>		// Header File For Windows
#include "mygl.h"
#include "ground.h"
#include "game.h"
#include "camera.h"
#include "irenderer.h"
#include "reghandler.h"
#include "minimap.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

extern HWND	hWnd;
extern bool	fullscreen;

CMouseHandler* mouse;

CMouseHandler::CMouseHandler()
{
	lastx=300;
	lasty=200;
	hide=false;
	mmMove=false;
	mmResize=false;

	for(int a=0;a<4;a++)
		buttons[a].pressed=false;
	mouseSpeed=regHandler.GetInt("MouseSpeed",50)*0.0002;
	moveSpeed=regHandler.GetInt("MoveSpeed",50)*0.1;
	invMouse=1.0-(float)regHandler.GetInt("InvMouse",1)*2.0;
}

CMouseHandler::~CMouseHandler()
{

}

static bool SetMouse=true;
void CMouseHandler::MouseMove(int x, int y)
{
	int dx=x-lastx;
	int dy=y-lasty;
	buttons[0].movement+=abs(dx)+abs(dy);
	buttons[1].movement+=abs(dx)+abs(dy);


	if(hide){
		RECT cr;
		if(GetWindowRect(hWnd,&cr)==0)
			MessageBox(0,"mouse error","",0);

		//bool SetMouse=!((x==300) && (y==200));
		if(SetMouse){
			if(dx!=0 || dy!=0)
				g.shared->updated=true;
			SetCursorPos(300+cr.left+4*!fullscreen,200+cr.top+23*!fullscreen);
			SetMouse=false;
		} else {
			SetMouse=true;
			lastx= x;  
			lasty = y;  
			return;
		}
	}

	if(buttons[1].pressed){
		viewCam.pos+=camera.right*dx*moveSpeed;
		viewCam.pos-=camera.up*dy*moveSpeed;
		lastx = x;  
		lasty = y;  
		return;
	};

	if(hide){
		viewCam.rot.y -= 0.01*(dx);  
		viewCam.rot.x -= 0.01*(dy)*invMouse;  
		if(viewCam.rot.x>PI*0.5)
			viewCam.rot.x=PI*0.5;
		if(viewCam.rot.x<-PI*0.5)
			viewCam.rot.x=-PI*0.5;

		lastx = x;  
		lasty = y;  
		return;	
	}

	if(mmMove){
		minimap->xpos+=dx;
		minimap->ypos-=dy;
	} else  if(mmResize){
		minimap->ypos-=dy;
		minimap->height+=dy;
		minimap->width+=dx;
	}

	lastx = x;  
	lasty = y;  
}

void CMouseHandler::MousePress(int x, int y, int button)
{
	buttons[button].pressed=true;
	buttons[button].time=g.frameNum;
	buttons[button].x=x;
	buttons[button].y=y;
	buttons[button].camPos=camera.pos;
	buttons[button].dir=hide ? camera.forward : camera.CalcPixelDir(x,y);
	buttons[button].movement=0;
	buttons[button].noRelease=false;

	if(button==0 && !hide){
		if((x>minimap->xpos) && (x<minimap->xpos+minimap->width) && (y>g.screeny-minimap->ypos-minimap->height) && (y<g.screeny-minimap->ypos) && minimap->show){
			if(x>minimap->xpos+minimap->width-30 && y>g.screeny-minimap->ypos-30)
				mmResize=true;
			else
				mmMove=true;
			return;
		}
		float3 dir=buttons[button].dir;
		float lh=sqrt(dir.x*dir.x+dir.z*dir.z);
		float heading;
		if(dir.z!=0)
			heading=atan(dir.x/dir.z);
		else
			heading=PI;
		if(dir.z<0)
			heading+=PI;
		viewCam.rot.x=atan(dir.y/lh);
		viewCam.rot.y=heading;
//		SetCursorPos(g.screenx/2,g.screeny/2);
	}
	if(button==1 && !hide){
		if((x>minimap->xpos) && (x<minimap->xpos+minimap->width) && (y>g.screeny-minimap->ypos-minimap->height) && (y<g.screeny-minimap->ypos) && minimap->show){
			buttons[1].noRelease=true;
			float xpart=((float)x-minimap->xpos)/minimap->width;
			float ypart=((float)y-(g.screeny-minimap->ypos-minimap->height))/minimap->height;
			viewCam.pos.x=xpart*g.mapx*SQUARE_SIZE;
			viewCam.pos.z=ypart*g.mapy*SQUARE_SIZE;
			return;
		}
	}
}

void CMouseHandler::MouseRelease(int x, int y, int button)
{
	buttons[button].pressed=false;

	if(buttons[button].noRelease){
		return;
	}

	if(button==0){
		mmMove=false;
		mmResize=false;
	} else if(button==1){
		if(buttons[1].movement<5){
			if(hide)
				ShowMouse();
			else{
				RECT cr;
				if(GetWindowRect(hWnd,&cr)==0)
					MessageBox(0,"error","",0);
				SetCursorPos(300+cr.left+4*!fullscreen,200+cr.top+23*!fullscreen);
				HideMouse();
			}
		}
	}
}

void CMouseHandler::Draw()
{
	return;
	if(buttons[0].pressed){
		float dist=ground->LineGroundCol(buttons[0].camPos,buttons[0].camPos+buttons[0].dir*2000);
		if(dist<0)
			return;
		float3 pos1=buttons[0].camPos+buttons[0].dir*dist;
		dist=ground->LineGroundCol(camera.pos,camera.pos+(hide ? camera.forward : camera.CalcPixelDir(lastx,lasty))*2000);
		if(dist<0)
			return;
		float3 pos2=camera.pos+(hide ? camera.forward : camera.CalcPixelDir(lastx,lasty))*dist;

		float3 forward=camera.forward;
		forward.y=0;
		forward.Normalize();
		float3 dif=pos1-pos2;
	
		float3 pos3=pos1-forward*forward.dot(dif);
		pos3.y=ground->GetHeight(pos3.x,pos3.z);

		float3 pos4=pos2+forward*forward.dot(dif);
		pos4.y=ground->GetHeight(pos4.x,pos4.z);

		glDisable(GL_FOG);
		glDisable(GL_DEPTH_TEST);
		glBegin(GL_LINE_STRIP);
		glVertexf3(pos1);
		glVertexf3(pos3);
		glVertexf3(pos2);
		glVertexf3(pos4);
		glVertexf3(pos1);
		glEnd();
		glEnable(GL_DEPTH_TEST);
		glEnable(GL_FOG);
	}
}

void CMouseHandler::ShowMouse()
{
	if(hide){
		ShowCursor(TRUE);
		hide=false;
	}
}

void CMouseHandler::HideMouse()
{
	if(!hide){
		ShowCursor(FALSE);
		hide=true;
		lastx = 300;  
		lasty = 200;  
	}
}
