// MiniMap.h: interface for the CMiniMap class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_MINIMAP_H__031E512D_66AB_4071_8769_EBAFAB24BBEA__INCLUDED_)
#define AFX_MINIMAP_H__031E512D_66AB_4071_8769_EBAFAB24BBEA__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include <vector>
#include "float3.h"
#include <deque>
class CSquad;

struct EhaMarker{
	int time;
	float x,y;
};

class CMiniMap  
{
public:
	struct fline {
		float base;
		float dir;
		int left;
		float minz;
		float maxz;
	};
	std::vector<fline> left;
	void Draw();
	CMiniMap();
	virtual ~CMiniMap();
	void GetFrustumSide(float3& side);
	void DrawInMap(float3 &pos);

	int xpos,ypos;
	int height,width;
	bool show;
	unsigned int unitBlip;

	std::deque<EhaMarker> markers;	//hack should be somewhere else
};
extern CMiniMap* minimap;

#endif // !defined(AFX_MINIMAP_H__031E512D_66AB_4071_8769_EBAFAB24BBEA__INCLUDED_)
