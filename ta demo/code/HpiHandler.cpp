// HpiHandler.cpp: implementation of the CHpiHandler class.
//
//////////////////////////////////////////////////////////////////////
#pragma warning(disable:4786)

#include "HpiHandler.h"
#include <windows.h>
#include <io.h>
#include "hpiutil.h"
#include "mygl.h"
#include "reghandler.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////
CHpiHandler* hpiHandler;

CHpiHandler::CHpiHandler()
{

	if((m_hDLL=LoadLibrary("hpiutil.dll"))==0)
		MessageBox(0,"Failed to find hpiutil.dll","",0);

	void (WINAPI *GetTADirectory)(LPSTR TADir);

	GetTADirectory=(void (WINAPI *)(LPSTR))GetProcAddress(m_hDLL,"GetTADirectory");
	HPIOpen=	(LPVOID (WINAPI *)(const char*))GetProcAddress(m_hDLL,"HPIOpen");
	HPIGetFiles=(LRESULT (WINAPI *)(void *, int, LPSTR, LPINT, LPINT))GetProcAddress(m_hDLL,"HPIGetFiles");
	HPIClose=(LRESULT (WINAPI *)(void *))GetProcAddress(m_hDLL,"HPIClose");
	HPIOpenFile=(LPSTR (WINAPI *)(void *hpi, const char*))GetProcAddress(m_hDLL,"HPIOpenFile");
	HPIGet=(void (WINAPI *)(void *Dest, void *, int, int))GetProcAddress(m_hDLL,"HPIGet");
	HPICloseFile=(LRESULT (WINAPI *)(LPSTR))GetProcAddress(m_hDLL,"HPICloseFile");

	RegHandler rg("Software\\Microsoft\\DirectPlay\\Applications\\Total Annihilation",HKEY_LOCAL_MACHINE);
	string s=rg.GetString("path","");
	string taDir=regHandler.GetString("TADir",s);

	if(taDir[taDir.size()-1]!='\\')
		taDir+="\\";

	char t[500];
	sprintf(t,"Mapping hpi files in %s",taDir.c_str());
	PrintLoadMsg(t);

	FindHpiFiles(taDir+"*.gp3",taDir);
	FindHpiFiles(taDir+"*.ufo",taDir);
	FindHpiFiles(taDir+"*.ccx",taDir);
	FindHpiFiles(taDir+"*.hpi",taDir);
}

CHpiHandler::~CHpiHandler()
{
	FreeLibrary(m_hDLL);
}

int CHpiHandler::GetFileSize(string name)
{
	MakeLower(name);
	if(files.find(name)==files.end())
		return 0;
	return files[name].size;
}

int CHpiHandler::LoadFile(string name, void *buffer)
{
	MakeLower(name);
	if(files.find(name)==files.end())
		return 0;
	void* hpi=HPIOpen(files[name].hpiname.c_str());

	char* file=HPIOpenFile(hpi, name.c_str());
	HPIGet(buffer,file,0,files[name].size);
	HPICloseFile(file);

	HPIClose(hpi);
	return files[name].size;
}

void CHpiHandler::FindHpiFiles(string pattern,string path)
{
	struct _finddata_t files;    
	long hFile;
	int morefiles=0;

	if( (hFile = _findfirst( pattern.c_str(), &files )) == -1L ){
		morefiles=-1;
	}

	while(morefiles==0){
		SearchHpiFile((char*)(path+files.name).c_str());
		
		morefiles=_findnext( hFile, &files ); 
	}
}

void CHpiHandler::SearchHpiFile(char* name)
{
	void* hpi=HPIOpen(name);
	if(hpi==0)
		return;
	char file[512];
	int type;
	int size;

	LRESULT nextFile=HPIGetFiles(hpi, 0, file, &type, &size);

	while(nextFile!=0){
		if(type==0)
			RegisterFile(name,file,size);
		nextFile=HPIGetFiles(hpi, nextFile, file, &type, &size);
	}
	HPIClose(hpi);
}

void CHpiHandler::RegisterFile(char *hpi, char *name, int size)
{
	MakeLower(name);
	if(files.find(name)==files.end()){
		FileData fd;
		fd.hpiname=hpi;
		fd.size=size;
		files[name]=fd;
	}
}


void CHpiHandler::MakeLower(string &s)
{
	for(int a=0;a<s.size();++a){
		if(s[a]>='A' && s[a]<='Z')
			s[a]=s[a]+'a'-'A';
	}
}

void CHpiHandler::MakeLower(char *s)
{
	for(int a=0;s[a]!=0;++a)
		if(s[a]>='A' && s[a]<='Z')
			s[a]=s[a]+'a'-'A';
}
