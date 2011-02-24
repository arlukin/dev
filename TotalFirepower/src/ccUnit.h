// ccUnit.h: interface for the ccUnit class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_CCUNIT_H__DC15FA36_FF37_498F_9DE1_436AE51624BE__INCLUDED_)
#define AFX_CCUNIT_H__DC15FA36_FF37_498F_9DE1_436AE51624BE__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

class ccUnit  
{
	// A D3DDevice used for rendering
    LPDIRECT3DDEVICE9 m_pd3dDevice; 
	
	// Unit Image 
	IDirect3DSurface9 	*m_pUnitImage;
	D3DXIMAGE_INFO m_srcInfo;

	// Positions
	POINT m_position;		// Units left upper corner Pixel position on tilemap.
	RECT m_writeArea;		// Position of allowed area on screen.

	POINT m_mapWorldPosition; // Top left corner of screen on the worldmap.
	SIZE  m_mapWorldSize;	  // Size of the world map;

	// Unit properties
	SIZE  m_unitSize;
	short m_speed;
	short max_speed;

public:		
	void setMapWorldPosition(POINT *position) {m_mapWorldPosition = *position;};
	void setMapWorldSize(SIZE *size) {m_mapWorldSize = *size;};
	void setWriteArea(RECT const * const writeArea) {m_writeArea = *writeArea;};
	
	SIZE * getUnitSize() {return &m_unitSize;};




	HRESULT loadUnit();


	void validatePosition();
	void setPosition(int x, int y);
	void movePosition(int x, int y);
	POINT * getWorldPosition();

	HRESULT drawUnit();
    
	// Initializing and destroying device-dependent objects
	HRESULT InitDeviceObjects( LPDIRECT3DDEVICE9 pd3dDevice );
    HRESULT RestoreDeviceObjects();
    HRESULT InvalidateDeviceObjects();
    HRESULT DeleteDeviceObjects();

	// Constructor / Destructor
	ccUnit();
	virtual ~ccUnit();

};

#endif // !defined(AFX_CCUNIT_H__DC15FA36_FF37_498F_9DE1_436AE51624BE__INCLUDED_)
