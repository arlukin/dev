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
{
    m_strWindowTitle            = TEXT( "TotalFirepower" );
    m_d3dEnumeration.AppUsesDepthBuffer           = FALSE;

	m_player1WriteArea.left = m_player1WriteArea.top = 0;
	m_player1WriteArea.right = m_player1WriteArea.bottom = 0;

	m_player2WriteArea.left = m_player2WriteArea.top = 0;
	m_player2WriteArea.right = m_player2WriteArea.bottom = 0;

    m_pFont                     = new CD3DFont( _T("Arial"), 12, D3DFONT_BOLD );
    m_pFontSmall                = new CD3DFont( _T("Arial"), 9, D3DFONT_BOLD );
	m_pTileMap					= new ccTileMap;
	m_pPlayer1					= new ccPlayer;
	m_pPlayer2					= new ccPlayer;
	
	m_bCapture = FALSE;

    m_dwCreationWidth   = 800;
    m_dwCreationHeight  = 600;
	//m_bStartFullscreen = TRUE;

	m_settings = new ccSettings(this);
}

CMyD3DApplication::~CMyD3DApplication()
{
	SAFE_DELETE(m_settings);	
}

HRESULT CMyD3DApplication::OneTimeSceneInit()
{
    D3DXMatrixIdentity( &m_matTrackBall );    

    D3DXMATRIXA16 matView;
    D3DXVECTOR3 vFromPt( 0, 10, -10);
    D3DXVECTOR3 vLookatPt( 0.0f, 0.0f, 0.0f );
    D3DXVECTOR3 vUpVec( 0.0f, -1.0f, 0.0f );
    D3DXMatrixLookAtLH( &m_matView, &vFromPt, &vLookatPt, &vUpVec );	

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
    m_pd3dDevice->SetRenderState( D3DRS_SPECULARENABLE, FALSE );

    // Set the world matrix
    D3DXMATRIXA16 matIdentity;
    D3DXMatrixIdentity( &matIdentity );
    m_pd3dDevice->SetTransform( D3DTS_WORLD,  &matIdentity );

    // Set the view matrix.
    D3DXMATRIXA16 matView;
    D3DXVECTOR3 vFromPt( 0, 10, -10);
    D3DXVECTOR3 vLookatPt( 0.0f, 0.0f, 0.0f );
    D3DXVECTOR3 vUpVec( 0.0f, -1.0f, 0.0f );
    D3DXMatrixLookAtLH( &matView, &vFromPt, &vLookatPt, &vUpVec );
    m_pd3dDevice->SetTransform( D3DTS_VIEW, &matView );

    // Set the projection matrix
    D3DXMATRIXA16 matProj;
    FLOAT fAspect = ((FLOAT)m_d3dsdBackBuffer.Width) / m_d3dsdBackBuffer.Height;
    
	//FIX:	
	//D3DXMatrixPerspectiveFovLH( &matProj, D3DX_PI/4, fAspect, 1.0f, 100.0f );
	
	D3DXMatrixPerspectiveFovLH( &matProj, D3DX_PI/4, 1.0f, 1.0f, 100.0f );
    m_pd3dDevice->SetTransform( D3DTS_PROJECTION, &matProj );
 
    // Restore the font
	HRESULT hr;
    if (FAILED(hr = m_pFont->RestoreDeviceObjects()))
		return hr;

    if (FAILED(hr = m_pFontSmall->RestoreDeviceObjects()))
		return hr;

	if (FAILED(hr = m_pTileMap->RestoreDeviceObjects()))
		return hr;	

	// Player 1
	m_player1WriteArea.left = 32;
	m_player1WriteArea.top = 32;
	m_player1WriteArea.right = (((m_d3dsdBackBuffer.Width/2)-16)/32);
	m_player1WriteArea.right *= 32;
	m_player1WriteArea.bottom = ((m_d3dsdBackBuffer.Height-32)/32)*32;
	
	m_pTileMap->setWriteArea(&m_player1WriteArea);

	if (FAILED(hr = m_pPlayer1->getUnit()->RestoreDeviceObjects()))
		return hr;
	m_pPlayer1->getUnit()->setWriteArea(&m_player1WriteArea);
	m_pPlayer1->getUnit()->setMapWorldSize(m_pTileMap->getWorldSize());


	// Player 2
	m_player2WriteArea.left = (((m_d3dsdBackBuffer.Width/2)+16)/32);
	m_player2WriteArea.left *= 32;
	m_player2WriteArea.top = 32;
	m_player2WriteArea.right = m_d3dsdBackBuffer.Width-32;
	m_player2WriteArea.bottom = ((m_d3dsdBackBuffer.Height-32)/32)*32;

	m_pTileMap->setWriteArea(&m_player2WriteArea);

	if (FAILED(hr = m_pPlayer2->getUnit()->RestoreDeviceObjects()))
		return hr;

	m_pPlayer2->getUnit()->setWriteArea(&m_player2WriteArea);
	m_pPlayer2->getUnit()->setMapWorldSize(m_pTileMap->getWorldSize());

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
		POINT *centerPoint;
		SIZE *unitSize;

		//
		// Draw Player 1 screen.
		//

        // Draw map;

		m_pTileMap->setWriteArea(&m_player1WriteArea);
		centerPoint = m_pPlayer1->getUnit()->getWorldPosition();		
		unitSize = m_pPlayer1->getUnit()->getUnitSize();		
		m_pTileMap->centerAround(centerPoint, unitSize);
		m_pTileMap->DrawMap();

		// Draw units
		
		m_pPlayer1->getUnit()->setMapWorldPosition(m_pTileMap->getWorldPosition());
		m_pPlayer1->getUnit()->drawUnit();

		//
		// Draw Player 2 screen.
		//

        // Draw map;

		m_pTileMap->setWriteArea(&m_player2WriteArea);
		centerPoint = m_pPlayer2->getUnit()->getWorldPosition();		
		unitSize = m_pPlayer2->getUnit()->getUnitSize();		
		m_pTileMap->centerAround(centerPoint, unitSize);
		m_pTileMap->DrawMap();

		m_pPlayer1->getUnit()->setWriteArea(&m_player2WriteArea);
		m_pPlayer1->getUnit()->setMapWorldPosition(m_pTileMap->getWorldPosition());
		m_pPlayer1->getUnit()->drawUnit();
		m_pPlayer1->getUnit()->setWriteArea(&m_player1WriteArea);

		m_pPlayer2->getUnit()->setMapWorldPosition(m_pTileMap->getWorldPosition());
		m_pPlayer2->getUnit()->drawUnit();

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
	/*
    SAFE_RELEASE( m_pWallMesh );
	SAFE_RELEASE( m_pSphereMesh );
    SAFE_RELEASE( m_pConeMesh );
	*/
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
// Name: FinalCleanup()
// Desc: Called before the app exits, this function gives the app the chance
//       to cleanup after itself.
//-----------------------------------------------------------------------------
HRESULT CMyD3DApplication::FinalCleanup()
{
    // Cleanup D3D font
    SAFE_DELETE( m_pFont );
    SAFE_DELETE( m_pFontSmall );

	SAFE_DELETE(m_pTileMap);
	SAFE_DELETE(m_pPlayer1);
	SAFE_DELETE(m_pPlayer2);

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

    return CD3DApplication::MsgProc( hWnd, uMsg, wParam, lParam );
}

 //Ingen callback funktion.. en funktion som kollar om vissa 


/*HRESULT CALLBACK CMyD3DApplication::deviceAction(CMyD3DApplication * application, int iDevice, DWORD dwAction, DWORD dwData)
{
	return S_OK;
}
*/

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
    if( m_bCapture )
    {				
        D3DXMATRIXA16 matCursor;
        D3DXQUATERNION qCursor = D3DUtil_GetRotationFromCursor( m_hWnd );
        D3DXMatrixRotationQuaternion( &matCursor, &qCursor );
        D3DXMatrixMultiply( &m_matView, &m_matTrackBall, &matCursor );

        D3DXMATRIXA16 matTrans;
        D3DXMatrixTranslation( &matTrans, 0.0f, 0.0f, -10.0f );
        D3DXMatrixMultiply( &m_matView, &m_matView, &matTrans );
    }

    return S_OK;
}

HRESULT CMyD3DApplication::checkInput()
{
	DWORD dwData;
	for( int iDevice=0; iDevice < m_settings->m_iNumDevices; iDevice++ )
	{
		for( int dwAction=0; dwAction < NUM_OF_ACTIONS; dwAction++ )
		{
			dwData = m_settings->m_aDevices[iDevice].dwInput[dwAction];
			if (dwData > 0)
			{				
				switch (dwAction)
				{
					//
					// Player 1
					//
					case PLAYER1_DRIVE:
						m_pPlayer1->getUnit()->movePosition(0, dwData);
					break;

					case PLAYER1_STEER:
						m_pPlayer1->getUnit()->movePosition(dwData, 0);
					break;

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

	m_pFont->DrawText( 2, 60, D3DCOLOR_ARGB(255,255,255,0), buffer );

}
