// ccPlayer.cpp: implementation of the ccPlayer class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
class ccPlayer;
#include "TotalFirepower.h"
#include "ccSettings.h"
#include "ccUnit.h"
#include "ccPlayer.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

ccPlayer::ccPlayer()
{
	getUnit()->setPosition(42, 42);
}

ccPlayer::~ccPlayer()
{

}

ccUnit *ccPlayer::getUnit()
{
	return &m_unit;
}
