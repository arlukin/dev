#ifndef MYGL_H
#define MYGL_H

#ifndef _WINSOCKAPI_
	#define _WINSOCKAPI_
	#include <windows.h>
	#undef _WINSOCKAPI_
#else
	#include <windows.h>
#endif

#include <gl/gl.h>
#include "float3.h"
#include "glext.h"
#include "glh_genext.h"

inline glVertexf3(const float3 &v)
{
	glVertex3f(v.x,v.y,v.z);
}

inline glNormalf3(const float3 &v)
{
	glNormal3f(v.x,v.y,v.z);
}

inline glTranslatef3(const float3 &v)
{
	glTranslatef(v.x,v.y,v.z);
}

void PrintLoadMsg(const char* text);
/*
extern PFNGLMULTITEXCOORD1FARBPROC     glMultiTexCoord1fARB    ;
extern PFNGLMULTITEXCOORD2FARBPROC     glMultiTexCoord2fARB    ;
extern PFNGLMULTITEXCOORD3FARBPROC     glMultiTexCoord3fARB    ;
extern PFNGLMULTITEXCOORD4FARBPROC     glMultiTexCoord4fARB    ;
extern PFNGLACTIVETEXTUREARBPROC       glActiveTextureARB      ;
extern PFNGLCLIENTACTIVETEXTUREARBPROC glClientActiveTextureARB;
*/
void LoadExtensions();
void UnloadExtensions();

#define GL_DOT3_RGB_ARB 0x86AE
#define GL_DOT3_RGBA_ARB 0x86AF

#define GL_COMBINE_RGB_ARB    0x8571
#define GL_COMBINE_ALPHA_ARB  0x8572
#define GL_SOURCE0_RGB_ARB    0x8580
#define GL_SOURCE1_RGB_ARB    0x8581
#define GL_SOURCE2_RGB_ARB    0x8582
#define GL_SOURCE0_ALPHA_ARB  0x8588
#define GL_SOURCE1_ALPHA_ARB  0x8589
#define GL_SOURCE2_ALPHA_ARB  0x858A
#define GL_OPERAND0_RGB_ARB   0x8590
#define GL_OPERAND1_RGB_ARB   0x8591
#define GL_OPERAND2_RGB_ARB   0x8592
#define GL_OPERAND0_ALPHA_ARB 0x8598
#define GL_OPERAND1_ALPHA_ARB 0x8599
#define GL_OPERAND2_ALPHA_ARB 0x859A

#define GL_PREVIOUS_ARB 0x8578
#define GL_COMBINE_ARB 0x8570

#define GL_ADD_SIGNED_ARB    0x8574
#define GL_INTERPOLATE_ARB   0x8575
#define GL_SUBTRACT_ARB      0x84E7

extern bool multiTextureEnabled;
extern int numTextureUnits;
extern bool nvidiaExt;
extern bool dot3Ext;

void APIENTRY DummyTexCoord (GLenum target, GLfloat s, GLfloat t);

class CVertexArray;

CVertexArray* GetVertexArray();
#endif