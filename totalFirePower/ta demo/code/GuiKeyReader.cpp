// GuiKeyReader.cpp: implementation of the CGuiKeyReader class.
//
//////////////////////////////////////////////////////////////////////

#include "GuiKeyReader.h"
#include <windows.h>
#include <iostream>
#include <fstream>

using namespace std;

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

static GetWord(ifstream& ifs,std::string &s)
{
	s=" ";
	char a=ifs.peek();
	while(a==' ' || a=='\xd' || a=='\xa'){
		ifs.read(&a,1);
		a=ifs.peek();
	}
	char c[500];
	ifs>>c;
	while((c[0]=='/') && (c[1]=='/')){
		ifs.getline(c,500);
		c[0]='/';
		c[1]=0;
		ifs>>c;
		if(ifs.bad())
			break;
	}
	s=c;
}

static MakeLow(std::string &s)
{
	std::string s2=s;
	s="";
	std::string::iterator si;
	for(si=s2.begin();si!=s2.end();si++){
		if(((*si)>='A') && ((*si)<='Z'))
			s+=(char)('a'-'A'+(*si));
		else
			s+=(*si);
	}
}

CGuiKeyReader::CGuiKeyReader(char* filename)
{
	CreateKeyNames();	
	ifstream ifs(filename, ios::in);
	char ch[1000];
	string s;
	bool inComment=false;;

	while(ifs.peek()!=EOF){
		GetWord(ifs,s);
		if(s[0]=='/' && !inComment){
			if(s.size()>1 && s[1]=='*')
				inComment=true;
		}
		if(inComment){
			for(int a=0;a<s.size()-1;++a)
				if(s[a]=='*' && s[a+1]=='/')
					inComment=false;
			if(inComment)
				continue;
		}
		MakeLow(s);
		if(ifs.bad())
			break;
		while((s.c_str()[0]=='/') || (s.c_str()[0]=='\n')){
			ifs.getline(ch,500);
			GetWord(ifs,s);
			MakeLow(s);
			if(ifs.bad())
				break;
		}
		if(ifs.peek()==EOF)
			break;
		if(s.compare("bind")==0){
			GetWord(ifs,s);
			MakeLow(s);
			int i=GetKey(s);
			GetWord(ifs,s);
			MakeLow(s);
			guiKeys[i]=s;			
		} else 
			MessageBox(0,"Couldnt parse control file",s.c_str(),0);
		ifs.getline(ch,500);
	}
}

CGuiKeyReader::~CGuiKeyReader()
{

}

string CGuiKeyReader::TranslateKey(int key)
{
	return guiKeys[key];
}


void CGuiKeyReader::CreateKeyNames()
{
	std::string s="\'";
	for(char c='a';c<='z';++c)
		keynames[s+c+s]=c+'A'-'a';

	for(c='0';c<='9';++c)
		keynames[s+c+s]=c+48-'0';

	keynames["space"]=VK_SPACE;
	keynames["enter"]=13;
	keynames["backspace"]=8;
	keynames["esc"]=27;
	keynames["f1"]=112;
	keynames["f2"]=113;
	keynames["f3"]=114;
	keynames["f4"]=115;
	keynames["f5"]=116;
	keynames["f6"]=117;
	keynames["f7"]=118;
	keynames["f8"]=119;
	keynames["f9"]=120;
	keynames["f10"]=121;
	keynames["f11"]=122;
	keynames["f12"]=123;
	keynames["printscreen"]=124;
	keynames["shift"]=16;
	keynames["alt"]=18;
	keynames["tilde"]=220;
	keynames[s+'<'+s]=226;
	keynames[s+','+s]=188;
	keynames[s+'.'+s]=190;
	keynames["insert"]=45;
	keynames["delete"]=46;
	keynames["home"]=36;
	keynames["end"]=35;
	keynames["pageup"]=33;
	keynames["pagedown"]=34;
	keynames["numpad0"]=VK_NUMPAD0;
	keynames["numpad1"]=VK_NUMPAD1;
	keynames["numpad2"]=VK_NUMPAD2;
	keynames["numpad3"]=VK_NUMPAD3;
	keynames["numpad4"]=VK_NUMPAD4;
	keynames["numpad5"]=VK_NUMPAD5;
	keynames["numpad6"]=VK_NUMPAD6;
	keynames["numpad7"]=VK_NUMPAD7;
	keynames["numpad8"]=VK_NUMPAD8;
	keynames["numpad9"]=VK_NUMPAD9;
	keynames["numpad+"]=107;
	keynames["numpad-"]=109;
	keynames["numpad*"]=106;
	keynames["numpad/"]=111;
	keynames["ctrl"]=VK_CONTROL;
	keynames["up"]=VK_UP;
	keynames["down"]=VK_DOWN;
	keynames["left"]=VK_LEFT;
	keynames["right"]=VK_RIGHT;
	keynames["pause"]=VK_PAUSE;
	keynames["joyx"]=400;
	keynames["joyy"]=401;
	keynames["joyz"]=402;
	keynames["joyw"]=403;
	keynames["joy0"]=300;
	keynames["joy1"]=301;
	keynames["joy2"]=302;
	keynames["joy3"]=303;
	keynames["joy4"]=304;
	keynames["joy5"]=305;
	keynames["joy6"]=306;
	keynames["joy7"]=307;
	keynames["joyup"]=320;
	keynames["joydown"]=321;
	keynames["joyleft"]=322;
	keynames["joyright"]=323;
}

int CGuiKeyReader::GetKey(string s)
{
	if((s[0]>'0') && (s[0]<='9'))
		return atoi(s.c_str());
	
	int a=keynames[s];
	if(a==0)
		MessageBox(0,s.c_str(),"Unknown key",0);
	return a;

}
