// ccUnit.h: interface for the ccUnit class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_CCUNIT_H__DC15FA36_FF37_498F_9DE1_436AE51624BE__INCLUDED_)
#define AFX_CCUNIT_H__DC15FA36_FF37_498F_9DE1_436AE51624BE__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

class ccTileMap;
class cc3do;
class ccUnit  
{
	// A D3DDevice used for rendering
    LPDIRECT3DDEVICE9 m_pd3dDevice; 
	
	// Unit Image 
	IDirect3DSurface9 	*m_pUnitImage;
	D3DXIMAGE_INFO m_srcInfo;

	//Map members
	ccTileMap * m_tileMap;
	ccArrayList * m_unitList;	// All units in the game.

	// Unit properties
	cc3do *m_3do;

	POINT m_position;		// Units left upper corner Pixel position on worldMap.
	SIZE  m_unitSize;
	RECT  m_unitRect;		// Positions on the worldMap.
	short m_speed;
	short max_speed;

	float m_yaw;
	float m_pitch;
	float m_roll;

public:				
	void rotate(float yaw, float pitch, float roll);
	HRESULT load3DO(char* filename);
	HRESULT isCollision(RECT *unitRect);
	
	SIZE * getUnitSize() {return &m_unitSize;};


	HRESULT loadUnit();

	HRESULT validRect(RECT * unitRect);
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
	ccUnit(ccTileMap * tileMap, ccArrayList * unitList);
	virtual ~ccUnit();

};

#endif // !defined(AFX_CCUNIT_H__DC15FA36_FF37_498F_9DE1_436AE51624BE__INCLUDED_)
