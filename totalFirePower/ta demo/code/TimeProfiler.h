// TimeProfiler.h: interface for the CTimeProfiler class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_TIMEPROFILER_H__3C2D635C_014C_4725_8254_32D218832C95__INCLUDED_)
#define AFX_TIMEPROFILER_H__3C2D635C_014C_4725_8254_32D218832C95__INCLUDED_

#define PROFILE_TIME

#pragma warning(disable:4786)

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifdef PROFILE_TIME

#define WIN32_LEAN_AND_MEAN 1
#include <windows.h>
#include <string>
#include <map>

using namespace std;

class CTimeProfiler  
{
	struct TimeRecord{
		LARGE_INTEGER total;
		LARGE_INTEGER current;
		float percent;
	};
public:
	void AddTime(string name,__int64 time);
	void Update();
	void Draw();
	CTimeProfiler();
	virtual ~CTimeProfiler();

	map<string,TimeRecord> profile;
	LARGE_INTEGER timeSpeed;
};

extern CTimeProfiler profiler;
#endif

#endif // !defined(AFX_TIMEPROFILER_H__3C2D635C_014C_4725_8254_32D218832C95__INCLUDED_)
