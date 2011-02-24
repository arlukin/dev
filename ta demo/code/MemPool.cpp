#include "MemPool.h"
#include <assert.h>

CMemPool mempool;

CMemPool::CMemPool()
{
	for(int a=0;a<120;a++){
		nextFree[a]=0;
		poolSize[a]=10;
	}
};

void* CMemPool::Alloc(size_t n)
{
  if(n>120 || n<4){
    return ::operator new(n);
  }
  void* p=nextFree[n];
  
  if(p)
    nextFree[n]=(*(void**)p);
  else{
    void* newBlock= ::operator new(n*poolSize[n]);

    for(int i=0;i<poolSize[n]-1;++i)
      *(void**)&((char*)newBlock)[(i)*n]=(void*)&((char*)newBlock)[(i+1)*n];
    
    *(void**)&((char*)newBlock)[(poolSize[n]-1)*n]=0;

    p=newBlock;
    nextFree[n]=(*(void**)p);
    poolSize[n]*=2;
  }
  return p;
}

void CMemPool::Free(void* p,size_t n)
{
  if(p==0) return;
  
  if(n>120 || n<4){
    ::operator delete(p);
    return;
  }
  *(void**)p=nextFree[n];
  nextFree[n]=p;
}

CMemPool::~CMemPool()
{
}
