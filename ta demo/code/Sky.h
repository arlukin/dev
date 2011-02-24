// Sky.h: interface for the CSky class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_SKY_H__9A754BA1_AB87_11D4_AD55_0080ADA84DE3__INCLUDED_)
#define AFX_SKY_H__9A754BA1_AB87_11D4_AD55_0080ADA84DE3__INCLUDED_

#include "float3.h"	// Added by ClassView
#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "float3.h"

class CSky  
{
public:
	void CreateTransformVectors();
	void CreateRandMatrix(int matrix[32][32],float mod);
	void DrawShafts();
	void ResetCloudShadow(int texunit);
	void SetCloudShadow(int texunit);
	void CreateClouds();
	void UpdateClouds();
	void DrawSunFlare();
	Draw();
	float3 GetCoord(int x,int y);
	float3 GetTexCoord(int x,int y);
	CSky();
	virtual ~CSky();

	unsigned int skyTex;
	unsigned int skyDot3Tex;
	unsigned int cloudDot3Tex;
	unsigned int displist;
	unsigned int suntex;

	int randMatrix[16][32][32];

	unsigned char alphaTransform[1024];
	unsigned char thicknessTransform[1024];

	int lastCloudUpdate;
	bool dynamicSky;
	bool cloudDown[10];
	bool drawFlare;

	float cloudDensity;
};
extern CSky* sky;

#endif // !defined(AFX_SKY_H__9A754BA1_AB87_11D4_AD55_0080ADA84DE3__INCLUDED_)
