// DrawWater.cpp: implementation of the CDrawWater class.
//
//////////////////////////////////////////////////////////////////////

#include "DrawWater.h"
#include <windows.h>
#include "mygl.h"
#include <GL\glu.h>
#include <math.h>
#include "globalstuff.h"
#include "bitmap.h"
#include "readmap.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CDrawWater::CDrawWater()
{
	glGenTextures(1, &texture);
	CBitmap pic("bitmaps\\ocean.jpg");

	// create mipmapped texture
	glBindTexture(GL_TEXTURE_2D, texture);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_NEAREST);
	gluBuild2DMipmaps(GL_TEXTURE_2D,4 ,pic.xsize, pic.ysize, GL_RGBA, GL_UNSIGNED_BYTE, pic.mem);
	
	displist=0;
}

CDrawWater::~CDrawWater()
{
	glDeleteTextures (1, &texture);
}

void CDrawWater::Draw()
{
	if(displist==0){
		displist=glGenLists(1);
		glNewList(displist, GL_COMPILE);

		glDisable(GL_ALPHA_TEST);
		glDepthMask(0);
		glDisable(GL_TEXTURE_2D);
		glColor3f(0.05f,0.05f,0.3f);
		glBegin(GL_QUADS);
			float xsize=(g.mapx-1)*SQUARE_SIZE;
			float ysize=(g.mapy-1)*SQUARE_SIZE;
			glVertex3f(0,g.seaLevel,0);
			glVertex3f(0,-5,0);
			glVertex3f(xsize,-5,0);
			glVertex3f(xsize,g.seaLevel,0);
			glVertex3f(0,g.seaLevel,0);
			glVertex3f(0,-5,0);
			glVertex3f(0,-5,ysize);
			glVertex3f(0,g.seaLevel,ysize);
			glVertex3f(xsize,g.seaLevel,ysize);
			glVertex3f(xsize,-5,ysize);
			glVertex3f(xsize,-5,0);
			glVertex3f(xsize,g.seaLevel,0);
			glVertex3f(xsize,g.seaLevel,ysize);
			glVertex3f(xsize,-5,ysize);
			glVertex3f(0,-5,ysize);
			glVertex3f(0,g.seaLevel,ysize);

			glColor3f(0.0f,0.0f,0.0f);
			for(int y=0;y<3;++y)
				for(int x=0;x<3;++x)
					if(x!=1 || y!=1){
						glVertex3f(-xsize*1.04+x*xsize*1.02,0,-ysize*1.04+y*ysize*1.02);
						glVertex3f(-xsize*1.04+x*xsize*1.02,0,y*ysize*1.02);
						glVertex3f(x*xsize*1.02,0,y*ysize*1.02);
						glVertex3f(x*xsize*1.02,0,-ysize*1.04+y*ysize*1.02);
					}
	
					glEnd();

		glColor4f(0.6f,0.6f,0.6f,0.4f);
		glEnable(GL_TEXTURE_2D);
		glBindTexture(GL_TEXTURE_2D, texture);
		glBegin(GL_QUADS);
/*		for(int y=0;y<(g.mapy-1)/32;y++){
			for(int x=0;x<(g.mapx-1)/32;x++){
				bool draw=false;
				for(int y2=y*32;y2<=(y+1)*32;y2++)
					for(int x2=x*32;x2<=(x+1)*32;x2++)
						if(readmap->map[y2*(g.mapx)+x2]<=g.seaLevel)
							draw=true;
				if(draw){
					glTexCoord2f(x*0.5f,y*0.5f);
					glVertex3f(x*256,g.seaLevel,y*256);
					glTexCoord2f(x*0.5f,(y+1)*0.5f);
					glVertex3f(x*256,g.seaLevel,(y+1)*256);
					glTexCoord2f((x+1)*0.5f,(y+1)*0.5f);
					glVertex3f((x+1)*256,g.seaLevel,(y+1)*256);
					glTexCoord2f((x+1)*0.5f,y*0.5f);
					glVertex3f((x+1)*256,g.seaLevel,y*256);
				}
			}
		}
*/
		if(g.seaLevel>1){
			glTexCoord2f(0,0);
			glVertex3f(0,g.seaLevel,0);
			glTexCoord2f(0,(g.mapy-1)/64);
			glVertex3f(0,g.seaLevel,(g.mapy-1)*SQUARE_SIZE);
			glTexCoord2f((g.mapx-1)/64,(g.mapy-1)/64);
			glVertex3f((g.mapx-1)*SQUARE_SIZE,g.seaLevel,(g.mapy-1)*SQUARE_SIZE);
			glTexCoord2f((g.mapx-1)/64,0);
			glVertex3f((g.mapx-1)*SQUARE_SIZE,g.seaLevel,0);
		}
		glEnd();

		glDisable(GL_TEXTURE_2D);
		glDepthMask(1);
		glEndList();
	}
	glCallList(displist);
}
