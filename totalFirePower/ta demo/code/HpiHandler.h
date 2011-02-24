// HpiHandler.h: interface for the CHpiHandler class.
//
//////////////////////////////////////////////////////////////////////
#pragma warning(disable:4786)

#if !defined(AFX_HPIHANDLER_H__68DF4969_8792_4893_98F7_8092C36479D7__INCLUDED_)
#define AFX_HPIHANDLER_H__68DF4969_8792_4893_98F7_8092C36479D7__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include <windows.h>
#include <string>
#include <map>

using std::string;
using std::map;

class CHpiHandler  
{
public:
	void MakeLower(char* s);
	void MakeLower(string &s);
	void FindHpiFiles(string pattern,string path);
	int LoadFile(string name,void* buffer);
	int GetFileSize(string name);
	CHpiHandler();
	virtual ~CHpiHandler();

	struct FileData{
		string hpiname;
		int size;
	};
	map<string,FileData> files;
private:
	void RegisterFile(char* hpi,char* name,int size);
	void SearchHpiFile(char* name);

	HINSTANCE m_hDLL;

	LPVOID (WINAPI *HPIOpen)(const char* FileName);
	LRESULT (WINAPI *HPIGetFiles)(void *hpi, int Next, LPSTR Name, LPINT Type, LPINT Size);
	LRESULT (WINAPI *HPIClose)(void *hpi);
	LPSTR (WINAPI *HPIOpenFile)(void *hpi, const char* FileName);
	void (WINAPI *HPIGet)(void *Dest, void *FileHandle, int offset, int bytecount);
	LRESULT (WINAPI *HPICloseFile)(LPSTR FileHandle);
};

extern CHpiHandler* hpiHandler;

#endif // !defined(AFX_HPIHANDLER_H__68DF4969_8792_4893_98F7_8092C36479D7__INCLUDED_)
