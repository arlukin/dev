// ccDebug.h: interface for the ccDebug class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_CCDEBUG_H__742DFD63_A761_47FB_AEC7_543E3AEA18C5__INCLUDED_)
#define AFX_CCDEBUG_H__742DFD63_A761_47FB_AEC7_543E3AEA18C5__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000


void ccDebugMessage(char * file, int line, char * message = NULL);

#ifdef _DEBUG

#define ASSERTMSG(condition, str) \
	if (condition)\
		ccDebugMessage(__FILE__, __LINE__, str); 

#define ASSERT(condition) \
	if (condition)\
		ccDebugMessage(__FILE__, __LINE__); 

#else   // _DEBUG

#define ASSERTMSG(condition,str)          ((void)0)
#define ASSERT(condition)          ((void)0)

#endif // !_DEBUG
#endif // !defined(AFX_CCDEBUG_H__742DFD63_A761_47FB_AEC7_543E3AEA18C5__INCLUDED_)
