// ccTileMap.cpp: implementation of the ccTileMap class.
//
//////////////////////////////////////////////////////////////////////
#include "stdafx.h"
#include "ccTileMap.h"


//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

ccTileMap::ccTileMap()
{	
	ZeroMemory( &m_header, sizeof(m_header) );
	m_mapLoadData = NULL;
	m_pTileSurface	= NULL;	

	m_tileWidth = 32;
	m_tileHeight = 32;
}


ccTileMap::~ccTileMap()
{

}

//-----------------------------------------------------------------------------
// Name: InitDeviceObjects()
// Desc: Initializes device-dependent objects, including the vertex buffer used
//       for rendering text and the texture map which stores the font image.
//-----------------------------------------------------------------------------
HRESULT ccTileMap::InitDeviceObjects(LPDIRECT3DDEVICE9 pd3dDevice)
{
    // Keep a local copy of the device
    m_pd3dDevice = pd3dDevice;
	
	return S_OK;
}

//-----------------------------------------------------------------------------
// Name: RestoreDeviceObjects()
// Desc:
//-----------------------------------------------------------------------------
HRESULT ccTileMap::RestoreDeviceObjects()
{
	HRESULT hr = S_OK;	

	if (FAILED(hr=loadTNT()))
		return hr;

	return hr;
}

//-----------------------------------------------------------------------------
// Name: InvalidateDeviceObjects()
// Desc: Destroys all device-dependent objects
//-----------------------------------------------------------------------------
HRESULT ccTileMap::InvalidateDeviceObjects()
{	
	for (int i = 0; i < m_header.Tiles; i++)
		SAFE_RELEASE(m_pTileSurface[i]);
	SAFE_DELETE(m_pTileSurface);

    return S_OK;
}

//-----------------------------------------------------------------------------
// Name: DeleteDeviceObjects()
// Desc: Destroys all device-dependent objects
//-----------------------------------------------------------------------------
HRESULT ccTileMap::DeleteDeviceObjects()
{
    m_pd3dDevice = NULL;    

    return S_OK;
}

//

HRESULT ccTileMap::DrawMap()
{
    if( m_pd3dDevice == NULL )
        return E_FAIL;	

	HRESULT hr;
	IDirect3DSurface9 *ppBackBuffer;		

	if (SUCCEEDED(hr = m_pd3dDevice->GetBackBuffer(0, 0, D3DBACKBUFFER_TYPE_MONO, &ppBackBuffer)))
	{							
		RECT srcRect, destRect;
		int tileToWrite = 0;

		srcRect.top  = m_drawStartPixel.y;
		srcRect.bottom = m_tileHeight;

		destRect.top = m_writeArea.top;
		destRect.bottom = destRect.top + m_tileHeight - m_drawStartPixel.y;
		for (int yIndex=0; yIndex<m_drawNumTile.cy; yIndex++)
		{				
			if (destRect.top > m_writeArea.bottom)
				break;
			else if (destRect.bottom > m_writeArea.bottom)
			{
				srcRect.bottom -= (destRect.bottom - m_writeArea.bottom);
				destRect.bottom = m_writeArea.bottom;
				if (srcRect.bottom <= 0)
					break;
			}

			srcRect.left  = m_drawStartPixel.x;					
			srcRect.right = m_tileWidth;

			destRect.left = m_writeArea.left;
			destRect.right = destRect.left + m_tileWidth - m_drawStartPixel.x;
			
			for (int xIndex=0; xIndex<m_drawNumTile.cx; xIndex++)
			{					
				if (destRect.left > m_writeArea.right)
					break;
				else if (destRect.right > m_writeArea.right)
				{
					srcRect.right -= (destRect.right - m_writeArea.right);
					destRect.right = m_writeArea.right;
					if (srcRect.right <= 0)
						break;
				}
				
				tileToWrite = m_mapLoadData[((yIndex+m_drawStartTile.y)*(m_worldTileSize.cx))+xIndex+m_drawStartTile.x];

				if (tileToWrite<m_header.Tiles)
				{				
 					if (FAILED(hr = m_pd3dDevice->StretchRect(m_pTileSurface[tileToWrite], &srcRect, ppBackBuffer, &destRect, D3DTEXF_NONE)))
					{
						break;
					}
				}

				srcRect.left = 0;
				srcRect.right = m_tileWidth;

				destRect.left = destRect.right;
				destRect.right = destRect.left + m_tileWidth;
			}
			srcRect.top = 0;
			srcRect.bottom = m_tileHeight;

			destRect.top = destRect.bottom;
			destRect.bottom = destRect.top + m_tileHeight;			
		}
	}
	SAFE_RELEASE(ppBackBuffer);
	
	return hr;
}

//
//
//

HRESULT ccTileMap::loadTNT()
{
	//
	// loadTNT
	//
	FILE *stream;
	//if( (stream  = fopen( "..//map//The Pass.tnt", "rb" )) == NULL)
	//if( (stream  = fopen( "..//map//Metal Heck.tnt", "rb" )) == NULL)
	if( (stream  = fopen( "..//map//test.tnt", "rb" )) == NULL)
	{
		printf( "The file 'data' was not opened\n" );
		return E_FAIL;
	}
	
	//
	// loadHeader
	//
	if(fread( &m_header, sizeof( TAMAP ), 1, stream ) == 0 || ferror( stream ))
		return E_FAIL;

	if (m_header.IDiversion != 8192)
		return E_FAIL;

	m_worldTileSize.cx = (m_header.MapWidth/2);
	m_worldTileSize.cy = (m_header.MapHeight/2);

	m_worldSize.cx  = m_worldTileSize.cx*m_tileWidth;
	m_worldSize.cy = m_worldTileSize.cy*m_tileHeight;

	loadMapData(stream);
	// loadScenData(stream);
	loadTileData(stream);

	/* Close stream */
	if(fclose( stream ))
	{
	  printf("The file 'data' was not closed\n");
	  return E_FAIL;
	}

	return S_OK;
}

//

HRESULT ccTileMap::loadMapData(FILE *stream)
{
	if(fseek( stream, m_header.PTRMapData, SEEK_SET))
		return E_FAIL;
       
	int mapDataSize = (m_worldTileSize.cx * m_worldTileSize.cy);
	m_mapLoadData = new unsigned short[mapDataSize];
	ZeroMemory(m_mapLoadData, sizeof(m_mapLoadData) );
		
	if(fread( m_mapLoadData, mapDataSize*2, 1, stream) == 0 || ferror( stream ))
		return E_FAIL;


	int moo = m_mapLoadData[(130*131)+130];
	moo = m_mapLoadData[(131*131)];
	moo = m_mapLoadData[0];
	return S_OK;
}

//

HRESULT ccTileMap::loadTileData(FILE *stream)
{
	if(fseek( stream, m_header.PTRTileGfx, SEEK_SET))
		return E_FAIL;
       
	int tileDataSize = m_header.Tiles*1024;
	unsigned char *tileLoadData = new unsigned char[tileDataSize];
	ZeroMemory(tileLoadData, tileDataSize );

	if(fread(tileLoadData, tileDataSize, 1, stream) == 0 || ferror( stream ))
		return E_FAIL;

	//
	// Create surfaces.
	//

	HRESULT hr;
	IDirect3DSurface9 *ppBackBuffer;
	if (SUCCEEDED(hr = m_pd3dDevice->GetBackBuffer(0, 0, D3DBACKBUFFER_TYPE_MONO, &ppBackBuffer)))
	{
		D3DSURFACE_DESC d3dsDesc;
		ppBackBuffer->GetDesc(&d3dsDesc);

		m_pTileSurface = new LPDIRECT3DSURFACE9[m_header.Tiles];
		
		RECT srcRect;
		srcRect.left   = srcRect.top	 = 0;
		srcRect.right  = m_tileWidth - 1;
		srcRect.bottom = m_tileHeight - 1;	
		
		for(int i=0;i<m_header.Tiles;i++)
		{			
			if (FAILED(hr = m_pd3dDevice->CreateOffscreenPlainSurface(
				m_tileWidth, m_tileHeight, d3dsDesc.Format, D3DPOOL_DEFAULT, &m_pTileSurface[i], NULL)))    	
				return hr;
			
			if (FAILED(hr = D3DXLoadSurfaceFromMemory(
				m_pTileSurface[i], NULL, NULL, (tileLoadData+(i*1024)), D3DFMT_P8, m_tileWidth, taPalette, &srcRect, D3DX_DEFAULT , 0)))
			{
				return hr;
			}			
		}
	}

	SAFE_RELEASE(ppBackBuffer);
	return S_OK;
}

void ccTileMap::setWriteArea(const RECT *const writeArea)
{	
	// Funkar inte riktigt, måste
	if ((writeArea->right-writeArea->left)%m_tileWidth)
		ASSERT("Writearea width must be divided by two");

	if ((writeArea->bottom-writeArea->top)%m_tileHeight)
		ASSERT("Writearea height must be divided by two");

	m_writeArea = *writeArea;
}

RECT *ccTileMap::getWriteArea()
{
	return &m_writeArea;
}
//FIX: remove size
void ccTileMap::centerAround(POINT *worldPosition, SIZE * unitSize)
{
	//
	// Horizontal
	//	
	m_worldPosition.x = worldPosition->x-((m_writeArea.right-m_writeArea.left)/2);

	m_drawStartTile.x = m_worldPosition.x / m_tileWidth;
	m_drawStartPixel.x = m_worldPosition.x % m_tileWidth;	
	m_drawNumTile.cx = (long)ceil((double)(m_writeArea.right-m_writeArea.left)/(double)m_tileWidth);
	


	if (m_drawStartPixel.x >= m_tileWidth)
	{
		m_drawStartTile.x++;		
		m_drawStartPixel.x = 0;
	}

	if (m_drawStartTile.x < 0 || m_drawStartPixel.x < 0)
	{
		m_drawStartTile.x = 0;		
		m_drawStartPixel.x = 0;
	}
	else if (m_drawStartTile.x >= (m_worldTileSize.cx)-m_drawNumTile.cx)
	{
		m_drawStartTile.x = (m_worldTileSize.cx)-m_drawNumTile.cx;		
		m_drawStartPixel.x = 0;		
	}
	else if (m_drawStartPixel.x > 0)
	{
		m_drawNumTile.cx++;
	}

	m_worldPosition.x = (m_drawStartTile.x * m_tileWidth)+m_drawStartPixel.x;

	if (m_worldPosition.x > (m_worldSize.cx+m_tileWidth - (m_writeArea.right - m_writeArea.left)))
		m_worldPosition.x = (m_worldSize.cx+m_tileWidth - (m_writeArea.right - m_writeArea.left));
	
	//
	// Vertical
	//
	m_worldPosition.y = worldPosition->y-((m_writeArea.bottom-m_writeArea.top)/2);

	m_drawStartTile.y = m_worldPosition.y / m_tileHeight;
	m_drawStartPixel.y = m_worldPosition.y % m_tileHeight;	
	m_drawNumTile.cy = (long)ceil((double)(m_writeArea.bottom-m_writeArea.top)/(double)m_tileHeight);

	if (m_drawStartPixel.y >= m_tileHeight)
	{
		m_drawStartTile.y++;		
		m_drawStartPixel.y = 0;
	}

	if (m_drawStartTile.y < 0 || m_drawStartPixel.y < 0)
	{
		m_drawStartTile.y = 0;		
		m_drawStartPixel.y = 0;
	}
	else if (m_drawStartTile.y >= m_worldTileSize.cy-m_drawNumTile.cy)
	{
		m_drawStartTile.y = m_worldTileSize.cy-m_drawNumTile.cy;		
		m_drawStartPixel.y = 0;
	}
	else if (m_drawStartPixel.y > 0)
	{
		m_drawNumTile.cy++;
	}

	m_worldPosition.y = (m_drawStartTile.y * m_tileHeight)+m_drawStartPixel.y;

	if (m_worldPosition.y > (m_worldSize.cy+m_tileHeight - (m_writeArea.bottom - m_writeArea.top)))
		m_worldPosition.y = (m_worldSize.cy+m_tileHeight - (m_writeArea.bottom - m_writeArea.top));
}

POINT * ccTileMap::getWorldPosition()
{
	return &m_worldPosition;
}

SIZE * ccTileMap::getWorldSize()
{
	return &m_worldSize;
}
