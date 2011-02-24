// glFont.cpp: implementation of the CglFont class.
//
//////////////////////////////////////////////////////////////////////

#include "glFont.h"
#include <stdio.h>
#include "globalstuff.h"
#include "camera.h"
#include <fstream>
//#include <ostream.h>
//#include <istream.h>

using namespace std;

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////
CglFont* font;

CglFont::CglFont(HDC hDC, int start, int num)
{
	numchars=num;
	startchar=start;

	HFONT	font;										// Windows Font ID
	base = glGenLists(num);			
	unsigned char tex[1024][4];
	char ch;
	int a;

	for(a=0;a<1024;a++){
		tex[a][0]=255;
		tex[a][1]=255;
		tex[a][2]=255;
		tex[a][3]=0;
	}
	ifstream ifs("bagge.fnt",ios::in|ios::binary);
	ofstream* ofs=0;
	if(!ifs.is_open())
		ofs=new ofstream("bagge.fnt",ios::out|ios::binary);

	int size=64;
	for(int sizenum=0;size!=32;sizenum++){
		size/=2;
		font = CreateFont(	-size,							// Height Of Font
								0,								// Width Of Font
								0,								// Angle Of Escapement
								0,								// Orientation Angle
								FW_BOLD,						// Font Weight
								FALSE,							// Italic
								FALSE,							// Underline
								FALSE,							// Strikeout
								ANSI_CHARSET,					// Character Set Identifier
								OUT_TT_PRECIS,					// Output Precision
								CLIP_DEFAULT_PRECIS,			// Clipping Precision
								ANTIALIASED_QUALITY,			// Output Quality
								FF_DONTCARE|DEFAULT_PITCH,		// Family And Pitch
								"Courier New");					// Font Name

		SelectObject(hDC, font);							// Selects The Font We Want

		if(sizenum==0){
			glGenTextures(num, ttextures);
			if(GetCharWidth(hDC,start,start+num,charWidths)==0){
				char t[500];
				sprintf(t,"Couldnt get text width %d",GetLastError());
				MessageBox(0,t,"Error generating font",0);
			}
		}
		
		RECT r;
		r.bottom=size;
		r.left=0;
		r.top=0;
		r.right=size;

		for(a=0;a<num;a++){
			if(ofs){
				ch=a+start;
				DrawText(hDC,&ch,1,&r,DT_LEFT | DT_TOP);
				
				COLORREF cr;
				for(int y=0;y<size;y++){
					for(int x=0;x<charWidths[a];x++){
						cr=GetPixel(hDC,x,y);
						int a=255-cr&0xff;
						tex[y*size+x][0]=255;
						tex[y*size+x][1]=255;
						tex[y*size+x][2]=255;
						tex[y*size+x][3]=a;
					}
				}
				ofs->write((char*)tex[0],size*size*4);
			} else
				ifs.read((char*)tex[0],size*size*4);
			if(sizenum==0){
				glBindTexture(GL_TEXTURE_2D, ttextures[a]);
				glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
				glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR/*_MIPMAP_NEAREST*/);
				glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_CLAMP);
				glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_CLAMP);
			}
			glBindTexture(GL_TEXTURE_2D, ttextures[a]);
			glTexImage2D(GL_TEXTURE_2D, sizenum, 4, size, size, 0, GL_RGBA, GL_UNSIGNED_BYTE, tex[0]);
//			gluBuild2DMipmaps(GL_TEXTURE_2D,4 ,size, size, GL_RGBA, GL_UNSIGNED_BYTE, tex[0]);

		}
	}

	for(a=0;a<num;a++){
		int ch=a+start;
#define DRAW_SIZE 1
		float charpart=(charWidths[a])/32.0f;
		glNewList(base+a,GL_COMPILE);
			glBindTexture(GL_TEXTURE_2D, ttextures[a]);
			glBegin(GL_TRIANGLE_STRIP);
				glTexCoord2f(0,1-1.0/64);	glVertex3f(0,0,0);
				glTexCoord2f(0,0);	glVertex3f(0,DRAW_SIZE,0);
				glTexCoord2f(charpart,1-1.0/64);	glVertex3f(DRAW_SIZE*charpart,0,0);
				glTexCoord2f(charpart,0);	glVertex3f(DRAW_SIZE*charpart,DRAW_SIZE,0);
			glEnd();
			glTranslatef(DRAW_SIZE*(charpart+0.02f),0,0);
		glEndList();
	}
	if(ofs)
		delete ofs;
}

CglFont::~CglFont()
{
	glDeleteLists(base, numchars);							// Delete All 96 Characters
	glDeleteTextures (numchars, ttextures);
}

void CglFont::glPrint(const char *fmt, ...)
{
	char		text[256];								// Holds Our String
	va_list		ap;										// Pointer To List Of Arguments

	if (fmt == NULL)									// If There's No Text
		return;											// Do Nothing

	va_start(ap, fmt);									// Parses The String For Variables
	    vsprintf(text, fmt, ap);						// And Converts Symbols To Actual Numbers
	va_end(ap);											// Results Are Stored In Text

	glPushAttrib(GL_LIST_BIT);							// Pushes The Display List Bits
	glPushMatrix();
	glListBase(base - startchar);
	glCallLists(strlen(text), GL_UNSIGNED_BYTE, text);	// Draws The Display List Text
	glPopMatrix();
	glPopAttrib();										// Pops The Display List Bits
}

void CglFont::glWorldPrint(const char *fmt, ...)
{
	char		text[256];								// Holds Our String
	va_list		ap;										// Pointer To List Of Arguments

	if (fmt == NULL)									// If There's No Text
		return;											// Do Nothing

	va_start(ap, fmt);									// Parses The String For Variables
	    vsprintf(text, fmt, ap);						// And Converts Symbols To Actual Numbers
	va_end(ap);											// Results Are Stored In Text

	glPushMatrix();
	int b=strlen(text);
	float charpart=(charWidths[text[0]-startchar])/32.0f;
	glTranslatef(-b*0.5f*DRAW_SIZE*(charpart+0.03f)*camera.right.x,-b*0.5f*DRAW_SIZE*(charpart+0.03f)*camera.right.y,-b*0.5f*DRAW_SIZE*(charpart+0.03f)*camera.right.z);
	for(int a=0;a<b;a++)
		WorldChar(text[a]);
	glPopMatrix();
}

CglFont::WorldChar(char c)
{
	float charpart=(charWidths[c-startchar])/32.0f;
	glBindTexture(GL_TEXTURE_2D, ttextures[c-startchar]);
	glBegin(GL_TRIANGLE_STRIP);
		glTexCoord2f(0,1);	glVertex3f(0,0,0);
		glTexCoord2f(0,0);	glVertex3f(DRAW_SIZE*camera.up.x,DRAW_SIZE*camera.up.y,DRAW_SIZE*camera.up.z);
		glTexCoord2f(charpart,1);	glVertex3f(DRAW_SIZE*charpart*camera.right.x,DRAW_SIZE*charpart*camera.right.y,DRAW_SIZE*charpart*camera.right.z);
		glTexCoord2f(charpart,0);	glVertex3f(DRAW_SIZE*(camera.up.x+camera.right.x*charpart),DRAW_SIZE*(camera.up.y+camera.right.y*charpart),DRAW_SIZE*(camera.up.z+camera.right.z*charpart));
	glEnd();
	glTranslatef(DRAW_SIZE*(charpart+0.03f)*camera.right.x,DRAW_SIZE*(charpart+0.03f)*camera.right.y,DRAW_SIZE*(charpart+0.03f)*camera.right.z);
}
