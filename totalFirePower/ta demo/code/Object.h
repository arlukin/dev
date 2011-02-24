// Object.h: interface for the CObject class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_OBJECT_H__64BC40C1_A468_11D4_AD55_0080ADA84DE3__INCLUDED_)
#define AFX_OBJECT_H__64BC40C1_A468_11D4_AD55_0080ADA84DE3__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include <list>

class CObject  
{
public:
	void DeleteDeathDependence(CObject* o);
	void AddDeathDependence(CObject* o);
	virtual DependentDied(CObject* o);
	inline CObject(){};
	virtual ~CObject();
	
	std::list<CObject*> listeners,listening;
};

#endif // !defined(AFX_OBJECT_H__64BC40C1_A468_11D4_AD55_0080ADA84DE3__INCLUDED_)
