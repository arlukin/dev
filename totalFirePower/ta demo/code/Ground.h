// Ground.h: interface for the CGround class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_GROUND_H__EB512761_1B68_11D4_AD55_0080ADA84DE3__INCLUDED_)
#define AFX_GROUND_H__EB512761_1B68_11D4_AD55_0080ADA84DE3__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#pragma warning(disable:4786)

class CGround;

#include "globalstuff.h"
#include <vector>
#include "float3.h"	// Added by ClassView
class CProjectileHandler;
class CProjectile;

using namespace std;
class CGround  
{
public:
	CGround();
	virtual ~CGround();

	void AddHinder(float3 &pos,float size);
	float3 TestHinderSquare(float3& from,float3 &to,int xs,int ys,float width,float length,float goalDir);
	float3 TestHinder(float3& from,float3& to,float width,float goalDir);
	float CheckTreeCol(const float3& from,const float3& to,int xs,int ys);
	float3 GetSmoothNormal(float x,float y);
	float GetApproximateHeight(float x,float y);
	float GetSlope(const float x,const float y);
	float GetHeight(const float x,const float y);
	float3& GetNormal(const float x,const float y);
	float LineGroundCol(const float3 &from,const float3 &to,bool checkTrees=false);

	typedef std::list<CProjectile*> Projectile_List;

	struct SHinder {
		float size;
		float3 pos;
	};
	vector<SHinder> hinders;
	char granMem[256][512];
	char birchMem[256][512];
private:


	float LineGroundSquareCol(const float3 &from,const float3 &to,int xs,int ys);

	float3 beamdir;
	bool checkTrees;

};
extern CGround* ground;

#endif // !defined(AFX_GROUND_H__EB512761_1B68_11D4_AD55_0080ADA84DE3__INCLUDED_)
