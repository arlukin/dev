// ccSettings.cpp: implementation of the ccSettings class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "TotalFirepower.h"
#include "ccSettings.h"



const TCHAR *ACTION_NAMES[] =
{
    TEXT("Drive forward/backward"),
    TEXT("Drive forward"),
    TEXT("Drive backward"),

    TEXT("Steer left/right"),
    TEXT("Steer left"),
    TEXT("Steer right"),

    TEXT("Fire"),	
    TEXT("Weapons"),
	TEXT("Quit")
};


DIACTION g_adiaActionMap[NUM_OF_ACTIONS] =
{
    // Device input (joystick, etc.) that is pre-defined by DInput according
    // to genre type. The genre for this app is Action->DIVIRTUAL_DRIVING_TANK 
    { PLAYER1_DRIVE,    DIAXIS_DRIVINGT_ACCELERATE,     0,  ACTION_NAMES[PLAYER1_DRIVE], },	
    { PLAYER1_STEER,    DIAXIS_DRIVINGT_ROTATE,			0,  ACTION_NAMES[PLAYER1_STEER], },	
    { PLAYER1_FIRE,     DIBUTTON_DRIVINGT_FIRE,			0,  ACTION_NAMES[PLAYER1_FIRE], },
    { PLAYER1_WEAPONS,  DIBUTTON_DRIVINGT_WEAPONS,      0,  ACTION_NAMES[PLAYER1_WEAPONS], },

    // Keyboard input mappings
    { PLAYER1_DRIVE_FORWARD,    DIKEYBOARD_W,           0,  ACTION_NAMES[PLAYER1_DRIVE_FORWARD], },
    { PLAYER1_DRIVE_BACKWARD,   DIKEYBOARD_S,           0,  ACTION_NAMES[PLAYER1_DRIVE_BACKWARD], },
    { PLAYER1_STEER_LEFT,       DIKEYBOARD_A,           0,  ACTION_NAMES[PLAYER1_STEER_LEFT], },
    { PLAYER1_STEER_RIGHT,      DIKEYBOARD_D,           0,  ACTION_NAMES[PLAYER1_STEER_RIGHT], },
    { PLAYER1_FIRE,				DIKEYBOARD_RSHIFT,      0,  ACTION_NAMES[PLAYER1_FIRE], },
    { PLAYER1_WEAPONS,          DIKEYBOARD_RCONTROL,    0,  ACTION_NAMES[PLAYER1_WEAPONS], },

    // The DIA_APPFIXED constant can be used to instruct DirectInput that the
    // current mapping can not be changed by the user.
    { QUIT,	DIKEYBOARD_F12, DIA_APPFIXED, ACTION_NAMES[QUIT], },

    // Mouse input mappings
    { PLAYER1_DRIVE,            DIMOUSE_YAXIS,                0,  ACTION_NAMES[PLAYER1_DRIVE], },
	{ PLAYER1_STEER,            DIMOUSE_XAXIS,                0,  ACTION_NAMES[PLAYER1_STEER], },
    { PLAYER1_FIRE,				DIMOUSE_BUTTON0,              0,  ACTION_NAMES[PLAYER1_FIRE], },
    { PLAYER1_WEAPONS,          DIMOUSE_BUTTON1,              0,  ACTION_NAMES[PLAYER1_WEAPONS], }
};

//-----------------------------------------------------------------------------
// Name: EnumDevicesCallback
// Desc: Callback function for EnumDevices. This particular function stores
//       a list of all currently attached devices for use on the input chart.
//-----------------------------------------------------------------------------
BOOL CALLBACK EnumDevicesCallback( LPCDIDEVICEINSTANCE lpddi, 
                                  LPDIRECTINPUTDEVICE8 lpdid, DWORD dwFlags, 
                                  DWORD dwRemaining, LPVOID pvRef )
{
    HRESULT hr;

	ccSettings * settings = (ccSettings *)pvRef;
	CMyD3DApplication * application = (CMyD3DApplication *)settings->getParent();

    if( settings->m_iNumDevices < MAX_DEVICES )
    {   		
		lpdid->SetCooperativeLevel(application->getWindow(), DISCL_FOREGROUND | DISCL_NONEXCLUSIVE | DISCL_NOWINKEY);

        // Build the action map against the device
		char strUserName[15] = "TotalFirePower";
        if( FAILED(hr = lpdid->BuildActionMap( &settings->m_diaf, strUserName, DIDBAM_DEFAULT )) )
            // There was an error while building the action map. Ignore this
            // device, and contine with the enumeration
            return DIENUM_CONTINUE;

        
        // Inspect the results
        for( UINT i=0; i < settings->m_diaf.dwNumActions; i++ )
        {
            DIACTION *dia = &(settings->m_diaf.rgoAction[i]);

            if( dia->dwHow != DIAH_ERROR && dia->dwHow != DIAH_UNMAPPED )
                settings->m_aDevices[settings->m_iNumDevices].bMapped[dia->uAppData] = TRUE;
        }

        // Set the action map
        if( FAILED(hr = lpdid->SetActionMap( &settings->m_diaf, strUserName, DIDSAM_DEFAULT )) )
        {
            // An error occured while trying the set the action map for the 
            // current device. Clear the stored values, and continue to the
            // next device.
            ZeroMemory( settings->m_aDevices[settings->m_iNumDevices].bMapped, 
                 sizeof(settings->m_aDevices[settings->m_iNumDevices].bMapped) );
            return DIENUM_CONTINUE;
        }

        // The current device has been successfully mapped. By storing the
        // pointer and informing COM that we've added a reference to the 
        // device, we can use this pointer later when gathering input.
        settings->m_aDevices[settings->m_iNumDevices].pDevice = lpdid;
        lpdid->AddRef();

        // Store the device's friendly name for display on the chart.
        _tcsncat( settings->m_aDevices[settings->m_iNumDevices].szName, lpddi->tszInstanceName, LENGTH_DEV_NAME-5 );
    
        if( _tcslen( lpddi->tszInstanceName ) > LENGTH_DEV_NAME-5 )
            _tcscat( settings->m_aDevices[settings->m_iNumDevices].szName, TEXT("...") );

        // Store axis absolute/relative flag
        DIPROPDWORD dipdw;  
        dipdw.diph.dwSize       = sizeof(DIPROPDWORD); 
        dipdw.diph.dwHeaderSize = sizeof(DIPROPHEADER); 
        dipdw.diph.dwObj        = 0; 
        dipdw.diph.dwHow        = DIPH_DEVICE; 
 
        hr = lpdid->GetProperty( DIPROP_AXISMODE, &dipdw.diph ); 
        if (SUCCEEDED(hr)) 
            settings->m_aDevices[settings->m_iNumDevices].bAxisRelative = ( DIPROPAXISMODE_REL == dipdw.dwData );

        settings->m_iNumDevices++;    // Increment the global device index   
    }
   
    // Ask for the next device
    return DIENUM_CONTINUE;
}


//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

ccSettings::ccSettings(CMyD3DApplication * parent)
{	
	m_parent = parent;

	m_keyUp =  VK_UP;
	m_keyDown = VK_DOWN;
	m_keyLeft = VK_LEFT;
	m_keyRight = VK_RIGHT;

	m_pDI         = NULL;  // DirectInput access pointer
	ZeroMemory( &m_diaf, sizeof(DIACTIONFORMAT) ); // DIACTIONFORMAT structure, used for
												   //   enumeration and viewing config
	ZeroMemory( &m_aDevices, sizeof(m_aDevices) ); // List of devices
										   	
	m_iNumDevices = 0;     // Total number of stored devices

    
    // Initialize DirectInput
    if( FAILED(InitDirectInput()) )
    {
        MessageBox( NULL, TEXT("Failed to initialize DirectInput.\n")
                          TEXT("The sample will now exit."),
                          TEXT("Error"), MB_ICONEXCLAMATION | MB_OK );
        PostQuitMessage(0);
    }


}

ccSettings::~ccSettings()
{
    // Release device pointers
    for( int i=0; i < m_iNumDevices; i++ )
    {
        if( m_aDevices[i].pDevice )
        {
            m_aDevices[i].pDevice->Unacquire();
            m_aDevices[i].pDevice->Release();
            m_aDevices[i].pDevice = NULL;
        }
    }

    // Release DirectInput
    SAFE_RELEASE(m_pDI);
}

//-----------------------------------------------------------------------------
// Name: InitDirectInput
// Desc: Initialize the DirectInput variables.
//-----------------------------------------------------------------------------
HRESULT ccSettings::InitDirectInput()
{
    HRESULT hr;

    // Register with the DirectInput subsystem and get a pointer to an 
    // IDirectInput interface we can use.
    if( FAILED( hr = DirectInput8Create( GetModuleHandle(NULL), DIRECTINPUT_VERSION, 
                                         IID_IDirectInput8, (VOID**)&m_pDI, NULL ) ) )
        return hr;


    // ************************************************************************
    // Step 3: Enumerate Devices.
    // 
    // Enumerate through devices according to the desired action map.
    // Devices are enumerated in a prioritized order, such that devices which
    // can best be mapped to the provided action map are returned first.
    // ************************************************************************

    // Setup action format for the actual gameplay
    ZeroMemory( &m_diaf, sizeof(DIACTIONFORMAT) );
    m_diaf.dwSize          = sizeof(DIACTIONFORMAT);
    m_diaf.dwActionSize    = sizeof(DIACTION);
    m_diaf.dwDataSize      = NUM_OF_ACTIONS * sizeof(DWORD);
	m_diaf.dwNumActions    = NUM_OF_ACTIONS;
    m_diaf.guidActionMap   = g_guidApp;
    m_diaf.dwGenre         = DIVIRTUAL_DRIVING_TANK ;     
    m_diaf.rgoAction       = g_adiaActionMap;

	m_diaf.dwBufferSize    = 16;
    m_diaf.lAxisMin        = -99;
    m_diaf.lAxisMax        = 99;    
    _tcscpy( m_diaf.tszActionMap, _T("Total Firepower Action Map") );
 
	
	char strUserName[] = "TotalFirePower";
    if( FAILED( hr = m_pDI->EnumDevicesBySemantics( strUserName, &m_diaf,  
                                                    EnumDevicesCallback,
                                                    this, DIEDBSFL_ATTACHEDONLY ) ) )
        return hr;

    return S_OK;
}

//

//-----------------------------------------------------------------------------
// Name: CheckInput
// Desc: Poll the attached devices and update the display
//-----------------------------------------------------------------------------
HRESULT ccSettings::checkInput()
{
    HRESULT hr;
    
    // For each device gathered during enumeration, gather input. Although when
    // using action maps the input is received according to actions, each device 
    // must still be polled individually. Although for most actions your
    // program will follow the same logic regardless of which device generated
    // the action, there are special cases which require checking from which
    // device an action originated.

    for( int iDevice=0; iDevice < m_iNumDevices; iDevice++ )
    {
        LPDIRECTINPUTDEVICE8 pdidDevice = m_aDevices[iDevice].pDevice;
        DIDEVICEOBJECTDATA rgdod[10];
        DWORD   dwItems = 10;

        hr = pdidDevice->Acquire();
        hr = pdidDevice->Poll();

		// FIX: In develop mode, returning random data, if unacquired.
        hr = pdidDevice->GetDeviceData( sizeof(DIDEVICEOBJECTDATA),
                                        rgdod, &dwItems, 0 );

        // GetDeviceData can fail for several reasons, some of which are
        // expected during a program's execution. A device's acquisition is not
        // permanent, and your program might need to reacquire a device several
        // times. Since this sample is polling frequently, an attempt to
        // acquire a lost device will occur during the next call to CheckInput.

        if( FAILED(hr) )
            continue;

        // For each buffered data item, extract the game action and perform
        // necessary game state changes. A more complex program would certainly
        // handle each action separately, but this sample simply stores raw
        // axis data for a WALK action, and button up or button down states for
        // all other game actions. 

        // Relative axis data is never reported to be zero since relative data
        // is given in relation to the last position, and only when movement 
        // occurs. Manually set relative data to zero before checking input.
        
		// FIX: Need relative or not??
		if( m_aDevices[iDevice].bAxisRelative )
		{
            m_aDevices[iDevice].dwInput[PLAYER1_DRIVE] = 0;
			m_aDevices[iDevice].dwInput[PLAYER1_STEER] = 0;			
		}

        for( DWORD j=0; j<dwItems; j++ )
        {
            UINT_PTR dwAction = rgdod[j].uAppData;
            DWORD dwData = 0;

            // The value stored in dwAction equals the 32 bit value stored in 
            // the uAppData member of the DIACTION structure. For this sample
            // we selected these action constants to be indices into an array,
            // but we could have chosen these values to represent anything
            // from variable addresses to function pointers.

            switch( dwAction )
            {
                case PLAYER1_DRIVE:  
				case PLAYER1_STEER:
                {
                    // Axis data. Absolute axis data is already scaled to the
                    // boundaries selected in the DIACTIONFORMAT structure, but
                    // relative data is reported as relative motion change 
                    // since the last report. This sample scales relative data
                    // and clips it to axis data boundaries.

                    dwData = rgdod[j].dwData;   
                    
                    if( m_aDevices[iDevice].bAxisRelative )
                    {
                        // scale relative data
                        dwData *= 5;

                        // clip to boundaries
                        if( (int)dwData < 0 )
                            dwData = max( (int)dwData, m_diaf.lAxisMin );
                        else
                            dwData = min( (int)dwData, m_diaf.lAxisMax );
                    }
                    
                    break;
                }

                default:
                {
                    dwData = rgdod[j].dwData & BUTTON_DOWN ?    1 : 0;
                    break;
                }
            }

            m_aDevices[iDevice].dwInput[dwAction] = dwData;
			//m_doAction(m_application, iDevice, dwAction, dwData);				
        }
    }
	return S_OK;
}

void* ccSettings::getParent()
{
	return m_parent;
}
