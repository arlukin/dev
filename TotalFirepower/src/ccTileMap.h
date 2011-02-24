// ccTileMap.h: interface for the ccTileMap class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_CCTILEMAP_H__A7FA5E4C_3451_49FA_84C7_6AC3D21D1D62__INCLUDED_)
#define AFX_CCTILEMAP_H__A7FA5E4C_3451_49FA_84C7_6AC3D21D1D62__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000


extern D3DXMATRIXA16 m_matView;
class ccTileMap  
{
	// TNT header struct
	struct TAMAP
	{
		long IDiversion;
		long MapWidth;
		long MapHeight;
		long PTRMapData;
		long PTRMapAttr;
		long PTRTileGfx;
		long Tiles;
		long TileAnims;
		long PTRTileAnim;
		long SeaLevel;
		long PTRMiniMap;
		long hBool;
		long unknown12;
		long unknown13;
		long unknown14;	
		long unknown15;	
	};

    LPDIRECT3DDEVICE9       m_pd3dDevice; // A D3DDevice used for rendering
	
	// TA Map data
	TAMAP m_header;
	unsigned short *m_mapLoadData;
	LPDIRECT3DSURFACE9 	*m_pTileSurface;

	short m_tileWidth;	// Width of a tile in pixels
	short m_tileHeight;
	
	long m_mapWidth;	// Width of the map in pixels
	long m_mapHeight;

protected:
		
	HRESULT loadTNT();
	HRESULT loadMapData(FILE *stream);
	HRESULT loadTileData(FILE *stream);
public:	

	HRESULT DrawMap(RECT const * const writeArea, POINT const * const centerPoint);
    
	// Initializing and destroying device-dependent objects
	HRESULT InitDeviceObjects( LPDIRECT3DDEVICE9 pd3dDevice );
    HRESULT RestoreDeviceObjects();
    HRESULT InvalidateDeviceObjects();
    HRESULT DeleteDeviceObjects();

    // Constructor / destructor
	ccTileMap();
	virtual ~ccTileMap();
};

#endif // !defined(AFX_CCTILEMAP_H__A7FA5E4C_3451_49FA_84C7_6AC3D21D1D62__INCLUDED_)
