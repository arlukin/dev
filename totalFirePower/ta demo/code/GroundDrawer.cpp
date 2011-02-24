// GroundDrawer.cpp: implementation of the CGroundDrawer class.
//
//////////////////////////////////////////////////////////////////////

#include "GroundDrawer.h"
#include "Ground.h"
#include <windows.h>		// Header File For Windows
#include "mygl.h"
#include <gl\glu.h>			// Header File For The GLu32 Library
#include <gl\glaux.h>		// Header File For The Glaux Library
#include "Ground.h"
#include "readmap.h"
#include "camera.h"
#include "readmap.h"
#include "infoconsole.h"
#include "sky.h"
#include "vertexarray.h"
#include "treedrawer.h"
#include "featurehandler.h"
#include "timeprofiler.h"
#include "irenderer.h"
#include "tamem.h"
#include "reghandler.h"

static GLfloat FogWhite[]=			{ 1.0f,	1.0f, 1.0f, 0	 }; 
static GLfloat FogLand[]=			{ 0.7f,	0.7f, 0.8f, 0	 }; 

#define NUM_LODS 4
#define VIEW_RADIUS 30

CGroundDrawer* groundDrawer;

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////
CGroundDrawer::CGroundDrawer()
{
	int a;
	viewRadius=regHandler.GetInt("GroundDetail",56);
	viewRadius+=viewRadius%2;

	if(viewRadius>58){
		useLargeTextures=true;
		textureSize=2048;
		tilesInTex=64;
	} else{
		useLargeTextures=false;
		textureSize=1024;
		tilesInTex=32;
	}

	baseTreeDistance=regHandler.GetInt("TreeDistance",4000)/256.0f;

	drawTrees=true;

	striptype=GL_TRIANGLE_STRIP;

	treeDrawer=new CTreeDrawer();

	unsigned char* scrap=new unsigned char[textureSize*textureSize*4];

	for(a=0;a<3;++a){
		glGenTextures(1, &texLevels[a].tex);
		glBindTexture(GL_TEXTURE_2D, texLevels[a].tex);
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
		glTexImage2D(GL_TEXTURE_2D,0,4 ,textureSize, textureSize, 0,GL_RGBA, GL_UNSIGNED_BYTE, scrap);
		texLevels[a].xpos=-1000;
		texLevels[a].ypos=-1000;
	}

	delete[] scrap;
}

CGroundDrawer::~CGroundDrawer()
{
	delete treeDrawer;
	for(int a=0;a<3;++a){
		glDeleteTextures (1, &texLevels[a].tex);
	}
}

static CVertexArray* va;

static float texMulX;
static float texMulY;

static inline void DrawVertexA(int x,int y)
{
	float height=readmap->map[y*g.mapx+x];
	va->AddVertexT2(float3(x*SQUARE_SIZE,height,y*SQUARE_SIZE),
		x*texMulX,(y+0.5-height*0.037f)*texMulY,float(x)/2.37,float(y)/2.37);
}

static inline void DrawVertexA(int x,int y,float height)
{
	va->AddVertexT2(float3(x*SQUARE_SIZE,height,y*SQUARE_SIZE),
		x*texMulX,(y+0.5-height*0.037f)*texMulY,float(x)/2.37,float(y)/2.37);
}

static inline void EndStrip()
{
	va->EndStrip();	
}

static void DrawGroundVertexArray(){
	va->DrawArrayT2(GL_TRIANGLE_STRIP);
/*	if(sky->drawShadows){
		sky->SetCloudShadow(0);
		if(multiTextureEnabled){
			glActiveTextureARB(GL_TEXTURE1_ARB);
			glDisable(GL_TEXTURE_2D);
			glActiveTextureARB(GL_TEXTURE0_ARB);
		}
		glColor4f(1,1,1,1);
		glBlendFunc(GL_ZERO,GL_SRC_COLOR);
		glEnable(GL_BLEND);
		glFogfv(GL_FOG_COLOR,FogWhite);

		va->DrawArrayT(GL_TRIANGLE_STRIP,28);

		glDisable(GL_BLEND);
		glFogfv(GL_FOG_COLOR,FogLand);
		sky->ResetCloudShadow(0);

		if(multiTextureEnabled){
				glActiveTextureARB(GL_TEXTURE1_ARB);
				glEnable(GL_TEXTURE_2D);
				glBindTexture(GL_TEXTURE_2D, readmap->detailtex);
				glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);		
				glActiveTextureARB(GL_TEXTURE0_ARB);
		}
		glEnable(GL_TEXTURE_2D);
		glBindTexture(GL_TEXTURE_2D, readmap->bigtex);
	}

	if(multiTextureEnabled){
		glClientActiveTextureARB(GL_TEXTURE1_ARB);
		glDisableClientState(GL_TEXTURE_COORD_ARRAY);
		glClientActiveTextureARB(GL_TEXTURE0_ARB);
	}
*/	va=GetVertexArray();
	va->Initialize();
}

void CGroundDrawer::Draw()
{
#ifdef PROFILE_TIME
	LARGE_INTEGER start;
	QueryPerformanceCounter(&start);
#endif
	int baseViewRadius=viewRadius;
	float zoom=45/camera.fov;
	viewRadius=viewRadius*sqrt(zoom);
	viewRadius+=viewRadius%2;
	
	va=GetVertexArray();
	va->Initialize();

	int x,y;
	int mapx=g.mapx;
	int hmapx=mapx>>1;
	int mapy=g.mapy;

	left.clear();
	right.clear();
	
	//Add restraints for camera sides
	AddFrustumRestraint(camera.bottom);
	AddFrustumRestraint(camera.top);
	AddFrustumRestraint(camera.rightside);
	AddFrustumRestraint(camera.leftside);

	//Add restraint for maximum view distance
	fline temp;
	float3 up(0,1,0);
	float3 side=camera.forward;
	float3 camHorizontal=camera.forward;
	camHorizontal.y=0;
	camHorizontal.Normalize();
	float3 b=up.cross(camHorizontal);			//get vector for collision between frustum and horizontal plane
	if(fabs(b.z)>0.0001){    
		temp.dir=b.x/b.z;				//set direction to that
		float3 c=b.cross(camHorizontal);			//get vector from camera to collision line
		float3 colpoint;				//a point on the collision line
		
		if(side.y>0)								
			colpoint=camera.pos+camHorizontal*g.viewRange*1.05f-c*(camera.pos.y/c.y);
		else
			colpoint=camera.pos+camHorizontal*g.viewRange*1.05f-c*((camera.pos.y-255/3.5f)/c.y);
		
		
		temp.base=colpoint.x-colpoint.z*temp.dir;	//get intersection between colpoint and z axis
		if(b.z>0){
			left.push_back(temp);			
		}else{
			right.push_back(temp);
		}
	}

	float cellsize=SQUARE_SIZE;
	int cx=(int)(camera.pos.x/cellsize);
	int cy=(int)(camera.pos.z/cellsize);
	int curSquare=0;

	glDisable(GL_BLEND);
	glEnable(GL_TEXTURE_2D);							// Enable Texture Mapping
	glEnable(GL_CULL_FACE);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	int xstart=1,xstop=1,ystart=1,ystop=1;

	glColor4f(1,1,1,1);
	glBindTexture(GL_TEXTURE_2D, readmap->bigtex);
	if(multiTextureEnabled){
			glActiveTextureARB(GL_TEXTURE1_ARB);
			glEnable(GL_TEXTURE_2D);
			glBindTexture(GL_TEXTURE_2D, readmap->detailtex);
			glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);		
		  glActiveTextureARB(GL_TEXTURE0_ARB);
	}
	bool inStrip=false;

	PrepareTex(0,camera.pos);
	int ys=cy-viewRadius/2+2;
	if(ys<0)
		ys=0;
	int xs=cx-viewRadius/2;
	if(xs<0)
		xs=0;
	int yend=cy+viewRadius/2-1;
	if(yend>(mapy-1))
		yend=(mapy-1);
	int xend=cx+viewRadius/2+1;
	if(xend>(mapx-1))
		xend=(mapx-1);
	for(y=ys;y<yend;++y){
		for(int x=xs;x<xend;++x){
			DrawVertexA(x,y);
			DrawVertexA(x,y+1);
		}
		DrawVertexA(x,y);
		DrawVertexA(x,y+1);
		EndStrip();
	}
	DrawGroundVertexArray();

  float camxpart=0,oldcamxpart;
  float camypart=0,oldcamypart;
	int lodLevel=0;
  for(int lod=1;lod<(2<<NUM_LODS);lod*=2){

		int maxyxs=-100000;
		int minyxs=100000;
		int maxyxe=-100000;
		int minyxe=100000;
    cx=(cx/lod)*lod;
    cy=(cy/lod)*lod;
    int hlod=lod>>1;
    int ysquaremod=((cy)%(2*lod))/lod;
    int xsquaremod=((cx)%(2*lod))/lod;
    
    oldcamxpart=camxpart;
    float cx2=(cx/(2*lod))*lod*2;
    camxpart=(camera.pos.x/cellsize-cx2)/(lod*2);

    oldcamypart=camypart;
    float cy2=(cy/(2*lod))*lod*2;
    camypart=(camera.pos.z/cellsize-cy2)/(lod*2);

    int x2start=cx+(-viewRadius*xstart+2-xsquaremod-(1-xstart)*4)*lod;
    if(x2start<0)
      x2start=0;
    int xend=cx+(viewRadius*xstop-xsquaremod+(1-xstop)*4)*lod;
    if(xend>mapx-lod)
      xend=mapx-lod;
    int y2start=cy+(-viewRadius*ystart+2-ysquaremod-(1-ystart)*4)*lod;
    if(y2start<0)
      y2start=0;
    if(y2start>mapy-lod)
      y2start=mapy-lod;
    int yend=cy+(viewRadius*ystop-ysquaremod+(1-ystop)*4)*lod;
    if(yend>mapy-lod)
      yend=mapy-lod;
    if(yend<0)
      yend=0;

		lodLevel++;
		PrepareTex(lodLevel,camera.pos);

    for(y=y2start+(y2start==0 ? 0 : lod);y<yend-(yend==mapy-lod ? 0 : lod);y+=lod){
      int x2s=x2start;
      int xe=xend;
      int xtest,xtest2;
      std::vector<fline>::iterator fli;
      for(fli=left.begin();fli!=left.end();fli++){
        xtest=((int)(fli->base/SQUARE_SIZE+fli->dir*y))/lod*lod-lod;
        xtest2=((int)(fli->base/SQUARE_SIZE+fli->dir*(y+lod)))/lod*lod-lod;
        if(xtest>xtest2)
          xtest=xtest2;
        if(xtest>x2s)
          x2s=xtest;
      }
      for(fli=right.begin();fli!=right.end();fli++){
        xtest=((int)(fli->base/SQUARE_SIZE+fli->dir*y))/lod*lod+lod;
        xtest2=((int)(fli->base/SQUARE_SIZE+fli->dir*(y+lod)))/lod*lod+lod;
        if(xtest<xtest2)
          xtest=xtest2;
        if(xtest<xe)
          xe=xtest;
      }
			if(x2s==x2start && y-lod<=minyxs)
				minyxs=y-lod*2;
			if(x2s==x2start && y+lod>=maxyxs)
				maxyxs=y+lod*2;
			if(xe==xend && y-lod<=minyxe)
				minyxe=y-lod*2;
			if(xe==xend && y+lod>=maxyxe)
				maxyxe=y+lod*2;

			if(minyxs<y2start)
				minyxs=y2start;
			if(minyxe<y2start)
				minyxe=y2start;
			if(maxyxe>yend)
				maxyxe=yend;
			if(maxyxs>yend)
				maxyxs=yend;


			if(x2s==x2start && x2s!=0)
				x2s+=lod;
			if(xe==xend && xe!=mapx-lod)
				xe-=lod;

      for(x=x2s;x<xe;x+=lod){
				if(lod==1){
					if((x>(cx)+viewRadius*lod/2) || (x<(cx)-viewRadius*lod/2) ||
						 (y>(cy)+viewRadius*lod/2-2) || (y<(cy)-viewRadius*lod/2+2)){  //normal terräng
						if(!inStrip){
							DrawVertexA(x,y);
							DrawVertexA(x,y+lod);
							inStrip=true;
						}
						DrawVertexA(x+lod,y);
						DrawVertexA(x+lod,y+lod);
					} else {
						if(inStrip){
							EndStrip();
							inStrip=false;
						}

					}
				} else {
        if((x>(cx)+viewRadius*hlod) || (x<(cx)-viewRadius*hlod) ||
           (y>(cy)+viewRadius*hlod) || (y<(cy)-viewRadius*hlod)){  //normal terräng
					if(!inStrip){
						DrawVertexA(x,y);
						DrawVertexA(x,y+lod);
						inStrip=true;
					}
					DrawVertexA(x+lod,y);
					DrawVertexA(x+lod,y+lod);
        } else {  //inre begränsning mot föregående lod
          if((x>=(cx)+viewRadius*hlod)){
            float h1=(readmap->map[(y)*mapx+x]+readmap->map[(y+lod)*mapx+x])*0.5*(1-oldcamxpart)+readmap->map[(y+hlod)*mapx+x]*(oldcamxpart);
            float h2=(readmap->map[(y)*mapx+x]+readmap->map[(y)*mapx+x+lod])*0.5*(1-oldcamxpart)+readmap->map[(y)*mapx+x+hlod]*(oldcamxpart);
            float h3=(readmap->map[(y+lod)*mapx+x]+readmap->map[(y)*mapx+x+lod])*0.5*(1-oldcamxpart)+readmap->map[(y+hlod)*mapx+x+hlod]*(oldcamxpart);
            float h4=(readmap->map[(y+lod)*mapx+x]+readmap->map[(y+lod)*mapx+x+lod])*0.5*(1-oldcamxpart)+readmap->map[(y+lod)*mapx+x+hlod]*(oldcamxpart);
            
						if(inStrip){
							EndStrip();
							inStrip=false;
						}
            DrawVertexA(x,y);                                            
            DrawVertexA(x,y+hlod,h1);
            DrawVertexA(x+hlod,y,h2);
            DrawVertexA(x+hlod,y+hlod,h3);
						EndStrip();
            DrawVertexA(x,y+hlod,h1);
            DrawVertexA(x,y+lod);
            DrawVertexA(x+hlod,y+hlod,h3);
            DrawVertexA(x+hlod,y+lod,h4);
						EndStrip();
            DrawVertexA(x+hlod,y+lod,h4);
            DrawVertexA(x+lod,y+lod);
            DrawVertexA(x+hlod,y+hlod,h3);
            DrawVertexA(x+lod,y);
            DrawVertexA(x+hlod,y,h2);
						EndStrip();
          }     
          if((x<=(cx)-viewRadius*hlod)){
            float h1=(readmap->map[(y)*mapx+x+lod]+readmap->map[(y+lod)*mapx+x+lod])*0.5*(oldcamxpart)+readmap->map[(y+hlod)*mapx+x+lod]*(1-oldcamxpart);
            float h2=(readmap->map[(y)*mapx+x]+readmap->map[(y)*mapx+x+lod])*0.5*(oldcamxpart)+readmap->map[(y)*mapx+x+hlod]*(1-oldcamxpart);
            float h3=(readmap->map[(y+lod)*mapx+x]+readmap->map[(y)*mapx+x+lod])*0.5*(oldcamxpart)+readmap->map[(y+hlod)*mapx+x+hlod]*(1-oldcamxpart);
            float h4=(readmap->map[(y+lod)*mapx+x]+readmap->map[(y+lod)*mapx+x+lod])*0.5*(oldcamxpart)+readmap->map[(y+lod)*mapx+x+hlod]*(1-oldcamxpart);
            
						if(inStrip){
							EndStrip();
							inStrip=false;
						}
            DrawVertexA(x+lod,y+hlod,h1);
            DrawVertexA(x+lod,y);
            DrawVertexA(x+hlod,y+hlod,h3);
            DrawVertexA(x+hlod,y,h2);
            EndStrip();
            DrawVertexA(x+lod,y+lod);
            DrawVertexA(x+lod,y+hlod,h1);
            DrawVertexA(x+hlod,y+lod,h4);
            DrawVertexA(x+hlod,y+hlod,h3);
            EndStrip();
            DrawVertexA(x+hlod,y,h2);
            DrawVertexA(x,y);
            DrawVertexA(x+hlod,y+hlod,h3);
            DrawVertexA(x,y+lod);
            DrawVertexA(x+hlod,y+lod,h4);
            EndStrip();        
          } 
          if((y>=(cy)+viewRadius*hlod)){
            float h1=(readmap->map[(y)*mapx+x]+readmap->map[(y)*mapx+x+lod])*0.5*(1-oldcamypart)+readmap->map[(y)*mapx+x+hlod]*(oldcamypart);
            float h2=(readmap->map[(y)*mapx+x]+readmap->map[(y+lod)*mapx+x])*0.5*(1-oldcamypart)+readmap->map[(y+hlod)*mapx+x]*(oldcamypart);
            float h3=(readmap->map[(y+lod)*mapx+x]+readmap->map[(y)*mapx+x+lod])*0.5*(1-oldcamypart)+readmap->map[(y+hlod)*mapx+x+hlod]*(oldcamypart);
            float h4=(readmap->map[(y+lod)*mapx+x+lod]+readmap->map[(y)*mapx+x+lod])*0.5*(1-oldcamypart)+readmap->map[(y+hlod)*mapx+x+lod]*(oldcamypart);
            
						if(inStrip){
							EndStrip();
							inStrip=false;
						}
            DrawVertexA(x,y);                                            
            DrawVertexA(x,y+hlod,h2);
            DrawVertexA(x+hlod,y,h1);
            DrawVertexA(x+hlod,y+hlod,h3);
            DrawVertexA(x+lod,y);
            DrawVertexA(x+lod,y+hlod,h4);
            EndStrip();
            DrawVertexA(x,y+hlod,h2);
            DrawVertexA(x,y+lod);
            DrawVertexA(x+hlod,y+hlod,h3);
            DrawVertexA(x+lod,y+lod);
            DrawVertexA(x+lod,y+hlod,h4);
            EndStrip();        
          }
          if((y<=(cy)-viewRadius*hlod)){
            float h1=(readmap->map[(y+lod)*mapx+x]+readmap->map[(y+lod)*mapx+x+lod])*0.5*(oldcamypart)+readmap->map[(y+lod)*mapx+x+hlod]*(1-oldcamypart);
            float h2=(readmap->map[(y)*mapx+x]+readmap->map[(y+lod)*mapx+x])*0.5*(oldcamypart)+readmap->map[(y+hlod)*mapx+x]*(1-oldcamypart);
            float h3=(readmap->map[(y+lod)*mapx+x]+readmap->map[(y)*mapx+x+lod])*0.5*(oldcamypart)+readmap->map[(y+hlod)*mapx+x+hlod]*(1-oldcamypart);
            float h4=(readmap->map[(y+lod)*mapx+x+lod]+readmap->map[(y)*mapx+x+lod])*0.5*(oldcamypart)+readmap->map[(y+hlod)*mapx+x+lod]*(1-oldcamypart);
            
						if(inStrip){
							EndStrip();
							inStrip=false;
						}
            DrawVertexA(x,y+hlod,h2);
            DrawVertexA(x,y+lod);
            DrawVertexA(x+hlod,y+hlod,h3);
            DrawVertexA(x+hlod,y+lod,h1);
            DrawVertexA(x+lod,y+hlod,h4);
            DrawVertexA(x+lod,y+lod);
            EndStrip();
            DrawVertexA(x+lod,y+hlod,h4);
            DrawVertexA(x+lod,y);
            DrawVertexA(x+hlod,y+hlod,h3);
            DrawVertexA(x,y);
            DrawVertexA(x,y+hlod,h2);
            EndStrip();        
          }
        }}
      }
			if(inStrip){
				EndStrip();
				inStrip=false;
			}
    }
		//rita yttre begränsnings yta mot nästa lod
		if((x=xend-lod)<mapx-2*lod){
			for(y=minyxe;y<maxyxe;y+=lod){
				DrawVertexA(x,y);
				DrawVertexA(x,y+lod);
				if(y%(lod*2)){
					float h=((readmap->map[(y-lod)*mapx+x+lod]+readmap->map[(y+lod)*mapx+x+lod])*0.5)*(1-camxpart)+readmap->map[(y)*mapx+x+lod]*(camxpart);
					DrawVertexA(x+lod,y,h);
					DrawVertexA(x+lod,y+lod);
				} else {
					DrawVertexA(x+lod,y);
					float h=(readmap->map[(y)*mapx+x+lod]+readmap->map[(y+lod*2)*mapx+x+lod])*0.5*(1-camxpart)+readmap->map[(y+lod)*mapx+x+lod]*(camxpart);
					DrawVertexA(x+lod,y+lod,h);
				}
				}
		}	EndStrip();
		
		if((x=x2start)>0){
			for(y=minyxs;y<maxyxs;y+=lod){
				if(y%(lod*2)){
					float h=((readmap->map[(y-lod)*mapx+x]+readmap->map[(y+lod)*mapx+x])*0.5)*(camxpart)+readmap->map[(y)*mapx+x]*(1-camxpart);
					DrawVertexA(x,y,h);
					DrawVertexA(x,y+lod);
				} else {
					DrawVertexA(x,y);
					float h=(readmap->map[(y)*mapx+x]+readmap->map[(y+lod*2)*mapx+x])*0.5*(camxpart)+readmap->map[(y+lod)*mapx+x]*(1-camxpart);
					DrawVertexA(x,y+lod,h);
				}
				DrawVertexA(x+lod,y);
				DrawVertexA(x+lod,y+lod);
				EndStrip();
			}
		}
		if((y=yend-lod)<mapy-2*lod){
			int x2s=x2start;
			int xe=xend;
			int xtest,xtest2;
			std::vector<fline>::iterator fli;
			for(fli=left.begin();fli!=left.end();fli++){
				xtest=((int)(fli->base/SQUARE_SIZE+fli->dir*y))/lod*lod-lod;
				xtest2=((int)(fli->base/SQUARE_SIZE+fli->dir*(y+lod)))/lod*lod-lod;
				if(xtest>xtest2)
					xtest=xtest2;
				if(xtest>x2s)
					x2s=xtest;
			}
			for(fli=right.begin();fli!=right.end();fli++){
				xtest=((int)(fli->base/SQUARE_SIZE+fli->dir*y))/lod*lod+lod;
				xtest2=((int)(fli->base/SQUARE_SIZE+fli->dir*(y+lod)))/lod*lod+lod;
				if(xtest<xtest2)
					xtest=xtest2;
				if(xtest<xe)
					xe=xtest;
			}
			if(x2s<xe){
				x=x2s;
				if(x%(lod*2)){
					DrawVertexA(x,y);
					float h=((readmap->map[(y+lod)*mapx+x-lod]+readmap->map[(y+lod)*mapx+x+lod])*0.5)*(1-camypart)+readmap->map[(y+lod)*mapx+x]*(camypart);
					DrawVertexA(x,y+lod,h);
				} else {
					DrawVertexA(x,y);
					DrawVertexA(x,y+lod);
				}
				for(x=x2s;x<xe;x+=lod){
					if(x%(lod*2)){
						DrawVertexA(x+lod,y);
						DrawVertexA(x+lod,y+lod);
					} else {
						DrawVertexA(x+lod,y);
						float h=(readmap->map[(y+lod)*mapx+x+2*lod]+readmap->map[(y+lod)*mapx+x])*0.5*(1-camypart)+readmap->map[(y+lod)*mapx+x+lod]*(camypart);
						DrawVertexA(x+lod,y+lod,h);
					}
				}
				EndStrip();
			}
		}
		if((y=y2start)>0){
			int x2s=x2start;
			int xe=xend;
			int xtest,xtest2;
			std::vector<fline>::iterator fli;
			for(fli=left.begin();fli!=left.end();fli++){
				xtest=((int)(fli->base/SQUARE_SIZE+fli->dir*y))/lod*lod-lod;
				xtest2=((int)(fli->base/SQUARE_SIZE+fli->dir*(y+lod)))/lod*lod-lod;
				if(xtest>xtest2)
					xtest=xtest2;
				if(xtest>x2s)
					x2s=xtest;
			}
			for(fli=right.begin();fli!=right.end();fli++){
				xtest=((int)(fli->base/SQUARE_SIZE+fli->dir*y))/lod*lod+lod;
				xtest2=((int)(fli->base/SQUARE_SIZE+fli->dir*(y+lod)))/lod*lod+lod;
				if(xtest<xtest2)
					xtest=xtest2;
				if(xtest<xe)
					xe=xtest;
			}
			if(x2s<xe){
				x=x2s;
				if(x%(lod*2)){
					float h=((readmap->map[(y)*mapx+x-lod]+readmap->map[(y)*mapx+x+lod])*0.5)*(camypart)+readmap->map[(y)*mapx+x]*(1-camypart);
					DrawVertexA(x,y,h);
					DrawVertexA(x,y+lod);
				} else {
					DrawVertexA(x,y);
					DrawVertexA(x,y+lod);
				}
				for(x=x2s;x<xe;x+=lod){
					if(x%(lod*2)){
						DrawVertexA(x+lod,y);
						DrawVertexA(x+lod,y+lod);
					} else {
						float h=(readmap->map[(y)*mapx+x+2*lod]+readmap->map[(y)*mapx+x])*0.5*(camypart)+readmap->map[(y)*mapx+x+lod]*(1-camypart);
						DrawVertexA(x+lod,y,h);
						DrawVertexA(x+lod,y+lod);
					}
				}
				EndStrip();
			}
		}
		DrawGroundVertexArray();
  }

	
//	DrawGroundVertexArray();
//	sky->ResetCloudShadow(1);
	if(multiTextureEnabled){
			glActiveTextureARB(GL_TEXTURE1_ARB);
			glDisable(GL_TEXTURE_2D);
		  glActiveTextureARB(GL_TEXTURE0_ARB);
	}
	glDisable(GL_CULL_FACE);

	glEnable(GL_ALPHA_TEST);
	glEnable(GL_TEXTURE_2D);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_BLEND);
	glColor4f(1,1,1,1);

	float treeDistance=baseTreeDistance*sqrt((zoom));
	if(treeDistance>g.viewRange/128)
		treeDistance=g.viewRange/128;


	if(drawTrees){
		treeDrawer->Draw(treeDistance);
	}
	
	glDisable(GL_ALPHA_TEST);

	glDisable(GL_TEXTURE_2D);
	viewRadius=baseViewRadius;
	
#ifdef PROFILE_TIME
	LARGE_INTEGER stop;
	QueryPerformanceCounter(&stop);
	profiler.AddTime("Drawing ground",stop.QuadPart - start.QuadPart);
#endif
}

CGroundDrawer::AddFrustumRestraint(float3 side)
{
	fline temp;
	float3 up(0,1,0);
	
	float3 b=up.cross(side);		//get vector for collision between frustum and horizontal plane
	if(fabs(b.z)>0.0001){
		temp.dir=b.x/b.z;				//set direction to that
		float3 c=b.cross(side);			//get vector from camera to collision line
		float3 colpoint;				//a point on the collision line
		
		if(side.y>0)								
			colpoint=camera.pos-c*((camera.pos.y+150)/c.y);
		else
			colpoint=camera.pos-c*((camera.pos.y-400)/c.y);
		
		
		temp.base=colpoint.x-colpoint.z*temp.dir;	//get intersection between colpoint and z axis
		if(b.z>0){
			left.push_back(temp);			
		}else{
			right.push_back(temp);
		}
	}	
}


void CGroundDrawer::PrepareTex(int level, float3 &pos)
{
	if(level>2){
		glBindTexture(GL_TEXTURE_2D, readmap->bigtex);
		texMulX=1.0/(g.mapx-1);
		texMulY=1.0/(g.mapy-1);
		return;
	}
	int levSize=1<<level;
	int levTexSize=32>>level;
	int xpos=pos.x/32;
	int ypos=pos.z/32-1;
	glBindTexture(GL_TEXTURE_2D, texLevels[level].tex);

	if(abs(xpos-texLevels[level].xpos)>12 || abs(ypos-texLevels[level].ypos)>12){
		FillTexArea(level,xpos-tilesInTex/2*levSize,ypos-tilesInTex/2*levSize,tilesInTex*levSize,tilesInTex*levSize);

		texLevels[level].xpos=xpos;
		texLevels[level].ypos=ypos;
	}

	if(xpos-texLevels[level].xpos>0){
		int dif=xpos-texLevels[level].xpos;
		FillTexArea(level,xpos+tilesInTex/2*levSize-dif,ypos-tilesInTex/2*levSize,dif,tilesInTex*levSize);

		texLevels[level].xpos=xpos;
	}

	if(xpos-texLevels[level].xpos<0){
		int dif=-(xpos-texLevels[level].xpos);
		FillTexArea(level,xpos-tilesInTex/2*levSize,ypos-tilesInTex/2*levSize,dif,tilesInTex*levSize);

		texLevels[level].xpos=xpos;
	}

	if(ypos-texLevels[level].ypos>0){
		int dif=ypos-texLevels[level].ypos;
		FillTexArea(level,xpos-tilesInTex/2*levSize,ypos+tilesInTex/2*levSize-dif,tilesInTex*levSize,dif);

		texLevels[level].ypos=ypos;
	}
	if(ypos-texLevels[level].ypos<0){
		int dif=-(ypos-texLevels[level].ypos);
		FillTexArea(level,xpos-tilesInTex/2*levSize,ypos-tilesInTex/2*levSize,tilesInTex*levSize,dif);

		texLevels[level].ypos=ypos;
	}

	texMulX=1.0/((64<<level)<<useLargeTextures);
	texMulY=1.0/((64<<level)<<useLargeTextures);
}

void CGroundDrawer::MemBlit(unsigned char *dest, unsigned char *source, int width, int height, int destSkip)
{
	int* d=(int*)dest;
	int* s=(int*)source;
	for(int y=0;y<height;++y){
		for(int x=0;x<width;++x){
			*d=*s;
			++d;
			++s;
		}
		d+=destSkip;
	}
}

void CGroundDrawer::FillTexArea(int level, int xstart, int ystart, int width, int height)
{
	int levSize=1<<level;
	int levTexSize=32>>level;

	if(xstart<0){
		xstart=0;
	}
	if(ystart<0){
		ystart=0;
	}
	if(xstart+width>(g.mapx-1)/2)
		width=(g.mapx-1)/2-xstart;
	if(ystart+height>(g.mapy-1)/2)
		height=(g.mapy-1)/2-ystart;

	int texXStart=xstart%(tilesInTex*levSize);

	if(texXStart+width>tilesInTex*levSize){
		int xBreak=xstart-texXStart+tilesInTex*levSize;
		FillTexArea(level,xstart,ystart,xBreak-xstart,height);
		FillTexArea(level,xBreak,ystart,width-(xBreak-xstart),height);
	}

	int texYStart=ystart%(tilesInTex*levSize);

	if(texYStart+height>tilesInTex*levSize){
		int yBreak=ystart-texYStart+tilesInTex*levSize;
		FillTexArea(level,xstart,ystart,width,yBreak-ystart);
		FillTexArea(level,xstart,yBreak,width,height-(yBreak-ystart));
	}

	unsigned char* buf=new unsigned char[width*height*4*levTexSize*levTexSize];
	int skip=(width-1)*levTexSize;

	for(int y=0;y<height;++y){
		for(int x=0;x<width;++x){
			unsigned char* s=&readmap->tileData[level][readmap->tile[(ystart+y)*(g.mapx-1)/2+(xstart+x)]*levTexSize*levTexSize*4];
			MemBlit(&buf[(y*width*levTexSize+x)*levTexSize*4],s,levTexSize,levTexSize,skip);
		}
	}

	if(g.features){

	int texStartX=xstart*levTexSize;
	int texStartY=ystart*levTexSize;
	int texEndX=(xstart+width)*levTexSize;
	int texEndY=(ystart+height)*levTexSize;
	int hTexSize=levTexSize/2;

	int sy=ystart>3 ? -3:-ystart;
	int sx=xstart>3 ? -3:-xstart;
	int endy=height*2+7+ystart*2<g.mapy-7 ? height*2+7:g.mapy-7-ystart*2;
	int endx=width*2+3+xstart*2<g.mapx-3 ? width*2+3:g.mapx-3-xstart*2;
	for(y=sy;y<endy;++y){
		for(int x=sx;x<endx;++x){
			int f=g.features[(ystart*2+y)*(g.shared->FeatureMapXSize)+(xstart*2+x)].FeatureDefIndex;
			if(f>0){
				CTreeDrawer::FeatureDef* fd=&treeDrawer->featureDef[f];
				if(fd->type==2){
					int dsx=0;
					int dsy=0;
					int fsx=(xstart*2+x)*hTexSize+((24-fd->xoffset)>>level);
					int fsy=(ystart*2+y)*hTexSize+((32-fd->yoffset)>>level)-ground->GetHeight((xstart*2+x)*16,(ystart*2+y)*16)*(0.037f)*(16>>level);
					int ex=fd->xsize[level];
					int ey=fd->ysize[level];

					if(fsx+ex>texEndX)
						ex=texEndX-fsx;
					if(fsy+ey>texEndY)
						ey=texEndY-fsy;

					if(fsx<texStartX){
						dsx=texStartX-fsx;
						fsx=texStartX;
						ex-=dsx;
					}
					if(fsy<texStartY){
						dsy=texStartY-fsy;
						fsy=texStartY;
						ey-=dsy;
					}
					unsigned char* s=&fd->lods[level][(dsy*fd->xsize[level]+dsx)*4];
					MemBlitFeature(&buf[((fsy-texStartY)*width*levTexSize+(fsx-texStartX))*4],s,ex,ey,width*levTexSize-ex,fd->xsize[level]-ex);
				}
			}
		}
	}
	}
	glTexSubImage2D(GL_TEXTURE_2D,0,texXStart*levTexSize,texYStart*levTexSize,width*levTexSize,height*levTexSize,GL_RGBA,GL_UNSIGNED_BYTE,buf);

	delete[] buf;
}

void CGroundDrawer::MemBlitFeature(void *dest, void *source, int xsize, int ysize, int destSkip, int sourceSkip)
{
	int* d=(int*)dest;
	int* s=(int*)source;
	for(int y=0;y<ysize;++y){
		for(int x=0;x<xsize;++x){
/*			if(((unsigned char*)s)[3]>125)
				*d=*s;
*/
			((unsigned char*)d)[0]=(((unsigned)(((unsigned char*)d)[0]))*(255-((unsigned char*)s)[3])+((unsigned)(((unsigned char*)s)[0]))*((unsigned char*)s)[3])>>8;
			((unsigned char*)d)[1]=(((unsigned)(((unsigned char*)d)[1]))*(255-((unsigned char*)s)[3])+((unsigned)(((unsigned char*)s)[1]))*((unsigned char*)s)[3])>>8;
			((unsigned char*)d)[2]=(((unsigned)(((unsigned char*)d)[2]))*(255-((unsigned char*)s)[3])+((unsigned)(((unsigned char*)s)[2]))*((unsigned char*)s)[3])>>8;
			++d;
			++s;
		}
		d+=destSkip;
		s+=sourceSkip;
	}
}
