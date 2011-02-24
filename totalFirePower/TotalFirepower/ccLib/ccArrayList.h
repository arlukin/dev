// ccArrayList.h: interface for the ccArrayList class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_CCARRAYLIST_H__81908054_0A5C_4E34_A902_BF8F399BCD52__INCLUDED_)
#define AFX_CCARRAYLIST_H__81908054_0A5C_4E34_A902_BF8F399BCD52__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

class ccArrayList : public CArrayList  
{
public:
	
	ccArrayList(ArrayListType Type, UINT BytesPerEntry = 0 );
	/*
	virtual ~ccArrayList();
	*/

	int count() {return m_NumEntries;};

	void* operator []( UINT Entry ) {return GetPtr(Entry);};
};

#endif // !defined(AFX_CCARRAYLIST_H__81908054_0A5C_4E34_A902_BF8F399BCD52__INCLUDED_)
