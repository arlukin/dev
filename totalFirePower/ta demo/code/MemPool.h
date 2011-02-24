#ifndef CMEMPOOL_H
#define CMEMPOOL_H

#include <new>

class CMemPool
{
 public:
  CMemPool();
  void *Alloc(size_t n);
  void Free(void *p,size_t n);
  ~CMemPool();
 private:
  void* nextFree[121];
  int poolSize[121];
};
extern CMemPool mempool;
#endif
