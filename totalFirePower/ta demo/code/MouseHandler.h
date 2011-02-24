// MouseHandler.h: interface for the CMouseHandler class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_MOUSEHANDLER_H__E6FA621D_050F_430D_B49B_A1E7FA1C1BDF__INCLUDED_)
#define AFX_MOUSEHANDLER_H__E6FA621D_050F_430D_B49B_A1E7FA1C1BDF__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "float3.h"

class CMouseHandler  
{
public:
	void HideMouse();
	void ShowMouse();
	void Draw();
	void MouseRelease(int x,int y,int button);
	void MousePress(int x,int y,int button);
	void MouseMove(int x,int y);
	CMouseHandler();
	virtual ~CMouseHandler();


	int lastx;  
	int lasty;  
	bool hide;
	bool mmMove,mmResize;
	float mouseSpeed;
	float moveSpeed;
	float invMouse;

	struct ButtonPress{
		bool pressed;
		bool noRelease;
		int x;
		int y;
		float3 camPos;
		float3 dir;
		int time;
		int movement;
	};

	ButtonPress buttons[4];
};

extern CMouseHandler* mouse;

#endif // !defined(AFX_MOUSEHANDLER_H__E6FA621D_050F_430D_B49B_A1E7FA1C1BDF__INCLUDED_)
