// DrawWater.h: interface for the CDrawWater class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_DRAWWATER_H__B59D3FE0_03FC_4A16_AEE4_6384895BD3AE__INCLUDED_)
#define AFX_DRAWWATER_H__B59D3FE0_03FC_4A16_AEE4_6384895BD3AE__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

class CDrawWater  
{
public:
	void Draw();
	CDrawWater();
	virtual ~CDrawWater();

	unsigned int texture;
	unsigned int displist;

};

#endif // !defined(AFX_DRAWWATER_H__B59D3FE0_03FC_4A16_AEE4_6384895BD3AE__INCLUDED_)
