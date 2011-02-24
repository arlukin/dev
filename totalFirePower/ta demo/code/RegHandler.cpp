// RegHandler.cpp: implementation of the RegHandler class.
//
//////////////////////////////////////////////////////////////////////

#include "RegHandler.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

RegHandler regHandler("Software\\Yankspankers\\3dta");

RegHandler::RegHandler(string keyname,HKEY key)
{
	if(RegCreateKey(key,keyname.c_str(),&regkey)!=ERROR_SUCCESS)
		MessageBox(0,"Failed to crete registry key","Registry error",0);

}

RegHandler::~RegHandler()
{
	RegCloseKey(regkey);
}

unsigned int RegHandler::GetInt(string name, unsigned int def)
{
	unsigned char regbuf[100];
	DWORD regLength=100;
	DWORD regType=REG_DWORD;

	if(RegQueryValueEx(regkey,name.c_str(),0,&regType,regbuf,&regLength)==ERROR_SUCCESS)
		return *((unsigned int*)regbuf);

	return def;
}

string RegHandler::GetString(string name, string def)
{
	unsigned char regbuf[100];
	DWORD regLength=100;
	DWORD regType=REG_SZ;

	if(RegQueryValueEx(regkey,name.c_str(),0,&regType,regbuf,&regLength)==ERROR_SUCCESS)
		return string((char*)regbuf);

	return def;
}

void RegHandler::SetString(string name, string value)
{
	RegSetValueEx(regkey,name.c_str(),0,REG_SZ,(unsigned char*)value.c_str(),value.size()+1);
}

void RegHandler::SetInt(string name, unsigned int value)
{
	RegSetValueEx(regkey,name.c_str(),0,REG_DWORD,(unsigned char*)&value,sizeof(int));
}
