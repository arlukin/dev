// ccDebug.cpp: implementation of the ccDebug class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "ccDebug.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////
#ifdef _DEBUG
void ccDebugMessage(char * file, int line, char * message)
{
	TCHAR buffer[512];	
	const int cchBufferSize = sizeof(buffer) / sizeof(TCHAR);
	buffer[0]  = _T('\0');
    _sntprintf( buffer, cchBufferSize, 
		_T("FILE: %s \nLINE: %d\n%s"),
		file, line, message
		);
	buffer[cchBufferSize - 1] = TEXT('\0');

	MessageBox(NULL, buffer, "ASSERT/ERROR", MB_OK);\
	PostQuitMessage(0);\
}
#endif