// Object.cpp: implementation of the CObject class.
//
//////////////////////////////////////////////////////////////////////

#include "Object.h"
#include <windows.h>

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CObject::~CObject()
{
	std::list<CObject*>::iterator di;
	for(di=listeners.begin();di!=listeners.end();di++){
		(*di)->DependentDied(this);
		(*di)->listening.remove(this);
	}
	for(di=listening.begin();di!=listening.end();di++){
		(*di)->listeners.remove(this);
	}
}

CObject::DependentDied(CObject* o)
{
//	MessageBox(0,"wrong","ag",0);
}

void CObject::AddDeathDependence(CObject *o)
{
	o->listeners.push_back(this);
	listening.push_back(o);
}

void CObject::DeleteDeathDependence(CObject *o)
{
	std::list<CObject*>::iterator di;
	for(di=listening.begin();di!=listening.end();di++){
		if((*di)==o){
			listening.erase(di);
			break;
		}
	}	
	for(di=o->listeners.begin();di!=o->listeners.end();di++){
		if((*di)==this){
			o->listeners.erase(di);
			break;
		}
	}
}
