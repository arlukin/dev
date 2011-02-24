//-----------------------------------------------------------------------------
// File: Matrices.cpp
//
// Desc: Now that we know how to create a device and render some 2D vertices,
//       this tutorial goes the next step and renders 3D geometry. To deal with
//       3D geometry we need to introduce the use of 4x4 matrices to transform
//       the geometry with translations, rotations, scaling, and setting up our
//       camera.
//
//       Geometry is defined in model space. We can move it (translation),
//       rotate it (rotation), or stretch it (scaling) using a world transform.
//       The geometry is then said to be in world space. Next, we need to
//       position the camera, or eye point, somewhere to look at the geometry.
//       Another transform, via the view matrix, is used, to position and
//       rotate our view. With the geometry then in view space, our last
//       transform is the projection transform, which "projects" the 3D scene
//       into our 2D viewport.
//
//       Note that in this tutorial, we are introducing the use of D3DX, which
//       is a set of helper utilities for D3D. In this case, we are using some
//       of D3DX's useful matrix initialization functions. To use D3DX, simply
//       include <d3dx9.h> and link with d3dx9.lib.
//
// Copyright (c) Microsoft Corporation. All rights reserved.
//-----------------------------------------------------------------------------
#include <Windows.h>
#include <mmsystem.h>
#include <d3dx9.h>




//-----------------------------------------------------------------------------
// Global variables
//-----------------------------------------------------------------------------
LPDIRECT3D9             g_pD3D       = NULL; // Used to create the D3DDevice
LPDIRECT3DDEVICE9       g_pd3dDevice = NULL; // Our rendering device
LPDIRECT3DVERTEXBUFFER9 g_pVB        = NULL; // Buffer to hold vertices
LPDIRECT3DVERTEXBUFFER9 g_pVB2       = NULL; // Buffer to hold vertices
LPDIRECT3DTEXTURE9      g_pTexture   = NULL; // Our texture

// A structure for our custom vertex type
struct CUSTOMVERTEX
{
    FLOAT x, y, z;      // The untransformed, 3D position for the vertex
    D3DCOLOR specular, diffuse;	
    FLOAT    tu, tv;

   
};

// Our custom FVF, which describes our custom vertex structure
#define D3DFVF_CUSTOMVERTEX (D3DFVF_XYZ |D3DFVF_DIFFUSE |D3DFVF_SPECULAR | D3DFVF_TEX1  )




//-----------------------------------------------------------------------------
// Name: InitD3D()
// Desc: Initializes Direct3D
//-----------------------------------------------------------------------------
HRESULT InitD3D( HWND hWnd )
{
    // Create the D3D object.
    if( NULL == ( g_pD3D = Direct3DCreate9( D3D_SDK_VERSION ) ) )
        return E_FAIL;

    // Set up the structure used to create the D3DDevice
    D3DPRESENT_PARAMETERS d3dpp;
    ZeroMemory( &d3dpp, sizeof(d3dpp) );
    d3dpp.Windowed = TRUE;
    d3dpp.SwapEffect = D3DSWAPEFFECT_DISCARD;
    d3dpp.BackBufferWidth = 800;
    d3dpp.BackBufferHeight = 600;	
    d3dpp.BackBufferFormat = D3DFMT_UNKNOWN;
	d3dpp.BackBufferCount = 1;


    
    
	// Create the D3DDevice
    if( FAILED( g_pD3D->CreateDevice( D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, hWnd,
                                      D3DCREATE_SOFTWARE_VERTEXPROCESSING,
                                      &d3dpp, &g_pd3dDevice ) ) )
    {
        return E_FAIL;
    }

    // Turn off culling, so we see the front and back of the triangle
    g_pd3dDevice->SetRenderState( D3DRS_CULLMODE, D3DCULL_NONE );

    // Turn off D3D lighting, since we are providing our own vertex colors
    g_pd3dDevice->SetRenderState( D3DRS_LIGHTING, FALSE );

    return S_OK;
}




//-----------------------------------------------------------------------------
// Name: InitGeometry()
// Desc: Creates the scene geometry
//-----------------------------------------------------------------------------
HRESULT InitUnit1(LPDIRECT3DVERTEXBUFFER9 * pVB)
{
    // Create the vertex buffer.
    if( FAILED( g_pd3dDevice->CreateVertexBuffer( 6*sizeof(CUSTOMVERTEX),
                                                  0, D3DFVF_CUSTOMVERTEX,
                                                  D3DPOOL_DEFAULT, pVB, NULL ) ) )
    {
        return E_FAIL;
    }

    // Fill the vertex buffer.
    CUSTOMVERTEX* v;
    if( FAILED( (*pVB)->Lock( 0, 0, (void**)&v, 0 ) ) )
        return E_FAIL;

	v[0].x  = 0.0f;  v[0].y  = 1.0;  v[0].z  = 0.0f;
	v[0].diffuse  = 0xffff0000;
	v[0].specular = 0xff00ff00;
	v[0].tu = 0.0f;  v[0].tv = 0.0f;

	v[1].x  = 0.0f;  v[1].y  = 0.0f;  v[1].z  = 0.0f;
	v[1].diffuse  = 0xff00ff00;
	v[1].specular = 0xff00ffff;
	v[1].tu = 0.0f;  v[1].tv = 0.0f;

	v[2].x  = 1.0f; v[2].y  = 1.0f; v[2].z  = 0.0f;
	v[2].diffuse  = 0xffff00ff;
	v[2].specular = 0xff000000;
	v[2].tu = 0.0f;  v[2].tv = 0.0f;

	v[3].x  = 1.0f; v[3].y  = 0.0f;  v[3].z = 0.0f;
	v[3].diffuse  = 0xffffff00;
	v[3].specular = 0xffff0000;
	v[3].tu = 0.0f; v[3].tv = 0.0f;

	v[4].x  = 1.0f;  v[4].y  = 1.0;	v[4].z = 1.0f;
	v[4].diffuse  = 0xffff0000;		
	v[4].specular = 0xff00ff00;		
	v[4].tu = 0.0f;  v[4].tv = 0.0f;
									
	v[5].diffuse  = 0xff00ff00;		
	v[5].x  = 1.0f;  v[5].y  = 0.0f;v[5].z = 1.0f;
	v[5].specular = 0xff00ffff;		
	v[5].tu = 0.0f;  v[5].tv = 0.0f;
									
											
	(*pVB)->Unlock();

    return S_OK;
}

HRESULT InitUnit2(LPDIRECT3DVERTEXBUFFER9 * pVB)
{
    // Create the vertex buffer.
    if( FAILED( g_pd3dDevice->CreateVertexBuffer( 4*sizeof(CUSTOMVERTEX),
                                                  0, D3DFVF_CUSTOMVERTEX,
                                                  D3DPOOL_DEFAULT, pVB, NULL ) ) )
    {
        return E_FAIL;
    }

    // Fill the vertex buffer.
    CUSTOMVERTEX* v;
    if( FAILED( (*pVB)->Lock( 0, 0, (void**)&v, 0 ) ) )
        return E_FAIL;

	v[0].x  = 0.0f;  v[0].y  = 4.0;  v[0].z  = 0.0f;
	v[0].diffuse  = 0xffff0000;
	v[0].specular = 0xff00ff00;
	v[0].tu = 0.0f;  v[0].tv = 0.0f;

	v[1].x  = 0.0f;  v[1].y  = 0.0f;  v[1].z  = 0.0f;
	v[1].diffuse  = 0xffff0000;;
	v[1].specular = 0xff00ffff;
	v[1].tu = 0.0f;  v[1].tv = 0.0f;

	v[2].x  = 4.0f; v[2].y  = 4.0f; v[2].z  = 0.0f;
	v[2].diffuse  = 0xffff0000;;
	v[2].specular = 0xff000000;
	v[2].tu = 0.0f;  v[2].tv = 0.0f;

	v[3].x  = 4.0f; v[3].y  = 0.0f;  v[3].z = 0.0f;
	v[3].diffuse  = 0xffff0000;;
	v[3].specular = 0xffff0000;
	v[3].tu = 0.0f; v[3].tv = 0.0f;

											
	(*pVB)->Unlock();

    return S_OK;
}

HRESULT InitGeometry()
{	
    // Use D3DX to create a texture from a file based image
    if( FAILED( D3DXCreateTextureFromFile( g_pd3dDevice, "banana.bmp", &g_pTexture ) ) )
    {
        // If texture is not in current folder, try parent folder
        if( FAILED( D3DXCreateTextureFromFile( g_pd3dDevice, "..\\banana.bmp", &g_pTexture ) ) )
        {
            MessageBox(NULL, "Could not find banana.bmp", "Textures.exe", MB_OK);
            return E_FAIL;
        }
    }

	if( FAILED(InitUnit2(&g_pVB)))
		return E_FAIL;

	if( FAILED(InitUnit1(&g_pVB2)))
		return E_FAIL;

	return S_OK;	
}




//-----------------------------------------------------------------------------
// Name: Cleanup()
// Desc: Releases all previously initialized objects
//-----------------------------------------------------------------------------
VOID Cleanup()
{
    if( g_pTexture != NULL )
        g_pTexture->Release();

    if( g_pVB != NULL )
        g_pVB->Release();

    if( g_pVB2 != NULL )
        g_pVB2->Release();

    if( g_pd3dDevice != NULL )
        g_pd3dDevice->Release();

    if( g_pD3D != NULL )
        g_pD3D->Release();
}



//-----------------------------------------------------------------------------
// Name: SetupMatrices()
// Desc: Sets up the world, view, and projection transform matrices.
//-----------------------------------------------------------------------------
VOID SetupMatrices()
{
    // For our world matrix, we will just rotate the object about the y-axis.
    D3DXMATRIXA16 matWorld1, matWorld2, matWorld3, matWorld ;

    // Set up the rotation matrix to generate 1 full rotation (2*PI radians) 
    // every 1000 ms. To avoid the loss of precision inherent in very high 
    // floating point numbers, the system time is modulated by the rotation 
    // period before conversion to a radian angle.
    
	UINT  iTime  = timeGetTime() % 1000;
    FLOAT fAngle = iTime * (2.0f * D3DX_PI) / 1000.0f;
    
	D3DXMatrixRotationX( &matWorld1, fAngle );	
	D3DXMatrixRotationY( &matWorld2, fAngle );	
	D3DXMatrixMultiply(          
		&matWorld,
		&matWorld1,
		&matWorld2
	);

	D3DXMatrixTranslation(&matWorld3,
		iTime * (2.0f * D3DX_PI) / 5000.0f,
		0,
		0
	);

	D3DXMatrixMultiply(          
		&matWorld,
		&matWorld,
		&matWorld3
	);


    g_pd3dDevice->SetTransform( D3DTS_WORLD, &matWorld );
	
	
	
	
	

    // Set up our view matrix. A view matrix can be defined given an eye point,
    // a point to lookat, and a direction for which way is up. Here, we set the
    // eye five units back along the z-axis and up three units, look at the
    // origin, and define "up" to be in the y-direction.
    D3DXVECTOR3 vEyePt( 0.0f, 0.0f,-3.0f );
    D3DXVECTOR3 vLookatPt( 0.0f, 0.0f, 0.0f );
    D3DXVECTOR3 vUpVec( 0.0f, 1.0f, 0.0f );
    D3DXMATRIXA16 matView;
    D3DXMatrixLookAtLH( &matView, &vEyePt, &vLookatPt, &vUpVec );
    g_pd3dDevice->SetTransform( D3DTS_VIEW, &matView );

    // For the projection matrix, we set up a perspective transform (which
    // transforms geometry from 3D view space to 2D viewport space, with
    // a perspective divide making objects smaller in the distance). To build
    // a perpsective transform, we need the field of view (1/4 pi is common),
    // the aspect ratio, and the near and far clipping planes (which define at
    // what distances geometry should be no longer be rendered).
    D3DXMATRIXA16 matProj;
    D3DXMatrixPerspectiveFovLH( &matProj, D3DX_PI/4, 1.0f, 1.0f, 100.0f );
    g_pd3dDevice->SetTransform( D3DTS_PROJECTION, &matProj );

}

void BackBuffer()
{
	IDirect3DSurface9 *ppBackBuffer, *ppOffScreen;
	HRESULT back;
D3DXIMAGE_INFO pSrcInfo;
	if (SUCCEEDED(back = g_pd3dDevice->CreateOffscreenPlainSurface(
		256, 256, D3DFMT_X8R8G8B8, D3DPOOL_SYSTEMMEM, &ppOffScreen, NULL)))    	
	{	
		
		if (SUCCEEDED( back = D3DXLoadSurfaceFromFile(
			ppOffScreen,
			NULL,
			NULL,
			"bana.bmp",
			NULL,
			D3DX_FILTER_TRIANGLE,
			0,
			&pSrcInfo)))
		{
			back = NULL;
		}
		else if (back == D3DERR_INVALIDCALL)
		{
			back = 0;
		}
		else if (back == D3DXERR_INVALIDDATA)
		{
			pSrcInfo.Width;
			back = 1;
		}
		else
		{
			back = 2;
		}
	}

	//if (SUCCEEDED(g_pd3dDevice->GetRenderTarget(0, &ppBackBuffer)))
	if (SUCCEEDED(g_pd3dDevice->GetBackBuffer(0, 0, D3DBACKBUFFER_TYPE_MONO, &ppBackBuffer)))
	{
		D3DSURFACE_DESC pDesc;
		ppBackBuffer->GetDesc(&pDesc);
		POINT pDestinationPoint;
	
		for (int i=0; i<4; i++)
		{
			pDestinationPoint.x = i*pSrcInfo.Width;
			for (int j=0; j<4; j++)
			{
				pDestinationPoint.y = j*pSrcInfo.Height;


				if (SUCCEEDED(back = g_pd3dDevice->UpdateSurface(ppOffScreen, NULL, ppBackBuffer, &pDestinationPoint)))
				{
					back = 0;
				}	
			}
		}
	}
	ppBackBuffer->Release();
	ppOffScreen->Release();
	

	

	/*
	if (SUCCEEDED(back =  g_pd3dDevice->CreateRenderTarget(
		256,
		256,
		D3DFMT_R8G8B8,
		D3DMULTISAMPLE_NONE,
		0,
		true,
		&ppBackBuffer,
		NULL)))
		*/

	/*if (SUCCEEDED(back = g_pd3dDevice->CreateDepthStencilSurface(
		256,
		256,
		D3DFMT_D16,
		D3DMULTISAMPLE_NONE,
		0,
		true,
		&ppBackBuffer,
		NULL)))*/
	//if (SUCCEEDED(g_pd3dDevice->GetBackBuffer(0, 0, D3DBACKBUFFER_TYPE_MONO, &ppBackBuffer)))
/*

		
		D3DLOCKED_RECT pLockedRect;
		if (SUCCEEDED(back = ppBackBuffer->LockRect(&pLockedRect, NULL, D3DLOCK_READONLY)))
		{
			back=1;
		}
		
		

*/




				
/*

		HDC phdc;

		if (SUCCEEDED(back = ppBackBuffer->GetDC(&phdc)))

		//if (SUCCEEDED(back = ppBackBuffer->LockRect(&pLockedRect, NULL, D3DLOCK_READONLY)))
		{
			BYTE* pSrcTopRow = (BYTE*)pLockedRect.pBits;
			DWORD dwSrcPitch = (DWORD)pLockedRect.Pitch;
			*pSrcTopRow =1;
			//for(int i=0;i<1;i++)
			//	*(pSrcTopRow+(i*dwSrcPitch)) = 1;

		}
		else if (back == D3DERR_INVALIDCALL)
		{
			back = 0;
		}
		else if(back == D3DERR_WASSTILLDRAWING)
		{
			back = 0;
		}

*/
//		ppBackBuffer->UnlockRect();


}

//-----------------------------------------------------------------------------
// Name: Render()
// Desc: Draws the scene
//-----------------------------------------------------------------------------
VOID Render()
{
	

    // Clear the backbuffer to a black color
	g_pd3dDevice->Clear( 0, NULL, D3DCLEAR_TARGET, D3DCOLOR_XRGB(0,0,255), 1.0f, 0L );
	//BackBuffer();	



    // Begin the scene
    if( SUCCEEDED( g_pd3dDevice->BeginScene() ) )
    {

		g_pd3dDevice->SetTexture( 0, g_pTexture );
		/*
        g_pd3dDevice->SetTextureStageState( 0, D3DTSS_COLOROP,   D3DTOP_MODULATE );
        g_pd3dDevice->SetTextureStageState( 0, D3DTSS_COLORARG1, D3DTA_TEXTURE );
        g_pd3dDevice->SetTextureStageState( 0, D3DTSS_COLORARG2, D3DTA_DIFFUSE );
        g_pd3dDevice->SetTextureStageState( 0, D3DTSS_ALPHAOP,   D3DTOP_DISABLE );
		*/
/*
        D3DXMATRIXA16 mat;
        mat._11 = 0.25f; mat._12 = 0.00f; mat._13 = 0.00f; mat._14 = 0.00f;
        mat._21 = 0.00f; mat._22 =-0.25f; mat._23 = 0.00f; mat._24 = 0.00f;
        mat._31 = 0.00f; mat._32 = 0.00f; mat._33 = 1.00f; mat._34 = 0.00f;
        mat._41 = 0.50f; mat._42 = 0.50f; mat._43 = 0.00f; mat._44 = 1.00f;

        g_pd3dDevice->SetTransform( D3DTS_TEXTURE0, &mat );
		*/

		//g_pd3dDevice->SetTextureStageState( 0, D3DTSS_TEXTURETRANSFORMFLAGS, D3DTTFF_COUNT2 );
        g_pd3dDevice->SetTextureStageState( 0, D3DTSS_TEXCOORDINDEX, D3DTSS_TCI_CAMERASPACEPOSITION);

		
		
        /*
		D3DXMATRIXA16 matWorld ;
    
		UINT  iTime  = timeGetTime() % 1000;
		FLOAT fAngle = iTime * (2.0f * D3DX_PI) / 1000.0f;
    
		D3DXMatrixRotationX( &matWorld, 0);	
		g_pd3dDevice->SetTransform( D3DTS_WORLD, &matWorld );
		*/

        // Render the vertex buffer contents
		g_pd3dDevice->SetFVF( D3DFVF_CUSTOMVERTEX );
        g_pd3dDevice->SetStreamSource( 0, g_pVB, 0, sizeof(CUSTOMVERTEX) );
		g_pd3dDevice->DrawPrimitive( D3DPT_TRIANGLESTRIP, 0, 2);






		// Setup the world, view, and projection matrices
		/*
        SetupMatrices();


		//g_pd3dDevice->SetTexture( 0, NULL );
        g_pd3dDevice->SetStreamSource( 0, g_pVB2, 0, sizeof(CUSTOMVERTEX) );
        g_pd3dDevice->DrawPrimitive( D3DPT_TRIANGLESTRIP, 0, 4);

*/

        // End the scene
        g_pd3dDevice->EndScene();
    }

    // Present the backbuffer contents to the display
    g_pd3dDevice->Present( NULL, NULL, NULL, NULL );
}




//-----------------------------------------------------------------------------
// Name: MsgProc()
// Desc: The window's message handler
//-----------------------------------------------------------------------------
LRESULT WINAPI MsgProc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
    switch( msg )
    {
        case WM_DESTROY:
            Cleanup();
            PostQuitMessage( 0 );
            return 0;

		case WM_SETCURSOR:
			// Turn off window cursor 
			SetCursor( NULL );
			g_pd3dDevice->ShowCursor( TRUE );
			return TRUE; // prevent Windows from setting cursor to window class cursor
		break;

    }

    return DefWindowProc( hWnd, msg, wParam, lParam );
}




//-----------------------------------------------------------------------------
// Name: WinMain()
// Desc: The application's entry point
//-----------------------------------------------------------------------------
INT WINAPI WinMain( HINSTANCE hInst, HINSTANCE, LPSTR, INT )
{
    // Register the window class
    WNDCLASSEX wc = { sizeof(WNDCLASSEX), CS_CLASSDC, MsgProc, 0L, 0L,
                      GetModuleHandle(NULL), NULL, NULL, NULL, NULL,
                      "D3D Tutorial", NULL };
    RegisterClassEx( &wc );

    // Create the application's window
    HWND hWnd = CreateWindow( "D3D Tutorial", "D3D Tutorial 03: Matrices",
                              WS_OVERLAPPEDWINDOW, 100, 100, 800, 600,
                              GetDesktopWindow(), NULL, wc.hInstance, NULL );

    // Initialize Direct3D
    if( SUCCEEDED( InitD3D( hWnd ) ) )
    {
        // Create the scene geometry
        if( SUCCEEDED( InitGeometry() ) )
        {
			
            // Show the window
            ShowWindow( hWnd, SW_SHOWDEFAULT );
            UpdateWindow( hWnd );

            // Enter the message loop
            MSG msg;
            ZeroMemory( &msg, sizeof(msg) );
            while( msg.message!=WM_QUIT )
            {
                if( PeekMessage( &msg, NULL, 0U, 0U, PM_REMOVE ) )
                {
                    TranslateMessage( &msg );
                    DispatchMessage( &msg );
                }
                else
                    Render();
            }
        }
    }

    UnregisterClass( "D3D Tutorial", wc.hInstance );
    return 0;
}