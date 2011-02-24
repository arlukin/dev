// DrawTree.cpp: implementation of the CDrawTree class.
//
//////////////////////////////////////////////////////////////////////
/*
#include "DrawTree.h"
#include <windows.h>		// Header File For Windows
#include "mygl.h"
#include <gl\glu.h>			// Header File For The GLu32 Library
#include <gl\glaux.h>		// Header File For The Glaux Library
#include "globalstuff.h"
#include "vertexarray.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CDrawTree::CDrawTree()
{
	AUX_RGBImageRec *TextureImage=auxDIBImageLoad("bark.bmp");
	unsigned char(* tree)[512][4]=new unsigned char[256][512][4]; 
	if (TextureImage)
	{
		for(int y=0;y<256;y++){
			for(int x=0;x<256;x++){
				tree[y][x][0]=TextureImage->data[(y*256+x)*3];
				tree[y][x][1]=TextureImage->data[(y*256+x)*3+1];
				tree[y][x][2]=TextureImage->data[(y*256+x)*3+2];
				tree[y][x][3]=255;
			}
		}
	}
	// free the image structure
	if (TextureImage)
	{
		if (TextureImage->data)
		{
			free(TextureImage->data);
		}	
		free(TextureImage);
	}

	TextureImage=auxDIBImageLoad("leaf.bmp");
	if (TextureImage)
	{
		for(int y=0;y<256;y++){
			for(int x=0;x<256;x++){
				if(TextureImage->data[(y*256+x)*3]==0 && TextureImage->data[(y*256+x)*3+1]==0){
					tree[y][x+256][0]=125*0.6f;
					tree[y][x+256][1]=146*0.7f;
					tree[y][x+256][2]=82*0.6f;
					tree[y][x+256][3]=0;
				} else {
					tree[y][x+256][0]=TextureImage->data[(y*256+x)*3];
					tree[y][x+256][1]=TextureImage->data[(y*256+x)*3+1];
					tree[y][x+256][2]=TextureImage->data[(y*256+x)*3+2];
					tree[y][x+256][3]=255;
				}
			}
		}
	}
	// free the image structure
	if (TextureImage)
	{
		if (TextureImage->data)
		{
			free(TextureImage->data);
		}	
		free(TextureImage);
	}

	int xsize=512;
	int ysize=256;
	unsigned char* data=tree[0][0];
	glGenTextures(1, &barkTex);
	glBindTexture(GL_TEXTURE_2D, barkTex);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_NEAREST);
	gluBuild2DMipmaps(GL_TEXTURE_2D,4 ,512, 256, GL_RGBA, GL_UNSIGNED_BYTE, data);

	delete[] tree;
	displist=0;
}

CDrawTree::~CDrawTree()
{
	glDeleteTextures (1, &barkTex);
	if(displist!=0)
		glDeleteLists(displist,1);
}

void CDrawTree::Draw()
{
	if(displist==0){
		va=GetVertexArray();
		va->Initialize();
		barkva=GetVertexArray();
		barkva->Initialize();

		displist=glGenLists(1);
		glNewList(displist,GL_COMPILE);
		srand(15);
		glEnable(GL_LIGHTING);
		glLightModeli(GL_LIGHT_MODEL_TWO_SIDE,GL_TRUE);
		glDisable(GL_NORMALIZE);
		glColorMaterial(GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE);
		glEnable(GL_COLOR_MATERIAL);
		glEnable(GL_TEXTURE_2D);
		glBindTexture(GL_TEXTURE_2D, barkTex);
		glEnable(GL_ALPHA_TEST);
		glDisable(GL_BLEND);

		float3 pos(1500,50,1500);
		TrunkIterator(pos,float3(0,1,0),100,10,5);

		glColor3f(0.3f,0.7f,0.3f);
		va->DrawArrayTN(GL_QUADS);
		glColor3f(1,0.8f,0.7f);
		barkva->DrawArrayTN(GL_TRIANGLE_STRIP);

		glDisable(GL_ALPHA_TEST);
		glDisable(GL_TEXTURE_2D);
		glDisable(GL_LIGHTING);
		glDisable(GL_COLOR_MATERIAL);
		glEndList();
	}
	glCallList(displist);
}

void CDrawTree::DrawTrunk(float3 &start, float3 &end,float3& orto1,float3& orto2, float size)
{
	for(int a=0;a<11;a++){
		float angle=a/10.0*2*PI;
		barkva->AddVertexTN(start+orto1*sin(angle)*size+orto2*cos(angle)*size,angle/PI*0.25,0,-orto1*sin(angle)-orto2*cos(angle));
		barkva->AddVertexTN(end+orto1*sin(angle)*size*0.7f+orto2*cos(angle)*size*0.7f,angle/PI*0.25,3,-orto1*sin(angle)-orto2*cos(angle));
	}
	barkva->EndStrip();
}

void CDrawTree::TrunkIterator(float3 &start, float3 &dir, float length, float size, int depth)
{
	if(depth==0)
		length*=3;

	float3 orto1;
	if(dir.dot(float3(0,0,1))<0.9)
		orto1=dir.cross(float3(0,0,1));
	else
		orto1=dir.cross(float3(1,0,0));
	orto1.Normalize();
	float3 orto2=dir.cross(orto1);
	orto2.Normalize();

	DrawTrunk(start,start+dir*length,orto1,orto2,size);

	if(depth<=1)
		CreateLeaves(start,dir,length,orto1,orto2);

	if(depth==0)
		return;
	
	float baseRot=double(rand())/RAND_MAX*2*PI;
	float dirDif=double(rand())/RAND_MAX*0.8+0.6;
	int numTrunks=3;//double(rand())/RAND_MAX*3+3;
	for(int a=0;a<numTrunks;a++){
		float angle=baseRot+float(a)/numTrunks*2*PI;
		float3 newbase=start+dir*length*0.97f;
		float3 newDir=dir+orto1*sin(angle)*dirDif+orto2*cos(angle)*dirDif;
		newDir.Normalize();
		TrunkIterator(newbase,newDir,length*0.6,size*0.5,depth-1);
	}
}

void CDrawTree::CreateLeaves(float3 &start, float3 &dir, float length,float3& orto1,float3& orto2)
{
	float baseRot=double(rand())/RAND_MAX*2*PI;
	int numLeaves=double(rand())/RAND_MAX*5+5;

	for(int a=0;a<numLeaves+1;a++){
		float3 pos=start+dir*a*length/numLeaves;
		float angle=baseRot+a*0.618*2*PI;

		float3 out=(orto1*sin(angle)+orto2*cos(angle))*3;
		float3 side=(-orto1*cos(angle)+orto2*sin(angle))*3;

		va->AddVertexTN(pos+side+out*1.5+dir*3,0.52f,0.98f,dir);
		va->AddVertexTN(pos-side+out*1.5+dir*4,0.98f,0.98f,dir);
		va->AddVertexTN(pos-side,0.98f,0.02f,dir);
		va->AddVertexTN(pos+side,0.52f,0.02f,dir);
	}
//	va->EndStrip();
}
*/