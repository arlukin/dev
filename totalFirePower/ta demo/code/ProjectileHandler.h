// ProjectileHandler.h: interface for the CProjectileHandler class.
//
//////////////////////////////////////////////////////////////////////
#pragma warning(disable:4786)

#if !defined(AFX_PROJECTILEHANDLER_H__C7B284AB_3578_11D4_AD55_0080ADA84DE3__INCLUDED_)
#define AFX_PROJECTILEHANDLER_H__C7B284AB_3578_11D4_AD55_0080ADA84DE3__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

class CProjectileHandler;
class CProjectile;

#include <list>
#include <vector>
#include "float3.h"
#include <map>

typedef std::list<CProjectile*> Projectile_List;
struct Projectile;
struct S3DO;

class CProjectileHandler  
{
public:
	void DrawArray();
	float3 hs2rgb(float h,float s);
	struct Laser{
		float3 pos,pos2;
		float3 color;
	};
	struct Plasma{
		float3 pos;
		float size;
	};

	struct Smoke {
		char* name;
		int numSubs;
		float3 pos[10];
		int frame[10];
	};

	struct ProjDef{
		int type;
		S3DO* model;
		float3 color;
	};

	struct Explo{
		float3 pos;
		int frame;
		char* name;
	};
	ProjDef projDefs[256];

	void CreateProjDefs();
	void Draw3do(const float3& pos,const float3& rot,const S3DO *model);
	void DrawExplosion(Explo* p);
	void DrawPlasma(Plasma* p);
	void DrawLaser(Laser* l);
	void DrawLighting(Laser* l);
	void DrawSmoke(Smoke* s);

	Draw();
	Update();
	CProjectileHandler();
	virtual ~CProjectileHandler();

private:	
	void SearchWeaponFile(std::string name);

	std::map<std::string,std::string> weapon2file;
};
extern CProjectileHandler* ph;

#endif // !defined(AFX_PROJECTILEHANDLER_H__C7B284AB_3578_11D4_AD55_0080ADA84DE3__INCLUDED_)
