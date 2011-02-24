// ccUnit.cpp: implementation of the ccUnit class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"

#include "ccUnit.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

ccUnit::ccUnit()
{
	m_position.x = 0;
	m_position.y = 0;
	m_mapWorldPosition.x = m_mapWorldPosition.y = 0;
	m_mapWorldSize.cx = m_mapWorldSize.cy = 0;

	m_unitSize.cx = m_unitSize.cy = 0;

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
	m_position.x += x*m_speed;
	m_position.y += y*m_speed;
	validatePosition();
}

void ccUnit::setPosition(int x, int y)
{
	m_position.x = x;
	m_position.y = y;
	validatePosition();
}

void ccUnit::validatePosition()
{
	if (m_position.x < 0)
		m_position.x = 0;
	else if (m_position.x > (m_mapWorldSize.cx-(long)m_srcInfo.Width))
		m_position.x = (m_mapWorldSize.cx-(long)m_srcInfo.Width);

	if (m_position.y < 0)
		m_position.y = 0;
	else if (m_position.y > (m_mapWorldSize.cy-(long)m_srcInfo.Height))
		m_position.y = (m_mapWorldSize.cy-(long)m_srcInfo.Height);
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

HRESULT ccUnit::drawUnit()
{
    if( m_pd3dDevice == NULL )
        return E_FAIL;

	HRESULT hr;
	IDirect3DSurface9 *ppBackBuffer;		

	if (SUCCEEDED(hr = m_pd3dDevice->GetBackBuffer(0, 0, D3DBACKBUFFER_TYPE_MONO, &ppBackBuffer)))
	{	
		RECT destRect;
		destRect.left = m_position.x-m_mapWorldPosition.x+m_writeArea.left;
		destRect.top = m_position.y-m_mapWorldPosition.y+m_writeArea.top;		
		destRect.right = destRect.left+m_srcInfo.Width;
		destRect.bottom = destRect.top+m_srcInfo.Height;

		hr = m_pd3dDevice->StretchRect(m_pUnitImage, NULL, ppBackBuffer, &destRect, D3DTEXF_NONE);
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
			NULL,
			&m_srcInfo
		)))
			return hr;
	}
	SAFE_RELEASE(ppBackBuffer);

	return S_OK;
}