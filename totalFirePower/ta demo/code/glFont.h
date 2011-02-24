// glFont.h: interface for the CglFont class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_GLFONT_H__E6EEC624_801A_11D4_AD55_0080ADA84DE3__INCLUDED_)
#define AFX_GLFONT_H__E6EEC624_801A_11D4_AD55_0080ADA84DE3__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include <windows.h>		// Header File For Windows
#include <gl\gl.h>			// Header File For The OpenGL32 Library
#include <gl\glu.h>			// Header File For The GLu32 Library
#include <gl\glaux.h>		// Header File For The Glaux Library

class CglFont  
{
public:
	void glPrint(const char* fmt, ...);
	void glWorldPrint(const char* fmt, ...);
	CglFont(HDC hDC, int start, int num);
	virtual ~CglFont();
	
	GLuint ttextures[256]; 
	GLuint base;				// Base Display List For The Font Set
	
	int numchars;
	int startchar;
	int charWidths[256];

private:
	WorldChar(char c);
};
extern CglFont* font;

#endif // !defined(AFX_GLFONT_H__E6EEC624_801A_11D4_AD55_0080ADA84DE3__INCLUDED_)
