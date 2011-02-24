// InfoConsole.h: interface for the CInfoConsole class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_INFOCONSOLE_H__E9B2D6A1_80B3_11D4_AD55_0080ADA84DE3__INCLUDED_)
#define AFX_INFOCONSOLE_H__E9B2D6A1_80B3_11D4_AD55_0080ADA84DE3__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include <deque>
#include <string>

class CInfoConsole  
{
public:
	Update();
	Draw();
	AddLine(const char* text);
	AddLine(std::string text);
	CInfoConsole();
	virtual ~CInfoConsole();
	int lifetime;
	float xpos;
	float ypos;

	CInfoConsole& operator<< (int i);
	CInfoConsole& operator<< (float f);
	CInfoConsole& operator<< (const char* c);

private:
	struct InfoLine {
		std::string text;
		int time;
	};
	int lastTime;
	std::deque<InfoLine> data;
	std::string tempstring;
};

extern CInfoConsole* info;

#endif // !defined(AFX_INFOCONSOLE_H__E9B2D6A1_80B3_11D4_AD55_0080ADA84DE3__INCLUDED_)
