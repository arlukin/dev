// TextureHandler.h: interface for the CTextureHandler class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_TEXTUREHANDLER_H__C6D286E1_997B_11D4_AD55_0080ADA84DE3__INCLUDED_)
#define AFX_TEXTUREHANDLER_H__C6D286E1_997B_11D4_AD55_0080ADA84DE3__INCLUDED_

#pragma warning(disable:4786)

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include <map>
#include <string>
class CGaf;

//#define GEN_TEX_FROM_GAF

struct taTexture {
	float xstart;
	float xend;
	float ystart;
	float yend;
	int side;
	std::string realName;
};

class CTextureHandler  
{
public:
	void SetBigTex();
	void SetTexture();
	taTexture* GetTexture(const char* name,int side);
	CTextureHandler();
	virtual ~CTextureHandler();

	bool bigTexFound;
	int bigTexX;
	int bigTexY;
private:
	struct BigTex {
		unsigned int tex;
		int xsize,ysize;
	};
	std::map<std::string,BigTex> bigTex;
	std::map<std::string,taTexture*> textures;
	unsigned int globalTex;
	unsigned int curBigTexId;
	bool newTexFound;
};
extern CTextureHandler* texturehandler;

#endif // !defined(AFX_TEXTUREHANDLER_H__C6D286E1_997B_11D4_AD55_0080ADA84DE3__INCLUDED_)
