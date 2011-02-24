// TotalFirepower.h: interface for the ccTileMap class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_TOTALFIREPOWER_H__A7FA5E4C_3451_49FA_84C7_6AC3D21D1D62__INCLUDED_)
#define AFX_TOTALFIREPOWER_H__A7FA5E4C_3451_49FA_84C7_6AC3D21D1D62__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

// FIX:
// Musik i spelet astralDub, In Grey?? =)

//-----------------------------------------------------------------------------
// Name: class CMyD3DApplication
// Desc: Application class. The base class (CD3DApplication) provides the 
//       generic functionality needed in all Direct3D samples. CMyD3DApplication 
//       adds functionality specific to this sample program.
//-----------------------------------------------------------------------------

#include "ccPlayer.h"

class ccTileMap;
class ccPlayer;
class ccSettings;

class CMyD3DApplication : public CD3DApplication
{
	BOOL m_bCapture;
	D3DXMATRIXA16 m_matTrackBall;
	D3DXMATRIXA16 m_matView;
	

    CD3DFont* m_pFont;					// Font for drawing text
    CD3DFont* m_pFontSmall;				// Font for drawing text

	ccTileMap  *m_pTileMap;				// Loaded map	
 	ccPlayer   *m_pPlayer1;				// The player
	ccPlayer   *m_pPlayer2;				// The player
	ccSettings *m_settings;	

	ccArrayList m_units;				// Allt units, players and computers.

	RECT m_oneScreenWriteArea;			// If only one player, or both player on same screen.
	RECT m_player1WriteArea;
	RECT m_player2WriteArea;

protected:    

	// Derivation of abstract functions
    HRESULT InitDeviceObjects();
    HRESULT RestoreDeviceObjects();
    HRESULT InvalidateDeviceObjects();
    HRESULT DeleteDeviceObjects();
    HRESULT FrameMove();
    HRESULT Render();
    HRESULT FinalCleanup();
	HRESULT OneTimeSceneInit();

    LRESULT MsgProc( HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam );	

public:
	void BuildPresentParamsFromSettings();
	HRESULT setupMatrix();
	void isD3DSpy();
	HRESULT drawUnits();
	void drawStatistics();
	HWND getWindow();
	HRESULT checkInput();
	//static HRESULT CALLBACK deviceAction(CMyD3DApplication * application, int iDevice, DWORD dwAction, DWORD dwData);	

	virtual HRESULT Create( HINSTANCE hInstance );
    CMyD3DApplication();
	~CMyD3DApplication();
};

#endif // !defined(AFX_TOTALFIREPOWER_H__A7FA5E4C_3451_49FA_84C7_6AC3D21D1D62__INCLUDED_)