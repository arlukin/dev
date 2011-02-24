// TimeProfiler.cpp: implementation of the CTimeProfiler class.
//
//////////////////////////////////////////////////////////////////////

#include "TimeProfiler.h"
#include "mygl.h"
#include "glfont.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////
CTimeProfiler profiler;

CTimeProfiler::CTimeProfiler()
{
	QueryPerformanceFrequency(&timeSpeed);
}

CTimeProfiler::~CTimeProfiler()
{

}

void CTimeProfiler::Draw()
{
	glPushMatrix();
	glDisable(GL_TEXTURE_2D);
	glColor4f(0,0,0.5f,0.5f);
	if(!profile.empty()){
		glBegin(GL_TRIANGLE_STRIP);
			glVertex3f(0.65f,0.99f,0);
			glVertex3f(0.99f,0.99f,0);
			glVertex3f(0.65f,0.99f-profile.size()*0.024-0.01,0);
			glVertex3f(0.99f,0.99f-profile.size()*0.024-0.01,0);
		glEnd();
	}
	glTranslatef(0.655f,0.965f,0);
	glScalef(0.015f,0.02f,0.02f);
	glColor4f(1,1,1,1);

	glEnable(GL_TEXTURE_2D);

	map<string,TimeRecord>::iterator pi;

	for(pi=profile.begin();pi!=profile.end();++pi){
		font->glPrint("%20s %6.2fs %5.2f%%",pi->first.c_str(),((double)pi->second.total.QuadPart)/timeSpeed.QuadPart,pi->second.percent*100);
		glTranslatef(0,-1.2f,0);

	}
	glPopMatrix();
}

void CTimeProfiler::Update()
{
	map<string,TimeRecord>::iterator pi;

	for(pi=profile.begin();pi!=profile.end();++pi){
		pi->second.percent=((double)pi->second.current.QuadPart)/timeSpeed.QuadPart;
		pi->second.current.QuadPart=0;
	}
}

void CTimeProfiler::AddTime(string name, __int64 time)
{
	if(profile.find(name)!=profile.end()){
		profile[name].total.QuadPart+=time;
		profile[name].current.QuadPart+=time;
	} else {
		profile[name].total.QuadPart=time;
		profile[name].current.QuadPart=time;
		profile[name].percent=0;
	}
}
