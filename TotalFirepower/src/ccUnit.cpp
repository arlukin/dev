// ccUnit.cpp: implementation of the ccUnit class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"

#include "ccTileMap.h"
#include "ccUnit.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

ccUnit::ccUnit(ccTileMap * tileMap, ccArrayList * unitList)
{
	m_tileMap = tileMap;
	m_unitList = unitList;

	m_position.x = 0;
	m_position.y = 0;

	m_unitSize.cx = m_unitSize.cy = 0;
	m_unitRect.left = m_unitRect.top = 0;
	m_unitRect.right = m_unitRect.bottom = 0;

	m_speed = 1;
	max_speed = 10;
}

ccUnit::~ccUnit()
{

}

//

POINT * ccUnit::getWorldPosition()
{
	return &m_position;
}

void ccUnit::movePosition(int x, int y)
{
	RECT unitRect;
	unitRect.left = m_position.x + x*m_speed;
	unitRect.top  = m_position.y + y*m_speed;
	unitRect.right  = unitRect.left + m_unitSize.cx;
	unitRect.bottom = unitRect.top + m_unitSize.cy;

	if (SUCCEEDED(validRect(&unitRect)))
	{
		m_position.x = unitRect.left;
		m_position.y = unitRect.top;

		m_unitRect = unitRect;
	}
}

void ccUnit::setPosition(int x, int y)
{
	RECT unitRect;
	unitRect.left = x;
	unitRect.top  = y;
	unitRect.right  = unitRect.left + m_unitSize.cx;
	unitRect.bottom = unitRect.top + m_unitSize.cy;

	if (SUCCEEDED(validRect(&unitRect)))
	{
		m_position.x =unitRect.left;
		m_position.y =unitRect.top;

		m_unitRect = unitRect;
	}
}

HRESULT ccUnit::validRect(RECT * unitRect)
{	
	HRESULT hr = S_OK;
	if (m_tileMap)
	{
		// FIX: Kanske flytta till ccTileMap. ValidWorldPosition()
		//
		// validMapPostion
		//
		SIZE * mapWorldSize = m_tileMap->getWorldSize();
		
		if (unitRect->left < 0)
			unitRect->left = 0;
		else if (unitRect->left > (mapWorldSize->cx-m_unitSize.cx))
			unitRect->left = (mapWorldSize->cx-m_unitSize.cx);

		if (unitRect->top < 0)
			unitRect->top = 0;
		else if (unitRect->top > (mapWorldSize->cy-m_unitSize.cy))
			unitRect->top = (mapWorldSize->cy-m_unitSize.cy);

		//
		// Collision With Other Unit?
		//
		ccUnit *unit;
		for(int i=0;i<m_unitList->count();i++)
		{
			unit = (ccUnit*)(*m_unitList)[i];
			if (this != unit)
			{
				if (FAILED(unit->isCollision(unitRect)))
				{
					hr = E_FAIL;
				}
			}
		}
	}
	else
	{
		m_position.x = m_position.y = 0;
		hr = E_FAIL;
	}
	
	return hr;
}

//

//-----------------------------------------------------------------------------
// Name: InitDeviceObjects()
// Desc: Initializes device-dependent objects, including the vertex buffer used
//       for rendering text and the texture map which stores the font image.
//-----------------------------------------------------------------------------
HRESULT ccUnit::InitDeviceObjects(LPDIRECT3DDEVICE9 pd3dDevice)
{
    // Keep a local copy of the device
    m_pd3dDevice = pd3dDevice;
	
	return S_OK;
}

//-----------------------------------------------------------------------------
// Name: RestoreDeviceObjects()
// Desc:
//-----------------------------------------------------------------------------
HRESULT ccUnit::RestoreDeviceObjects()
{
	HRESULT hr = S_OK;	

	if (FAILED(hr=loadUnit()))
		return hr;

	return hr;
}

//-----------------------------------------------------------------------------
// Name: InvalidateDeviceObjects()
// Desc: Destroys all device-dependent objects
//-----------------------------------------------------------------------------
HRESULT ccUnit::InvalidateDeviceObjects()
{	
	SAFE_RELEASE(m_pUnitImage);

    return S_OK;
}

//-----------------------------------------------------------------------------
// Name: DeleteDeviceObjects()
// Desc: Destroys all device-dependent objects
//-----------------------------------------------------------------------------
HRESULT ccUnit::DeleteDeviceObjects()
{
    m_pd3dDevice = NULL;    

    return S_OK;
}

// draw2DUnit
HRESULT ccUnit::drawUnit()
{
    if( m_pd3dDevice == NULL )
        return E_FAIL;

	HRESULT hr;
	IDirect3DSurface9 *ppBackBuffer;		

	if (SUCCEEDED(hr = m_pd3dDevice->GetBackBuffer(0, 0, D3DBACKBUFFER_TYPE_MONO, &ppBackBuffer)))
	{	
		RECT srcRect, destRect;
		destRect.left	= m_position.x;
		destRect.top	= m_position.y;
		destRect.right  = m_position.x+m_unitSize.cx;
		destRect.bottom = m_position.y+m_unitSize.cy;
		
		srcRect.left = srcRect.top = 0;
		srcRect.right = m_unitSize.cx;
		srcRect.bottom = m_unitSize.cy;
		
		if (SUCCEEDED(m_tileMap->worldToScreenPos(&destRect, &srcRect)))
		{
			hr = m_pd3dDevice->StretchRect(m_pUnitImage, &srcRect, ppBackBuffer, &destRect, D3DTEXF_NONE);
		}
	}

	SAFE_RELEASE(ppBackBuffer);
	return hr;
}
//

HRESULT ccUnit::loadUnit()
{
	//
	// Create surfaces.
	//

	HRESULT hr;
	IDirect3DSurface9 *ppBackBuffer;
	if (SUCCEEDED(hr = m_pd3dDevice->GetBackBuffer(0, 0, D3DBACKBUFFER_TYPE_MONO, &ppBackBuffer)))
	{
		D3DSURFACE_DESC d3dsDesc;
		ppBackBuffer->GetDesc(&d3dsDesc);		
				
		char fileName[] = "..//units//armbulldog.bmp";
		
		if (FAILED(hr = D3DXGetImageInfoFromFile(
			fileName,
			&m_srcInfo)))
			return hr;

		m_unitSize.cx = m_srcInfo.Width;
		m_unitSize.cy = m_srcInfo.Height;

		m_unitRect.right  += m_unitSize.cx;
		m_unitRect.bottom += m_unitSize.cy;
				
		if (FAILED(hr = m_pd3dDevice->CreateOffscreenPlainSurface(
			m_srcInfo.Width, m_srcInfo.Height, d3dsDesc.Format, D3DPOOL_DEFAULT, &m_pUnitImage, NULL)))
			return hr;				

		if (FAILED(hr = D3DXLoadSurfaceFromFile(          
			m_pUnitImage,
			NULL,
			NULL,
			fileName,
			NULL,
			D3DX_FILTER_NONE,
			0x7B97FF,
			&m_srcInfo
		)))
			return hr;
		
	}
	SAFE_RELEASE(ppBackBuffer);

	return S_OK;
}

HRESULT ccUnit::isCollision(RECT *unitRect)
{	
	if (
		m_unitRect.left < unitRect->right && m_unitRect.top < unitRect->bottom &&
		m_unitRect.right > unitRect->left && m_unitRect.bottom > unitRect->top
	   )
		return E_FAIL;
	else
		return S_OK;
}
