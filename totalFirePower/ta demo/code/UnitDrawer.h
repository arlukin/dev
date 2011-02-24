// UnitDrawer.h: interface for the CUnitDrawer class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_UNITDRAWER_H__B5ACD75B_D583_4B27_ACDA_168EF13DCA04__INCLUDED_)
#define AFX_UNITDRAWER_H__B5ACD75B_D583_4B27_ACDA_168EF13DCA04__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

struct S3DO;
struct Unit;

class CUnitDrawer  
{
public:
	void DrawPart(S3DO* part);
	void Draw();
	CUnitDrawer();
	virtual ~CUnitDrawer();

	bool drawHealth;
	bool drawKills;
	bool drawName;
private:
	int curPart;
	Unit* curUnit;

	struct PrevUnit{
		char name[0x20];
		S3DO* model;
	};

	PrevUnit prevUnits[20000];
};

#endif // !defined(AFX_UNITDRAWER_H__B5ACD75B_D583_4B27_ACDA_168EF13DCA04__INCLUDED_)
