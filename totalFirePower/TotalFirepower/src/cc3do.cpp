// cc3do.cpp: implementation of the cc3do class.
//
//////////////////////////////////////////////////////////////////////
#include "stdafx.h"
#include "cc3do.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

cc3do::cc3do()
{
	m_pd3dDevice = NULL;
	m_pVB = NULL; 
	m_pSphereMesh               = NULL;
}

cc3do::~cc3do()
{

}

HRESULT cc3do::draw(float x, float y, float z, float yaw, float pitch, float roll)
{		
	
	D3DXMATRIX matWorldTrans; 
	D3DXMATRIX matWorldRotation; 
	D3DXMATRIX matWorld; 

	D3DXMATRIX matTempWorld;  
	D3DXMATRIX matTrans;	
	D3DXMATRIX matRotation;	

		
	m_pd3dDevice->SetRenderState( D3DRS_FILLMODE, D3DFILL_SOLID );
	//m_pd3dDevice->SetRenderState( D3DRS_FILLMODE, D3DFILL_WIREFRAME );
	// Enable alpha blending.
	
	m_pd3dDevice->SetRenderState(D3DRS_ALPHABLENDENABLE, TRUE);
	m_pd3dDevice->SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCCOLOR);
	m_pd3dDevice->SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCCOLOR);
	
		

	//	
	D3DXMatrixTranslation(&matWorldTrans, x, -y, z);		
	D3DXMatrixRotationYawPitchRoll( &matWorldRotation, yaw, pitch, roll);  
	matWorld = matWorldRotation * matWorldTrans;
	//D3DXMatrixIdentity(&matWorld);
	//D3DXMatrixRotationYawPitchRoll(&matWorld, 5.0f, 5.0f, 5.0f);
	
	m_pd3dDevice->SetStreamSource( 0, m_pVB, 0, sizeof(VERTEX3DO) );
    m_pd3dDevice->SetFVF( D3DFVF_VERTEX3DO );

	//
	// Draw the back wall	
    D3DXMatrixTranslation( &matTrans, 0.0f, 0.0f, -40.0f );	
    D3DXMatrixRotationX( &matRotation, 0.0f );
    matTempWorld = matRotation * matTrans * matWorldRotation * matWorldTrans;		
	m_pd3dDevice->SetTransform( D3DTS_WORLD,  &matTempWorld );
    m_pd3dDevice->DrawPrimitive( D3DPT_TRIANGLESTRIP, 0, 2 );
	
	// Draw the front wall	
    D3DXMatrixTranslation( &matTrans, 0.0f, 0.0f, 40.0f );	
    D3DXMatrixRotationX( &matRotation, D3DX_PI );
    matTempWorld = matRotation * matTrans * matWorldRotation * matWorldTrans;			
	m_pd3dDevice->SetTransform( D3DTS_WORLD,  &matTempWorld );
    m_pd3dDevice->DrawPrimitive( D3DPT_TRIANGLESTRIP, 0, 2 );

	// Draw the right side wall		
    D3DXMatrixTranslation( &matTrans, 40.0f,0.0f, 0.0f );
	D3DXMatrixRotationY( &matRotation, -D3DX_PI/2 );	
    matTempWorld = matRotation * matTrans * matWorldRotation * matWorldTrans;		
	m_pd3dDevice->SetTransform( D3DTS_WORLD,  &matTempWorld );
    m_pd3dDevice->DrawPrimitive( D3DPT_TRIANGLESTRIP, 0, 2 );

	// Draw the left side wall		
    D3DXMatrixTranslation( &matTrans, -40.0f, 0.0f, 0.0f );
	D3DXMatrixRotationY( &matRotation, D3DX_PI/2 );	
    matTempWorld = matRotation * matTrans * matWorldRotation * matWorldTrans;		
	m_pd3dDevice->SetTransform( D3DTS_WORLD,  &matTempWorld );
    m_pd3dDevice->DrawPrimitive( D3DPT_TRIANGLESTRIP, 0, 2 );	

	// Draw the top side wall				
    D3DXMatrixTranslation( &matTrans, 0.0f, -40.0f, 0.0f );
	D3DXMatrixRotationX( &matRotation, -D3DX_PI/2 );	
    matTempWorld = matRotation * matTrans * matWorldRotation * matWorldTrans;	
	m_pd3dDevice->SetTransform( D3DTS_WORLD,  &matTempWorld );
    m_pd3dDevice->DrawPrimitive( D3DPT_TRIANGLESTRIP, 0, 2 );

	// Draw the bottom side wall		
    D3DXMatrixTranslation( &matTrans, 0.0f, 40.0f, 0.0f );
	D3DXMatrixRotationX( &matRotation, D3DX_PI/2 );	
    matTempWorld = matRotation * matTrans * matWorldRotation * matWorldTrans;	
	m_pd3dDevice->SetTransform( D3DTS_WORLD,  &matTempWorld );
    m_pd3dDevice->DrawPrimitive( D3DPT_TRIANGLESTRIP, 0, 2 );

	
	// Mesh cube
	D3DXMatrixTranslation(&matTrans, x-150, -y, z);			
	matTempWorld = matWorldRotation * matTrans;
	m_pd3dDevice->SetTransform( D3DTS_WORLD,  &matTempWorld );
	m_pd3dDevice->SetRenderState(D3DRS_FILLMODE, D3DFILL_WIREFRAME);
	m_pSphereMesh->DrawSubset(0);
	
	return S_OK;
}

HRESULT cc3do::load3do(char *filename)
{
	//
	// initVertexBuffer
	//
    
	/*
    VERTEX3DO vertices[] =
    {
        { -40.0f,-40.0f, 0.0f, 0xffff0000, },
        { 40.0f,-40.0f, 0.0f, 0xff0000ff, },
		{ -40.0f, 40.0f, 0.0f, 0xffffffff, },
        {  40.0f, 40.0f, 0.0f, 0xffffffff, },	
    };*/
    
	VERTEX3DO vertices[] =
    {
        { -40.0f,-40.0f, 0.0f, 0xffff0000, },
        { 40.0f,-40.0f, 0.0f, 0xff0000ff, },
		{ -40.0f, 40.0f, 0.0f, 0xffffffff, },
        {  40.0f, 40.0f, 0.0f, 0xffffffff, },	


    };

    // Create the vertex buffer. Here we are allocating enough memory
    // (from the default pool) to hold all our 3 custom vertices. We also
    // specify the FVF, so the vertex buffer knows what data it contains.
    if( FAILED( m_pd3dDevice->CreateVertexBuffer( sizeof(vertices),
                                                  0, D3DFVF_VERTEX3DO,
                                                  D3DPOOL_DEFAULT, &m_pVB, NULL ) ) )
    {
        return E_FAIL;
    }

    // Now we fill the vertex buffer. To do this, we need to Lock() the VB to
    // gain access to the vertices. This mechanism is required becuase vertex
    // buffers may be in device memory.
    VOID* pVertices;
    if( FAILED( m_pVB->Lock( 0, sizeof(vertices), (void**)&pVertices, 0 ) ) )
        return E_FAIL;
    memcpy( pVertices, vertices, sizeof(vertices) );
    m_pVB->Unlock();


	//
	// cubeVerices
	//


	return S_OK;
}

//-----------------------------------------------------------------------------
// Name: InitDeviceObjects()
// Desc: Initializes device-dependent objects, including the vertex buffer used
//       for rendering text and the texture map which stores the font image.
//-----------------------------------------------------------------------------
HRESULT cc3do::InitDeviceObjects(LPDIRECT3DDEVICE9 pd3dDevice)
{
    // Keep a local copy of the device
    m_pd3dDevice = pd3dDevice;
	
	HRESULT hr = S_OK;	

	if (FAILED(hr=load3do(NULL)))
		return hr;

	return hr;
}

//-----------------------------------------------------------------------------
// Name: RestoreDeviceObjects()
// Desc:
//-----------------------------------------------------------------------------
HRESULT cc3do::RestoreDeviceObjects()
{
	HRESULT hr = S_OK;	

    if (FAILED( D3DXCreateBox(m_pd3dDevice, 80.0f, 80.0f, 80.0f, &m_pSphereMesh, NULL) ) )
        return E_FAIL;
	
	return hr;
}

//-----------------------------------------------------------------------------
// Name: InvalidateDeviceObjects()
// Desc: Destroys all device-dependent objects
//-----------------------------------------------------------------------------
HRESULT cc3do::InvalidateDeviceObjects()
{		
	SAFE_RELEASE(m_pVB);

	SAFE_RELEASE( m_pSphereMesh );

    return S_OK;
}

//-----------------------------------------------------------------------------
// Name: DeleteDeviceObjects()
// Desc: Destroys all device-dependent objects
//-----------------------------------------------------------------------------
HRESULT cc3do::DeleteDeviceObjects()
{	
    m_pd3dDevice = NULL;    

    return S_OK;
}
