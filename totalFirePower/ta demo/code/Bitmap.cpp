// Bitmap.cpp: implementation of the CBitmap class.
//
//////////////////////////////////////////////////////////////////////

#include "Bitmap.h"
#include <GL\glaux.h>
#include <ostream>
#include <fstream>
#include "jpeglib.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CBitmap::CBitmap()
: xsize(1),
	ysize(1)
{
	mem=new unsigned char[4];
}

CBitmap::~CBitmap()
{
	if(mem!=0)
		delete[] mem;
}

CBitmap::CBitmap(unsigned char *data, int xsize, int ysize)
: xsize(xsize),
	ysize(ysize)
{
	mem=new unsigned char[xsize*ysize*4];	
	memcpy(mem,data,xsize*ysize*4);
}

CBitmap::CBitmap(string filename)
: mem(0),
	xsize(0),
	ysize(0)
{
	Load(filename);
}

void CBitmap::Load(string filename)
{
	if(mem!=0)
		delete[] mem;

	if(filename.find(".jpg")!=string::npos)
		LoadJPG(filename);
	else
		LoadBMP(filename);
}


void CBitmap::Save(string filename)
{
	char* buf=new char[xsize*ysize*3];
	for(int a=0;a<xsize*ysize;a++){
		buf[a*3]=mem[a*4+2];
		buf[a*3+1]=mem[a*4+1];
		buf[a*3+2]=mem[a*4];
	}
	BITMAPFILEHEADER bmfh;
	bmfh.bfType=('B')+('M'<<8);
	bmfh.bfSize=sizeof(BITMAPFILEHEADER)+sizeof(BITMAPINFOHEADER)+ysize*xsize*3;
	bmfh.bfReserved1=0;
	bmfh.bfReserved2=0;
	bmfh.bfOffBits=sizeof(BITMAPINFOHEADER)+sizeof(BITMAPFILEHEADER);
	BITMAPINFOHEADER bmih;
	bmih.biSize=sizeof(BITMAPINFOHEADER);
	bmih.biWidth=xsize;
	bmih.biHeight=ysize;
	bmih.biPlanes=1;
	bmih.biBitCount=24;
	bmih.biCompression=BI_RGB;
	bmih.biSizeImage=0;
	bmih.biXPelsPerMeter=1000;
	bmih.biYPelsPerMeter=1000;
	bmih.biClrUsed=0;
	bmih.biClrImportant=0;
	std::ofstream ofs(filename.c_str(), std::ios::out|std::ios::binary);
	if(ofs.bad() || !ofs.is_open())
		MessageBox(0,"Couldnt save file",filename.c_str(),0);
	ofs.write((char*)&bmfh,sizeof(bmfh));
	ofs.write((char*)&bmih,sizeof(bmih));
	ofs.write((char*)buf,xsize*ysize*3);
	delete[] buf;
}

void CBitmap::LoadBMP(string filename)
{
	AUX_RGBImageRec *TextureImage=auxDIBImageLoad(filename.c_str());				

	if (TextureImage){
		xsize=TextureImage->sizeX;
		ysize=TextureImage->sizeY;

		mem=new unsigned char[xsize*ysize*4];
		for(int a=0;a<xsize*ysize;++a){
			mem[a*4]=TextureImage->data[a*3];
			mem[a*4+1]=TextureImage->data[a*3+1];
			mem[a*4+2]=TextureImage->data[a*3+2];
			mem[a*4+3]=255;
		}

		if (TextureImage->data)
		{
			free(TextureImage->data);
		}
		
		free(TextureImage);
	} else {
		xsize=1;
		ysize=1;
		mem=new unsigned char[4];
	}
}

void CBitmap::LoadJPG(string filename)
{
	struct jpeg_decompress_struct cinfo;
	jpeg_error_mgr jerr;
	FILE *pFile;

	if((pFile = fopen(filename.c_str(), "rb")) == NULL) 
	{
		// Display an error message saying the file was not found, then return NULL
		MessageBox(0, "Unable to load JPG File!", "Error", MB_OK);
		return;
	}

	cinfo.err = jpeg_std_error(&jerr);
	jpeg_create_decompress(&cinfo);
	jpeg_stdio_src(&cinfo, pFile);

	jpeg_read_header(&cinfo, TRUE);
	jpeg_start_decompress(&cinfo);

	int rowSpan = cinfo.image_width * cinfo.num_components;
	xsize = cinfo.image_width;
	ysize = cinfo.image_height;

	unsigned char* tempLine=new unsigned char[rowSpan];
	mem=new unsigned char[xsize*ysize*4];
	
	for(int y=0;y<ysize;++y){
		jpeg_read_scanlines(&cinfo, &tempLine, 1);
		for(int x=0;x<xsize;++x){
			mem[((ysize-1-y)*xsize+x)*4+0]=tempLine[x*3];
			mem[((ysize-1-y)*xsize+x)*4+1]=tempLine[x*3+1];
			mem[((ysize-1-y)*xsize+x)*4+2]=tempLine[x*3+2];
			mem[((ysize-1-y)*xsize+x)*4+3]=255;
		}
	}

	delete[] tempLine;
	jpeg_destroy_decompress(&cinfo);
	fclose(pFile);
}
