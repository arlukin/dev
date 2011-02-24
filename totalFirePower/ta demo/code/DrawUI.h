// DrawUI.h: interface for the CDrawUI class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_DRAWUI_H__F2CF8EB9_BF22_43AF_9616_8F5EEB2157D8__INCLUDED_)
#define AFX_DRAWUI_H__F2CF8EB9_BF22_43AF_9616_8F5EEB2157D8__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

class CDrawUI  
{
public:
	void Draw();
	CDrawUI();
	virtual ~CDrawUI();

	bool drawRes;
};

#endif // !defined(AFX_DRAWUI_H__F2CF8EB9_BF22_43AF_9616_8F5EEB2157D8__INCLUDED_)
