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
    LPDIRECT3DDEVICE9       m_pd3dDevice; // A D3DDevice used for rendering
	POINT m_position;

	//fix: SKA det vara pekare till pekra???? LP DU VET
	IDirect3DSurface9 	*m_pUnitImage;
	D3DSURFACE_DESC m_d3dsDesc;

public:
	HRESULT loadUnit();
	void validatePosition();
	void setPosition(int x, int y);
	void movePosition(int x, int y);
	POINT getPosition();


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
