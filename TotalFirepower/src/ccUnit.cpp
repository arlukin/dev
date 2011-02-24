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
}

ccUnit::~ccUnit()
{

}

//

POINT ccUnit::getPosition()
{
	return m_position;
}

void ccUnit::movePosition(int x, int y)
{
	m_position.x += x;
	m_position.y += y;
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
	if (m_position.x <0)
		m_position.x = 0;

	if (m_position.y < 0)
		m_position.y = 0;
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
	SAFE_DELETE(m_pUnitImage);

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
		destRect.top = 0;
		destRect.left = 0;

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
		ppBackBuffer->GetDesc(&m_d3dsDesc);		
				
		char fileName[] = "..//units//armbulldog.bmp";

		D3DXIMAGE_INFO srcInfo;
		if (FAILED(hr = D3DXGetImageInfoFromFile(
			fileName,
			&srcInfo)))
			return hr;
				
		if (FAILED(hr = m_pd3dDevice->CreateOffscreenPlainSurface(
			srcInfo.Width, srcInfo.Height, m_d3dsDesc.Format, D3DPOOL_DEFAULT, &m_pUnitImage, NULL)))    	
			return hr;				

		if (FAILED(hr = D3DXLoadSurfaceFromFile(          
			m_pUnitImage,
			NULL,
			NULL,
			fileName,
			NULL,
			D3DX_FILTER_NONE,
			NULL,
			&m_d3dsDesc
		)))
			return hr;
	}
	SAFE_RELEASE(ppBackBuffer);

	return S_OK;
}
