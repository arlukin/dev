// ccPlayer.h: interface for the ccPlayer class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_CCPLAYER_H__967CE9BD_01A5_4FFB_85A7_CC008BBF419F__INCLUDED_)
#define AFX_CCPLAYER_H__967CE9BD_01A5_4FFB_85A7_CC008BBF419F__INCLUDED_

#include "ccUnit.h"	// Added by ClassView
#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000



class ccPlayer  
{
	ccUnit m_unit;
public:	
	ccUnit *getUnit();

	// Constructor / Destructor
	ccPlayer();
	virtual ~ccPlayer();

};

#endif // !defined(AFX_CCPLAYER_H__967CE9BD_01A5_4FFB_85A7_CC008BBF419F__INCLUDED_)
