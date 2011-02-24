// InfoConsole.cpp: implementation of the CInfoConsole class.
//
//////////////////////////////////////////////////////////////////////

#include "InfoConsole.h"
#include <windows.h>		// Header File For Windows
#include <gl\gl.h>			// Header File For The OpenGL32 Library
#include <gl\glu.h>			// Header File For The GLu32 Library
#include <gl\glaux.h>		// Header File For The Glaux Library
#include "glFont.h"
#include "globalstuff.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////
CInfoConsole* info;

CInfoConsole::CInfoConsole()
{
	lastTime=0;
	lifetime=300;

	xpos=-1.6f;
	ypos=1.1f;	
}

CInfoConsole::~CInfoConsole()
{

}

CInfoConsole::AddLine(const char *text)
{
	char text2[50];
	if(strlen(text)>42){
		memcpy(text2,text,42);
		text2[42]=0;
	} else
		strcpy(text2,text);
	InfoLine l;
	if(data.size()>5){
		data[1].time+=data[0].time;
		data.pop_front();
	}
	data.push_back(l);
	data.back().text=text2;
	data.back().time=lifetime-lastTime;
	lastTime=lifetime;
#ifdef TRACE_SYNC
		tracefile << "Info line: ";
		tracefile << text << "\n";
#endif
	if(strlen(text)>42){
		AddLine(&text[42]);
	}

}

CInfoConsole::AddLine(std::string text)
{
	AddLine(text.c_str());
}

CInfoConsole::Draw()
{
	glPushMatrix();
	glDisable(GL_TEXTURE_2D);
	glColor4f(0,0,0.5f,0.4f);
	if(!data.empty()){
		glBegin(GL_TRIANGLE_STRIP);
			glVertex3f(0.01f,0.99f,0);
			glVertex3f(0.41f,0.99f,0);
			glVertex3f(0.01f,0.83f,0);
			glVertex3f(0.41f,0.83f,0);
		glEnd();
	}
	glTranslatef(0.015f,0.97f,0);
	glScalef(0.015f,0.02f,0.02f);
	glColor4f(1,1,1,1);

	glEnable(GL_TEXTURE_2D);

	std::deque<InfoLine>::iterator ili;
	for(ili=data.begin();ili!=data.end();ili++){
		font->glPrint("%s",ili->text.c_str());
		glTranslatef(0,-1.2f,0);
	}
	glPopMatrix();
}

CInfoConsole::Update()
{
	if(lastTime>0)
		lastTime--;
	if(!data.empty()){
		data.begin()->time--;
		if(data[0].time<=0)
			data.pop_front();
	}
}

CInfoConsole& CInfoConsole::operator<< (int i)
{
	char t[50];
	sprintf(t,"%d ",i);
	tempstring+=t;
	return *this;
}

CInfoConsole& CInfoConsole::operator<< (float f)
{
	char t[50];
	sprintf(t,"%f ",f);
	tempstring+=t;
	return *this;
}

CInfoConsole& CInfoConsole::operator<< (const char* c)
{
	for(int a=0;a<strlen(c);a++){
		if(c[a]!='\n'){
			tempstring+=c[a];
		} else {
			AddLine(tempstring);
			tempstring="";
			return *this;
		}
	}
	return *this;
}
