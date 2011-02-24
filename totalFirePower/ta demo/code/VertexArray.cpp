// VertexArray.cpp: implementation of the CVertexArray class.
//
//////////////////////////////////////////////////////////////////////

#include "VertexArray.h"
#include "mygl.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CVertexArray::CVertexArray()
{
	drawIndex=0;
	stripIndex=0;

	drawArray=new float[1000];
	drawArraySize=1000;
	stripArray=new int[1000];
	stripArraySize=1000;
}

CVertexArray::~CVertexArray()
{
	if(!nvidiaExt)
		delete[] drawArray;
	delete[] stripArray;
}

void CVertexArray::EndStrip()
{
	if(stripArraySize<stripIndex+2)
		EnlargeStripArray();
	stripArray[stripIndex++]=drawIndex;	
}

bool CVertexArray::IsReady()
{
	return true;
}

CVertexArray::Initialize()
{
	stripIndex=0;
	drawIndex=0;
}

void CVertexArray::AddVertexT(float3 &pos, float tx, float ty)
{
	if(drawArraySize<drawIndex+10)
		EnlargeDrawArray();
	drawArray[drawIndex++]=pos.x;
	drawArray[drawIndex++]=pos.y;
	drawArray[drawIndex++]=pos.z;
	drawArray[drawIndex++]=tx;
	drawArray[drawIndex++]=ty;
}

void CVertexArray::AddVertex2DT(float x,float y, float tx, float ty)
{
	if(drawArraySize<drawIndex+10)
		EnlargeDrawArray();
	drawArray[drawIndex++]=x;
	drawArray[drawIndex++]=y;
	drawArray[drawIndex++]=0;
	drawArray[drawIndex++]=tx;
	drawArray[drawIndex++]=ty;
}

void CVertexArray::AddVertexT2(float3 &pos, float t1x, float t1y, float t2x, float t2y)
{
	if(drawArraySize<drawIndex+10)
		EnlargeDrawArray();
	drawArray[drawIndex++]=pos.x;
	drawArray[drawIndex++]=pos.y;
	drawArray[drawIndex++]=pos.z;
	drawArray[drawIndex++]=t1x;
	drawArray[drawIndex++]=t1y;
	drawArray[drawIndex++]=t2x;
	drawArray[drawIndex++]=t2y;
}

void CVertexArray::AddVertexTN(float3 &pos, float tx, float ty, float3 &norm)
{
	if(drawArraySize<drawIndex+10)
		EnlargeDrawArray();
	drawArray[drawIndex++]=pos.x;
	drawArray[drawIndex++]=pos.y;
	drawArray[drawIndex++]=pos.z;
	drawArray[drawIndex++]=tx;
	drawArray[drawIndex++]=ty;
	drawArray[drawIndex++]=norm.x;
	drawArray[drawIndex++]=norm.y;
	drawArray[drawIndex++]=norm.z;
}

void CVertexArray::AddVertexTC(float3 &pos, float tx, float ty, unsigned char *color)
{
	if(drawArraySize<drawIndex+10)
		EnlargeDrawArray();
	drawArray[drawIndex++]=pos.x;
	drawArray[drawIndex++]=pos.y;
	drawArray[drawIndex++]=pos.z;
	drawArray[drawIndex++]=tx;
	drawArray[drawIndex++]=ty;
	drawArray[drawIndex++]=*(float*)color;
}

void CVertexArray::DrawArrayT(int drawType,int stride)
{
	if(stripIndex==0 || stripArray[stripIndex-1]!=drawIndex)
		EndStrip();
	glVertexPointer(3,GL_FLOAT,stride,&drawArray[0]);
	glTexCoordPointer(2,GL_FLOAT,stride,&drawArray[3]);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_VERTEX_ARRAY);
	int oldIndex=0;
	for(int a=0;a<stripIndex;a++){
		glDrawArrays(drawType,oldIndex*4/stride,stripArray[a]*4/stride-oldIndex*4/stride);
		oldIndex=stripArray[a];
	}
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_VERTEX_ARRAY);						
}

void CVertexArray::DrawArray2DT(int drawType,int stride)
{
	if(stripIndex==0 || stripArray[stripIndex-1]!=drawIndex)
		EndStrip();
	glVertexPointer(3,GL_FLOAT,stride,&drawArray[0]);
	glTexCoordPointer(2,GL_FLOAT,stride,&drawArray[3]);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_VERTEX_ARRAY);
	int oldIndex=0;
	for(int a=0;a<stripIndex;a++){
		glDrawArrays(drawType,oldIndex*4/stride,stripArray[a]*4/stride-oldIndex*4/stride);
		oldIndex=stripArray[a];
	}
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_VERTEX_ARRAY);						
}

void CVertexArray::DrawArrayT2(int drawType,int stride)
{
	if(stripIndex==0 || stripArray[stripIndex-1]!=drawIndex)
		EndStrip();
	glVertexPointer(3,GL_FLOAT,stride,&drawArray[0]);
	glTexCoordPointer(2,GL_FLOAT,stride,&drawArray[3]);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_VERTEX_ARRAY);
	if(multiTextureEnabled){
		glClientActiveTextureARB(GL_TEXTURE1_ARB);
		glTexCoordPointer(2,GL_FLOAT,stride,&drawArray[5]);
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
		glClientActiveTextureARB(GL_TEXTURE0_ARB);
	}
	int oldIndex=0;
	for(int a=0;a<stripIndex;a++){
		glDrawArrays(drawType,oldIndex*4/stride,stripArray[a]*4/stride-oldIndex*4/stride);
		oldIndex=stripArray[a];
	}
	if(multiTextureEnabled){
		glClientActiveTextureARB(GL_TEXTURE1_ARB);
		glDisableClientState(GL_TEXTURE_COORD_ARRAY);
		glClientActiveTextureARB(GL_TEXTURE0_ARB);
	}
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_VERTEX_ARRAY);						
}

void CVertexArray::DrawArrayTN(int drawType, int stride)
{
	if(stripIndex==0 || stripArray[stripIndex-1]!=drawIndex)
		EndStrip();
	glVertexPointer(3,GL_FLOAT,stride,&drawArray[0]);
	glTexCoordPointer(2,GL_FLOAT,stride,&drawArray[3]);
	glNormalPointer(GL_FLOAT,stride,&drawArray[5]);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_NORMAL_ARRAY);
	
	int oldIndex=0;
	for(int a=0;a<stripIndex;a++){
		glDrawArrays(drawType,oldIndex*4/stride,stripArray[a]*4/stride-oldIndex*4/stride);
		oldIndex=stripArray[a];
	}
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_VERTEX_ARRAY);						
	glDisableClientState(GL_NORMAL_ARRAY);
}

void CVertexArray::DrawArrayTC(int drawType, int stride)
{
	if(stripIndex==0 || stripArray[stripIndex-1]!=drawIndex)
		EndStrip();
	glVertexPointer(3,GL_FLOAT,stride,&drawArray[0]);
	glTexCoordPointer(2,GL_FLOAT,stride,&drawArray[3]);
	glColorPointer(4,GL_UNSIGNED_BYTE,stride,&drawArray[5]);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);
	
	int oldIndex=0;
	for(int a=0;a<stripIndex;a++){
		glDrawArrays(drawType,oldIndex*4/stride,stripArray[a]*4/stride-oldIndex*4/stride);
		oldIndex=stripArray[a];
	}
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_VERTEX_ARRAY);						
	glDisableClientState(GL_COLOR_ARRAY);
}

void CVertexArray::EnlargeDrawArray()
{
	float* da=new float[drawArraySize*2];
	for(int a=0;a<drawArraySize;++a)
		da[a]=drawArray[a];
	delete[] drawArray;
	drawArray=da;
	drawArraySize*=2;
}

void CVertexArray::EnlargeStripArray()
{
	int* sa=new int[stripArraySize*2];
	for(int a=0;a<stripArraySize;++a)
		sa[a]=stripArray[a];
	delete[] stripArray;
	stripArray=sa;
	stripArraySize*=2;
}
