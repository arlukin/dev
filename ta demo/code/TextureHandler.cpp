// TextureHandler.cpp: implementation of the CTextureHandler class.
//
//////////////////////////////////////////////////////////////////////

#include "TextureHandler.h"

#include "windows.h"
#include <gl\gl.h>			// Header file for the openGL32 library
#include <gl\glu.h>			// Header file for the gLu32 library
#include <gl\glaux.h>		// Header file for the glaux library
#include <math.h>
#include "tapalette.h"
#include "gaf.h"
#include "infoconsole.h"
#include <vector>
#include "bitmap.h"
#include "globalstuff.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CTextureHandler* texturehandler;
static bool texCreated=false;

using namespace std;

CTextureHandler::CTextureHandler()
{
	newTexFound=true;
	taTexture* t=new taTexture;
	t->xstart=0;
	t->ystart=0;
	t->xend=0;
	t->yend=0;
	textures[" "]=t;
	ifstream iifs("tatex.bin",ios::in|ios::binary);
	if(iifs.is_open()){
		while(!iifs.bad() && iifs.peek()!=EOF){
			char c;
			iifs.read(&c,1);
			std::string name,realname;
			while(c!=0){
				name+=c;
				iifs.read(&c,1);
			}
			iifs.read(&c,1);
			while(c!=0){
				realname+=c;
				iifs.read(&c,1);
			}
			short xs,ys,xe,ye,side;
			iifs.read((char*)&xs,sizeof(short));
			iifs.read((char*)&ys,sizeof(short));
			iifs.read((char*)&xe,sizeof(short));
			iifs.read((char*)&ye,sizeof(short));
			iifs.read((char*)&side,sizeof(short));

			taTexture* tt=new taTexture;
			tt->xstart=float(xs)/1024+1/2048.0;
			tt->ystart=float(ys)/2048+1/4096.0;
			tt->xend=float(xs+xe)/1024-1/2048.0;
			tt->yend=float(ys+ye)/2048-1/4096.0;
			tt->side=side;
			tt->realName=realname;
			textures[name]=tt;
		}
	}
}

struct tatex2 {
	unsigned char* data;
	int xsize;
	int ysize;
	std::string name,realname;
	int side;
};

static int CompareTatex2( const void *arg1, const void *arg2 ){
	if(((tatex2*)arg1)->ysize > ((tatex2*)arg2)->ysize)
	   return -1;
   return 1;
}

CTextureHandler::~CTextureHandler()
{
	std::map<std::string,taTexture*>::iterator tti;
	textures.erase(" ");
	if(newTexFound){
		tatex2 *ysort=new tatex2[textures.size()];

		int a=0;
		for(tti=textures.begin();tti!=textures.end();++tti){
			unsigned char* t=(unsigned char*)gafHandler->GetGaf(tti->second->realName.c_str(),tti->second->side);
			if(gafHandler->Width==0 || t==0){
				continue;
			}

			tatex2 temp;
			temp.xsize=gafHandler->Width;
			temp.ysize=gafHandler->Height;
			temp.name=tti->first;
			temp.realname=tti->second->realName;
			temp.side=tti->second->side;
			temp.data=t;
			ysort[a++]=temp;;
		}
		qsort(ysort,textures.size(),sizeof(tatex2),CompareTatex2);

		unsigned char* tex=new unsigned char[1024*2048*4];
		for(a=0;a<1024*2048*4;++a){
			tex[a]=0;
		}
		int cury=32;
		int curx=128;	//make place for plasma and lighting
		int maxy=96;
		ofstream iofs("tatex.bin",ios::out|ios::binary);
		for(a=0;a<textures.size();++a){
			if(curx+ysort[a].xsize>=1024){
				curx=0;
				cury=maxy;
			}
			if(cury+ysort[a].ysize>maxy){
				maxy=cury+ysort[a].ysize;
			}
			if(maxy>2048)
				break;
			for(int y=0;y<ysort[a].ysize;y++){
				for(int x=0;x<ysort[a].xsize;x++){
					int taCol=ysort[a].data[y*ysort[a].xsize+x];
					for(int col=0;col<3;col++){
						tex[(cury+y)*1024*4+(curx+x)*4+col]=palette[taCol][col];
					}
				}
			}
			delete[] ysort[a].data;

			const char* c=ysort[a].name.c_str();
			iofs.write(c,strlen(c)+1);
			c=ysort[a].realname.c_str();
			iofs.write(c,strlen(c)+1);

			short s=curx;
			iofs.write((char*)&s,sizeof(short));
			s=cury;
			iofs.write((char*)&s,sizeof(short));
			s=ysort[a].xsize;
			iofs.write((char*)&s,sizeof(short));
			s=ysort[a].ysize;
			iofs.write((char*)&s,sizeof(short));
			s=ysort[a].side;
			iofs.write((char*)&s,sizeof(short));
			curx+=ysort[a].xsize;
		}
		CBitmap bm(tex,1024,2048);
		bm.Save("tatex.bmp");
		delete[] tex;
	}
	for(tti=textures.begin();tti!=textures.end();++tti){
		delete tti->second;
	}
	if(texCreated)
		glDeleteTextures (1, &(globalTex));

	std::map<std::string,BigTex>::iterator bti;
	for(bti=bigTex.begin();bti!=bigTex.end();++bti)
		glDeleteTextures (1, &(bti->second.tex));
}

taTexture* CTextureHandler::GetTexture(const char *name,int side)
{
	bigTexFound=false;
	if(!texCreated){
		texCreated=true;
		CBitmap bm("tatex.bmp");
		
		glGenTextures(1, &globalTex);
		
		glBindTexture(GL_TEXTURE_2D, globalTex);
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_NEAREST);

		if(bm.xsize>100){
			
			for(int a=0;a<bm.xsize*bm.ysize;++a){
				if(bm.mem[a*4+0]==0 && bm.mem[a*4+1]==0 && bm.mem[a*4+2]==0){
					bm.mem[a*4+0]=0;
					bm.mem[a*4+1]=0;
					bm.mem[a*4+2]=0;
					bm.mem[a*4+3]=0;
				}
				if(bm.mem[a*4+0]==palette[9][0] && bm.mem[a*4+1]==palette[9][1] && bm.mem[a*4+2]==palette[9][2])
					bm.mem[a*4+3]=0;
			}
			for(int y=0;y<64;y++){		//add plasma ball
				for(int x=0;x<64;x++){
					float dist=sqrt((x-32)*(x-32)+(y-32)*(y-32));
					if(dist>31.5)
						dist=31.5;
					bm.mem[((y+32)*bm.xsize+x)*4+0]=(255-dist*4);//*((255-dist*8)/255);
					bm.mem[((y+32)*bm.xsize+x)*4+1]=(255-dist*4);//*((255-dist*8)/255);
					bm.mem[((y+32)*bm.xsize+x)*4+2]=(255-dist*4);//*((255-dist*8)/255);
					bm.mem[((y+32)*bm.xsize+x)*4+3]=255-dist*8;
				}
			}
			for(y=0;y<64;y++){		//add laser
				for(int x=0;x<64;x++){
					float dist=abs(y-32);
					if(dist>31.5)
						dist=31.5;
					bm.mem[((y+32)*bm.xsize+x+64)*4+0]=(255-dist*4);//*((255-dist*8)/255);
					bm.mem[((y+32)*bm.xsize+x+64)*4+1]=(255-dist*4);//*((255-dist*8)/255);
					bm.mem[((y+32)*bm.xsize+x+64)*4+2]=(255-dist*4);//*((255-dist*8)/255);
					bm.mem[((y+32)*bm.xsize+x+64)*4+3]=255-dist*8;
				}
			}
			for(int x=0;x<1024;x++){		//add lighting
				float rad=x*(PI/64);

				float y1=sin(rad)*12+16;
				float y2=-sin(rad)*12+16;

				for(int y=0;y<32;++y){
					float value=0;
					if(fabs(y1-y)<3)
						value+=1-fabs(y1-y)/3;
					if(fabs(y2-y)<3)
						value+=1-fabs(y2-y)/3;
					if(value>1)
						value=1;
					bm.mem[((y)*bm.xsize+x)*4+0]=255;//value*255;
					bm.mem[((y)*bm.xsize+x)*4+1]=255;//value*255;
					bm.mem[((y)*bm.xsize+x)*4+2]=255;//value*255;
					bm.mem[((y)*bm.xsize+x)*4+3]=value*255;
				}
			}
			gluBuild2DMipmaps(GL_TEXTURE_2D, 4,bm.xsize, bm.ysize, GL_RGBA, GL_UNSIGNED_BYTE, bm.mem);
//			bm.Save("tex.bmp");
		}
		//delete[] tex;
	}

	std::string sidename=name;
	sidename+=side+'Z';

	std::map<std::string,taTexture*>::iterator tti;
	if((tti=textures.find(sidename))!=textures.end()){
		return tti->second;
	}

	if((tti=textures.find(name))!=textures.end()){
		return tti->second;
	}

	std::map<std::string,BigTex>::iterator bti;
	if((bti=bigTex.find(sidename))!=bigTex.end()){
		bigTexFound=true;
		bigTexX=bti->second.xsize;
		bigTexY=bti->second.ysize;
		curBigTexId=bti->second.tex;
		return textures[" "];
	}

	
	taTexture* tex=new taTexture;		
	unsigned char* t=(unsigned char*)gafHandler->GetGaf(name,side);
	if(gafHandler->Width==0 || t==0){
		(*info) << "Error couldnt find texture " << name << "\n";
		return textures[" "];
	}

	if(gafHandler->Height>64 && gafHandler->Width>64){
//		(*info) << "bigtex " << name << "\n";
		bigTexFound=true;
		bigTexX=gafHandler->Width;
		bigTexY=gafHandler->Height;
		unsigned char* tm=new unsigned char[gafHandler->Width*gafHandler->Height*4];
		for(int a=0;a<gafHandler->Width*gafHandler->Height;++a){
			tm[a*4+0]=palette[t[a]][0];
			tm[a*4+1]=palette[t[a]][1];
			tm[a*4+2]=palette[t[a]][2];
			if(t[a]==0)
				tm[a*4+3]=0;
			else
				tm[a*4+3]=255;
		}
		unsigned int texId;
		glGenTextures(1, &texId);
		glBindTexture(GL_TEXTURE_2D, texId);
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_NEAREST);
		gluBuild2DMipmaps(GL_TEXTURE_2D, 4,gafHandler->Width, gafHandler->Height, GL_RGBA, GL_UNSIGNED_BYTE, tm);
		curBigTexId=texId;

		BigTex bt;
		bt.tex=texId;
		bt.xsize=gafHandler->Width;
		bt.ysize=gafHandler->Height;
		bigTex[sidename]=bt;
		delete[] tm;
		delete[] t;
		return textures[" "];			
	}
	delete[] t;

	(*info) << "New texture found " << name << "\n";
	newTexFound=true;
	tex->xstart=0;
	tex->ystart=0;
	tex->xend=0;
	tex->yend=0;

	bool sideFound=gafHandler->SubFrames;
		
	tex->realName=name;
	tex->side=side;

	if(sideFound){
		textures[sidename]=tex;
		return textures[sidename];
	} else {
		textures[name]=tex;
		return textures[name];
	}
}

void CTextureHandler::SetTexture()
{
	glBindTexture(GL_TEXTURE_2D, globalTex);
}

void CTextureHandler::SetBigTex()
{
	glBindTexture(GL_TEXTURE_2D, curBigTexId);
}
