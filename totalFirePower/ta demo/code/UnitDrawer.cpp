// UnitDrawer.cpp: implementation of the CUnitDrawer class.
//
//////////////////////////////////////////////////////////////////////

#include "UnitDrawer.h"
#include "mygl.h"
#include "globalstuff.h"
#include "irenderer.h"
#include "camera.h"
#include "3doparser.h"
#include "infoconsole.h"
#include "timeprofiler.h"
#include "reghandler.h"
#include "glfont.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

static GLfloat GreenLightDiffuse[]=	{ 0.0f, 1.4f, 0.0f, 1.0f };
static GLfloat GreenLightAmbient[]=	{ 0.0f, 0.6f, 0.0f, 1.0f };
static GLfloat LightDiffuseLand[]=	{ 0.7f, 0.7f, 0.7f, 1.0f };
static GLfloat LightAmbientLand[]=	{ 0.3f, 0.3f, 0.3f, 1.0f };

static const float PlasmaMidX=33/1024.0;
static const float PlasmaMidY=65/2048.0;

CUnitDrawer::CUnitDrawer()
{
	drawHealth=!!regHandler.GetInt("HealthBars",0);
	drawKills=!!regHandler.GetInt("KillCount",0);
	drawName=!!regHandler.GetInt("CmdNames",0);
}

CUnitDrawer::~CUnitDrawer()
{

}
//1065353216
static float scaleFactor;
static bool greenLight=false;
void CUnitDrawer::Draw()
{
#ifdef PROFILE_TIME
	LARGE_INTEGER start;
	QueryPerformanceCounter(&start);
#endif
	scaleFactor=1/(65536.0);
	glDisable(GL_CULL_FACE);
	glDisable(GL_BLEND);
	texturehandler->SetTexture();
	glDisable(GL_ALPHA_TEST);
	glEnable(GL_TEXTURE_2D);
//	(*info) << g.shared->numPlayers << " " << g.shared->maxUnits << " " << g.shared->players[0].maxUsedUnit << "\n";
//	(*info) << g.shared->units[0].active << " " << g.shared->units[0].name << "\n";
//	(*info) << g.shared->units[0].pos.x*scaleFactor << " " << g.shared->units[0].pos.y*scaleFactor << " " << g.shared->units[0].pos.z*scaleFactor << "\n";
	for(int p=0;p<g.shared->numPlayers;++p){
		int maxUsed=p * g.shared->maxUnits + g.shared->players[p].maxUsedUnit;
		for(int u=p*g.shared->maxUnits;u<maxUsed;++u){
			if(g.shared->units[u].active && g.shared->units[u].name[0]!=0){
				curUnit=&g.shared->units[u];

				float3 pos(curUnit->pos.x*scaleFactor,curUnit->pos.z*scaleFactor,curUnit->pos.y*scaleFactor);

				if(camera.InView(pos,80)){
					if(curUnit->beingBuilt){
/*						float complete=(1065353216-curUnit->beingBuilt)/1000.0;

						GLfloat gld[]=	{ 0.7f*complete, 1.4f*(1-complete)+0.7f*complete, 0.7f*complete, 1.0f };
						GLfloat gla[]=	{ 0.3f*complete, 0.6f*(1-complete)+0.3f*complete, 0.3f*complete, 1.0f };
*/						glLightfv(GL_LIGHT1, GL_AMBIENT, GreenLightAmbient);
						glLightfv(GL_LIGHT1, GL_DIFFUSE, GreenLightDiffuse);
						glPolygonMode(GL_FRONT_AND_BACK,GL_LINE);
						greenLight=true;
					} else {
						if(greenLight){
							greenLight=false;
							glLightfv(GL_LIGHT1, GL_AMBIENT, LightAmbientLand);		// Setup The Ambient Light
							glLightfv(GL_LIGHT1, GL_DIFFUSE, LightDiffuseLand);		// Setup The Diffuse Light
							glPolygonMode(GL_FRONT_AND_BACK,GL_FILL);
						}
					}
					glPushMatrix();
					glTranslatef3(pos);
					if(curUnit->turn.x!=0)
						glRotatef(curUnit->turn.x*(360.0f*(1/65536.0f)),0,1,0);
					if(curUnit->turn.y!=0)
						glRotatef(curUnit->turn.y*(360.0f*(1/65536.0f)),-1,0,0);
					if(curUnit->turn.z!=0)
						glRotatef(curUnit->turn.z*(360.0f*(1/65536.0f)),0,0,1);
					S3DO* model;
					if(strcmp(prevUnits[u].name,curUnit->name)==0){
						model=prevUnits[u].model;
					} else {
						model=unitparser->Load3DO((string("objects3d\\")+curUnit->name+".3do").c_str(),1,g.shared->players[p].color);
						prevUnits[u].model=model;
						strcpy(prevUnits[u].name,curUnit->name);
					}
					curPart=0;
					DrawPart(model);
					glPopMatrix();
					if(drawHealth){
						glTexCoord2f(PlasmaMidX,PlasmaMidY);
						glNormal3f(0,0.7f,0.7f);
						float h=curUnit->health/100.0;
						glColor3f(0.3f+(1-h),0.3+h*0.7,0.3f);
						float3 up(0,1,0);
						glBegin(GL_QUADS);
							glVertexf3(pos+camera.right*-9+up*(model->size+2)+camera.up*2);
							glVertexf3(pos+camera.right*(h*18-9)+up*(model->size+2)+camera.up*2);
							glVertexf3(pos+camera.right*(h*18-9)+up*(model->size+2));
							glVertexf3(pos+camera.right*-9+up*(model->size+2));
							glColor3f(0,0,0);
							glVertexf3(pos+camera.right*9+up*(model->size+2)+camera.up*2);
							glVertexf3(pos+camera.right*(h*18-9)+up*(model->size+2)+camera.up*2);
							glVertexf3(pos+camera.right*(h*18-9)+up*(model->size+2));
							glVertexf3(pos+camera.right*9+up*(model->size+2));
						glEnd();
					}
					if(drawKills && curUnit->kills){
						if(curUnit->kills>4)
							glColor3f(2,2.0,2.0);
						else
							glColor3f(2,0.5,0.5);
						glPushMatrix();
						glEnable(GL_ALPHA_TEST);
						glEnable(GL_BLEND);
						float3 up(0,1,0);
						glTranslatef3(pos+up*(model->size+4)-camera.right*2);
						glScalef(8,8,8);
						font->glWorldPrint("%d",curUnit->kills);						
						glDisable(GL_BLEND);
						glDisable(GL_ALPHA_TEST);
						glPopMatrix();
						texturehandler->SetTexture();
					}
					if(drawName && model->writeName){
						glColor3f(2,2.0,2.0);
						glPushMatrix();
						glEnable(GL_ALPHA_TEST);
						glEnable(GL_BLEND);
						float3 up(0,1,0);
						glTranslatef3(pos+up*(model->size+10)-camera.right*2);
						glScalef(8,8,8);
						font->glWorldPrint("%s",g.shared->players[p].name);						
						glDisable(GL_BLEND);
						glDisable(GL_ALPHA_TEST);
						glPopMatrix();
						texturehandler->SetTexture();						
					}
				}
			}
		}
	}
	glLightfv(GL_LIGHT1, GL_AMBIENT, LightAmbientLand);		// Setup The Ambient Light
	glLightfv(GL_LIGHT1, GL_DIFFUSE, LightDiffuseLand);		// Setup The Diffuse Light
	glPolygonMode(GL_FRONT_AND_BACK,GL_FILL);
#ifdef PROFILE_TIME
	LARGE_INTEGER stop;
	QueryPerformanceCounter(&stop);
	profiler.AddTime("Drawing units",stop.QuadPart - start.QuadPart);
#endif
}

void CUnitDrawer::DrawPart(S3DO* part)
{
	if(!part->isEmpty){
		glPushMatrix();
		SubPart* cp=&curUnit->parts[curPart];
		glTranslatef(cp->offset.x*scaleFactor+part->offset.x, cp->offset.z*scaleFactor+part->offset.y, -cp->offset.y*scaleFactor+part->offset.z);
		if(cp->turn.z!=0)
			glRotatef(cp->turn.z*(360.0f*(1/65536.0f)),0,1,0);
		if(cp->turn.x!=0)
			glRotatef(cp->turn.x*(360.0f*(1/65536.0f)),-1,0,0);
		if(cp->turn.y!=0)
			glRotatef(cp->turn.y*(360.0f*(1/65536.0f)),0,0,1);

		if(cp->visible)
			glCallList(part->displist);
	}
	curPart++;
	std::vector<S3DO>::iterator ci;
	for(ci=part->childs.begin();ci!=part->childs.end();++ci)
		DrawPart(ci);

	if(!part->isEmpty)
		glPopMatrix();
}
