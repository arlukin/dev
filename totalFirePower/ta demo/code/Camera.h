// Camera.h: interface for the CCamera class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_CAMERA_H__3AC5F701_8EEE_11D4_AD55_0080ADA84DE3__INCLUDED_)
#define AFX_CAMERA_H__3AC5F701_8EEE_11D4_AD55_0080ADA84DE3__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "float3.h"

class CCamera  
{
public:
	float3 CalcPixelDir(int x,int y);
	void UpdateForward();
	bool InView(const float3& p,float radius=0);
	Update(bool freeze);
	CCamera();
	virtual ~CCamera();
	float3 pos;
	float3 rot;			//varning inte alltid uppdaterad
	float3 forward;
	float3 right;
	float3 up;
	float3 top;
	float3 bottom;
	float3 rightside;
	float3 leftside;
	float fov;
	float oldFov;
};

extern CCamera camera;
extern CCamera viewCam;
#endif // !defined(AFX_CAMERA_H__3AC5F701_8EEE_11D4_AD55_0080ADA84DE3__INCLUDED_)
