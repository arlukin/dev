#include "mygl.h"
#include "gl\glu.h"
#include "glfont.h"
#include <ostream>
#include <fstream>
#include "vertexarray.h"
#include "vertexarrayrange.h"

#define GLH_EXT_SINGLE_FILE
#undef GLH_EXTERN
#include "glh_genext.h"

using namespace std;
bool multiTextureEnabled;
int numTextureUnits=1;
bool nvidiaExt;
bool dot3Ext=false;
/*
PFNGLMULTITEXCOORD1FARBPROC     glMultiTexCoord1fARB    = NULL;
PFNGLMULTITEXCOORD2FARBPROC     glMultiTexCoord2fARB    = NULL;
PFNGLMULTITEXCOORD3FARBPROC     glMultiTexCoord3fARB    = NULL;
PFNGLMULTITEXCOORD4FARBPROC     glMultiTexCoord4fARB    = NULL;
PFNGLACTIVETEXTUREARBPROC       glActiveTextureARB      = NULL;
PFNGLCLIENTACTIVETEXTUREARBPROC glClientActiveTextureARB= NULL;
*/
GLint maxTexelUnits=1; 
extern HDC hDC;
extern HWND	hWnd;

static CVertexArray* vertexArray1=0;
static CVertexArray* vertexArray2=0;
static CVertexArray* currentVertexArray=0;

CVertexArray* GetVertexArray()
{
	if(currentVertexArray==vertexArray1){
		currentVertexArray=vertexArray2;
	} else {
		currentVertexArray=vertexArray1;
	}
	return currentVertexArray;
}

bool isInString(char *string, const char *search) {
	int pos=0;
	int maxpos=strlen(search)-1;
	int len=strlen(string);
	char *other;
	for (int i=0; i<len; i++) {
		if ((i==0) || ((i>1) && string[i-1]=='\n')) {                   // New Extension Begins Here!
			other=&string[i];
			pos=0;                                                  // Begin New Search
			while (string[i]!='\n') {                               // Search Whole Extension-String
				if (string[i]==search[pos]) pos++;              // Next Position
				if ((pos>maxpos) && string[i+1]=='\n') return true;     // We Have A Winner!
				i++;
			}
		}
	}
	return false;                                                           // Sorry, Not Found!
}

//#define EXT_INFO

bool initMultitexture(void) {
	char *extensions;
	extensions=strdup((char *) glGetString(GL_EXTENSIONS));                 // Fetch Extension String
	int len=strlen(extensions);
	for (int i=0; i<len; i++)                                               // Separate It By Newline Instead Of Blank
		if (extensions[i]==' ') extensions[i]='\n';
		
#ifdef EXT_INFO
		MessageBox(hWnd,extensions,"supported GL extensions",MB_OK | MB_ICONINFORMATION);
#endif
		ofstream ofs("ext.txt",ios::out|ios::binary);
		ofs.write((char*)extensions,strlen(extensions));
		
		if (isInString(extensions,"GL_ARB_multitexture")                        // Is Multitexturing Supported?
			&& isInString(extensions,"GL_EXT_texture_env_combine"))         // texture-environment-combining supported?
		{       
			glGetIntegerv(GL_MAX_TEXTURE_UNITS_ARB,&maxTexelUnits);
			glMultiTexCoord1fARB = (PFNGLMULTITEXCOORD1FARBPROC) wglGetProcAddress("glMultiTexCoord1fARB");
			glMultiTexCoord2fARB = (PFNGLMULTITEXCOORD2FARBPROC) wglGetProcAddress("glMultiTexCoord2fARB");
			glMultiTexCoord3fARB = (PFNGLMULTITEXCOORD3FARBPROC) wglGetProcAddress("glMultiTexCoord3fARB");
			glMultiTexCoord4fARB = (PFNGLMULTITEXCOORD4FARBPROC) wglGetProcAddress("glMultiTexCoord4fARB");
			glActiveTextureARB   = (PFNGLACTIVETEXTUREARBPROC) wglGetProcAddress("glActiveTextureARB");
			glClientActiveTextureARB= (PFNGLCLIENTACTIVETEXTUREARBPROC) wglGetProcAddress("glClientActiveTextureARB");
			
#ifdef EXT_INFO
			MessageBox(hWnd,"The GL_ARB_multitexture extension will be used.","feature supported!",MB_OK | MB_ICONINFORMATION);
#endif
			multiTextureEnabled=true;
			numTextureUnits=maxTexelUnits;
//			numTextureUnits=2;
			return true;
		}
	glMultiTexCoord2fARB = DummyTexCoord;
	multiTextureEnabled=false;
	return false;
}

void initDot3(void) {
	char *extensions;
	extensions=strdup((char *) glGetString(GL_EXTENSIONS));                 // Fetch Extension String
	int len=strlen(extensions);
	for (int i=0; i<len; i++)                                               // Separate It By Newline Instead Of Blank
		if (extensions[i]==' ') extensions[i]='\n';
		
	ofstream ofs("ext.txt",ios::out|ios::binary);
	ofs.write((char*)extensions,strlen(extensions));
		
	if (isInString(extensions,"GL_ARB_texture_env_dot3")){
		dot3Ext=true;
	}
}

float* big_array;

void LoadExtensions()
{
	initMultitexture();
	initDot3();
	nvidiaExt=true;
	if(!InitExtension("GL_NV_fence"))
		nvidiaExt=false;
	if(!InitExtension("GL_NV_vertex_array_range"))
		nvidiaExt=false;

/*	if(nvidiaExt){
	  big_array = (GLfloat *)wglAllocateMemoryNV(1000000*sizeof(GLfloat), 0, 0.25, 0.5);
		vertexArray1=new CVertexArrayRange(big_array,500000);
		vertexArray2=new CVertexArrayRange(big_array+500000,500000);
	} else {
*/		vertexArray1=new CVertexArray;
		vertexArray2=new CVertexArray;
//	}
}

void UnloadExtensions()
{
	delete vertexArray1;
	delete vertexArray2;


}

void APIENTRY DummyTexCoord (GLenum target, GLfloat s, GLfloat t)
{
}

void PrintLoadMsg(const char* text)
{
/*	glClearColor(0,0,0,1);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glLoadIdentity();
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_TEXTURE_2D);
	glTranslatef(-0.13f*strlen(text),0,-15);
	glColor3f(1,1,1);
	font->glPrint("%s",text);
	SwapBuffers(hDC);
*/
	glClearColor(0,0,0,1);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	glMatrixMode(GL_PROJECTION);						// Select The Projection Matrix
	glLoadIdentity();									// Reset The Projection Matrix
	gluOrtho2D(0,1,0,1);
	glMatrixMode(GL_MODELVIEW);							// Select The Modelview Matrix

	glLoadIdentity();
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_TEXTURE_2D);
	glTranslatef(0.5f-0.01f*strlen(text),0.48f,0.0f);
	glScalef(0.03f,0.04f,0.1f);
	glColor3f(1,1,1);
	font->glPrint("%s",text);
	SwapBuffers(hDC);
}

