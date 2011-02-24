// ProjectileHandler.cpp: implementation of the CProjectileHandler class.
//
//////////////////////////////////////////////////////////////////////

#include "ProjectileHandler.h"
#define _WINSOCKAPI_   /* Prevent inclusion of winsock.h in windows.h */
#include <windows.h>		// Header File For Windows
#include "mygl.h"
#include <gl\glu.h>			// Header File For The GLu32 Library
#include <gl\glaux.h>		// Header File For The Glaux Library
#include "camera.h"
#include "vertexarray.h"
#include "irenderer.h"
#include "infoconsole.h"
#include "tapalette.h"
#include "3doparser.h"
#include "hpihandler.h"
#include "otareader.h"
#include "timeprofiler.h"
#include "globalstuff.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CProjectileHandler* ph;
extern GLfloat FogLand[]; 
extern GLfloat FogBlack[]; 

static const float PlasmaStartX=0.5/1024.0;
static const float PlasmaStartY=32.5/2048.0;
static const float PlasmaEndX=63.5/1024.0;
static const float PlasmaEndY=95.5/2048.0;
static const float PlasmaMidX=32/1024.0;
static const float PlasmaMidY=64/2048.0;

static const float LaserMidX=96/1024.0;

static const float LightingStartX=0.0/1024.0;
static const float LightingStartY=0.5/2048.0;
static const float LightingEndX=64/1024.0;
static const float LightingEndY=31.5/2048.0;

CProjectileHandler::CProjectileHandler()
{
	PrintLoadMsg("Mapping weapons");

	texturehandler->GetTexture(" ",0);	
	CreateProjDefs();
}

CProjectileHandler::~CProjectileHandler()
{
//	glDeleteTextures (1, CProjectile::textures);
	ph=0;
}

CProjectileHandler::Update()
{
}

struct ProjDist{
	float dist;
	int type;
	int num;
};


int CompareProjDist( const void *arg1, const void *arg2 ){
	if(((ProjDist*)arg1)->dist > ((ProjDist*)arg2)->dist)
	   return -1;
   return 1;
}

static bool blendAdd;
static bool inArray;
static CVertexArray* va;

CProjectileHandler::Draw()
{
#ifdef PROFILE_TIME
	LARGE_INTEGER start;
	QueryPerformanceCounter(&start);
#endif
	int a;
	glEnable(GL_TEXTURE_2D);
	glDisable(GL_BLEND);

	static Plasma plasma[300];
	static Laser laser[300];
	static Laser lighting[300];
	static Explo explosion[300];
	static Smoke smoke[1000];
	static ProjDist transProj[2200];

	int numPlasma=0;
	int numLaser=0;
	int numLighting=0;
	int numExplosions=0;
	int numSmoke=0;
	int numTransProj=0;

	for(a=0;a<g.shared->numSmoke;++a){
		SmokeParticle* s=&g.shared->smoke[a];
		float3 pos(s->subs[0].pos.x*(1/65536.0f),s->subs[0].pos.z*(1/65536.0f),s->subs[0].pos.y*(1/65536.0f));
		if(camera.InView(pos,10)){
			transProj[numTransProj].num=numSmoke;
			transProj[numTransProj].type=0;
			transProj[numTransProj].dist=pos.dot(camera.forward);
			numTransProj++;

			smoke[numSmoke].name=s->name;
			smoke[numSmoke].numSubs=s->numSub;
			smoke[numSmoke].frame[0]=s->subs[0].frame;
			smoke[numSmoke].pos[0]=pos;
			for(int b=1;b<s->numSub;++b){
				smoke[numSmoke].frame[b]=s->subs[b].frame;
				smoke[numSmoke].pos[b]=float3(s->subs[b].pos.x*(1/65536.0f),s->subs[b].pos.z*(1/65536.0f),s->subs[b].pos.y*(1/65536.0f));
			}
			numSmoke++;
		}
	}
	texturehandler->SetTexture();

	glEnable(GL_LIGHTING);
	glEnable(GL_COLOR_MATERIAL);
	glDisable(GL_ALPHA_TEST);
	glColor4f(1,1,1,1);
	for(a=0;a<g.shared->numProjectiles;++a){
		Projectile* p=&g.shared->projectiles[a];
		float3 pos(p->pos.x*(1/65536.0f),p->pos.z*(1/65536.0f),p->pos.y*(1/65536.0f));
		float size;
		if(projDefs[p->type].type==0 || projDefs[p->type].type==7)
			size=70;
		else
			size=10;

		if(camera.InView(pos,size)){
			switch(projDefs[p->type].type){
			case 0:
				transProj[numTransProj].num=numLaser;
				transProj[numTransProj].type=1;
				transProj[numTransProj].dist=pos.dot(camera.forward);
				numTransProj++;

				laser[numLaser].pos=pos;
				laser[numLaser].pos2=float3(p->pos2.x*(1/65536.0f),p->pos2.z*(1/65536.0f),p->pos2.y*(1/65536.0f));
				laser[numLaser].color=projDefs[p->type].color;
				numLaser++;

				break;
			case 7:
				transProj[numTransProj].num=numLighting;
				transProj[numTransProj].type=2;
				transProj[numTransProj].dist=pos.dot(camera.forward);
				numTransProj++;

				lighting[numLighting].pos=pos;
				lighting[numLighting].pos2=float3(p->pos2.x*(1/65536.0f),p->pos2.z*(1/65536.0f),p->pos2.y*(1/65536.0f));
				lighting[numLighting].color=projDefs[p->type].color;
				numLighting++;
				break;
			case 1:
			case 6:
			case 3:{
				float3 rot(p->turn.x*(360/65536.0f),p->turn.y*(360/65536.0f),p->turn.z*(360/65536.0f));
				Draw3do(pos,rot,projDefs[p->type].model);
				break;
				}
			case 4:
			case 5:
				transProj[numTransProj].num=numPlasma;
				transProj[numTransProj].type=3;
				transProj[numTransProj].dist=pos.dot(camera.forward);
				numTransProj++;

				plasma[numPlasma].pos=pos;
				if(projDefs[p->type].type==4)
					plasma[numPlasma].size=3;
				else
					plasma[numPlasma].size=9;
				numPlasma++;
				break;
			default:
				(*info) << "Unknown render type " << projDefs[p->type].type << "for projectile type" << p->type <<"\n";
				break;
			}
		}
	}

	glDisable(GL_LIGHTING);
	glDisable(GL_COLOR_MATERIAL);
//	glDisable(GL_TEXTURE_2D);
	for(a=0;a<g.shared->numExplosions;++a){
		Explosion *e=&g.shared->explosions[a];
		float3 pos(e->pos.x*(1/65536.0f),e->pos.z*(1/65536.0f),e->pos.y*(1/65536.0f));
		if(camera.InView(pos,20) && e->name[0]!=0){
			if(e->isDebris){
				taTexture* tex=texturehandler->GetTexture("wreck001c",0);
				float3 v1(e->vertices[0].x*(1/65536.0f),e->vertices[0].z*(1/65536.0f),e->vertices[0].y*(1/65536.0f));
				float3 v2(e->vertices[1].x*(1/65536.0f),e->vertices[1].z*(1/65536.0f),e->vertices[1].y*(1/65536.0f));
				float3 v3(e->vertices[2].x*(1/65536.0f),e->vertices[2].z*(1/65536.0f),e->vertices[2].y*(1/65536.0f));
				float3 v4(e->vertices[3].x*(1/65536.0f),e->vertices[3].z*(1/65536.0f),e->vertices[3].y*(1/65536.0f));

				glPushMatrix();
				glTranslatef3(pos);
				if(e->turn.x!=0)
					glRotatef(e->turn.x*(360.0f*(1/65536.0f)),0,1,0);
				if(e->turn.y!=0)
					glRotatef(e->turn.y*(360.0f*(1/65536.0f)),-1,0,0);
				if(e->turn.z!=0)
					glRotatef(e->turn.z*(360.0f*(1/65536.0f)),0,0,1);
				
				glBegin(GL_QUADS);
				glTexCoord2f(tex->xstart,tex->ystart);
				glVertexf3(v1);
				glTexCoord2f(tex->xend,tex->ystart);
				glVertexf3(v2);
				glTexCoord2f(tex->xend,tex->yend);
				glVertexf3(v3);
				glTexCoord2f(tex->xstart,tex->yend);
				glVertexf3(v4);
				glEnd();
				glPopMatrix();
			} else {
				transProj[numTransProj].num=numExplosions;
				transProj[numTransProj].type=4;
				transProj[numTransProj].dist=pos.dot(camera.forward);
				numTransProj++;

				explosion[numExplosions].pos=pos;
				explosion[numExplosions].name=e->name;
				explosion[numExplosions].frame=e->frame;
				numExplosions++;
			}
		}
	}

	qsort(transProj,numTransProj,sizeof(ProjDist),CompareProjDist);

//	(*info) << g.shared->numSmoke << " "<< g.shared->smoke[0].numSub <<"\n";

	glEnable(GL_TEXTURE_2D);
	glBlendFunc(GL_SRC_ALPHA,GL_ONE);
	glEnable(GL_BLEND);
	glDepthMask(0);
	glFogfv(GL_FOG_COLOR,FogBlack);
	glAlphaFunc(GL_GREATER,0.01f);
	glEnable(GL_ALPHA_TEST);

	va=GetVertexArray();
	va->Initialize();
	inArray=false;
	blendAdd=true;
	for(a=0;a<numTransProj;++a){
		switch(transProj[a].type){
		case 0:
			DrawSmoke(&smoke[transProj[a].num]);
			break;
		case 1:
			DrawLaser(&laser[transProj[a].num]);
			break;
		case 2:
			DrawLighting(&lighting[transProj[a].num]);
			break;
		case 3:
			DrawPlasma(&plasma[transProj[a].num]);
			break;
		case 4:
			DrawExplosion(&explosion[transProj[a].num]);
			break;
		}
	}

	if(inArray)
		va->DrawArrayTC(GL_QUADS);

	glDisable(GL_TEXTURE_2D);
	glDisable(GL_ALPHA_TEST);
	glDepthMask(1);
	glFogfv(GL_FOG_COLOR,FogLand);

#ifdef PROFILE_TIME
	LARGE_INTEGER stop;
	QueryPerformanceCounter(&stop);
	profiler.AddTime("Drawing extras",stop.QuadPart - start.QuadPart);
#endif
}

static unsigned char col[4];

void CProjectileHandler::DrawLaser(Laser *l)
{
	if(!blendAdd){
		if(inArray)
			DrawArray();
		glBlendFunc(GL_SRC_ALPHA, GL_ONE);
		glFogfv(GL_FOG_COLOR,FogBlack);
		blendAdd=true;
	}

	inArray=true;
	
	col[0]=l->color.x*255;
	col[1]=l->color.y*255;
	col[2]=l->color.z*255;
	col[3]=0.6*255;

	float3 dir=l->pos-l->pos2;
	float fromdist=l->pos2.distance(camera.pos);
	float todist=l->pos.distance(camera.pos);
	float frompart=fromdist/(fromdist+todist);
	float3 closecam=l->pos2+dir*frompart;
	dir.Normalize();
	float3 camdir=closecam-camera.pos;
	camdir.Normalize();
	float3 bcd=dir.cross(camdir);
	bcd.Normalize();
	bcd=bcd*2;

	va->AddVertexTC(l->pos2+bcd,LaserMidX,PlasmaStartY,col);
	va->AddVertexTC(l->pos2-bcd,LaserMidX,PlasmaEndY  ,col);
	va->AddVertexTC(l->pos -bcd,LaserMidX,PlasmaEndY  ,col);
	va->AddVertexTC(l->pos +bcd,LaserMidX,PlasmaStartY,col);
}

void CProjectileHandler::DrawLighting(Laser *l)
{
	if(!blendAdd){
		if(inArray)
			DrawArray();
		glBlendFunc(GL_SRC_ALPHA, GL_ONE);
		glFogfv(GL_FOG_COLOR,FogBlack);
		blendAdd=true;
	}

	inArray=true;

	col[0]=l->color.x*255;
	col[1]=l->color.y*255;
	col[2]=l->color.z*255;
	col[3]=0.6f*255;

	float3 dir=l->pos-l->pos2;
	float fromdist=l->pos2.distance(camera.pos);
	float todist=l->pos.distance(camera.pos);
	float frompart=fromdist/(fromdist+todist);
	float3 closecam=l->pos2+dir*frompart;
	dir.Normalize();
	float3 camdir=closecam-camera.pos;
	camdir.Normalize();
	float3 bcd=dir.cross(camdir);
	bcd.Normalize();
	bcd=bcd*4;
	float length=l->pos.distance(l->pos2);

	va->AddVertexTC(l->pos2+bcd,0,LightingStartY,col);
	va->AddVertexTC(l->pos2-bcd,0,LightingEndY  ,col);
	va->AddVertexTC(l->pos -bcd,length*LightingEndX*0.025,LightingEndY  ,col);
	va->AddVertexTC(l->pos +bcd,length*LightingEndX*0.025,LightingStartY,col);
}

void CProjectileHandler::DrawPlasma(Plasma *p)
{
	if(!blendAdd){
		if(inArray)
			DrawArray();
		glBlendFunc(GL_SRC_ALPHA, GL_ONE);
		glFogfv(GL_FOG_COLOR,FogBlack);
		blendAdd=true;
	}

	inArray=true;

	col[0]=1*255;
	col[1]=0.5*255;
	col[2]=0*255;
	col[3]=0.6*255;

	va->AddVertexTC(p->pos-camera.right*p->size-camera.up*p->size,PlasmaStartX,PlasmaStartY,col);
	va->AddVertexTC(p->pos+camera.right*p->size-camera.up*p->size,PlasmaEndX  ,PlasmaStartY,col);
	va->AddVertexTC(p->pos+camera.right*p->size+camera.up*p->size,PlasmaEndX  ,PlasmaEndY  ,col);
	va->AddVertexTC(p->pos-camera.right*p->size+camera.up*p->size,PlasmaStartX,PlasmaEndY  ,col);
}

void CProjectileHandler::DrawExplosion(Explo *e)
{
	if(!blendAdd){
		if(inArray)
			DrawArray();
		glBlendFunc(GL_SRC_ALPHA, GL_ONE);
		glFogfv(GL_FOG_COLOR,FogBlack);
		blendAdd=true;
	}

	col[0]=255;
	col[1]=255;
	col[2]=255;
	col[3]=0.6*255;

	taTexture* tex=texturehandler->GetTexture(e->name,e->frame);
	
	if(texturehandler->bigTexFound){
		if(inArray)
			DrawArray();
		
		texturehandler->SetBigTex();
		float xsize=texturehandler->bigTexX>>1;
		float ysize=texturehandler->bigTexY>>1;
		e->pos.y+=15;
		glColor4f(1,1,1,0.6f);
		glBegin(GL_QUADS);
		glTexCoord2f(0,1);
		glVertexf3(e->pos-camera.right*xsize-camera.up*ysize);
		glTexCoord2f(1,1);
		glVertexf3(e->pos+camera.right*xsize-camera.up*ysize);
		glTexCoord2f(1,0);
		glVertexf3(e->pos+camera.right*xsize+camera.up*ysize);
		glTexCoord2f(0,0);
		glVertexf3(e->pos-camera.right*xsize+camera.up*ysize);
		glEnd();
		texturehandler->SetTexture();
		return;
	}

	inArray=true;

	float xsize=(tex->xend-tex->xstart)*512.0;
	float ysize=(tex->yend-tex->ystart)*1024.0;
	va->AddVertexTC(e->pos-camera.right*xsize-camera.up*ysize,tex->xstart,tex->ystart,col);
	va->AddVertexTC(e->pos+camera.right*xsize-camera.up*ysize,tex->xend,tex->ystart,col);
	va->AddVertexTC(e->pos+camera.right*xsize+camera.up*ysize,tex->xend,tex->yend,col);
	va->AddVertexTC(e->pos-camera.right*xsize+camera.up*ysize,tex->xstart,tex->yend,col);
}

void CProjectileHandler::DrawSmoke(Smoke* s)
{
	if(blendAdd){
		if(inArray)
			DrawArray();
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		glFogfv(GL_FOG_COLOR,FogLand);
		blendAdd=false;
	}

	inArray=true;

	col[0]=180;
	col[1]=180;
	col[2]=180;
	col[3]=0.5*255;

	for(int a=0;a<s->numSubs;++a){
		taTexture* tex=texturehandler->GetTexture(s->name,s->frame[a]);
		
		float xsize=(tex->xend-tex->xstart)*512.0;
		float ysize=(tex->yend-tex->ystart)*1024.0;
		va->AddVertexTC(s->pos[a]-camera.right*xsize-camera.up*ysize,tex->xstart,tex->ystart,col);
		va->AddVertexTC(s->pos[a]+camera.right*xsize-camera.up*ysize,tex->xend,tex->ystart,col);
		va->AddVertexTC(s->pos[a]+camera.right*xsize+camera.up*ysize,tex->xend,tex->yend,col);
		va->AddVertexTC(s->pos[a]-camera.right*xsize+camera.up*ysize,tex->xstart,tex->yend,col);
	}
}

void CProjectileHandler::Draw3do(const float3 &pos, const float3 &rot, const S3DO *model)
{
	glPushMatrix();
	glTranslatef3(pos);
	if(rot.x!=0)
		glRotatef(rot.x,0,1,0);
	if(rot.z!=0)
		glRotatef(rot.z,1,0,0);
//	if(rot.y!=0)
//		glRotatef(rot.y,0,0,1);
//	S3DO* model=unitparser->Load3DO((string("objects3d\\")+name+".3do").c_str(),1,0);
	glCallList(model->displist);
	if(model->childs.size()>0){
		glTranslatef3(model->childs[0].offset);
		glCallList(model->childs[0].displist);
	}
	glPopMatrix();
}

void CProjectileHandler::CreateProjDefs()
{
	map<string,CHpiHandler::FileData>::iterator fi;

	for(fi=hpiHandler->files.begin();fi!=hpiHandler->files.end();++fi){
		if(fi->first.find("weapons\\")!=string::npos && fi->first.find(".tdf")!=string::npos){
			SearchWeaponFile(fi->first);
		}
	}

	if(!g.sharedShared)
		return;

	for(int a=0;a<256;++a){
		if(weapon2file.find(g.shared->weapons[a].name)==weapon2file.end()){
			projDefs[a].type=4;
			if(g.shared->weapons[a].name[0]!=0)
				(*info) << "Couldnt find weapon " << g.shared->weapons[a].name << "\n";
			continue;
		}
		int size=hpiHandler->GetFileSize(weapon2file[g.shared->weapons[a].name]);
		unsigned char* fileBuf=new unsigned char[size+1];
		fileBuf[size]=0;
		hpiHandler->LoadFile(weapon2file[g.shared->weapons[a].name],fileBuf);

		char res[50];
		string s(g.shared->weapons[a].name);
		getOTAValue((char*)fileBuf,(s+".rendertype").c_str(),res);
		projDefs[a].type=atoi(res);

		switch(projDefs[a].type){
		case 0:
		case 7:{
			getOTAValue((char*)fileBuf,(s+".color").c_str(),res);
			float hue=atof(res)/255.0;
			getOTAValue((char*)fileBuf,(s+".color2").c_str(),res);
			float sat=atof(res)/255.0;
			float3 c=hs2rgb(hue,sat);
//			(*info) << c.x << " " << c.z << " " << c.y << "\n";
			projDefs[a].color=c;
			break;}
		case 1:
		case 6:
		case 3:
			getOTAValue((char*)fileBuf,(s+".model").c_str(),res);
			projDefs[a].model=unitparser->Load3DO((string("objects3d\\")+res+".3do").c_str(),1,0);
			break;
		}
		delete[] fileBuf;
	}
}

void CProjectileHandler::SearchWeaponFile(string name)
{
	int size=hpiHandler->GetFileSize(name.c_str());
	unsigned char* fileBuf=new unsigned char[size];
	hpiHandler->LoadFile(name.c_str(),fileBuf);

	int pos=0;
	string keyName;

	while(pos<size){
		if(fileBuf[pos]=='['){
			keyName="";
			while(fileBuf[++pos]!=']')
				keyName+=fileBuf[pos];
			weapon2file[keyName]=name;
			pos++;
		}
		pos++;
	}

	delete[] fileBuf;
}

float3 CProjectileHandler::hs2rgb(float h, float s)
{
	if(h>0.5)
		h+=0.1f;
	if(h>1)
		h-=1;

	s=1;
	float invSat=1-s;
	float3 col(invSat/2,invSat/2,invSat/2);

	if(h<1/6.0){
		col.x+=s;
		col.y+=s*(h*6);
	} else if(h<1/3.0){
		col.y+=s;
		col.x+=s*((1/3.0-h)*6);

	} else if(h<1/2.0){
		col.y+=s;
		col.z+=s*((h-1/3.0)*6);

	} else if(h<2/3.0){
		col.z+=s;
		col.y+=s*((2/3.0-h)*6);

	} else if(h<5/6.0){
		col.z+=s;
		col.x+=s*((h-2/3.0)*6);

	} else {
		col.x+=s;
		col.z+=s*((3/3.0-h)*6);
	}
	return col;
}



void CProjectileHandler::DrawArray()
{
	va->DrawArrayTC(GL_QUADS);
	va=GetVertexArray();
	va->Initialize();
	inArray=false;
}
