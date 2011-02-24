// 3DOParser.cpp: implementation of the C3DOParser class.
//
//////////////////////////////////////////////////////////////////////

#include "3DOParser.h"
#include <math.h>
#include <iostream>
#include <ostream>
#include <fstream>
#include <windows.h>
#include "mygl.h"
//#include <gl\glu.h>			// Header File For The GLu32 Library
//#include <gl\glaux.h>		// Header File For The Glaux Library
#include "globalstuff.h"
#include "tapalette.h"
#include "infoconsole.h"
#include <vector>
#include "vertexarray.h"
#include "hpihandler.h"
#include <set>

using namespace std;

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

C3DOParser* unitparser;

C3DOParser::C3DOParser()
{
	scaleFactor=400000.0f;
}

C3DOParser::~C3DOParser()
{
	map<string,S3DO*>::iterator ui;
	for(ui=units.begin();ui!=units.end();++ui){
		DeleteS3DO(ui->second);
		delete ui->second;
	}
}


C3DOParser::DeleteS3DO(S3DO *o)
{
	glDeleteLists(o->displist,1);
	std::vector<S3DO>::iterator di;
	for(di=o->childs.begin();di!=o->childs.end();di++)
		DeleteS3DO(di);
}

S3DO* C3DOParser::Load3DO(const char *name,float scale,int side)
{
	scaleFactor=1/(65536.0f);

	string sideName(name);
	hpiHandler->MakeLower(sideName);
	sideName+=side+'0';

	map<string,S3DO*>::iterator ui;
	if((ui=units.find(sideName))!=units.end()){
		return ui->second;
	}

//	ifstream ifs(name, ios::in|ios::binary);
	int size=hpiHandler->GetFileSize(name);
	if(size==0){
		MessageBox(0,"No file",name,0);
		return 0;
	}
	fileBuf=new unsigned char[size];
	hpiHandler->LoadFile(name,fileBuf);
	
	S3DO* object=new S3DO;
//	object->name=name;
	
	_3DObject root;
//	ifs.seekg(0);
//	ifs.read((char*)&root,sizeof(_3DObject));
	curOffset=0;
	SimStreamRead(&root,sizeof(_3DObject));

	std::vector<float3> vertexes;
	
	GetVertexes(&root,object);
	GetPrimitives(object,root.OffsetToPrimitiveArray,root.NumberOfPrimitives,&vertexes,root.SelectionPrimitive,side);
	CalcNormals(object);
	if(root.OffsetToChildObject>0)
		if(!ReadChild(root.OffsetToChildObject,object,side))
			object->isEmpty=false;

	object->offset.x=root.XFromParent*scaleFactor;
	object->offset.y=root.YFromParent*scaleFactor;
	object->offset.z=root.ZFromParent*scaleFactor;

	object->size=FindSize(object,float3(0,0,0));

	units[sideName]=object;

	if(sideName.find("armcom")!=string::npos || sideName.find("corcom")!=string::npos)
		object->writeName=true;
	else
		object->writeName=false;

	CreateLists(object);

//	ifs.Close();
	delete[] fileBuf;
	return object;
}

C3DOParser::	GetVertexes(_3DObject* o,S3DO* object)
{
	curOffset=o->OffsetToVertexArray;
	for(int a=0;a<o->NumberOfVertices;a++){
		_Vertex v;
		SimStreamRead(&v,sizeof(_Vertex));

		SVertex vertex;
		float3 f;
		f.x=-(v.x)*scaleFactor;
		f.y=(v.y)*scaleFactor;
		f.z=(v.z)*scaleFactor;
		vertex.pos=f;
		object->vertices.push_back(vertex);
	}
}

C3DOParser::GetPrimitives(S3DO *obj, int pos, int num,vertex_vector* vv,int excludePrim,int side)
{
	map<int,int> prevHashes;

	for(int a=0;a<num;a++){
		if(excludePrim==a){
			continue;
		}
		curOffset=pos+a*sizeof(_Primitive);
		_Primitive p;

		SimStreamRead(&p,sizeof(_Primitive));
		SPrimitive sp;
		sp.numVertex=p.NumberOfVertexIndexes;

		if(sp.numVertex<3)
			continue;

		curOffset=p.OffsetToVertexIndexArray;
		WORD w;
		
		list<int> orderVert;
		for(int b=0;b<sp.numVertex;b++){
			SimStreamRead(&w,2);
			sp.vertices.push_back(w);
			orderVert.push_back(w);
		}
		orderVert.sort();
		list<int>::iterator vi;
		int vertHash=0;

		for(vi=orderVert.begin();vi!=orderVert.end();++vi)
			vertHash=(vertHash+*vi)**vi;

		sp.texture=0;
		if(p.OffsetToTextureName!=0){
			sp.texture=texturehandler->GetTexture(GetText(p.OffsetToTextureName).c_str(),side);
			if(sp.texture==0)
				(*info) << "Parser couldnt get texture " << GetText(p.OffsetToTextureName).c_str() << "\n";
		} else {
			sp.color[0]=palette[p.PaletteEntry][0]/float(255);
			sp.color[1]=palette[p.PaletteEntry][1]/float(255);
			sp.color[2]=palette[p.PaletteEntry][2]/float(255);
			sp.color[3]=palette[p.PaletteEntry][3]/float(255);
		}
		float3 n=-(obj->vertices[sp.vertices[1]].pos-obj->vertices[sp.vertices[0]].pos).cross(obj->vertices[sp.vertices[2]].pos-obj->vertices[sp.vertices[0]].pos);
		n.Normalize();
		sp.normal=n;
		
		if(n.dot(float3(0,-1,0))>0.99){
			int ignore=true;
			for(int a=0;a<sp.numVertex;++a)
				if(obj->vertices[sp.vertices[1]].pos.y>0)
					ignore=false;
			continue;
		}

		map<int,int>::iterator phi;
		if((phi=prevHashes.find(vertHash))!=prevHashes.end()){
			if(n.y>0){
				obj->prims[phi->second]=sp;
				continue;
			} else {
				continue;
			}
		} else {
			prevHashes[vertHash]=obj->prims.size();
			obj->prims.push_back(sp);
			obj->isEmpty=false;
		}
		curOffset=p.OffsetToVertexIndexArray;
		
		for(b=0;b<sp.numVertex;b++){
			SimStreamRead(&w,2);
			obj->vertices[w].prims.push_back(obj->prims.size()-1);
		}
	}
}

void C3DOParser::CalcNormals(S3DO *o)
{
	std::vector<SVertex>::iterator vi;
	for(vi=o->vertices.begin();vi!=o->vertices.end();++vi){
		std::vector<int>::iterator pi;
		float3 n(0,0,0);
		for(pi=vi->prims.begin();pi!=vi->prims.end();++pi){
			n+=o->prims[*pi].normal;
		}
		n.Normalize();
		vi->normal=n;
	}
}

std::string C3DOParser::GetText(int pos)
{
//	ifs->seekg(pos);
	curOffset=pos;
	char c;
	std::string s;
//	ifs->read(&c,1);
	SimStreamRead(&c,1);
	while(c!=0){
		s+=c;
//		ifs->read(&c,1);
		SimStreamRead(&c,1);
	}	
	return s;
}

bool C3DOParser::ReadChild(int pos, S3DO *root,int side)
{
	S3DO object;
	_3DObject me;

	curOffset=pos;
	SimStreamRead(&me,sizeof(_3DObject));

	object.offset.x=-me.XFromParent*scaleFactor;
	object.offset.y=me.YFromParent*scaleFactor;
	object.offset.z=me.ZFromParent*scaleFactor;
	std::vector<float3> vertexes;
	object.isEmpty=true;

	GetVertexes(&me,&object);
	GetPrimitives(&object,me.OffsetToPrimitiveArray,me.NumberOfPrimitives,&vertexes,me.SelectionPrimitive,side);
	CalcNormals(&object);

	bool ret=object.isEmpty;

	if(me.OffsetToChildObject>0)
		if(!ReadChild(me.OffsetToChildObject,&object,side)){
			ret=false;
			object.isEmpty=false;
		}

	root->childs.push_back(object);

	if(me.OffsetToSiblingObject>0)
		if(!ReadChild(me.OffsetToSiblingObject,root,side))
			ret=false;

	return ret;
}

C3DOParser::DrawSub(S3DO* o)
{
	CVertexArray* va=GetVertexArray();
	va->Initialize();
	bool nonTexFound=false;
	std::vector<SPrimitive>::iterator ps;
	taTexture* tex;
	for(ps=o->prims.begin();ps!=o->prims.end();ps++){
		if(ps->texture!=0 && ps->numVertex==4){
			tex=ps->texture;
			va->AddVertexTN(o->vertices[ps->vertices[0]].pos,tex->xstart,tex->ystart,o->vertices[ps->vertices[0]].normal);
			va->AddVertexTN(o->vertices[ps->vertices[1]].pos,tex->xend,tex->ystart,o->vertices[ps->vertices[1]].normal);
			va->AddVertexTN(o->vertices[ps->vertices[2]].pos,tex->xend,tex->yend,o->vertices[ps->vertices[2]].normal);
			va->AddVertexTN(o->vertices[ps->vertices[3]].pos,tex->xstart,tex->yend,o->vertices[ps->vertices[3]].normal);
		} else if(ps->numVertex==4){
			if(!nonTexFound){
				glDisable(GL_TEXTURE_2D);
				nonTexFound=true;
			}
			glColor3f(ps->color[0],ps->color[1],ps->color[2]);
			glBegin(GL_QUADS);
				float3 t=o->vertices[ps->vertices[0]].pos;
				glNormalf3(o->vertices[ps->vertices[0]].normal);
				glVertex3f(t.x,t.y,t.z);
				t=o->vertices[ps->vertices[1]].pos;
				glNormalf3(o->vertices[ps->vertices[1]].normal);
				glVertex3f(t.x,t.y,t.z);
				t=o->vertices[ps->vertices[2]].pos;
				glNormalf3(o->vertices[ps->vertices[2]].normal);
				glVertex3f(t.x,t.y,t.z);
				t=o->vertices[ps->vertices[3]].pos;
				glNormalf3(o->vertices[ps->vertices[3]].normal);
				glVertex3f(t.x,t.y,t.z);
			glEnd();
		} else if (ps->numVertex==3) {
			if(!nonTexFound){
				glDisable(GL_TEXTURE_2D);
				nonTexFound=true;
			}
			glColor3f(ps->color[0],ps->color[1],ps->color[2]);
			glBegin(GL_TRIANGLES);
				float3 t=o->vertices[ps->vertices[0]].pos;
				glNormalf3(o->vertices[ps->vertices[0]].normal);
				glVertex3f(t.x,t.y,t.z);
				t=o->vertices[ps->vertices[1]].pos;
				glNormalf3(o->vertices[ps->vertices[1]].normal);
				glVertex3f(t.x,t.y,t.z);
				t=o->vertices[ps->vertices[2]].pos;
				glNormalf3(o->vertices[ps->vertices[2]].normal);
				glVertex3f(t.x,t.y,t.z);
			glEnd();
		} else {
			if(!nonTexFound){
				glDisable(GL_TEXTURE_2D);
				nonTexFound=true;
			}
			glNormal3f(ps->normal.x,ps->normal.y,ps->normal.z);
			glColor3f(ps->color[0],ps->color[1],ps->color[2]);
			glBegin(GL_TRIANGLE_FAN);
				std::vector<int>::iterator fi;
				for(fi=ps->vertices.begin();fi!=ps->vertices.end();fi++){
					float3 t=o->vertices[(*fi)].pos;
					glNormalf3(o->vertices[*fi].normal);
					glVertex3f(t.x,t.y,t.z);
				}
			glEnd();

		}
	}
	if(nonTexFound){
		glEnable(GL_TEXTURE_2D);
		glColor3f(1,1,1);
	}
	va->DrawArrayTN(GL_QUADS);
}

C3DOParser::CreateLists(S3DO *o)
{
	o->displist=glGenLists(1);
	glNewList(o->displist,GL_COMPILE);
		glColor3f(1,1,1);
		DrawSub(o);
	glEndList();

	std::vector<S3DO>::iterator bs;
	for(bs=o->childs.begin();bs!=o->childs.end();bs++){
		CreateLists(bs);
	}
}

void C3DOParser::SimStreamRead(void *buf, int length)
{
	memcpy(buf,&fileBuf[curOffset],length);
	curOffset+=length;
}


float C3DOParser::FindSize(S3DO *object, float3 offset)
{
	offset+=object->offset;
	float maxSize=0;

	std::vector<SVertex>::iterator vi;
	for(vi=object->vertices.begin();vi!=object->vertices.end();++vi){
		float dist=(offset+vi->pos).Length();
		if(dist>maxSize)
			maxSize=dist;
	}

	std::vector<S3DO>::iterator si;
	for(si=object->childs.begin();si!=object->childs.end();++si){
		float dist=FindSize(si,offset);
		if(dist>maxSize)
			maxSize=dist;
	}

	return maxSize;
}
