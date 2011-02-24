//-----------------------------------------------------------------------------
// File: TotalFirepower.cpp
//
// Desc: Example code showing how to use D3D lights.
//
// Copyright (c) Microsoft Corporation. All rights reserved.
//-----------------------------------------------------------------------------
#define STRICT
#include "stdafx.h"
#include "ccSettings.h"
#include "ccPlayer.h"
#include "ccTileMap.h"
#include "TotalFirePower.h"

POINT3D g_Position1 = {0, 0, 0};
POINT3D g_Position2 = {0, 0, -800.0f};
POINT3D g_Position3 = {0, 0, 0};
POINT3D g_Position4 = {200, 5000, D3DX_PI/4};


//-----------------------------------------------------------------------------
// Name: WinMain()
// Desc: Entry point to the program. Initializes everything, and goes into a
//       message-processing loop. Idle time is used to render the scene.
//-----------------------------------------------------------------------------
INT WINAPI WinMain( HINSTANCE hInst, HINSTANCE, LPSTR, INT )
{
    CMyD3DApplication d3dApp;

    InitCommonControls();

    if( FAILED( d3dApp.Create( hInst ) ) )
        return 0;	

    return d3dApp.Run();
}

HRESULT CMyD3DApplication::Create(HINSTANCE hInstance)
{
	HRESULT hr;
	if (SUCCEEDED(hr = CD3DApplication::Create(hInstance)))
		SetTimer( m_hWnd, 1, 1000/30, NULL );

	return hr;
}

//-----------------------------------------------------------------------------
// Name: CMyD3DApplication()
// Desc: Application constructor. Sets attributes for the app.
//-----------------------------------------------------------------------------
CMyD3DApplication::CMyD3DApplication() 
: m_units(AL_REFERENCE)
{ 
	// GFX Modes
    m_strWindowTitle            = TEXT( "TotalFirepower" );
    m_d3dEnumeration.AppUsesDepthBuffer = FALSE;
	
    m_pFont                     = new CD3DFont( _T("Arial"), 12, D3DFONT_BOLD );
    m_pFontSmall                = new CD3DFont( _T("Arial"), 9, D3DFONT_BOLD );

	m_bCapture = FALSE;

    m_dwCreationWidth   = 800;
    m_dwCreationHeight  = 800;
	//m_bStartFullscreen = TRUE;
	
	//	
	m_settings = new ccSettings(this);
	
	m_pTileMap = new ccTileMap;
	
	//
	m_pPlayer1 = new ccPlayer();	
	m_pPlayer1->createUnit(m_pTileMap, &m_units);
	m_units.Add(m_pPlayer1->getUnit());

	//
	m_pPlayer2 = new ccPlayer();
	m_pPlayer2->createUnit(m_pTileMap, &m_units);
	m_units.Add(m_pPlayer2->getUnit());

	//
	m_oneScreenWriteArea.left = m_oneScreenWriteArea.top = 0;
	m_oneScreenWriteArea.right = m_oneScreenWriteArea.bottom = 0;

	m_player1WriteArea.left = m_player1WriteArea.top = 0;
	m_player1WriteArea.right = m_player1WriteArea.bottom = 0;

	m_player2WriteArea.left = m_player2WriteArea.top = 0;
	m_player2WriteArea.right = m_player2WriteArea.bottom = 0;	

}

CMyD3DApplication::~CMyD3DApplication()
{
	// See FinalCleanup
}

//-----------------------------------------------------------------------------
// Name: FinalCleanup()
// Desc: Called before the app exits, this function gives the app the chance
//       to cleanup after itself.
//-----------------------------------------------------------------------------
HRESULT CMyD3DApplication::FinalCleanup()
{
    // Cleanup D3D font
    SAFE_DELETE(m_pFont);
    SAFE_DELETE(m_pFontSmall);

	SAFE_DELETE(m_settings);
	//SAFE_DELETE(m_units);

	SAFE_DELETE(m_pTileMap);
	SAFE_DELETE(m_pPlayer1);
	SAFE_DELETE(m_pPlayer2);

    return S_OK;
}

HRESULT CMyD3DApplication::OneTimeSceneInit()
{
    return S_OK;
}


//-----------------------------------------------------------------------------
// Name: InitDeviceObjects()
// Desc: Initialize scene objects.
//-----------------------------------------------------------------------------
HRESULT CMyD3DApplication::InitDeviceObjects()
{
    HRESULT hr;

    if( FAILED( hr = m_pFont->InitDeviceObjects(m_pd3dDevice)))
        return hr;

    if( FAILED(hr = m_pFontSmall->InitDeviceObjects(m_pd3dDevice)))
        return hr;

    if( FAILED(hr = m_pTileMap->InitDeviceObjects(m_pd3dDevice)))
        return hr;	

	if(FAILED(hr = m_pPlayer1->getUnit()->InitDeviceObjects(m_pd3dDevice)))
		return hr;

	if(FAILED(hr = m_pPlayer2->getUnit()->InitDeviceObjects(m_pd3dDevice)))
		return hr;

    return S_OK;
}

//-----------------------------------------------------------------------------
// Name: RestoreDeviceObjects()
// Desc: Restores scene objects.
//-----------------------------------------------------------------------------
HRESULT CMyD3DApplication::RestoreDeviceObjects()
{	
	// Set miscellaneous render states
    m_pd3dDevice->SetRenderState( D3DRS_DITHERENABLE,   FALSE );
    m_pd3dDevice->SetRenderState( D3DRS_SPECULARENABLE, FALSE);

    // Turn off culling, so we see the front and back of the triangle
    //m_pd3dDevice->SetRenderState( D3DRS_CULLMODE, D3DCULL_NONE );

    // Turn off D3D lighting, since we are providing our own vertex colors
    m_pd3dDevice->SetRenderState( D3DRS_LIGHTING, FALSE );

    // Restore the font
	HRESULT hr;
    if (FAILED(hr = m_pFont->RestoreDeviceObjects()))
		return hr;

    if (FAILED(hr = m_pFontSmall->RestoreDeviceObjects()))
		return hr;

	if (FAILED(hr = m_pTileMap->RestoreDeviceObjects()))
		return hr;	

	// oneScreen	
	m_oneScreenWriteArea.left = 32;
	m_oneScreenWriteArea.top = 32;
	m_oneScreenWriteArea.right = m_d3dsdBackBuffer.Width-32;
	m_oneScreenWriteArea.bottom = ((m_d3dsdBackBuffer.Height-32)/32)*32;

	// Player 1
	m_player1WriteArea.left = 32;
	m_player1WriteArea.top = 32;
	m_player1WriteArea.right = (((m_d3dsdBackBuffer.Width/2)-16)/32);
	m_player1WriteArea.right *= 32;
	m_player1WriteArea.bottom = ((m_d3dsdBackBuffer.Height-32)/32)*32;

	if (FAILED(hr = m_pPlayer1->getUnit()->RestoreDeviceObjects()))
		return hr;

	// Player 2
	m_player2WriteArea.left = (((m_d3dsdBackBuffer.Width/2)+16)/32);
	m_player2WriteArea.left *= 32;
	m_player2WriteArea.top = 32;
	m_player2WriteArea.right = m_d3dsdBackBuffer.Width-32;
	m_player2WriteArea.bottom = ((m_d3dsdBackBuffer.Height-32)/32)*32;


	if (FAILED(hr = m_pPlayer2->getUnit()->RestoreDeviceObjects()))
		return hr;

	m_pPlayer2->getUnit()->setPosition(150,150);


    return S_OK;
}

//-----------------------------------------------------------------------------
// Name: Render()
// Desc: Called once per frame, the call is the entry point for 3d
//       rendering. This function sets up render states, clears the
//       viewport, and renders the scene.
//-----------------------------------------------------------------------------
HRESULT CMyD3DApplication::Render()
{
    // Clear the viewport
    m_pd3dDevice->Clear( 0L, NULL, D3DCLEAR_TARGET, 0x000000ff, 1.0f, 0L );

    // Begin the scene
    if( SUCCEEDED( m_pd3dDevice->BeginScene() ) )
    {		
		POINT *player1WorldPos, *player2WorldPos ;
		SIZE *player1UnitSize, *player2UnitSize;

		player1WorldPos = m_pPlayer1->getUnit()->getWorldPosition();		
		player2WorldPos = m_pPlayer2->getUnit()->getWorldPosition();

		player1UnitSize = m_pPlayer1->getUnit()->getUnitSize();				
		player2UnitSize = m_pPlayer2->getUnit()->getUnitSize();				

		// Both player fit on same screen.
		int xDistance = abs(player1WorldPos->x-player2WorldPos->x)+player1UnitSize->cx+player2UnitSize->cx;
		int yDistance = abs(player1WorldPos->y-player2WorldPos->y)+player1UnitSize->cy+player2UnitSize->cy;
		if (xDistance < (m_oneScreenWriteArea.right - m_oneScreenWriteArea.left) && 
			yDistance < (m_oneScreenWriteArea.bottom - m_oneScreenWriteArea.top)
		   )
		{
			POINT oneScreenWorldPos;
			oneScreenWorldPos.x = ((player1WorldPos->x + player2WorldPos->x)/2) + ((player1UnitSize->cx +player1UnitSize->cx) /4);
			oneScreenWorldPos.y = (player1WorldPos->y + player2WorldPos->y)/2  + ((player1UnitSize->cy +player1UnitSize->cy) /4);;

			SIZE noSize;
			noSize.cx = (player1UnitSize->cx + player2UnitSize->cx);
			noSize.cy = (player1UnitSize->cy + player2UnitSize->cy);

			m_pTileMap->setWriteArea(&m_oneScreenWriteArea);							
			m_pTileMap->centerAround(&oneScreenWorldPos, &noSize);
			m_pTileMap->DrawMap();			
			drawUnits();

		}
		else
		{								
			
			//
			// Draw Player 1 screen.
			//        
			m_pTileMap->setWriteArea(&m_player1WriteArea);							
			m_pTileMap->centerAround(player1WorldPos, player1UnitSize);
			m_pTileMap->DrawMap();
			drawUnits();

			//
			// Draw Player 2 screen.
			//
			m_pTileMap->setWriteArea(&m_player2WriteArea);					
			m_pTileMap->centerAround(player2WorldPos, player2UnitSize);
			m_pTileMap->DrawMap();
			drawUnits();
		}

		// Output statistics
		drawStatistics();

        // End the scene.
        m_pd3dDevice->EndScene();
    }

    return S_OK;
}


//-----------------------------------------------------------------------------
// Name: InvalidateDeviceObjects()
// Desc: Invalidates device objects.  
//-----------------------------------------------------------------------------
HRESULT CMyD3DApplication::InvalidateDeviceObjects()
{	
    m_pFont->InvalidateDeviceObjects();
    m_pFontSmall->InvalidateDeviceObjects();

	m_pTileMap->InvalidateDeviceObjects();
	m_pPlayer1->getUnit()->InvalidateDeviceObjects();
	m_pPlayer2->getUnit()->InvalidateDeviceObjects();

    return S_OK;
}




//-----------------------------------------------------------------------------
// Name: DeleteDeviceObjects()
// Desc: Called when the app is exiting, or the device is being changed,
//       this function deletes any device dependent objects.  
//-----------------------------------------------------------------------------
HRESULT CMyD3DApplication::DeleteDeviceObjects()
{
    m_pFont->DeleteDeviceObjects();
    m_pFontSmall->DeleteDeviceObjects();

	m_pTileMap->DeleteDeviceObjects();
	m_pPlayer1->getUnit()->DeleteDeviceObjects();
	m_pPlayer2->getUnit()->DeleteDeviceObjects();

    return S_OK;
}


//-----------------------------------------------------------------------------
// Name: MsgProc()
// Desc: Message proc function
//-----------------------------------------------------------------------------
LRESULT CMyD3DApplication::MsgProc( HWND hWnd, UINT uMsg, WPARAM wParam,
                                    LPARAM lParam )
{	
    switch( uMsg )
    {
		case WM_TIMER:
		{
			m_settings->checkInput();
		}
		break;

		case WM_COMMAND:
			break;
	}

    // Capture mouse when clicked
	/*
    if( WM_LBUTTONDOWN == uMsg )
    {
        D3DXMATRIXA16 matCursor;
        D3DXQUATERNION qCursor = D3DUtil_GetRotationFromCursor( m_hWnd );
        D3DXMatrixRotationQuaternion( &matCursor, &qCursor );
        D3DXMatrixTranspose( &matCursor, &matCursor );
        D3DXMatrixMultiply( &m_matTrackBall, &m_matTrackBall, &matCursor );

        SetCapture( m_hWnd );
        m_bCapture = TRUE;
        return 0;
    }

    if( WM_LBUTTONUP == uMsg )
    {
        D3DXMATRIXA16 matCursor;
        D3DXQUATERNION qCursor = D3DUtil_GetRotationFromCursor( m_hWnd );
        D3DXMatrixRotationQuaternion( &matCursor, &qCursor );
        D3DXMatrixMultiply( &m_matTrackBall, &m_matTrackBall, &matCursor );

        ReleaseCapture();
        m_bCapture = FALSE;
        return 0;
    }
	*/

    return CD3DApplication::MsgProc( hWnd, uMsg, wParam, lParam );
}

//-----------------------------------------------------------------------------
// Name: FrameMove()
// Desc: Called once per frame, the call is the entry point for animating
//       the scene.
//-----------------------------------------------------------------------------
HRESULT CMyD3DApplication::FrameMove()
{
	HRESULT hr;
	if (FAILED( hr = checkInput()))
		return hr;

    // When the window has focus, let the mouse adjust the camera view
    //if( m_bCapture )
    {				
		/*
        D3DXMATRIXA16 matCursor;
        D3DXQUATERNION qCursor = D3DUtil_GetRotationFromCursor( m_hWnd );
        D3DXMatrixRotationQuaternion( &matCursor, &qCursor );
        D3DXMatrixMultiply( &m_matView, &m_matTrackBall, &matCursor );

        D3DXMATRIXA16 matTrans;
        D3DXMatrixTranslation( &matTrans, 0.0f, 0.0f, -10.0f );
        D3DXMatrixMultiply( &m_matView, &m_matView, &matTrans );
		*/
    }

    return S_OK;
}

HRESULT CMyD3DApplication::checkInput()
{
	DWORD *dwInput = m_settings->m_actionState.dwInput;

	float currentMousePos = 0;
	// Coordinate one
	if (dwInput[COORDINATE_Z])
	{
		if (dwInput[COORDINATE_SPACE])
		{
		}
		else
		{
			if (dwInput[PLAYER1_DRIVE])
				m_pPlayer1->getUnit()->movePosition(0, dwInput[PLAYER1_DRIVE]);
			
			if (dwInput[PLAYER1_STEER])
				m_pPlayer1->getUnit()->movePosition(dwInput[PLAYER1_STEER], 0);
		}		
	}

	//
	// Coordinate 1
	//
	else if (dwInput[COORDINATE_X])
	{				
		if (dwInput[COORDINATE_SPACE])
		{
			if (dwInput[PLAYER1_STEER])
			{
				currentMousePos = (float)((short)dwInput[PLAYER1_STEER]);		
				g_Position1.z += currentMousePos;				
				m_pPlayer1->getUnit()->rotate(0, 0, currentMousePos * (2.0f * D3DX_PI) / 1000.0f);				
			}
		}
		else
		{
			if (dwInput[PLAYER1_STEER])
			{
				currentMousePos = (float)((short)dwInput[PLAYER1_STEER]);		
				g_Position1.x += currentMousePos;
				m_pPlayer1->getUnit()->rotate(currentMousePos * (2.0f * D3DX_PI) / 1000.0f, 0, 0);
			}

			if (dwInput[PLAYER1_DRIVE])
			{				
				currentMousePos = (float)((short)dwInput[PLAYER1_DRIVE]);		
				g_Position1.y += currentMousePos;
				m_pPlayer1->getUnit()->rotate(0, currentMousePos * (2.0f * D3DX_PI) / 1000.0f, 0);				
			}
		}
	}

	//
	// Coordinate 2
	//
	else if (dwInput[COORDINATE_C])
	{				
		if (dwInput[COORDINATE_SPACE])
		{
			if (dwInput[PLAYER1_STEER])
			{
				currentMousePos = (float)((short)dwInput[PLAYER1_STEER]);		
				g_Position2.z += currentMousePos;								
			}
		}
		else
		{
			if (dwInput[PLAYER1_STEER])
			{
				currentMousePos = (float)((short)dwInput[PLAYER1_STEER]);		
				g_Position2.x += currentMousePos;			
			}

			if (dwInput[PLAYER1_DRIVE])
			{				
				currentMousePos = (float)((short)dwInput[PLAYER1_DRIVE]);		
				g_Position2.y += currentMousePos;				
			}
		}
	}
	//
	// Coordinate 3
	//
	else if (dwInput[COORDINATE_V])
	{				
		if (dwInput[COORDINATE_SPACE])
		{
			if (dwInput[PLAYER1_STEER])
			{
				currentMousePos = (float)((short)dwInput[PLAYER1_STEER]);		
				g_Position3.z += currentMousePos;				
				
			}
		}
		else
		{
			if (dwInput[PLAYER1_STEER])
			{
				currentMousePos = (float)((short)dwInput[PLAYER1_STEER]);		
				g_Position3.x += currentMousePos;				
			}

			if (dwInput[PLAYER1_DRIVE])
			{				
				currentMousePos = (float)((short)dwInput[PLAYER1_DRIVE]);		
				g_Position3.y += currentMousePos;				
			}
		}
	}
	//
	// Coordinate 4
	//
	else if (dwInput[COORDINATE_B])
	{				
		if (dwInput[COORDINATE_SPACE])
		{
			if (dwInput[PLAYER1_STEER])
			{
				currentMousePos = (float)((short)dwInput[PLAYER1_STEER]);		
				g_Position4.z += currentMousePos/10000;				
				
			}
		}
		else
		{
			if (dwInput[PLAYER1_STEER])
			{
				currentMousePos = (float)((short)dwInput[PLAYER1_STEER]);		
				g_Position4.x += currentMousePos;				
			}

			if (dwInput[PLAYER1_DRIVE])
			{				
				currentMousePos = (float)((short)dwInput[PLAYER1_DRIVE]);		
				g_Position4.y += currentMousePos;				
			}
		}
	}
	else
	{
		DWORD dwData;
		for( int dwAction=0; dwAction < NUM_OF_ACTIONS; dwAction++ )
		{
			dwData = dwInput[dwAction];
			if (dwData > 0)
			{			
				switch (dwAction)
				{
					//
					// Player 1
					//
					case PLAYER1_DRIVE_FORWARD:
						m_pPlayer1->getUnit()->movePosition(0, -1);
					break;

					case PLAYER1_DRIVE_BACKWARD:
						m_pPlayer1->getUnit()->movePosition(0, 1);
					break;

					case PLAYER1_STEER_LEFT:
						m_pPlayer1->getUnit()->movePosition(-1, 0);
					break;

					case PLAYER1_STEER_RIGHT:
						m_pPlayer1->getUnit()->movePosition(1, 0);
					break;

					//
					// Player 2
					//

					case PLAYER2_DRIVE:
						m_pPlayer2->getUnit()->movePosition(0, dwData);
					break;

					case PLAYER2_STEER:
						m_pPlayer2->getUnit()->movePosition(dwData, 0);
					break;

					case PLAYER2_DRIVE_FORWARD:
						m_pPlayer2->getUnit()->movePosition(0, -1);
					break;

					case PLAYER2_DRIVE_BACKWARD:
						m_pPlayer2->getUnit()->movePosition(0, 1);
					break;

					case PLAYER2_STEER_LEFT:
						m_pPlayer2->getUnit()->movePosition(-1, 0);
					break;

					case PLAYER2_STEER_RIGHT:
						m_pPlayer2->getUnit()->movePosition(1, 0);
					break;

					//
					// System
					//

					case QUIT:
						//PostQuitMessage(0);
						SendMessage( m_hWnd, WM_CLOSE, 0, 0 );
						return E_FAIL;
					break;		
				}					
			}
		}		
	}
	return S_OK;
}


HWND CMyD3DApplication::getWindow()
{
	return m_hWnd;
}

void CMyD3DApplication::drawStatistics()
{    
    m_pFont->DrawText( 2, 0, D3DCOLOR_ARGB(255,255,255,0), m_strDeviceStats );

	
	TCHAR buffer[512];	
	const int cchBufferSize = sizeof(buffer) / sizeof(TCHAR);
	buffer[0]  = _T('\0');

	//
	// Screen Data.
	//		
   
    _sntprintf( buffer, cchBufferSize, 
		_T("%s"), m_strFrameStats
		);
        
	m_strFrameStats[cchBufferSize - 1] = TEXT('\0');

	m_pFont->DrawText( 2, 20, D3DCOLOR_ARGB(255,255,255,0), buffer );

	//
	// Draw worldmap coord.	
	//
	POINT *worldPosition = m_pTileMap->getWorldPosition();
	SIZE  *worldSize = m_pTileMap->getWorldSize();
    
    _sntprintf( buffer, cchBufferSize, 
		_T("World position: (%d, %d) World size:(%dx%d)"),
		worldPosition->x, worldPosition->y,
		worldSize->cx, worldSize->cy
		);
        
	m_strFrameStats[cchBufferSize - 1] = TEXT('\0');

	m_pFont->DrawText( 2, 40, D3DCOLOR_ARGB(255,255,255,0), buffer );
	
	//
	// Draw Player 1 unit coord.
	//	
	worldPosition = m_pPlayer1->getUnit()->getWorldPosition();
	SIZE * unitSize = m_pPlayer1->getUnit()->getUnitSize();
    
    _sntprintf( buffer, cchBufferSize, 
		_T("Unit position: (%d, %d) Unit size (%d, %d), writeArea: (%d, %d - %d, %d)"),
		worldPosition->x, worldPosition->y,
		unitSize->cx, unitSize->cy,		
		m_player1WriteArea.left, m_player1WriteArea.top,
		m_player1WriteArea.right-m_player1WriteArea.left, m_player1WriteArea.bottom - m_player1WriteArea.top		
		);
        
	m_strFrameStats[cchBufferSize - 1] = TEXT('\0');

	m_pFont->DrawText( 2, 60, D3DCOLOR_ARGB(255,255,255,0), buffer );

	//
	// Draw Player 2 unit coord.
	//
	worldPosition = m_pPlayer2->getUnit()->getWorldPosition();
	unitSize = m_pPlayer2->getUnit()->getUnitSize();
    
    _sntprintf( buffer, cchBufferSize, 
		_T("Unit position: (%d, %d) Unit size (%d, %d), writeArea: (%d, %d - %d, %d)"),
		worldPosition->x, worldPosition->y,
		unitSize->cx, unitSize->cy,		
		m_player2WriteArea.left, m_player2WriteArea.top,
		m_player2WriteArea.right-m_player2WriteArea.left, m_player2WriteArea.bottom - m_player2WriteArea.top		
		);
        
	m_strFrameStats[cchBufferSize - 1] = TEXT('\0');

	m_pFont->DrawText( 2, 80, D3DCOLOR_ARGB(255,255,255,0), buffer );

	// Draw Coordination Test position	
    _sntprintf( buffer, cchBufferSize, _T("Coordination position: (%f, %f, %f)"), g_Position1.x, g_Position1.y, g_Position1.z );	
	m_strFrameStats[cchBufferSize - 1] = TEXT('\0');
	m_pFont->DrawText( 2, 100, D3DCOLOR_ARGB(255,255,255,0), buffer );
	
	//
    _sntprintf( buffer, cchBufferSize, _T("Coordination position: (%f, %f, %f)"), g_Position2.x, g_Position2.y, g_Position2.z );	
	m_strFrameStats[cchBufferSize - 1] = TEXT('\0');
	m_pFont->DrawText( 2, 120, D3DCOLOR_ARGB(255,255,255,0), buffer );

	//
    _sntprintf( buffer, cchBufferSize, _T("Coordination position: (%f, %f, %f)"), g_Position3.x, g_Position3.y, g_Position3.z );	
	m_strFrameStats[cchBufferSize - 1] = TEXT('\0');
	m_pFont->DrawText( 2, 140, D3DCOLOR_ARGB(255,255,255,0), buffer );

	//
    _sntprintf( buffer, cchBufferSize, _T("Coordination position: (%f, %f, %f)"), g_Position4.x, g_Position4.y, g_Position4.z );	
	m_strFrameStats[cchBufferSize - 1] = TEXT('\0');
	m_pFont->DrawText( 2, 160, D3DCOLOR_ARGB(255,255,255,0), buffer );

}

HRESULT CMyD3DApplication::drawUnits()
{
	// Setup the world, view, and projection matrices
	setupMatrix();

	for(int i=0;i<m_units.count();i++)
	{
		((ccUnit*)m_units[i])->drawUnit();
	}

	return S_OK;
}

void CMyD3DApplication::isD3DSpy()
{
    typedef VOID (*D3DSPYBREAK)();
    HMODULE hModule;
    D3DSPYBREAK D3DSpyBreak;
    hModule = LoadLibrary( TEXT("d3d9.dll") );
    if( hModule != NULL )
    {
        D3DSpyBreak = (D3DSPYBREAK)GetProcAddress( hModule, "D3DSpyBreak" );
        if( D3DSpyBreak != NULL )
        {
            MessageBox(NULL, "d3dspy monitoring the program", NULL, MB_OK);
        }
        else
        {
            // D3DSpy is not monitoring this program.
        }
    }
}

HRESULT CMyD3DApplication::setupMatrix()
{	
    // Set up our view matrix. A view matrix can be defined given an eye point,
    // a point to lookat, and a direction for which way is up. Here, we set the
    // eye five units back along the z-axis and up three units, look at the
    // origin, and define "up" to be in the y-direction.

    D3DXVECTOR3 vEyePt( g_Position2.x, g_Position2.y, g_Position2.z );
    D3DXVECTOR3 vLookatPt( g_Position3.x, g_Position3.y, g_Position3.z );
    D3DXVECTOR3 vUpVec( 0.0f, 1.0f, 0.0f );
    D3DXMATRIXA16 matView;
    D3DXMatrixLookAtLH( &matView, &vEyePt, &vLookatPt, &vUpVec );
    m_pd3dDevice->SetTransform( D3DTS_VIEW, &matView );

    // For the projection matrix, we set up a perspective transform (which
    // transforms geometry from 3D view space to 2D viewport space, with
    // a perspective divide making objects smaller in the distance). To build
    // a perpsective transform, we need the field of view (1/4 pi is common),
    // the aspect ratio, and the near and far clipping planes (which define at
    // what distances geometry should be no longer be rendered).
    D3DXMATRIXA16 matProj;
	
    FLOAT fAspect = ((FLOAT)m_d3dsdBackBuffer.Width) / m_d3dsdBackBuffer.Height;   	
	D3DXMatrixPerspectiveFovLH( &matProj, g_Position4.z, fAspect, g_Position4.x, g_Position4.y );    

	/*
	D3DXMatrixPerspectiveOffCenterLH(&matProj,
		-30, (FLOAT)m_d3dsdBackBuffer.Width,
		-30, (FLOAT)m_d3dsdBackBuffer.Height,
		-30, 1000.0f
	);

	D3DXMatrixPerspectiveOffCenterLH(&matProj,
		-400.0f, 400.0f,
		-400.0f, 400.0f,
		-400.0f, 40.0f
	*/

    m_pd3dDevice->SetTransform( D3DTS_PROJECTION, &matProj );

	return S_OK;
}

void CMyD3DApplication::BuildPresentParamsFromSettings()
{
	CD3DApplication::BuildPresentParamsFromSettings();
	return;
}
