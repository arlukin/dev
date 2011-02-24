// Sky.cpp: implementation of the CSky class.
//
//////////////////////////////////////////////////////////////////////

#include "Sky.h"
#include "globalstuff.h"
#include <math.h>
#include <windows.h>		// Header File For Windows
#include "mygl.h"
#include <gl\glu.h>			// Header File For The GLu32 Library
#include <gl\glaux.h>		// Header file for the glaux library
#include "camera.h"
#include "readmap.h"
#include "bitmap.h"
#include "timeprofiler.h"
#include "reghandler.h"

/*#include "ground.h"
#include "infoconsole.h"
#include "readmap.h"
*/
//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////
extern GLfloat FogBlack[]; 
extern GLfloat FogLand[]; 

#define Y_PART 10.0
#define X_PART 10.0

#define CLOUD_DETAIL 6
#define CLOUD_SIZE 256

static float domeheight;
CSky* sky=0;
//static unsigned int cdtex;

CSky::CSky()
{	
	for(int a=0;a<CLOUD_DETAIL;a++)
		cloudDown[a]=false;
	PrintLoadMsg("Creating sky");
	domeheight=cos(PI/16)*1.01;
	float domeWidth=sin(2*PI/32)*400*1.7f;

	dynamicSky=!!regHandler.GetInt("DynamicSky",0);
	lastCloudUpdate=-30;
	cloudDensity=0.50f;
	CreateClouds();
/*
	glGenTextures(1, &cdtex);
	CBitmap pic("bitmaps\\cdet.bmp");

	unsigned char mem[128*128*4];
	for(a=0;a<128*128;++a){
		mem[a*4+0]=0;
		mem[a*4+1]=0;
		mem[a*4+2]=0;
		mem[a*4+3]=(pic.mem[a*4]>>4)+12;
	}
	glBindTexture(GL_TEXTURE_2D, cdtex);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_NEAREST);
	gluBuild2DMipmaps(GL_TEXTURE_2D,4 ,pic.xsize, pic.ysize, GL_RGBA, GL_UNSIGNED_BYTE, mem);
*/
	int y;
	glGetError();
	displist=glGenLists(1);
	glNewList(displist, GL_COMPILE);
	glDisable(GL_TEXTURE_2D);
	glDisable(GL_DEPTH_TEST);
	glDisable(GL_LIGHTING);
	glDisable(GL_ALPHA_TEST);
	glDisable(GL_BLEND);
	glFogi(GL_FOG_MODE,GL_LINEAR);
	glFogf(GL_FOG_START,-20);
	glFogf(GL_FOG_END,50);
	glFogf(GL_FOG_DENSITY,1.0f);
	glEnable(GL_FOG);
	glColor4f(1,1,1,1);
	glMatrixMode(GL_PROJECTION);						// Select The Projection Matrix
	glLoadIdentity();									// Reset The Projection Matrix

	// Calculate The Aspect Ratio Of The Window
	gluPerspective(45.0f,(GLfloat)g.screenx/(GLfloat)g.screeny,0.1f,100);

	glMatrixMode(GL_MODELVIEW);							// Select The Modelview Matrix

	glDisable(GL_TEXTURE_2D);
	if(multiTextureEnabled){
		glActiveTextureARB(GL_TEXTURE1_ARB);
		glEnable(GL_TEXTURE_2D);
		glBindTexture(GL_TEXTURE_2D, skyTex);
		glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);		
	  glActiveTextureARB(GL_TEXTURE0_ARB);
	}
	for(y=0;y<Y_PART;y++){
		for(int x=0;x<X_PART;x++){
			glBegin(GL_TRIANGLE_STRIP);
			float3 c=GetCoord(x,y);
			
//			glTexCoord2f(c.x*0.025,c.z*0.025);
			glMultiTexCoord2fARB(GL_TEXTURE1_ARB,c.x/domeWidth+0.5,c.z/domeWidth+0.5);
			glVertex3f(c.x,c.y,c.z);
			
			c=GetCoord(x,y+1);
			
//			glTexCoord2f(c.x*0.025,c.z*0.025);
			glMultiTexCoord2fARB(GL_TEXTURE1_ARB,c.x/domeWidth+0.5,c.z/domeWidth+0.5);
			glVertex3f(c.x,c.y,c.z);
			
			c=GetCoord(x+1,y);
			
//			glTexCoord2f(c.x*0.025,c.z*0.025);
			glMultiTexCoord2fARB(GL_TEXTURE1_ARB,c.x/domeWidth+0.5,c.z/domeWidth+0.5);
			glVertex3f(c.x,c.y,c.z);
			
			c=GetCoord(x+1,y+1);
			
//			glTexCoord2f(c.x*0.025,c.z*0.025);
			glMultiTexCoord2fARB(GL_TEXTURE1_ARB,c.x/domeWidth+0.5,c.z/domeWidth+0.5);
			glVertex3f(c.x,c.y,c.z);

			glEnd();
		}
	}/**/
	if(dot3Ext){
		glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
		glEnable(GL_BLEND);

		glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);
		glEnable(GL_TEXTURE_2D);
		glBindTexture(GL_TEXTURE_2D, cloudDot3Tex);
		if(multiTextureEnabled){
			glActiveTextureARB(GL_TEXTURE1_ARB);
			glEnable(GL_TEXTURE_2D);
			glBindTexture(GL_TEXTURE_2D, skyDot3Tex);
			glTexEnvi(GL_TEXTURE_ENV,GL_SOURCE0_RGB_ARB,GL_PREVIOUS_ARB);
			glTexEnvi(GL_TEXTURE_ENV,GL_SOURCE1_RGB_ARB,GL_TEXTURE);
			glTexEnvi(GL_TEXTURE_ENV,GL_COMBINE_RGB_ARB,GL_DOT3_RGB_ARB);

			glTexEnvi(GL_TEXTURE_ENV,GL_SOURCE0_ALPHA_ARB,GL_PREVIOUS_ARB);
			glTexEnvi(GL_TEXTURE_ENV,GL_SOURCE1_ALPHA_ARB,GL_TEXTURE);
			glTexEnvi(GL_TEXTURE_ENV,GL_COMBINE_ALPHA_ARB,GL_MODULATE);
			glTexEnvi(GL_TEXTURE_ENV,GL_OPERAND0_ALPHA_ARB,GL_ONE_MINUS_SRC_ALPHA);

			glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_COMBINE_ARB);
/*
			glActiveTextureARB(GL_TEXTURE2_ARB);
			glEnable(GL_TEXTURE_2D);
			glBindTexture(GL_TEXTURE_2D, cdtex);
			glTexEnvi(GL_TEXTURE_ENV,GL_COMBINE_RGB_ARB,GL_ADD);
			glTexEnvi(GL_TEXTURE_ENV,GL_COMBINE_ALPHA_ARB,GL_ADD_SIGNED_ARB);
			glTexEnvi(GL_TEXTURE_ENV,GL_ALPHA_SCALE,2.0);
			glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_COMBINE_ARB);
*/
			glActiveTextureARB(GL_TEXTURE0_ARB);
		}

		for(y=0;y<Y_PART;y++){
			for(int x=0;x<X_PART;x++){
				glBegin(GL_TRIANGLE_STRIP);
				float3 c=GetCoord(x,y);
				
				glTexCoord2f(c.x*0.025,c.z*0.025);
				glMultiTexCoord2fARB(GL_TEXTURE1_ARB,c.x/domeWidth+0.5,c.z/domeWidth+0.5);
//				glMultiTexCoord2fARB(GL_TEXTURE2_ARB,c.x,c.z);
				glVertex3f(c.x,c.y,c.z);
				
				c=GetCoord(x,y+1);
				
				glTexCoord2f(c.x*0.025,c.z*0.025);
				glMultiTexCoord2fARB(GL_TEXTURE1_ARB,c.x/domeWidth+0.5,c.z/domeWidth+0.5);
	//			glMultiTexCoord2fARB(GL_TEXTURE2_ARB,c.x,c.z);
				glVertex3f(c.x,c.y,c.z);
				
				c=GetCoord(x+1,y);
				
				glTexCoord2f(c.x*0.025,c.z*0.025);
				glMultiTexCoord2fARB(GL_TEXTURE1_ARB,c.x/domeWidth+0.5,c.z/domeWidth+0.5);
		//		glMultiTexCoord2fARB(GL_TEXTURE2_ARB,c.x,c.z);
				glVertex3f(c.x,c.y,c.z);
				
				c=GetCoord(x+1,y+1);
				
				glTexCoord2f(c.x*0.025,c.z*0.025);
				glMultiTexCoord2fARB(GL_TEXTURE1_ARB,c.x/domeWidth+0.5,c.z/domeWidth+0.5);
			//	glMultiTexCoord2fARB(GL_TEXTURE2_ARB,c.x,c.z);
				glVertex3f(c.x,c.y,c.z);

				glEnd();
			}
		}
	}
	glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);
	if(multiTextureEnabled){
		glActiveTextureARB(GL_TEXTURE1_ARB);
		glTexEnvi(GL_TEXTURE_ENV,GL_OPERAND0_ALPHA_ARB,GL_SRC_ALPHA);
		glDisable(GL_TEXTURE_2D);
	  glActiveTextureARB(GL_TEXTURE2_ARB);
		glDisable(GL_TEXTURE_2D);
	  glActiveTextureARB(GL_TEXTURE0_ARB);
	}

	glEnable(GL_DEPTH_TEST);
	glDisable(GL_TEXTURE_2D);
	glDisable(GL_BLEND);
	glEndList();

//	if(glGetError()!=GL_NO_ERROR)
//		(*info) << "gl error\n";
}

CSky::~CSky()
{
	glDeleteTextures(1, &skyTex);
	glDeleteTextures(1, &skyDot3Tex);
	glDeleteTextures(1, &cloudDot3Tex);
}


CSky::Draw()
{
#ifdef PROFILE_TIME
	LARGE_INTEGER start;
	QueryPerformanceCounter(&start);
#endif
	glPushMatrix();
	glTranslatef(viewCam.pos.x,viewCam.pos.y*0.999f,viewCam.pos.z);
	glMatrixMode(GL_TEXTURE);						// Select The Projection Matrix
		glPushMatrix();
		glTranslatef(g.frameNum*0.00009+viewCam.pos.x*0.000025,viewCam.pos.z*0.000025,0);
	glMatrixMode(GL_MODELVIEW);							// Select The Modelview Matrix
/*
  glActiveTextureARB(GL_TEXTURE2_ARB);
	glMatrixMode(GL_TEXTURE);						// Select The Projection Matrix
		glPushMatrix();
		glTranslatef(g.frameNum*0.00003*40+viewCam.pos.x*0.0001*40,viewCam.pos.z*0.0001*40,0);
	glMatrixMode(GL_MODELVIEW);							// Select The Modelview Matrix
	glActiveTextureARB(GL_TEXTURE0_ARB);
*/
	glCallList(displist);
	glMatrixMode(GL_TEXTURE);						// Select The Projection Matrix
		glPopMatrix();
	glMatrixMode(GL_MODELVIEW);							// Select The Modelview Matrix
/*
  glActiveTextureARB(GL_TEXTURE2_ARB);
	glMatrixMode(GL_TEXTURE);						// Select The Projection Matrix
		glPopMatrix();
	glMatrixMode(GL_MODELVIEW);							// Select The Modelview Matrix
	glActiveTextureARB(GL_TEXTURE0_ARB);
*/
	glPopMatrix();

	glFogfv(GL_FOG_COLOR,FogLand);
	glFogf(GL_FOG_START,g.viewRange*0.6);
	glFogf(GL_FOG_END,g.viewRange*0.99);
	glFogf(GL_FOG_DENSITY,1.01f);

	glMatrixMode(GL_PROJECTION);						// Select The Projection Matrix
	glLoadIdentity();									// Reset The Projection Matrix
	gluPerspective(45.0f,(GLfloat)g.screenx/(GLfloat)g.screeny,2,g.viewRange);

	glMatrixMode(GL_MODELVIEW);							// Select The Modelview Matrix

#ifdef PROFILE_TIME
	LARGE_INTEGER stop;
	QueryPerformanceCounter(&stop);
	profiler.AddTime("Drawing sky",stop.QuadPart - start.QuadPart);
#endif
}

float3 CSky::GetTexCoord(int x, int y)
{
	float3 c;
	float a=((float)y/Y_PART)*0.5f;
	float b=((float)x/X_PART)*2*PI;
	c.x=0.5f+sin(b)*a;
	c.y=0.5f+cos(b)*a;
	return c;
}

float3 CSky::GetCoord(int x, int y)
{
	float3 c;
	float fy=((float)y/Y_PART)*2*PI;
	float fx=((float)x/X_PART)*2*PI;

	c.x=sin(fy/32)*sin(fx)*400;
	c.y=(cos(fy/32)-domeheight)*400;
	c.z=sin(fy/32)*cos(fx)*400;
	return c;
}

void CSky::CreateClouds()
{
	glGenTextures(1, &skyTex);
	glGenTextures(1, &skyDot3Tex);
	glGenTextures(1, &cloudDot3Tex);
	int y;

	unsigned char (* skytex)[512][4]=new unsigned char[512][512][4];
	
	for(y=0;y<512;y++){
		for(int x=0;x<512;x++){
			int dx=(x-256)*2.0;
			int dy=y-290;
			float sunDist=sqrt(dx*dx+dy*dy);
			float sunMod=2.0/sqrt(sunDist);
			float red=(0.15f+sunMod);
			float green=(0.20f+sunMod);
			float blue=(0.80f+sunMod);
			if(red>1)
				red=1;
			if(green>1)
				green=1;
			if(blue>1)
				blue=1;
			skytex[y][x][0]=red*255;
			skytex[y][x][1]=green*255;
			skytex[y][x][2]=blue*255;
			skytex[y][x][3]=255;
		}
	}

	glBindTexture(GL_TEXTURE_2D, skyTex);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_NEAREST);
	gluBuild2DMipmaps(GL_TEXTURE_2D,4 ,512, 512, GL_RGBA, GL_UNSIGNED_BYTE, skytex[0][0]);
	delete[] skytex;

	unsigned char skytex2[256][256][4];
	for(y=0;y<256;y++){
		for(int x=0;x<256;x++){
			int dx=(x-128)*2.0;
			int dy=y-145;
			float sunDist=sqrt(dx*dx+dy*dy);
			float sunMod=0.3/sqrt(sunDist)+2.0/sunDist;
			float green=(0.55f+sunMod);
			if(green>1)
				green=1;
			skytex2[y][x][0]=255-y/2;
			skytex2[y][x][1]=green*255;
			skytex2[y][x][2]=203;
			skytex2[y][x][3]=255;
		}
	}

	glBindTexture(GL_TEXTURE_2D, skyDot3Tex);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_NEAREST);
	gluBuild2DMipmaps(GL_TEXTURE_2D,4 ,256, 256, GL_RGBA, GL_UNSIGNED_BYTE, skytex2[0][0]);

	for(int a=0;a<CLOUD_DETAIL;a++){
		CreateRandMatrix(randMatrix[a],1-a*0.03);
		CreateRandMatrix(randMatrix[a+8],1-a*0.03);
	}

	char* scrap=new char[CLOUD_SIZE*CLOUD_SIZE*4];
	glBindTexture(GL_TEXTURE_2D, cloudDot3Tex);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
	glTexImage2D(GL_TEXTURE_2D,0,4, CLOUD_SIZE, CLOUD_SIZE,0,GL_RGBA, GL_UNSIGNED_BYTE, scrap);
	delete[] scrap;

	dynamicSky=true;
	CreateTransformVectors();
	UpdateClouds();
	dynamicSky=false;
}

void CSky::UpdateClouds()
{
	if(lastCloudUpdate>g.frameNum-10 || !dynamicSky)
		return;
#ifdef PROFILE_TIME
	LARGE_INTEGER start;
	QueryPerformanceCounter(&start);
#endif

	lastCloudUpdate=g.frameNum;

	int blendMatrix[8][32][32];
	for(int a=0;a<CLOUD_DETAIL;a++){
		float fade=(g.frameNum/(70.0*(2<<(CLOUD_DETAIL-1-a))));
		fade-=floor(fade/2)*2;
		if(fade>1){
			fade=2-fade;
			if(!cloudDown[a]){
				cloudDown[a]=true;
				CreateRandMatrix(randMatrix[a+8],1-a*0.03);
			}
		} else {
			if(cloudDown[a]){
				cloudDown[a]=false;
				CreateRandMatrix(randMatrix[a],1-a*0.03);
			}

		}
		int ifade=(3*fade*fade-2*fade*fade*fade)*256;

		for(int y=0;y<32;y++){
			for(int x=0;x<32;x++){
				blendMatrix[a][y][x]=(randMatrix[a][y][x]*ifade+randMatrix[a+8][y][x]*(256-ifade))>>8;
			}
		}
	}
	int rawClouds[CLOUD_SIZE][CLOUD_SIZE];

	for(a=0;a<CLOUD_SIZE*CLOUD_SIZE;a++){
		rawClouds[0][a]=0;
	}

	int kernel[CLOUD_SIZE/4*CLOUD_SIZE/4];
	for(a=0;a<CLOUD_DETAIL;a++){
		int expLevel=1<<a;

		for(int y=0;y<(CLOUD_SIZE/4)>>a;++y){
			float ydist=fabs(1+y-((CLOUD_SIZE/8)>>a))/((CLOUD_SIZE/8)>>a);
			ydist=3*ydist*ydist-2*ydist*ydist*ydist;
			for(int x=0;x<(CLOUD_SIZE/4)>>a;++x){
				float xdist=fabs(1+x-((CLOUD_SIZE/8)>>a))/((CLOUD_SIZE/8)>>a);
				xdist=3*xdist*xdist-2*xdist*xdist*xdist;
				
				float contrib=(1-xdist)*(1-ydist);
				kernel[y*CLOUD_SIZE/4+x]=contrib*((4<<CLOUD_DETAIL)>>a);
			}
		}
		unsigned int by=0,bx=0;
		for(y=0;y<CLOUD_SIZE-((CLOUD_SIZE/8)>>a);y+=(CLOUD_SIZE/8)>>a){
			for(int x=0;x<CLOUD_SIZE-((CLOUD_SIZE/8)>>a);x+=(CLOUD_SIZE/8)>>a){
				int blend=blendMatrix[a][by&31][bx&31];
				for(int y2=0;y2<((CLOUD_SIZE/4)>>a)-1;++y2){
					for(int x2=0;x2<((CLOUD_SIZE/4)>>a)-1;++x2){
						rawClouds[y+y2][x+x2]+=blend*kernel[y2*CLOUD_SIZE/4+x2];
					}
				}
				bx++;
			}
			by++;
		}
		by=0;
		bx=31;
		for(y=0;y<CLOUD_SIZE-((CLOUD_SIZE/8)>>a);y+=(CLOUD_SIZE/8)>>a){
			int x=CLOUD_SIZE-((CLOUD_SIZE/8)>>a);
			int blend=blendMatrix[a][by&31][bx&31];
			for(int y2=0;y2<((CLOUD_SIZE/4)>>a)-1;++y2){
				for(int x2=0;x2<((CLOUD_SIZE/4)>>a)-1;++x2){
					if(x+x2<CLOUD_SIZE)
						rawClouds[y+y2][x+x2]+=blend*kernel[y2*CLOUD_SIZE/4+x2];
					else 
						rawClouds[y+y2][x+x2-CLOUD_SIZE]+=blend*kernel[y2*CLOUD_SIZE/4+x2];
				}
			}
			by++;
		}
		bx=0;
		by=31;
		for(int x=0;x<CLOUD_SIZE-((CLOUD_SIZE/8)>>a);x+=(CLOUD_SIZE/8)>>a){
			y=CLOUD_SIZE-((CLOUD_SIZE/8)>>a);
			int blend=blendMatrix[a][by&31][bx&31];
			for(int y2=0;y2<((CLOUD_SIZE/4)>>a)-1;++y2){
				for(int x2=0;x2<((CLOUD_SIZE/4)>>a)-1;++x2){
					if(y+y2<CLOUD_SIZE)
						rawClouds[y+y2][x+x2]+=blend*kernel[y2*CLOUD_SIZE/4+x2];
					else 
						rawClouds[y+y2-CLOUD_SIZE][x+x2]+=blend*kernel[y2*CLOUD_SIZE/4+x2];
				}
			}
			bx++;
		}
	}
	unsigned char cloudThickness[CLOUD_SIZE*CLOUD_SIZE*4];

	int max=0;
	for(a=0;a<CLOUD_SIZE*CLOUD_SIZE;a++){
		cloudThickness[a*4+3]=alphaTransform[rawClouds[0][a]>>7];
	}

	//create the cloud shading
	int ydif[CLOUD_SIZE];
	for(a=0;a<CLOUD_SIZE;++a){
		ydif[a]=0;
		ydif[a]+=cloudThickness[(a+3*CLOUD_SIZE)*4+3];
		ydif[a]+=cloudThickness[(a+2*CLOUD_SIZE)*4+3];
		ydif[a]+=cloudThickness[(a+1*CLOUD_SIZE)*4+3];
		ydif[a]+=cloudThickness[(a+0*CLOUD_SIZE)*4+3];
		ydif[a]-=cloudThickness[(a-1*CLOUD_SIZE+CLOUD_SIZE*CLOUD_SIZE)*4+3];
		ydif[a]-=cloudThickness[(a-2*CLOUD_SIZE+CLOUD_SIZE*CLOUD_SIZE)*4+3];
		ydif[a]-=cloudThickness[(a-3*CLOUD_SIZE+CLOUD_SIZE*CLOUD_SIZE)*4+3];
	}

	a=0;
	ydif[(a)&255]+=cloudThickness[(a-3*CLOUD_SIZE+CLOUD_SIZE*CLOUD_SIZE)*4+3];
	ydif[(a)&255]-=cloudThickness[(a)*4+3]*2;
	ydif[(a)&255]+=cloudThickness[(a+4*CLOUD_SIZE)*4+3];

	for(a=0;a<CLOUD_SIZE*3-1;a++){
		ydif[(a+1)&255]+=cloudThickness[(a-3*CLOUD_SIZE+1+CLOUD_SIZE*CLOUD_SIZE)*4+3];
		ydif[(a+1)&255]-=cloudThickness[(a+1)*4+3]*2;
		ydif[(a+1)&255]+=cloudThickness[(a+4*CLOUD_SIZE+1)*4+3];

		int dif=0;

		dif+=ydif[(a)&255];
		dif+=ydif[(a+1)&255]>>1;
		dif+=ydif[(a-1)&255]>>1;
		dif+=ydif[(a+2)&255]>>2;
		dif+=ydif[(a-2)&255]>>2;
		dif/=16;

		cloudThickness[a*4+0]=128+dif;
		cloudThickness[a*4+1]=thicknessTransform[rawClouds[0][a]>>7];
		cloudThickness[a*4+2]=255;
	}

	for(a=CLOUD_SIZE*3-1;a<CLOUD_SIZE*CLOUD_SIZE-CLOUD_SIZE*4-1;a++){
		ydif[(a+1)&255]+=cloudThickness[(a-3*CLOUD_SIZE+1)*4+3];
		ydif[(a+1)&255]-=cloudThickness[(a+1)*4+3]*2;
		ydif[(a+1)&255]+=cloudThickness[(a+4*CLOUD_SIZE+1)*4+3];

		int dif=0;

		dif+=ydif[(a)&255];
		dif+=ydif[(a+1)&255]>>1;
		dif+=ydif[(a-1)&255]>>1;
		dif+=ydif[(a+2)&255]>>2;
		dif+=ydif[(a-2)&255]>>2;
		dif/=16;

		cloudThickness[a*4+0]=128+dif;
		cloudThickness[a*4+1]=thicknessTransform[rawClouds[0][a]>>7];
		cloudThickness[a*4+2]=255;
	}

	for(a=CLOUD_SIZE*CLOUD_SIZE-CLOUD_SIZE*4-1;a<CLOUD_SIZE*CLOUD_SIZE;a++){
		ydif[(a+1)&255]+=cloudThickness[(a-3*CLOUD_SIZE+1)*4+3];
		ydif[(a+1)&255]-=cloudThickness[(a+1)*4+3]*2;
		ydif[(a+1)&255]+=cloudThickness[(a+4*CLOUD_SIZE+1-CLOUD_SIZE*CLOUD_SIZE)*4+3];

		int dif=0;

		dif+=ydif[(a)&255];
		dif+=ydif[(a+1)&255]>>1;
		dif+=ydif[(a-1)&255]>>1;
		dif+=ydif[(a+2)&255]>>2;
		dif+=ydif[(a-2)&255]>>2;
		dif/=16;

		cloudThickness[a*4+0]=128+dif;
		cloudThickness[a*4+1]=thicknessTransform[rawClouds[0][a]>>7];
		cloudThickness[a*4+2]=255;
	}

	glBindTexture(GL_TEXTURE_2D, cloudDot3Tex);
	glTexSubImage2D(GL_TEXTURE_2D,0, 0,0,CLOUD_SIZE, CLOUD_SIZE,GL_RGBA, GL_UNSIGNED_BYTE, cloudThickness);
#ifdef PROFILE_TIME
	LARGE_INTEGER stop;
	QueryPerformanceCounter(&stop);
	profiler.AddTime("Drawing sky",stop.QuadPart - start.QuadPart);
#endif
}

void CSky::CreateRandMatrix(int matrix[32][32],float mod)
{
	for(int y=0;y<32;y++){
		for(int x=0;x<32;x++){
			matrix[y][x]=myrand()*255/RAND_MAX;
		}
	}
}

void CSky::CreateTransformVectors()
{
	for(int a=0;a<1024;++a){
		float f=(1023.0-(a+cloudDensity*1024-512))/1023.0;
		float alpha=pow(f*2,3);
		if(alpha>1)
			alpha=1;
		alphaTransform[a]=alpha*255;

		float d=f*2;
		if(d>1)
			d=1;
		thicknessTransform[a]=128+d*64+alphaTransform[a]*255/(4*255);
	}
}

void CSky::DrawSunFlare()
{
/*	float sunStrength=1;
	for(int y=-1;y<=1;++y)
		for(int x=-1;x<=1;++x){
			if(ground->LineGroundCol(camera.pos,camera.pos+float3(x*5,100+y*5,200)*60,true)>0){
				sunStrength-=(1.0f/9);
			}
			glBegin(GL_LINES);
				glVertexf3(float3(4000,20,4000));
				glVertexf3(float3(4000,20,4000)+float3(x*5,100+y*5,200)*60);
			glEnd();
		}
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA,GL_ONE);
	glBindTexture(GL_TEXTURE_2D, suntex);
	glEnable(GL_TEXTURE_2D);
	glDisable(GL_DEPTH_TEST);
	glPushMatrix();	
	glTranslatef(camera.pos.x,camera.pos.y,camera.pos.z);
	glColor4f(1,1,1,sunStrength);
	glBegin(GL_QUADS);
		glTexCoord2f(0,0);
		glVertex3f(-1,1.0,4);
	
		glTexCoord2f(1,0);
		glVertex3f(1,1.0,4);
	
		glTexCoord2f(1,1);
		glVertex3f(1,3.0,4);

		glTexCoord2f(0,1);
		glVertex3f(-1,3.0,4);
	glEnd();
	glPopMatrix();
*/}

void CSky::SetCloudShadow(int texunit)
{
}

void CSky::ResetCloudShadow(int texunit)
{
}

void CSky::DrawShafts()
{
}

