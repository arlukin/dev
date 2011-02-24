// cc3do.h: interface for the cc3do class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_CC3DO_H__899AD4E3_DC62_4D1D_95D0_3B046C5973F3__INCLUDED_)
#define AFX_CC3DO_H__899AD4E3_DC62_4D1D_95D0_3B046C5973F3__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000


class cc3do  
{
private:
struct VERTEX3DO
{
	FLOAT x, y, z; // The transformed position for the vertex
	D3DXVECTOR3 n;
	DWORD color;        // The vertex color
};

#define D3DFVF_VERTEX3DO (D3DFVF_XYZ | D3DFVF_DIFFUSE | D3DFVF_NORMAL)
	
	LPDIRECT3DVERTEXBUFFER9 m_pVB; // Buffer to hold vertices
	LPD3DXMESH m_pSphereMesh;      // Test Mesh

	// A D3DDevice used for rendering
    LPDIRECT3DDEVICE9 m_pd3dDevice; 

public:
	HRESULT load3do(char *filename);
	HRESULT draw(float x, float y, float z, float yaw, float pitch, float roll);

	// Initializing and destroying device-dependent objects
	HRESULT InitDeviceObjects( LPDIRECT3DDEVICE9 pd3dDevice );
    HRESULT RestoreDeviceObjects();
    HRESULT InvalidateDeviceObjects();
    HRESULT DeleteDeviceObjects();

	// Constructor / Destructor
	cc3do();
	virtual ~cc3do();

};

#endif // !defined(AFX_CC3DO_H__899AD4E3_DC62_4D1D_95D0_3B046C5973F3__INCLUDED_)
