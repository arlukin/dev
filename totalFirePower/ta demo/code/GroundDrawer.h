// GroundDrawer.h: interface for the CGroundDrawer class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_GROUNDDRAWER_H__3F545FE6_CA1A_4DF1_B61B_F7EF855272E8__INCLUDED_)
#define AFX_GROUNDDRAWER_H__3F545FE6_CA1A_4DF1_B61B_F7EF855272E8__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "globalstuff.h"
#include <vector>
class CTreeDrawer;

class CGroundDrawer
{
	friend class CTreeDrawer;
public:
	void MemBlitFeature(void* dest,void* source,int xsize,int ysize,int destSkip,int sourceSkip);
	void FillTexArea(int level,int xstart,int ystart,int width,int height);
	void MemBlit(unsigned char* dest,unsigned char* source,int width,int height,int destSkip);
	void PrepareTex(int level,float3& pos);
	void Draw();
	CGroundDrawer();
	virtual ~CGroundDrawer();

	bool drawTrees;
	
	int viewRadius;
	int striptype;
	float baseTreeDistance;

protected:
	AddFrustumRestraint(float3 side);
	struct fline {
		float base;
		float dir;
	};
	std::vector<fline> right,left;

//	inline DrawVertex(int x,int y,float fx,float fy);

	CTreeDrawer* treeDrawer;

	struct TexLevel{
		unsigned int tex;
		int xpos;
		int ypos;
	};
	TexLevel texLevels[3];

	int useLargeTextures;
	int textureSize;
	int tilesInTex;
};
extern CGroundDrawer* groundDrawer;

#endif // !defined(AFX_GROUNDDRAWER_H__3F545FE6_CA1A_4DF1_B61B_F7EF855272E8__INCLUDED_)
