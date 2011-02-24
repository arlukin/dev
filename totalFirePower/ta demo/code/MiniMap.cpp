// MiniMap.cpp: implementation of the CMiniMap class.
//
//////////////////////////////////////////////////////////////////////

#pragma warning(disable:4786)

#include "MiniMap.h"
#include "mygl.h"
#include "GL\glu.h"
#include "globalstuff.h"
#include "infoconsole.h"
#include "irenderer.h"
#include "tapalette.h"
#include "reghandler.h"
#include "timeprofiler.h"
#include "camera.h"
#include "readmap.h"
#include "vertexarray.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CMiniMap* minimap;

CMiniMap::CMiniMap()
: xpos(10),
	ypos(g.screeny-210),
	height(200),
	width(200)
{
	show=!!regHandler.GetInt("DrawMap",1);
	//(*info)<<g.shared->RadarpicX<<g.shared->RadarpicX<<"\n";
	int maxSize=g.mapx;
	if(g.mapy>maxSize)
		maxSize=g.mapy;
	width=(150*g.mapx)/maxSize;
	height=(150*g.mapy)/maxSize;
	ypos=g.screeny-height-10;

	unsigned char tex[16][16][4];
	for(int y=0;y<16;++y){
		float dy=y-7.5;
		for(int x=0;x<16;++x){
			float dx=x-7.5;
			float dist=sqrt(dx*dx+dy*dy);
			if(dist<6 || dist>9){
				tex[y][x][0]=255;
				tex[y][x][1]=255;
				tex[y][x][2]=255;
			} else {
				tex[y][x][0]=0;
				tex[y][x][1]=0;
				tex[y][x][2]=0;
			}
			if(dist<7){
				tex[y][x][3]=255;
			} else {
				tex[y][x][3]=0;
			}
		}
	}
	glGenTextures(1, &unitBlip);
	glBindTexture(GL_TEXTURE_2D, unitBlip);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_NEAREST);
	gluBuild2DMipmaps(GL_TEXTURE_2D,4 ,16, 16, GL_RGBA, GL_UNSIGNED_BYTE, tex);
}

CMiniMap::~CMiniMap()
{
}

void CMiniMap::Draw()
{
	for(int a=0;a<500;++a){
		if(g.shared->Markers[a].IsNew){
			EhaMarker m;
			m.time=g.frameNum;
			m.x=g.shared->Markers[a].x;
			m.y=g.shared->Markers[a].y;
			markers.push_back(m);
			g.shared->Markers[a].IsNew=false;
		} else {
			break;
		}
	}
	while(!markers.empty() && markers.front().time<g.frameNum-100){
		markers.pop_front();
	}
	if(!show)
		return;
#ifdef PROFILE_TIME
	LARGE_INTEGER start;
	QueryPerformanceCounter(&start);
#endif

	glViewport(xpos,ypos,width,height);
	glLoadIdentity();									// Reset The Current Modelview Matrix
	glMatrixMode(GL_PROJECTION);						// Select The Projection Matrix
	glLoadIdentity();									// Reset The Projection Matrix
	gluOrtho2D(0,1,0,1);
	glMatrixMode(GL_MODELVIEW);							// Select The Modelview Matrix

	glColor4f(1,1,1,1);
	glEnable(GL_TEXTURE_2D);
	glDisable(GL_BLEND);
	glDisable(GL_ALPHA_TEST);
	glBindTexture(GL_TEXTURE_2D, readmap->bigtex);
	glBegin(GL_QUADS);
	glTexCoord2f(0,1);
	glVertex2f(0,0);
	glTexCoord2f(0,0);
	glVertex2f(0,1);
	glTexCoord2f(1,0);
	glVertex2f(1,1);
	glTexCoord2f(1,1);
	glVertex2f(1,0);
	glEnd();

	float XscaleFactor2=1.0/(g.mapx*SQUARE_SIZE);
	float YscaleFactor2=1.0/(g.mapy*SQUARE_SIZE);

	std::deque<EhaMarker>::iterator mi;
	glColor3f(1,0,0);
	for(mi=markers.begin();mi!=markers.end();++mi){
		float size=(mi->time-g.frameNum+100)*10;
		if(size<32)
			size=32;
		float x=mi->x*XscaleFactor2;
		float y=1-mi->y*YscaleFactor2;
		size*=XscaleFactor2;
		glBegin(GL_LINE_STRIP);
			glVertex2f(x+size,y+size);
			glVertex2f(x-size,y+size);
			glVertex2f(x-size,y-size);
			glVertex2f(x+size,y-size);
			glVertex2f(x+size,y+size);
		glEnd();
	}

	glEnable(GL_BLEND);
	glBindTexture(GL_TEXTURE_2D, unitBlip);
	static unsigned char c2p[]={227,212,80,235,108,219,208,93,130,67};
	float size=0.2f/sqrt(width+height);
	float XscaleFactor=1/(65536.0)/(g.mapx*SQUARE_SIZE);
	float YscaleFactor=1/(65536.0)/(g.mapy*SQUARE_SIZE);
	for(int p=0;p<g.shared->numPlayers;++p){
		CVertexArray* va=GetVertexArray();
		va->Initialize();
		int maxUsed=p * g.shared->maxUnits + g.shared->players[p].maxUsedUnit;
		glColor3ubv(palette[c2p[g.shared->players[p].color]]);
		for(int u=p*g.shared->maxUnits;u<maxUsed;++u){
			if(g.shared->units[u].active && g.shared->units[u].name[0]!=0 && (!(g.shared->units[u].RecentDamage&16))){
				Unit* curUnit=&g.shared->units[u];

				float x=(float)curUnit->pos.x*XscaleFactor;
				float y=1-(float)curUnit->pos.y*YscaleFactor;

				va->AddVertex2DT(x-size,y-size,0,0);
				va->AddVertex2DT(x-size,y+size,0,1);
				va->AddVertex2DT(x+size,y+size,1,1);
				va->AddVertex2DT(x+size,y-size,1,0);
			}
		}
		va->DrawArray2DT(GL_QUADS);
	}

	glDisable(GL_TEXTURE_2D);

	left.clear();
	
	//Add restraints for camera sides
	GetFrustumSide(camera.rightside);
	GetFrustumSide(camera.leftside);
	GetFrustumSide(camera.bottom);
	GetFrustumSide(camera.top);
	float3 forward=camera.forward;
	forward.y=0;
	forward.Normalize();
	camera.pos+=forward*g.viewRange*0.9f;
	GetFrustumSide(forward);
	camera.pos-=forward*g.viewRange*0.9f;

	if(left.size()==5){
		float v1=left[3].base*camera.forward.x;
		float v2=left[4].base*camera.forward.x;
		if(v1>v2 || forward.dot(camera.top)<0)
			left[3]=left[4];

		left.pop_back();
	}

	std::vector<fline>::iterator fli,fli2;
  for(fli=left.begin();fli!=left.end();fli++){
	  for(fli2=left.begin();fli2!=left.end();fli2++){
			if(fli==fli2)
				continue;
			float colz=-(fli->base-fli2->base)/(fli->dir-fli2->dir);
			if(fli2->left*(fli->dir-fli2->dir)>0){
				if(colz>fli->minz && colz<40096)
					fli->minz=colz;
			} else {
				if(colz<fli->maxz && colz>-10000)
					fli->maxz=colz;
			}
		}
	}
	glColor4f(1,1,1,0.5);
  glBegin(GL_LINES);
  for(fli=left.begin();fli!=left.end();fli++){
		if(fli->minz<fli->maxz){
			DrawInMap(float3(fli->base+fli->dir*fli->minz,0,fli->minz));
			DrawInMap(float3(fli->base+fli->dir*fli->maxz,0,fli->maxz));
		}
	}
	glEnd();

	glBegin(GL_POINTS);
	glColor4f(1,1,1,1/*0.0002f*(width+height)*/);
	for(a=0;a<g.shared->numProjectiles;++a){
		Projectile* p=&g.shared->projectiles[a];
		float x=(float)p->pos.x*XscaleFactor;
		float y=1-(float)p->pos.y*YscaleFactor;
		glVertex2f(x,y);
	}

	glColor4f(1,0.3f,0.3f,1/*0.0002f*(width+height)*/);
	for(a=0;a<g.shared->numExplosions;++a){
		Explosion *e=&g.shared->explosions[a];
		float x=(float)e->pos.x*XscaleFactor;
		float y=1-(float)e->pos.y*YscaleFactor;
		glVertex2f(x,y);
	}

	glColor4f(0.3f,0.3f,0.3f,1/*0.0002f*(width+height)*/);
	for(a=0;a<g.shared->numSmoke;++a){
		SmokeParticle* s=&g.shared->smoke[a];
		float x=(float)s->subs[0].pos.x*XscaleFactor;
		float y=1-(float)s->subs[0].pos.y*YscaleFactor;
		glVertex2f(x,y);
	}

	glEnd();

	glViewport(0,0,g.screenx,g.screeny);
#ifdef PROFILE_TIME
	LARGE_INTEGER stop;
	QueryPerformanceCounter(&stop);
	profiler.AddTime("Minimap",stop.QuadPart - start.QuadPart);
#endif
}

void CMiniMap::DrawInMap(float3 &pos)
{
	glVertex2f(pos.x/(g.mapx*SQUARE_SIZE),1-pos.z/(g.mapy*SQUARE_SIZE));
}

void CMiniMap::GetFrustumSide(float3& side)
{
	fline temp;
	float3 up(0,1,0);
	
	float3 b=up.cross(side);		//get vector for collision between frustum and horizontal plane
	if(fabs(b.z)<0.0001)
		b.z=0.00011f;
	if(fabs(b.z)>0.0001){
		temp.dir=b.x/b.z;				//set direction to that
		float3 c=b.cross(side);			//get vector from camera to collision line
		float3 colpoint;				//a point on the collision line
		
		if(side.y>0)								
			colpoint=camera.pos-c*((camera.pos.y)/c.y);
		else
			colpoint=camera.pos-c*((camera.pos.y)/c.y);
		
		
		temp.base=colpoint.x-colpoint.z*temp.dir;	//get intersection between colpoint and z axis
		temp.left=-1;
		if(b.z>0)
			temp.left=1;
		temp.maxz=g.mapy*SQUARE_SIZE;
		temp.minz=0;
		left.push_back(temp);			
	}	

}

