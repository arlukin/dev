// FeatureHandler.h: interface for the CFeatureHandler class.
//
//////////////////////////////////////////////////////////////////////

#pragma warning(disable:4786)

#if !defined(AFX_FEATUREHANDLER_H__F097063B_7FCF_4160_9057_C361A5A23129__INCLUDED_)
#define AFX_FEATUREHANDLER_H__F097063B_7FCF_4160_9057_C361A5A23129__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include <vector>
#include <map>


class CFeatureHandler  
{
public:
	static void MakeLower(char* s);
	static void MakeLower(std::string& s);
	void SearchTdfFile(std::string name);
	void FindTDFFiles();
	void LoadFeatures(unsigned char* map,int featurePos,int featureTablePos,int featureTableSize);
	CFeatureHandler();
	virtual ~CFeatureHandler();

	unsigned short* mapFeatures;

	struct FeatureData{
		bool showInMapTex;
		unsigned char *(lods[3]);
		int xsize[3];
		int ysize[3];
		int xoffset,yoffset;
	};
	FeatureData* featureTable;
	
	std::map<std::string,std::string> name2file;
	int numFeatures;
};

extern CFeatureHandler featureHandler;

#endif // !defined(AFX_FEATUREHANDLER_H__F097063B_7FCF_4160_9057_C361A5A23129__INCLUDED_)
