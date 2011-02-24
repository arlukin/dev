// TreeDrawer.cpp: implementation of the CTreeDrawer class.
//
//////////////////////////////////////////////////////////////////////

#include "TreeDrawer.h"
#include "grounddrawer.h"
#include "ground.h"
#include "camera.h"
#include "vertexarray.h"
#include "readmap.h"
#include <windows.h>		// Header File For Windows
#include "mygl.h"
//#include <gl\glu.h>			// Header File For The GLu32 Library
//#include <gl\glaux.h>		// Header File For The Glaux Library
#include "irenderer.h"
#include "tamem.h"
#include "texturehandler.h"
#include "3doparser.h"
#include "featurehandler.h"
#include "hpihandler.h"
#include "otareader.h"
#include "timeprofiler.h"
#include "bitmap.h"
#include "featurehandler.h"
#include "gaf.h"
#include "tapalette.h"
#include "reghandler.h"
#include "infoconsole.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

using namespace std;
extern GLfloat LightAmbientLand[];
extern GLfloat LightAmbientWreck[];

CTreeDrawer::CTreeDrawer()
{
	if(g.features==0)
		return;

	PrintLoadMsg("Loading tree texture");

	lastListClean=0;

	CBitmap TexImage("bitmaps\\gran.bmp");
	unsigned char(* gran)[512][4]=new unsigned char[1024][512][4]; 
	if (TexImage.xsize>1){
		for(int y=0;y<256;y++){
			for(int x=0;x<256;x++){
				if(TexImage.mem[(y*256+x)*4]==72 && TexImage.mem[(y*256+x)*4+1]==72){
					gran[y][x][0]=33;
					gran[y][x][1]=54;
					gran[y][x][2]=29;
					gran[y][x][3]=0;
					ground->granMem[y][x]=0;
				} else {
					gran[y][x][0]=TexImage.mem[(y*256+x)*4];
					gran[y][x][1]=TexImage.mem[(y*256+x)*4+1];
					gran[y][x][2]=TexImage.mem[(y*256+x)*4+2];
					gran[y][x][3]=255;
					ground->granMem[y][x]=1;
				}
			}
		}
	}

	TexImage.Load("bitmaps\\gran2.bmp");
	if (TexImage.xsize>1){
		for(int y=0;y<256;y++){
			for(int x=0;x<256;x++){
				if(TexImage.mem[(y*256+x)*4]==72 && TexImage.mem[(y*256+x)*4+1]==72){
					gran[y][x+256][0]=33;
					gran[y][x+256][1]=54;
					gran[y][x+256][2]=29;
					gran[y][x+256][3]=0;
					ground->granMem[y][x+256]=0;
				} else {
					gran[y][x+256][0]=TexImage.mem[(y*256+x)*4];
					gran[y][x+256][1]=TexImage.mem[(y*256+x)*4+1];
					gran[y][x+256][2]=TexImage.mem[(y*256+x)*4+2];
					gran[y][x+256][3]=255;
					ground->granMem[y][x+256]=1;
				}
			}
		}
	}
/*
	TexImage.Load("bitmaps\\birch1.bmp");
	if (TexImage.xsize>1){
		for(int y=0;y<256;y++){
			for(int x=0;x<128;x++){
				if(TexImage.mem[(y*128+x)*4]==72 && TexImage.mem[(y*128+x)*4+1]==72){
					gran[y+256][x][0]=125*0.6f;;
					gran[y+256][x][1]=146*0.7f;;
					gran[y+256][x][2]=82*0.6f;;
					gran[y+256][x][3]=0;
					ground->birchMem[y][x]=0;
				} else {
					gran[y+256][x][0]=TexImage.mem[(y*128+x)*4]*0.6f;
					gran[y+256][x][1]=TexImage.mem[(y*128+x)*4+1]*0.7f;
					gran[y+256][x][2]=TexImage.mem[(y*128+x)*4+2]*0.6f;
					gran[y+256][x][3]=255;
					ground->birchMem[y][x]=1;
				}
			}
		}
	}

	TexImage.Load("bitmaps\\birch2.bmp");
	if (TexImage.xsize>1){
		for(int y=0;y<256;y++){
			for(int x=0;x<128;x++){
				if(TexImage.mem[(y*128+x)*4]==72 && TexImage.mem[(y*128+x)*4+1]==72){
					gran[y+256][x+128][0]=125*0.6f;;
					gran[y+256][x+128][1]=146*0.7f;;
					gran[y+256][x+128][2]=82*0.6f;;
					gran[y+256][x+128][3]=0;
					ground->birchMem[y][x+128]=0;
				} else {
					gran[y+256][x+128][0]=TexImage.mem[(y*128+x)*4]*0.6f;
					gran[y+256][x+128][1]=TexImage.mem[(y*128+x)*4+1]*0.7f;
					gran[y+256][x+128][2]=TexImage.mem[(y*128+x)*4+2]*0.6f;
					gran[y+256][x+128][3]=255;
					ground->birchMem[y][x+128]=1;
				}
			}
		}
	}

	TexImage.Load("bitmaps\\birch3.bmp");
	if (TexImage.xsize>1){
		for(int y=0;y<256;y++){
			for(int x=0;x<256;x++){
				if(TexImage.mem[(y*256+x)*4]==72 && TexImage.mem[(y*256+x)*4+1]==72){
					gran[y+256][x+256][0]=125*0.6f;;
					gran[y+256][x+256][1]=146*0.7f;
					gran[y+256][x+256][2]=82*0.6f;;
					gran[y+256][x+256][3]=0;
					ground->birchMem[y][x+256]=0;
				} else {
					gran[y+256][x+256][0]=TexImage.mem[(y*256+x)*4]*0.6f;
					gran[y+256][x+256][1]=TexImage.mem[(y*256+x)*4+1]*0.7f;
					gran[y+256][x+256][2]=TexImage.mem[(y*256+x)*4+2]*0.6f;
					gran[y+256][x+256][3]=255;
					ground->birchMem[y][x+256]=1;
				}
			}
		}
	}
*/
	CreateTreeTex(treetex,gran[0][0],512,1024);

	xSquares=g.shared->FeatureMapXSize/16;
	ySquares=g.shared->FeatureMapYSize/16;
	numSquares=xSquares*ySquares;
	xFeatures=g.shared->FeatureMapXSize;

	features=new Feature[numSquares];
	featureDef=new FeatureDef[g.shared->NumFeatureDef];

	bool drawScars=!!regHandler.GetInt("DrawScars",1);

	for(int a=0;a<g.shared->NumFeatureDef;++a){
		string name=g.featureDef[a].Name;
		CFeatureHandler::MakeLower(name);
		string file=featureHandler.name2file[name];
		char res[50];

//		if(name.find("rago")!=string::npos)
//			MessageBox(0,file.c_str(),name.c_str(),0);

		int size=hpiHandler->GetFileSize(file);
		unsigned char* fileBuf=new unsigned char[size+1];
		fileBuf[size]=0;
		hpiHandler->LoadFile(file,fileBuf);
		CFeatureHandler::MakeLower((char*)fileBuf);

		if(getOTAValue((char*)fileBuf,(name+".object").c_str(),res)){
			featureDef[a].type=0;
			featureDef[a].object=unitparser->Load3DO((string("objects3d\\")+res+".3do").c_str());
		} else {
			featureDef[a].type=3;
			if(getOTAValue((char*)fileBuf,(name+".description").c_str(),res))
				if(strcmp(res,"tree")==0 || strcmp(res,"oolok tree")==0)
					featureDef[a].type=1;
			if(getOTAValue((char*)fileBuf,(name+".indestructible").c_str(),res) && atoi(res)==1
				&& (!getOTAValue((char*)fileBuf,(name+".reclaimable").c_str(),res) || atoi(res)==0)
				&& (!getOTAValue((char*)fileBuf,(name+".blocking").c_str(),res) || atoi(res)==0)){
				CreateInMapFeature(a,fileBuf,name);
			}else if((!getOTAValue((char*)fileBuf,(name+".blocking").c_str(),res) || atoi(res)==0) && (getOTAValue((char*)fileBuf,(name+".seqname").c_str(),res))){
		/*getOTAValue((char*)fileBuf,(name+".description").c_str(),res) && (strcmp(res,"damaged terrain")==0 || strcmp(res,"foliage")==0) && drawScars){*/
				;
				if(getOTAValue((char*)fileBuf,(name+".animtrans").c_str(),res) && atoi(res)==1)
					CreateInMapFeature(a,fileBuf,name,160);
				else
					CreateInMapFeature(a,fileBuf,name);
			}
		}

		delete[] fileBuf;
	}

	for(int y=0;y<ySquares;y++){
		for(int x=0;x<xSquares;x++){
			features[y*xSquares+x].wrecklist=0;
			features[y*xSquares+x].displist=0;
			features[y*xSquares+x].farDisplist=0;
		}
	}
}

CTreeDrawer::~CTreeDrawer()
{
	if(g.features==0)
		return;

	delete[] features;
	delete[] featureDef;
//	glDeleteTextures (1, &treetex);
}

static CVertexArray* va;

static void inline SetArray(float t1,float t2,float3 v)
{
	va->AddVertexT(v,t1,t2);
}

void CTreeDrawer::Draw(float treeDistance)
{
	if(g.features==0)
		return;

#ifdef PROFILE_TIME
	LARGE_INTEGER start;
	QueryPerformanceCounter(&start);
#endif
	int cx=(int)(camera.pos.x/(SQUARE_SIZE*16));
	int cy=(int)(camera.pos.z/(SQUARE_SIZE*16));
	
	int treeSquare=int(treeDistance*2)+1;

	texturehandler->SetTexture();	
	glLightfv(GL_LIGHT1, GL_AMBIENT, LightAmbientWreck);		// Setup The Ambient Light
	glEnable(GL_LIGHTING);
	glDisable(GL_ALPHA_TEST);
	glEnable(GL_COLOR_MATERIAL);
	int sy=cy-treeSquare;
	if(sy<0)
		sy=0;
	int ey=cy+treeSquare;
	if(ey>ySquares-1)
		ey=ySquares-1;
	for(int y=sy;y<=ey;y++){
		int sx=cx-treeSquare;
		if(sx<0)
			sx=0;
		int ex=cx+treeSquare;
		if(ex>xSquares-1)
			ex=xSquares-1;
		float xtest,xtest2;
		std::vector<CGroundDrawer::fline>::iterator fli;
		for(fli=groundDrawer->left.begin();fli!=groundDrawer->left.end();fli++){
			xtest=((fli->base/SQUARE_SIZE+fli->dir*(y*16)));
			xtest2=((fli->base/SQUARE_SIZE+fli->dir*((y*16)+16)));
			if(xtest>xtest2)
				xtest=xtest2;
			xtest=xtest/16;
			if(xtest>sx)
				sx=xtest;
		}
		for(fli=groundDrawer->right.begin();fli!=groundDrawer->right.end();fli++){
			xtest=((fli->base/SQUARE_SIZE+fli->dir*(y*16)));
			xtest2=((fli->base/SQUARE_SIZE+fli->dir*((y*16)+16)));
			if(xtest<xtest2)
				xtest=xtest2;
			xtest=xtest/16;
			if(xtest<ex)
				ex=xtest;
		}
		for(int x=sx;x<=ex;x++){/**/
			float3 dif;
			dif.x=camera.pos.x-(x*SQUARE_SIZE*16+SQUARE_SIZE*8);
			dif.y=0;
			dif.z=camera.pos.z-(y*SQUARE_SIZE*16+SQUARE_SIZE*8);
			float dist=dif.Length();
			dif/=dist;
			
			if(unsigned int(y*xSquares+x-g.frameNum)%4==0){
				int sum=0;
				for(int y2=0;y2<16;y2++){
					for(int x2=0;x2<16;x2++){
						FeatureStruct* fs=&g.features[(y*16+y2)*xFeatures+x*16+x2];
						if(fs->FeatureDefIndex!=0)
							sum=(sum+fs->FeatureDefIndex)*fs->FeatureDefIndex;
					}
				}
				if(sum!=features[y*xSquares+x].checkSum){
					features[y*xSquares+x].checkSum=sum;
					if(features[y*xSquares+x].wrecklist){
						glDeleteLists(features[y*xSquares+x].wrecklist,1);
						features[y*xSquares+x].wrecklist=0;
					}
					if(features[y*xSquares+x].displist){
						glDeleteLists(features[y*xSquares+x].displist,1);
						features[y*xSquares+x].displist=0;
					}
					if(features[y*xSquares+x].farDisplist){
						glDeleteLists(features[y*xSquares+x].farDisplist,1);
						features[y*xSquares+x].farDisplist=0;
					}
				}
			}
			if(dist<SQUARE_SIZE*16*treeDistance*2){
				features[y*xSquares+x].lastSeen=g.frameNum;

				if(!features[y*xSquares+x].wrecklist){
					features[y*xSquares+x].wrecklist=glGenLists(1);
					glNewList(features[y*xSquares+x].wrecklist,GL_COMPILE);
					for(int y2=0;y2<16;y2++){
						for(int x2=0;x2<16;x2++){
							FeatureStruct* fs=&g.features[(y*16+y2)*xFeatures+x*16+x2];
							if(fs->FeatureDefIndex>=0 && fs->WreckageInfoIndex>=0 && featureDef[fs->FeatureDefIndex].type==0){
								
								WreckageInfoStruct* ws=&g.wreckInfo[fs->WreckageInfoIndex];

								glPushMatrix();
								float3 pos(ws->XPos*(1/65536.0f),ws->ZPos*(1/65536.0f),ws->YPos*(1/65536.0f));
								glTranslatef3(pos+featureDef[fs->FeatureDefIndex].object->offset);
								if(ws->XTurn!=0)
									glRotatef(ws->XTurn*(360.0f*(1/65536.0f)),0,1,0);
								if(ws->YTurn!=0)
									glRotatef(ws->YTurn*(360.0f*(1/65536.0f)),-1,0,0);
								if(ws->ZTurn!=0)
									glRotatef(ws->ZTurn*(360.0f*(1/65536.0f)),0,0,1);

								glCallList(featureDef[fs->FeatureDefIndex].object->displist);					
								glPopMatrix();
							}
						}
					}
					glEndList();
				}

				glColor4f(1,1,1,1);			
				glDisable(GL_BLEND);
				glAlphaFunc(GL_GREATER,0.5f);
				glCallList(features[y*xSquares+x].wrecklist);
			}
		}
	}
	glDisable(GL_COLOR_MATERIAL);
	glDisable(GL_LIGHTING);
	glLightfv(GL_LIGHT1, GL_AMBIENT, LightAmbientLand);		// Setup The Ambient Light
	glAlphaFunc(GL_GREATER,0.5f);
	glBindTexture(GL_TEXTURE_2D, treetex);
	glEnable(GL_ALPHA_TEST);
	for(y=sy;y<=ey;y++){
		int sx=cx-treeSquare;
		if(sx<0)
			sx=0;
		int ex=cx+treeSquare;
		if(ex>xSquares-1)
			ex=xSquares-1;
		float xtest,xtest2;
		std::vector<CGroundDrawer::fline>::iterator fli;
		for(fli=groundDrawer->left.begin();fli!=groundDrawer->left.end();fli++){
			xtest=((fli->base/SQUARE_SIZE+fli->dir*(y*16)));
			xtest2=((fli->base/SQUARE_SIZE+fli->dir*((y*16)+16)));
			if(xtest>xtest2)
				xtest=xtest2;
			xtest=xtest/16;
			if(xtest>sx)
				sx=xtest;
		}
		for(fli=groundDrawer->right.begin();fli!=groundDrawer->right.end();fli++){
			xtest=((fli->base/SQUARE_SIZE+fli->dir*(y*16)));
			xtest2=((fli->base/SQUARE_SIZE+fli->dir*((y*16)+16)));
			if(xtest<xtest2)
				xtest=xtest2;
			xtest=xtest/16;
			if(xtest<ex)
				ex=xtest;
		}
		for(int x=sx;x<=ex;x++){/**/
			float3 dif;
			dif.x=camera.pos.x-(x*SQUARE_SIZE*16+SQUARE_SIZE*8);
			dif.y=0;
			dif.z=camera.pos.z-(y*SQUARE_SIZE*16+SQUARE_SIZE*8);
			float dist=dif.Length();
			dif/=dist;
			
			if(dist<SQUARE_SIZE*16*treeDistance*2 && dist>SQUARE_SIZE*16*(treeDistance)){
				features[y*xSquares+x].lastSeen=g.frameNum;
				if(!features[y*xSquares+x].farDisplist || dif.dot(features[y*xSquares+x].viewVector)<0.97){
					va=GetVertexArray();
					va->Initialize();
					features[y*xSquares+x].viewVector=dif;
					if(!features[y*xSquares+x].farDisplist)
						features[y*xSquares+x].farDisplist=glGenLists(1);
					float3 up(0,1,0);
					float3 side=up.cross(dif);
					for(int y2=0;y2<16;y2++){
						for(int x2=0;x2<16;x2++){
							FeatureStruct* fs=&g.features[(y*16+y2)*xFeatures+x*16+x2];
							if(fs->FeatureDefIndex>=0 && featureDef[fs->FeatureDefIndex].type==1){
								srand((y*16+y2)*764332+(x*16+x2)*23421);
								rand();
								float size=7;
								float dx=(x*16+x2)*(SQUARE_SIZE)+SQUARE_SIZE/2;
								float dy=(y*16+y2)*(SQUARE_SIZE)+SQUARE_SIZE/2;
								float3 base(dx,ground->GetHeight(dx,dy),dy);
								float height=size*(6+float(rand())/RAND_MAX*3);
								float width=size*(2+float(rand())/RAND_MAX);
								
								SetArray(0,0,base+side*width);
								SetArray(0,0.25,base+side*width+float3(0,height,0));
								SetArray(0.5f,0.25,base-side*width+float3(0,height,0));
								SetArray(0.5f,0,base-side*width);
							}
						}
					}
					glNewList(features[y*xSquares+x].farDisplist,GL_COMPILE);
					va->DrawArrayT(GL_QUADS);
					glEndList();
				}
				if(dist>SQUARE_SIZE*16*(treeDistance*2-1)){
					float trans=(SQUARE_SIZE*16*treeDistance*2-dist)/(SQUARE_SIZE*16);
					glEnable(GL_BLEND);
					glColor4f(1,1,1,trans);
					glAlphaFunc(GL_GREATER,(SQUARE_SIZE*16*treeDistance*2-dist)/(SQUARE_SIZE*32));
				} else {
					glColor4f(1,1,1,1);			
					glDisable(GL_BLEND);
					glAlphaFunc(GL_GREATER,0.5f);
				}
				glCallList(features[y*xSquares+x].farDisplist);
			}
			
			if(dist<SQUARE_SIZE*16*treeDistance){
				features[y*xSquares+x].lastSeen=g.frameNum;
				if(!features[y*xSquares+x].displist){
					va=GetVertexArray();
					va->Initialize();
					features[y*xSquares+x].displist=glGenLists(1);
					for(int y2=0;y2<16;y2++){
						for(int x2=0;x2<16;x2++){
							FeatureStruct* fs=&g.features[(y*16+y2)*xFeatures+x*16+x2];
							if(fs->FeatureDefIndex>=0 && featureDef[fs->FeatureDefIndex].type==1){
								srand((y*16+y2)*764332+(x*16+x2)*23421);
								rand();
								float size=7;
								float dx=(x*16+x2)*(SQUARE_SIZE)+SQUARE_SIZE/2;
								float dy=(y*16+y2)*(SQUARE_SIZE)+SQUARE_SIZE/2;
								float3 base(dx,ground->GetHeight(dx,dy),dy);
								float height=size*(6+float(rand())/RAND_MAX*3);
								float width=size*(2+float(rand())/RAND_MAX);
								SetArray(0,0,base+float3(width,0,0));
								SetArray(0,0.25,base+float3(width,height,0));
								SetArray(0.5f,0.25,base+float3(-width,height,0));
								SetArray(0.5f,0,base+float3(-width,0,0));
									
								SetArray(0,0,base+float3(0,0,width));
								SetArray(0,0.25,base+float3(0,height,width));
								SetArray(0.5f,0.25,base+float3(0,height,-width));
								SetArray(0.5f,0,base+float3(0,0,-width));
									
								width*=1.2f;
								SetArray(0.5,0,base+float3(width,height*0.25,0));
								SetArray(0.5,0.25,base+float3(0,height*0.25,-width));
								SetArray(1,0.25,base+float3(-width,height*0.25,0));
								SetArray(1,0,base+float3(0,height*0.25,width));
							}
						}
					}
					glNewList(features[y*xSquares+x].displist,GL_COMPILE);
					va->DrawArrayT(GL_QUADS);
					glEndList();
				}
				glColor4f(1,1,1,1);			
				glDisable(GL_BLEND);
				glAlphaFunc(GL_GREATER,0.5f);
				glCallList(features[y*xSquares+x].displist);
			}
		}
	}

	int startClean=lastListClean*50%(numSquares);
	int endClean=g.frameNum*50%(numSquares);
	if(startClean>endClean){
		for(int a=startClean;a<numSquares;a++){
			TestClean(a);
		}
		for(a=0;a<endClean;a++){
			TestClean(a);
		}
	} else {
		for(int a=startClean;a<endClean;a++){
			TestClean(a);
		}
	}
#ifdef PROFILE_TIME
	LARGE_INTEGER stop;
	QueryPerformanceCounter(&stop);
	profiler.AddTime("Drawing features",stop.QuadPart - start.QuadPart);
#endif
}

void CTreeDrawer::CreateTreeTex(unsigned int& texnum, unsigned char *data, int xsize, int ysize)
{
	glGenTextures(1, &texnum);
	glBindTexture(GL_TEXTURE_2D, texnum);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_NEAREST);
	int mipnum=0;
	glTexImage2D(GL_TEXTURE_2D,mipnum,4 ,xsize, ysize,0, GL_RGBA, GL_UNSIGNED_BYTE, data);
	while(xsize!=1 || ysize!=1){		
		mipnum++;
		if(xsize!=1)
			xsize/=2;
		if(ysize!=1)
			ysize/=2;
		for(int y=0;y<ysize;++y){
			for(int x=0;x<xsize;++x){
/*				for(int a=0;a<3;a++){
					int temp=0;
					int num=0;
					if(data[(y*2*xsize*2+x*2)*4+3]){
						temp+=data[(y*2*xsize*2+x*2)*4+a];
						num++;
					}
					if(data[((y*2+1)*xsize*2+x*2)*4+3]){
						temp+=data[((y*2+1)*xsize*2+x*2)*4+a];
						num++;
					}
					if(data[((y*2)*xsize*2+x*2+1)*4+3]){
						temp+=data[((y*2)*xsize*2+x*2+1)*4+a];
						num++;
					}
					if(data[((y*2+1)*xsize*2+x*2+1)*4+3]){
						temp+=data[((y*2+1)*xsize*2+x*2+1)*4+a];
						num++;
					}
					if(num>1)
						temp/=num;
					data[(y*xsize+x)*4+a]=temp;
				}
*/			data[(y*xsize+x)*4+0]=(data[(y*2*xsize*2+x*2)*4+0]+data[((y*2+1)*xsize*2+x*2)*4+0]+data[(y*2*xsize*2+x*2+1)*4+0]+data[((y*2+1)*xsize*2+x*2+1)*4+0])/4;
				data[(y*xsize+x)*4+1]=(data[(y*2*xsize*2+x*2)*4+1]+data[((y*2+1)*xsize*2+x*2)*4+1]+data[(y*2*xsize*2+x*2+1)*4+1]+data[((y*2+1)*xsize*2+x*2+1)*4+1])/4;
				data[(y*xsize+x)*4+2]=(data[(y*2*xsize*2+x*2)*4+2]+data[((y*2+1)*xsize*2+x*2)*4+2]+data[(y*2*xsize*2+x*2+1)*4+2]+data[((y*2+1)*xsize*2+x*2+1)*4+2])/4;
				data[(y*xsize+x)*4+3]=(data[(y*2*xsize*2+x*2)*4+3]+data[((y*2+1)*xsize*2+x*2)*4+3]+data[(y*2*xsize*2+x*2+1)*4+3]+data[((y*2+1)*xsize*2+x*2+1)*4+3])/4;
				if(data[(y*xsize+x)*4+3]>=127){
					data[(y*xsize+x)*4+3]=255;
				} else {
					data[(y*xsize+x)*4+3]=0;
				}
			}
		}
		glTexImage2D(GL_TEXTURE_2D,mipnum,4 ,xsize, ysize,0, GL_RGBA, GL_UNSIGNED_BYTE, data);
	}
}

void CTreeDrawer::TestClean(int a)
{
	if(features[a].lastSeen>g.frameNum-100)
		return;

	if(features[a].wrecklist){
		glDeleteLists(features[a].wrecklist,1);
		features[a].wrecklist=0;
	}
	if(features[a].displist){
		glDeleteLists(features[a].displist,1);
		features[a].displist=0;
	}
	if(features[a].farDisplist){
		glDeleteLists(features[a].farDisplist,1);
		features[a].farDisplist=0;
	}
}

void CTreeDrawer::CreateInMapFeature(int a, unsigned char *tdfBuf, string &name,int defAlpha)
{
	char res[64];
	char res2[64];

	if(getOTAValue((char*)tdfBuf,(name+".seqname").c_str(),res)){
		featureDef[a].type=2;
		getOTAValue((char*)tdfBuf,(name+".filename").c_str(),res2);
				
		unsigned char* t=(unsigned char*)gafHandler->GetGaf(res,(string("anims\\")+res2+".gaf").c_str());
		if(t==0){
//			MessageBox(0,"Couldnt find gaf",(char*)&fileBuf[featureDefPos+a*0x84+4],0);
			featureDef[a].xsize[0]=0;
			featureDef[a].ysize[0]=0;
			featureDef[a].lods[0]=0;
		featureDef[a].type=3;
			delete[] t;
			return;
		}
				
		featureDef[a].xsize[0]=gafHandler->Width;
		featureDef[a].ysize[0]=gafHandler->Height;

		featureDef[a].xoffset=gafHandler->xOffset;
		featureDef[a].yoffset=gafHandler->yOffset;
				
		featureDef[a].lods[0]=new unsigned char[gafHandler->Width*gafHandler->Height*4];
		unsigned char seeThrough=t[0];	//hack, what color is really transparent ?

		if(seeThrough!=9)//continue hacking :)
			seeThrough=0;
			//(*info) << seeThrough << name.c_str() << "\n";
		for(int b=0;b<gafHandler->Width*gafHandler->Height;++b){
			featureDef[a].lods[0][b*4+0]=palette[t[b]][0];
			featureDef[a].lods[0][b*4+1]=palette[t[b]][1];
			featureDef[a].lods[0][b*4+2]=palette[t[b]][2];
			if(t[b]!=seeThrough)
				featureDef[a].lods[0][b*4+3]=defAlpha;
			else
				featureDef[a].lods[0][b*4+3]=0;
		}
		for(b=1;b<3;++b){
			featureDef[a].xsize[b]=featureDef[a].xsize[b-1]/2;
			featureDef[a].ysize[b]=featureDef[a].ysize[b-1]/2;
			featureDef[a].lods[b]=new unsigned char[featureDef[a].xsize[b]*featureDef[a].ysize[b]*4];
					
			for(int y=0;y<featureDef[a].ysize[b];++y){
				for(int x=0;x<featureDef[a].xsize[b];++x){
					int alpha=0;
					int red=0,green=0,blue=0;
					for(int y2=0;y2<2;++y2){
						for(int x2=0;x2<2;++x2){
							int cAlpha=featureDef[a].lods[b-1][((y*2+y2)*featureDef[a].xsize[b-1]+(x*2+x2))*4+3];
							red  +=featureDef[a].lods[b-1][((y*2+y2)*featureDef[a].xsize[b-1]+(x*2+x2))*4+0]*cAlpha;
							green+=featureDef[a].lods[b-1][((y*2+y2)*featureDef[a].xsize[b-1]+(x*2+x2))*4+1]*cAlpha;
							blue +=featureDef[a].lods[b-1][((y*2+y2)*featureDef[a].xsize[b-1]+(x*2+x2))*4+2]*cAlpha;
							alpha+=cAlpha;
						}
					}
					if(alpha>0){
						featureDef[a].lods[b][(y*featureDef[a].xsize[b]+x)*4+0]=red/alpha;
						featureDef[a].lods[b][(y*featureDef[a].xsize[b]+x)*4+1]=green/alpha;
						featureDef[a].lods[b][(y*featureDef[a].xsize[b]+x)*4+2]=blue/alpha;
						featureDef[a].lods[b][(y*featureDef[a].xsize[b]+x)*4+3]=alpha/4;
					} else {
						featureDef[a].lods[b][(y*featureDef[a].xsize[b]+x)*4+3]=0;
					}
				}
			}
		}
		delete[] t;
	}
}
