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
	m_unit = NULL;
}

ccPlayer::~ccPlayer()
{

	SAFE_DELETE(m_unit);
}

HRESULT ccPlayer::createUnit(ccTileMap *tileMap, ccArrayList *unitList)
{
	m_unit = new ccUnit(tileMap, unitList);
	return S_OK;
}
