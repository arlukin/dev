// 3DOParser.h: interface for the C3DOParser class.
//
//////////////////////////////////////////////////////////////////////
#pragma warning(disable:4786)

#if !defined(AFX_3DOPARSER_H__C67F6602_9466_11D4_AD55_0080ADA84DE3__INCLUDED_)
#define AFX_3DOPARSER_H__C67F6602_9466_11D4_AD55_0080ADA84DE3__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include <vector>
#include <string>
#include "float3.h"
#include <iostream>
#include <fstream>
#include "texturehandler.h"
#include <map>

using namespace std;

struct SVertex {
	float3 pos;
	float3 normal;
	std::vector<int> prims;
};

struct SPrimitive {
	std::vector<int> vertices;
	float3 normal;
	int numVertex;
	taTexture* texture;
	float color[4];
};

struct S3DO {
//	std::string name;
	std::vector<S3DO> childs;
	std::vector<SPrimitive> prims;
	std::vector<SVertex> vertices;
	float3 offset;
	unsigned int displist;
	bool isEmpty;
	float size;
	bool writeName;
};

class C3DOParser  
{
public:
	float FindSize(S3DO* object,float3 offset);
	void CalcNormals(S3DO* o);
	typedef struct _3DObject
	{
		long VersionSignature;
		long NumberOfVertices;
		long NumberOfPrimitives;
		long SelectionPrimitive;
		long XFromParent;
		long YFromParent;
		long ZFromParent;
		long OffsetToObjectName;
		long Always_0;
		long OffsetToVertexArray;
		long OffsetToPrimitiveArray;
		long OffsetToSiblingObject;
		long OffsetToChildObject;
	} _3DObject;

	typedef struct _Vertex
	{
		long x;
		long y;
		long z;
	} _Vertex;

	typedef struct _Primitive
	{
		long PaletteEntry;
		long NumberOfVertexIndexes;
		long Always_0;
		long OffsetToVertexIndexArray;
		long OffsetToTextureName;
		long Unknown_1;
		long Unknown_2;
		long Unknown_3;    
	} _Primitive;

	typedef std::vector<float3> vertex_vector;

	C3DOParser();
	virtual ~C3DOParser();
	S3DO* Load3DO(const char* name,float scale=1,int side=2);
	DeleteS3DO(S3DO* o);
	CreateLists(S3DO* o);
	float scaleFactor;
private:
	GetPrimitives(S3DO* obj,int pos,int num,vertex_vector* vv,int excludePrim,int side);
	GetVertexes(_3DObject* o,S3DO* object);
	std::string GetText(int pos);
	bool ReadChild(int pos,S3DO* root,int side);
	DrawSub(S3DO* o);
	
	map<string,S3DO*> units;

	int curOffset;
	unsigned char* fileBuf;
	void SimStreamRead(void* buf,int length);
};

extern C3DOParser* unitparser;

#endif // !defined(AFX_3DOPARSER_H__C67F6602_9466_11D4_AD55_0080ADA84DE3__INCLUDED_)
