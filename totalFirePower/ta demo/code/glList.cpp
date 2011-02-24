// glList.cpp: implementation of the CglList class.
//
//////////////////////////////////////////////////////////////////////

#include "glList.h"
#include <windows.h>		// Header File For Windows
#include <gl\gl.h>			// Header File For The OpenGL32 Library
#include <gl\glu.h>			// Header File For The GLu32 Library
#include <gl\glaux.h>		// Header File For The Glaux Library
#include "globalstuff.h"
#include "glfont.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CglList::~CglList()
{
	RegSetValueEx(regkey,"vehicle",0,REG_SZ,(unsigned char*)items[place].c_str(),items[place].size()+1);
	RegCloseKey(regkey);
}

CglList::CglList(char *name,ListSelectCallback callback)
{
	this->name=name;
	this->callback=callback;
	place=0;
	if(RegCreateKey(HKEY_CURRENT_USER,"Software\\SJ\\Spring",&regkey)!=ERROR_SUCCESS)
		MessageBox(0,"Failed to crete registry key","Game error",0);
	unsigned char regbuf[100];
	DWORD regLength=100;
	DWORD regType;
	if(RegQueryValueEx(regkey,"vehicle",0,&regType,regbuf,&regLength)==ERROR_SUCCESS)
		lastChoosen=(char*)regbuf;
}

CglList::AddItem(const char *name,const char *description)
{
	items.push_back(name);
	if(lastChoosen.compare(name)==0)
		place=items.size()-1;
}

CglList::Draw()
{
	glDisable(GL_TEXTURE_2D);
	glLoadIdentity();
	glColor4f(0,0,0,0.5f);
	glBegin(GL_QUADS);
		glVertex3f(-0.4f,-0.5f,-1.1f);
		glVertex3f(0.4f,-0.5f,-1.1f);
		glVertex3f(0.4f,0.5f,-1.1f);
		glVertex3f(-0.4f,0.5f,-1.1f);
	glEnd();

	glEnable(GL_TEXTURE_2D);
	glColor4f(1,1,0.5f,0.8f);
	glLoadIdentity();
	glTranslatef(-3.5f,3.5f,-12.0f);						// Move One Unit Into The Screen
	font->glPrint(name.c_str());

	std::vector<std::string>::iterator ii;
	int a=0;
	for(ii=items.begin();ii!=items.end();ii++){
		if(a==place)
			glColor4f(1,1,1.0f,1.0f);
		else
			glColor4f(1,1,0.0f,0.3f);

		glLoadIdentity();
		glTranslatef(-3.5f,3.0f-a*0.45f,-12.0f);						// Move One Unit Into The Screen
		font->glPrint(ii->c_str());
		a++;
	}	
}

CglList::UpOne()
{
	place--;
	if(place<0)
		place=0;
}

CglList::DownOne()
{
	place++;
	if(place>=items.size())
		place=items.size()-1;
	if(place<0)
		place=0;
}

void CglList::Select()
{
	callback(items[place]);
}
