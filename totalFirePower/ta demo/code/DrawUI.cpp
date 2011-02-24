// DrawUI.cpp: implementation of the CDrawUI class.
//
//////////////////////////////////////////////////////////////////////

#include "DrawUI.h"
#include "globalstuff.h"
#include "irenderer.h"
#include "mygl.h"
#include "glfont.h"
#include "tapalette.h"
#include "reghandler.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CDrawUI::CDrawUI()
{
	drawRes=!!regHandler.GetInt("DrawResources",0);
}

CDrawUI::~CDrawUI()
{

}

void CDrawUI::Draw()
{
	static unsigned char c2p[]={227,212,80,235,108,219,208,93,130,67};
	if(!g.fromRec)
		return;

	if(drawRes){
		glPushMatrix();
		glTranslatef(0.73f,0.94f,0);
		glColor4f(1,1,1,1);
		glScalef(0.012f,0.012f,0.012f);
		for(int a=0;a<g.shared->numPlayers;++a){
			if((g.fromRec->storageM[a]==0 && g.fromRec->storageE[a]==0) || (g.fromRec->storedM[a]==1020 && g.fromRec->storedE[a]==1020) || (g.fromRec->storedM[a]==1000 && g.fromRec->storedE[a]==1000))
				continue;
			glColor4f(0,0,0.0f,0.3f);
			glDisable(GL_TEXTURE_2D);
			glBegin(GL_QUADS);
				glVertex3f(0,4,0);
				glVertex3f(21,4,0);
				glVertex3f(21,0,0);
				glVertex3f(0,0,0);
			glEnd();

			glColor3ubv(palette[c2p[g.shared->players[a].color]]);
			glBegin(GL_QUADS);
				glVertex3f(0.1f,3,0);
				glVertex3f(1.1f,3,0);
				glVertex3f(1.1f,4,0);
				glVertex3f(0.1f,4,0);
			glEnd();
			glColor3f(0,0,0);
			glBegin(GL_QUADS);
				glVertex3f(3,0.3f,0);
				glVertex3f(3,0.9f,0);
				glVertex3f(17,0.9f,0);
				glVertex3f(17,0.3f,0);

				glVertex3f(3,1.6f,0);
				glVertex3f(3,2.2f,0);
				glVertex3f(17,2.2f,0);
				glVertex3f(17,1.6f,0);

				glColor3f(0.9f,0.9f,0.9f);
				
				float partM=3+14*(g.fromRec->storedM[a]/g.fromRec->storageM[a]);
				glVertex3f(3,1.6f,0);
				glVertex3f(3,2.2f,0);
				glVertex3f(partM,2.2f,0);
				glVertex3f(partM,1.6f,0);

				glColor3f(0.9f,0.9f,0);
				
				float partE=3+14*(g.fromRec->storedE[a]/g.fromRec->storageE[a]);
				glVertex3f(3,0.3f,0);
				glVertex3f(3,0.9f,0);
				glVertex3f(partE,0.9f,0);
				glVertex3f(partE,0.3f,0);
			glEnd();


			glEnable(GL_TEXTURE_2D);
			glColor4f(1,1,1,0.9f);
			glPushMatrix();

			glTranslatef(1.2f,3,0);
			font->glPrint("%s",g.shared->players[a].name);
			
			glTranslatef(-1.1f,-1.33f,0);
			font->glPrint("%4.0f",g.fromRec->storedM[a]);
			
			glTranslatef(17,0,0);
			font->glPrint("+%5.0f",g.fromRec->incomeM[a]);

			glTranslatef(-17,-1.33f,0);
			font->glPrint("%4.0f",g.fromRec->storedE[a]);

			glTranslatef(17,0,0);
			font->glPrint("+%5.0f",g.fromRec->incomeE[a]);

			glPopMatrix();
			glTranslatef(0,-4,0);
		}
		glPopMatrix();
	}
}
