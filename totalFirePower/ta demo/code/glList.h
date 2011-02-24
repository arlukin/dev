// glList.h: interface for the CglList class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_GLLIST_H__87AE2821_660E_11D4_AD55_0080ADA84DE3__INCLUDED_)
#define AFX_GLLIST_H__87AE2821_660E_11D4_AD55_0080ADA84DE3__INCLUDED_

#pragma warning(disable:4786)

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include <string>
#include <vector>
#ifndef _WINSOCKAPI_
	#define _WINSOCKAPI_
	#include <windows.h>
	#undef _WINSOCKAPI_
#else
	#include <windows.h>
#endif
#include <winreg.h>

typedef void (* ListSelectCallback) (std::string selected);

class CglList  
{
public:
	void Select();
	DownOne();
	UpOne();
	Draw();
	AddItem(const char* name,const char* description);
	CglList(char* name,ListSelectCallback callback);
	virtual ~CglList();
	int place;
	std::vector<std::string> items;
	std::string name;

	HKEY regkey;
	std::string lastChoosen;
	ListSelectCallback callback;
};

#endif // !defined(AFX_GLLIST_H__87AE2821_660E_11D4_AD55_0080ADA84DE3__INCLUDED_)
