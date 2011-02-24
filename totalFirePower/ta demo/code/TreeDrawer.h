// TreeDrawer.h: interface for the CTreeDrawer class.
//
//////////////////////////////////////////////////////////////////////

#pragma warning(disable:4786)

#if !defined(AFX_TREEDRAWER_H__9E1F499C_815E_4F58_AD8B_0D3B04C73C4A__INCLUDED_)
#define AFX_TREEDRAWER_H__9E1F499C_815E_4F58_AD8B_0D3B04C73C4A__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "float3.h"
#include <map>
#include <string>

struct S3DO;

class CTreeDrawer  
{
public:
	void CreateInMapFeature(int num,unsigned char* fileBuf,std::string& name,int defAlpha=255);
	void TestClean(int a);
	struct FeatureDef{
		int type;
		S3DO* object;

		unsigned char *(lods[3]);
		int xsize[3];
		int ysize[3];
		int xoffset,yoffset;
	};

	CTreeDrawer();
	virtual ~CTreeDrawer();

	void Draw(float treeDistance);
	void CreateTreeTex(unsigned int& texnum,unsigned char* data,int xsize,int ysize);

	unsigned int treetex;
	int lastListClean;

	struct Feature {
		unsigned int wrecklist;
		unsigned int displist;
		unsigned int farDisplist;
		int lastSeen;
		int checkSum;
		float3 viewVector;
	};
	Feature* features;
	int numSquares;
	int xFeatures;
	int xSquares;
	int ySquares;

	FeatureDef* featureDef;
};

#endif // !defined(AFX_TREEDRAWER_H__9E1F499C_815E_4F58_AD8B_0D3B04C73C4A__INCLUDED_)
