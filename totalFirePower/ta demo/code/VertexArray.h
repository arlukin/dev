// VertexArray.h: interface for the CVertexArray class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_VERTEXARRAY_H__20C3F7EB_96DF_11D5_AA72_9A847018DE3E__INCLUDED_)
#define AFX_VERTEXARRAY_H__20C3F7EB_96DF_11D5_AA72_9A847018DE3E__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "float3.h"

class CVertexArray  
{
public:
	CVertexArray();
	virtual ~CVertexArray();
	virtual Initialize();

	void AddVertexTC(float3 &pos,float tx,float ty,unsigned char* color);
	virtual void DrawArrayTC(int drawType,int stride=24);
	void AddVertexTN(float3 &pos,float tx,float ty,float3& norm);
	virtual void DrawArrayTN(int drawType,int stride=32);
	void AddVertexT2(float3& pos,float t1x,float t1y,float t2x,float t2y);
	virtual void DrawArrayT2(int drawType,int stride=28);
	void AddVertexT(float3& pos,float tx,float ty);
	virtual void DrawArrayT(int drawType,int stride=20);
	void AddVertex2DT(float x,float y,float tx,float ty);
	virtual void DrawArray2DT(int drawType,int stride=20);

	virtual void EnlargeStripArray();
	virtual void EnlargeDrawArray();
	void EndStrip();
	virtual bool IsReady();

	float* drawArray;
	int drawArraySize;
	int drawIndex;

	int* stripArray;
	int stripArraySize;
	int stripIndex;
};

#endif // !defined(AFX_VERTEXARRAY_H__20C3F7EB_96DF_11D5_AA72_9A847018DE3E__INCLUDED_)
