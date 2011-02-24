// Ground.cpp: implementation of the CGround class.
//
//////////////////////////////////////////////////////////////////////
#pragma warning(disable:4786)

#include "Ground.h"
#include "readmap.h"
#include "camera.h"
#include "projectileHandler.h"
#include "readmap.h"
#include "infoconsole.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////
CGround* ground;
static unsigned int hustex;
static unsigned int rooftex;

CGround::CGround()
{
	CReadMap::Instance();
}

CGround::~CGround()
{
	delete readmap;
//	delete[] gstable;
//	delete[] gs;
}

float CGround::LineGroundCol(const float3 &from, const float3 &to,bool checkTrees)
{
	this->checkTrees=checkTrees;
	beamdir=to-from;
	beamdir.Normalize();
	double dx=to.x-from.x;
	double dz=to.z-from.z;
	double xp=from.x;
	double zp=from.z;
	double ret;
	double xn,zn;

	if((floor(from.x/SQUARE_SIZE)==floor(to.x/SQUARE_SIZE)) && (floor(from.z/SQUARE_SIZE)==floor(to.z/SQUARE_SIZE))){
		ret = LineGroundSquareCol(from,to,(int)floor(from.x/SQUARE_SIZE),(int)floor(from.z/SQUARE_SIZE));
		if(ret>=0)
			return ret;
	} else if(floor(from.x/SQUARE_SIZE)==floor(to.x/SQUARE_SIZE)){
		bool keepgoing=true;
		while(keepgoing){
			ret = LineGroundSquareCol(from,to,(int)floor(xp/SQUARE_SIZE),(int)floor(zp/SQUARE_SIZE));	
			if(ret>=0)
				return ret;
			keepgoing=fabs(zp-from.z)<fabs(to.z-from.z);
			if(dz>0)
				zp+=SQUARE_SIZE;
			else 
				zp-=SQUARE_SIZE;
		}
	} else if(floor(from.z/SQUARE_SIZE)==floor(to.z/SQUARE_SIZE)){
		bool keepgoing=true;
		while(keepgoing){
			ret = LineGroundSquareCol(from,to,(int)floor(xp/SQUARE_SIZE),(int)floor(zp/SQUARE_SIZE));	
			if(ret>=0)
				return ret;
			keepgoing=fabs(xp-from.x)<fabs(to.x-from.x);
			if(dx>0)
				xp+=SQUARE_SIZE;
			else 
				xp-=SQUARE_SIZE;
		}
	} else {
		bool keepgoing=true;
		while(keepgoing){
		ret = LineGroundSquareCol(from,to,(int)floor(xp/SQUARE_SIZE),(int)floor(zp/SQUARE_SIZE));	
		if(ret>=0)
			return ret;
		keepgoing=fabs(xp-from.x)<fabs(to.x-from.x) && fabs(zp-from.z)<fabs(to.z-from.z);

		if(dx>0){
			xn=(floor(xp/SQUARE_SIZE)*SQUARE_SIZE+SQUARE_SIZE-xp)/dx;
		} else {
			xn=(floor(xp/SQUARE_SIZE)*SQUARE_SIZE-xp)/dx;
		}
		if(dz>0){
			zn=(floor(zp/SQUARE_SIZE)*SQUARE_SIZE+SQUARE_SIZE-zp)/dz;
		} else {
			zn=(floor(zp/SQUARE_SIZE)*SQUARE_SIZE-zp)/dz;
		}
		
		if(xn<zn){
			xp+=(xn+0.00001)*dx;
			zp+=(xn+0.00001)*dz;
		} else {
			xp+=(zn+0.00001)*dx;
			zp+=(zn+0.00001)*dz;
		}
	}
	}
	return -1;
}	

float CGround::LineGroundSquareCol(const float3 &from,const float3 &to,int xs,int ys)
{
	if((xs<0) || (ys<0) || (xs>g.mapx-1) || (ys>g.mapy-1))
		return -1;
	float3 dir=to-from;
	float3 tri;
	//triangel 1
	tri.x=xs*SQUARE_SIZE;
	tri.z=ys*SQUARE_SIZE;
	tri.y=readmap->map[ys*g.mapx+xs];

	float3 norm=readmap->facenormals[(ys*(g.mapx-1)+xs)*2];
	double side1=(from-tri).dot(norm);			//ska alltid bli positiv (om ovan marken)
	double side2=(to-tri).dot(norm);

	if(side2<=0){				//linjen passerar triangelns plan?
		double frontpart=side1/(side1-side2);
		float3 col=from+(dir*frontpart);

		if((col.x>=tri.x) && (col.z>=tri.z) && (col.x+col.z<=tri.x+tri.z+SQUARE_SIZE)){	//kollision inuti triangeln (utntri.ytja trianglarnas "2d aktighet")
			return col.distance(from);
		}
	}
	//triangel 2
	tri.x=(xs+1)*SQUARE_SIZE;
	tri.z=(ys+1)*SQUARE_SIZE;
	tri.y=readmap->map[(ys+1)*g.mapx+xs+1];

	norm=readmap->facenormals[(ys*(g.mapx-1)+xs)*2+1];
	side1=(from-tri).dot(norm);
	side2=(to-tri).dot(norm);

	if(side2<=0){				//linjen passerar triangelns plan?
		double frontpart=side1/(side1-side2);
		float3 col=from+(dir*frontpart);

		if((col.x<=tri.x) && (col.z<=tri.z) && (col.x+col.z>=tri.x+tri.z-SQUARE_SIZE)){	//kollision inuti triangeln (utntri.ytja trianglarnas "2d aktighet")
			return col.distance(from);
		}
	}
	if(checkTrees){
		float r=CheckTreeCol(from,to,xs,ys);
		if(r>0 && r<from.distance(to))
			return r;
	}
	return -2;
}

float CGround::GetHeight(float x, float y)
{
	float a=LineGroundSquareCol(float3(x,1000,y),float3(x,0,y),x/SQUARE_SIZE,y/SQUARE_SIZE);
	if(a>0)
		return 1000-a;
	else 
		return 0;
}

float3& CGround::GetNormal(float x, float y)
{
	if((x<0) || (y<0) || (x>(g.mapx-1)*SQUARE_SIZE) || (y>(g.mapy-1)*SQUARE_SIZE))
		return readmap->facenormals[2000];
	return readmap->facenormals[(int(x)/SQUARE_SIZE+int(y)/SQUARE_SIZE*(g.mapx-1))*2];
}

float CGround::GetApproximateHeight(float x, float y)
{
	if((x<0) || (y<0) || (x>511*SQUARE_SIZE) || (y>511*SQUARE_SIZE))
		return 0;
	return readmap->map[int(x)/SQUARE_SIZE+int(y)/SQUARE_SIZE*g.mapx];
}

float CGround::GetSlope(float x, float y)
{
	return 1-readmap->facenormals[(int(x)/SQUARE_SIZE+int(y)/SQUARE_SIZE*g.mapx)*2].y;
	int sx=floor(x/SQUARE_SIZE);
	int sy=floor(y/SQUARE_SIZE);
	float slope=0;
	float h1=readmap->map[sy*g.mapx+sx];
	float h2=readmap->map[(sy+1)*g.mapx+sx];
	float h3=readmap->map[(sy+1)*g.mapx+sx+1];
	float h4=readmap->map[sy*g.mapx+sx+1];
	slope=fabs(h1-h2);
	if(slope<fabs(h2-h3))
		slope=fabs(h2-h3);
	if(slope<fabs(h3-h4))
		slope=fabs(h3-h4);
	if(slope<fabs(h4-h1))
		slope=fabs(h4-h1);
	return slope;
}


float3 CGround::GetSmoothNormal(float x, float y)
{
	int sx=floor(x/SQUARE_SIZE);
	int sy=floor(y/SQUARE_SIZE);

	float dx=(x-sx*SQUARE_SIZE)/SQUARE_SIZE;
	float dy=(y-sy*SQUARE_SIZE)/SQUARE_SIZE;

	float3 norm1=readmap->normals[sy*g.mapx+sx]*(1-dx)+readmap->normals[sy*g.mapx+sx+1]*dx;
	float3 norm2=readmap->normals[(sy+1)*g.mapx+sx]*(1-dx)+readmap->normals[(sy+1)*g.mapx+sx+1]*dx;

	norm1=norm1*(1-dy)+norm2*dy;
	norm1.Normalize();

	return norm1;
}

float CGround::CheckTreeCol(const float3 &from,const float3 &to, int xs, int ys)
{
	xs*=2;
	ys*=2;
	for(int y=ys;y<=ys+1;++y){
		for(int x=xs;x<=xs+1;++x){
			char ttype=readmap->mapdata[y*(g.mapx-1)+x];
			if(ttype==71 || ttype==72 || ttype==76){
				srand((y)*764332+(x)*23421);
				rand();
				int numTrees=2;
				float size=1;
				if(ttype==72)
					numTrees=1;
				if(ttype==76)
					size=0.5f;
				for(int a=0;a<numTrees;a++){
					float dx=x*(SQUARE_SIZE)+(float(rand())/RAND_MAX)*SQUARE_SIZE;
					float dy=y*(SQUARE_SIZE)+(float(rand())/RAND_MAX)*SQUARE_SIZE;
					float3 base(dx,GetHeight(dx,dy),dy);
					float height=size*(6+float(rand())/RAND_MAX*3);
					float width=size*(2+float(rand())/RAND_MAX);
					if(beamdir.x!=0){
						float r=(base.x - from.x) / beamdir.x;
						if(r>0){
							float ycol=from.y+beamdir.y*r;
							float zcol=from.z+beamdir.z*r;
							if(base.y+height>ycol && fabs(base.z-zcol)<width && granMem[int((ycol-base.y)/height*256)][int((zcol-base.z)/width*128+128)])
								return r;
						}
					}
					if(beamdir.z!=0){
						float r=(base.z - from.z) / beamdir.z;
						if(r>0){
							float ycol=from.y+beamdir.y*r;
							float xcol=from.x+beamdir.x*r;
							if(base.y+height>ycol && fabs(base.x-xcol)<width && granMem[int((ycol-base.y)/height*256)][int((xcol-base.x)/width*128+128)])
								return r;
						}
					}
				}
			}
			if(ttype==73 || ttype==74){
				srand((y)*764332+(x)*23421);
				rand();
				int numTrees=1;
				float size=0.8f;
				if(ttype==74)
					size=0.4f;
				for(int a=0;a<numTrees;a++){
					float dx=x*(SQUARE_SIZE)+(float(rand())/RAND_MAX)*SQUARE_SIZE;
					float dy=y*(SQUARE_SIZE)+(float(rand())/RAND_MAX)*SQUARE_SIZE;
					float3 base(dx,GetHeight(dx,dy),dy);
					float height=size*(6+float(rand())/RAND_MAX*3);
					float width=size*(2+float(rand())/RAND_MAX);
					if(beamdir.x!=0){
						float r=(base.x - from.x) / beamdir.x;
						if(r>0){
							float ycol=from.y+beamdir.y*r;
							float zcol=from.z+beamdir.z*r;
							if(base.y+height>ycol && fabs(base.z-zcol)<width && birchMem[int((ycol-base.y)/height*256)][int((zcol-base.z)/width*64+64)])
								return r;
						}
					}
					if(beamdir.z!=0){
						float r=(base.z - from.z) / beamdir.z;
						if(r>0){
							float ycol=from.y+beamdir.y*r;
							float xcol=from.x+beamdir.x*r;
							if(base.y+height>ycol && fabs(base.x-xcol)<width && birchMem[int((ycol-base.y)/height*256)][int((xcol-base.x)/width*64+192)])
								return r;
						}
					}
				}
			}			
		}
	}
	return -2;
}

float3 CGround::TestHinder(float3& from, float3 &to, float width,float goalDir)
{
	beamdir=to-from;
	float length=beamdir.Length();
	beamdir.y=0;
	beamdir.Normalize();

	float3 ret = TestHinderSquare(from,beamdir,(int)floor(from.x/(SQUARE_SIZE/2)),(int)floor(from.z/(SQUARE_SIZE/2)),width,length,goalDir);
	if(ret.y>=0)
		return ret;

	vector<SHinder>::iterator hi;
	for(hi=hinders.begin();hi!=hinders.end();++hi){
		float dx=hi->pos.x-from.x;
		float dy=hi->pos.z-from.z;
		float l=dx*beamdir.x+dy*beamdir.z;
		if(l<9 && l>0){
//			info->AddLine("hinder");
			float ddx=dx-beamdir.x*l;
			float ddy=dy-beamdir.z*l;
			if(sqrt(ddx*ddx+ddy*ddy)<width+hi->size)
				return float3(ddx*beamdir.z-ddy*beamdir.x,l,0);
		}		
	}
	return float3(0,-1,0);
}

float3 CGround::TestHinderSquare(float3 &from, float3 &dir, int xs, int ys, float width,float length,float goalDir)
{
	float3 closeCol(0,length,0);
	if((xs<1) || (ys<1) || (xs>g.mapx*2-2) || (ys>g.mapy*2-2))
		return float3(0,-1,0);
//	xs*=2;
//	ys*=2;
	for(int y=ys-1;y<=ys+1;++y){
		for(int x=xs-1;x<=xs+1;++x){
			char ttype=readmap->mapdata[y*(g.mapx-1)+x];
			if(ttype>=71 && ttype<=76 && ttype!=75){
				srand((y)*764332+(x)*23421);
				rand();
				int numTrees=1;
				if(ttype==71 || ttype==76)
					numTrees=2;
				for(int a=0;a<numTrees;a++){
					float dx=(x*(SQUARE_SIZE/2)+(float(rand())/RAND_MAX)*SQUARE_SIZE/2)-from.x;
					float dy=(y*(SQUARE_SIZE/2)+(float(rand())/RAND_MAX)*SQUARE_SIZE/2)-from.z;
					float l=dx*dir.x+dy*dir.z;
					if(l<closeCol.y && l>0){
						float ddx=dx-dir.x*l;
						float ddy=dy-dir.z*l;
						if(sqrt(ddx*ddx+ddy*ddy)<width+0.5)
							closeCol=float3((ddx*dir.z-ddy*dir.x)/l-goalDir,l,sqrt(dx*dx+dy*dy));
					}
					rand();
					rand();
				}
			}
		}
	}
	if(closeCol.y<length)
		return closeCol;
	return float3(0,-2,0);
}

void CGround::AddHinder(float3 &pos, float size)
{
	SHinder h;
	h.pos=pos;
	h.size=size;
	hinders.push_back(h);
}

