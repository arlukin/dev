// ccSettings.h: interface for the ccSettings class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_CCSETTINGS_H__D3E6FB85_D553_43A3_A0BC_BB204A3DA930__INCLUDED_)
#define AFX_CCSETTINGS_H__D3E6FB85_D553_43A3_A0BC_BB204A3DA930__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

// FIX:
//For the keyboard, you can also include DISCL_NOWINKEY in combination with DISCL_NONEXCLUSIVE. This flag disables the Windows logo key so that users cannot inadvertently break out of the application. In exclusive mode, the Windows logo key is always disabled. 



//-----------------------------------------------------------------------------
// Defines, and constants
//-----------------------------------------------------------------------------
// This GUID must be unique for every game, and the same for every instance of 
// this app. The GUID allows DirectInput to remember input settings.
const GUID g_guidApp = { 0x3afabad0, 0xd2c0, 0x4514, { 0xb4, 0x7e, 0x65, 0xfe, 0xf9, 0xb5, 0x14, 0x2f } };

// Global constants
const int MAX_DEVICES     = 8;    // The maximum number of allowed devices  
const int LENGTH_DEV_NAME = 40;   // The maximum length of device names
const int BUTTON_DOWN     = 0x80; // Mask for determining button state
const int NUM_OF_ACTIONS  = 17;	  // Number of game action constants


// Senare ha GAME_ACTIONS beroende på om det är tank, båt, bot, flyg...
enum GAME_ACTIONS 
{
	PLAYER1_DRIVE,
	PLAYER1_DRIVE_FORWARD,
	PLAYER1_DRIVE_BACKWARD,

	PLAYER1_STEER,
	PLAYER1_STEER_LEFT,
	PLAYER1_STEER_RIGHT,

	PLAYER1_FIRE,
	PLAYER1_WEAPONS,

	// Player 2
	PLAYER2_DRIVE,
	PLAYER2_DRIVE_FORWARD,
	PLAYER2_DRIVE_BACKWARD,

	PLAYER2_STEER,
	PLAYER2_STEER_LEFT,
	PLAYER2_STEER_RIGHT,

	PLAYER2_FIRE,
	PLAYER2_WEAPONS,

	// System
	QUIT
};

extern DIACTION g_adiaActionMap[];
extern BOOL CALLBACK EnumDevicesCallback( LPCDIDEVICEINSTANCE, LPDIRECTINPUTDEVICE8, DWORD, DWORD, LPVOID );

                             //   mapped to a device object

class CMyD3DApplication;
class ccSettings  
{
	// Convenience wrapper for device pointers
	struct DeviceState
	{
		LPDIRECTINPUTDEVICE8 pDevice;   // Pointer to the device 
		TCHAR szName[LENGTH_DEV_NAME];  // Friendly name of the device
		bool  bAxisRelative;            // Relative x-axis data flag
		DWORD dwInput[NUM_OF_ACTIONS];  // Arrays of the current input values and
		DWORD dwPaint[NUM_OF_ACTIONS];  //   values when last painted
		bool  bMapped[NUM_OF_ACTIONS];  // Flags whether action was successfully
	};     

private:
	CMyD3DApplication * m_parent;
	

public:  //FIX:
	LPDIRECTINPUT8  m_pDI;  // DirectInput access pointer
	DIACTIONFORMAT  m_diaf; // DIACTIONFORMAT structure, used for
							//   enumeration and viewing config
	DeviceState     m_aDevices[MAX_DEVICES];  // List of devices
	int             m_iNumDevices;			  // Total number of stored devices

	friend BOOL CALLBACK EnumDevicesCallback(LPCDIDEVICEINSTANCE, LPDIRECTINPUTDEVICE8, DWORD, DWORD, LPVOID );
public:	
	void* getParent();
			
	HRESULT checkInput();
	HRESULT InitDirectInput();
	
	
	ccSettings(CMyD3DApplication * application);
	virtual ~ccSettings();

	char m_keyUp;
	char m_keyDown;
	char m_keyLeft;
	char m_keyRight;
};

#endif // !defined(AFX_CCSETTINGS_H__D3E6FB85_D553_43A3_A0BC_BB204A3DA930__INCLUDED_)
