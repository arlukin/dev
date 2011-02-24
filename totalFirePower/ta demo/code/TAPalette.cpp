// TAPalette.cpp: implementation of the CTAPalette class.
//
//////////////////////////////////////////////////////////////////////

#include "TAPalette.h"
#include <iostream.h>
#include <fstream.h>

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CTAPalette palette;

CTAPalette::CTAPalette()
{
	ifstream pal("palette.pal", ios::in|ios::nocreate|ios::binary, filebuf::sh_read);
	
	for(int c=0;c<256;c++){
		for(int c2=0;c2<4;c2++){
			pal.read(&p[c][c2],1);
		}
		p[c][3]=255;
	}
/*	for(c=60;c<61;c++){
	p[c][0]=0;
	p[c][1]=0;
	p[c][2]=0;
	}
*/	pal.close();
}

CTAPalette::~CTAPalette()
{

}
