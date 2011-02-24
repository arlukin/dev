// Bitmap.h: interface for the CBitmap class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_BITMAP_H__BBA7EEE5_879F_4ABE_A878_51FE098C3A0D__INCLUDED_)
#define AFX_BITMAP_H__BBA7EEE5_879F_4ABE_A878_51FE098C3A0D__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include <string>

using std::string;

class CBitmap  
{
public:
	void LoadJPG(string filename);
	void LoadBMP(string filename);
	void Save(string filename);
	CBitmap(unsigned char* data,int xsize,int ysize);
	void Load(string filename);
	CBitmap(string filename);
	CBitmap();
	virtual ~CBitmap();

	unsigned char* mem;
	int xsize;
	int ysize;
};

#endif // !defined(AFX_BITMAP_H__BBA7EEE5_879F_4ABE_A878_51FE098C3A0D__INCLUDED_)
