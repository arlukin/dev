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

HRESULT ccTileMap::DrawMap(RECT const * const writeArea, POINT const * const centerPoint)
{
    if( m_pd3dDevice == NULL )
        return E_FAIL;

	HRESULT hr;
	IDirect3DSurface9 *ppBackBuffer;		

	if (SUCCEEDED(hr = m_pd3dDevice->GetBackBuffer(0, 0, D3DBACKBUFFER_TYPE_MONO, &ppBackBuffer)))
	{	
		D3DSURFACE_DESC d3dsDesc;
		ppBackBuffer->GetDesc(&d3dsDesc);

		RECT srcRect, destRect;
		int tileToWrite = 0;
		int numHorizontalTiles = ((writeArea->right-writeArea->left)/m_tileWidth)+1;
		int numVerticalTiles   = ((writeArea->bottom-writeArea->top)/m_tileHeight)+1;

		// Vertical
		int yStartTile = centerPoint->y / m_tileHeight;
		int yStartPixel = centerPoint->y % m_tileHeight;

		if (yStartTile >= (m_header.MapHeight/2)-numVerticalTiles)
		{
			yStartTile = (m_header.MapHeight/2)-numVerticalTiles;
			yStartPixel = 0;			
		}
		else if (yStartTile < 0 || yStartPixel < 0)
		{
			yStartTile = 0;
			yStartPixel = 0;
		}

		else if (yStartPixel > m_tileHeight-2)
		{
			yStartTile++;
			yStartPixel = 0;
		}
		else if (yStartPixel > 0)
		{
			numVerticalTiles++;
		}


		// Horizontal
		
		int xStartTile = centerPoint->x / m_tileWidth;
		int xStartPixel = centerPoint->x % m_tileWidth;
		

		if (xStartTile >= (m_header.MapWidth/2)-numHorizontalTiles)
		{
			xStartTile = (m_header.MapWidth/2)-numHorizontalTiles;
			xStartPixel = 0;
		}
		else if (xStartTile < 0 || xStartPixel < 0)
		{
			xStartTile = 0;
			xStartPixel = 0;
		}
		else if (xStartPixel > m_tileWidth-2)
		{
			xStartTile++;
			xStartPixel = 0;
		}
		else if (xStartPixel > 0)
		{
			numHorizontalTiles++;
		}

		
		//
		// Tile Loop
		//

		for (int yIndex=0; yIndex<numVerticalTiles; yIndex++)
		{				
			if (yIndex==0)
			{										
				srcRect.top  = yStartPixel;
				srcRect.bottom = m_tileHeight-1;

				destRect.top = writeArea->top;
				destRect.bottom = destRect.top + m_tileHeight - yStartPixel-1;
			}
			else if (yIndex == numVerticalTiles-1 && yStartPixel > 0)
			{
				srcRect.top  = 0;
				srcRect.bottom = yStartPixel;					

				destRect.bottom = destRect.top + yStartPixel;
			}
			else
			{
				srcRect.top = 0;
				srcRect.bottom = m_tileHeight-1;

				destRect.bottom = destRect.top + m_tileHeight-1;
			}

			for (int xIndex=0; xIndex<numHorizontalTiles; xIndex++)
			{					
				if (xIndex==0)
				{										
					srcRect.left  = xStartPixel;					
					srcRect.right = m_tileWidth-1;

					destRect.left = writeArea->left;
					destRect.right = destRect.left + m_tileWidth - xStartPixel-1;
				}
				else if (xIndex == numHorizontalTiles-1 && xStartPixel > 0)
				{
					srcRect.left  = 0;
					srcRect.right = xStartPixel;					

					destRect.right = destRect.left + xStartPixel;
				}
				else
				{
					srcRect.left = 0;
					srcRect.right = m_tileWidth-1;

					destRect.right = destRect.left + m_tileWidth-1;
				}
				
				tileToWrite = m_mapLoadData[((yIndex+yStartTile)*(m_header.MapWidth/2))+xIndex+xStartTile];
				
				if (FAILED(hr = m_pd3dDevice->StretchRect(m_pTileSurface[tileToWrite], &srcRect, ppBackBuffer, &destRect, D3DTEXF_NONE)))
				{
					break;
				}

				destRect.left = destRect.right;
			}
			destRect.top = destRect.bottom;
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
	if( (stream  = fopen( "..//map//Metal Heck.tnt", "rb" )) == NULL)
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

	m_mapWidth  = m_header.MapWidth/2*m_tileWidth;
	m_mapHeight = m_header.MapHeight/2*m_tileHeight;	

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
       
	int mapDataSize = ((m_header.MapWidth/2) * (m_header.MapHeight/2)) ;
	m_mapLoadData = new unsigned short[mapDataSize-1];	// Zero based
		
	if(fread( m_mapLoadData, mapDataSize*2, 1, stream) == 0 || ferror( stream ))
		return E_FAIL;

	return S_OK;
}

//

HRESULT ccTileMap::loadTileData(FILE *stream)
{
	if(fseek( stream, m_header.PTRTileGfx, SEEK_SET))
		return E_FAIL;
       
	int tileDataSize = m_header.Tiles*1024;
	unsigned char *tileLoadData = new unsigned char[tileDataSize-1];	// Zero based
	ZeroMemory(tileLoadData, tileDataSize-1 );

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
		srcRect.left	= srcRect.top	 = 0;
		srcRect.right	= srcRect.bottom = 31;			
		
		for(int i=0;i<m_header.Tiles;i++)
		{			
			if (FAILED(hr = m_pd3dDevice->CreateOffscreenPlainSurface(
				32, 32, d3dsDesc.Format, D3DPOOL_DEFAULT, &m_pTileSurface[i], NULL)))    	
				return hr;
			
			if (FAILED(hr = D3DXLoadSurfaceFromMemory(
				m_pTileSurface[i], NULL, NULL, (tileLoadData+(i*1024)), D3DFMT_P8, 32, taPalette, &srcRect, D3DX_DEFAULT , 0)))
			{
				return hr;
			}			
		}
	}

	SAFE_RELEASE(ppBackBuffer);
	return S_OK;
}