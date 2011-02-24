///////////////////////////////////////////////////////////////////////////////
// Params:
//  pszOTABuf  - buffer with OTA file
//  pszName    - name to read, e.g. "GlobalHeader.Schema0.specials.special2.XPos"
//  pszValue   - value is written here (out param), make sure buffer is big enough
// 
// Returns true if the value was found, otherwise false.
//
#include <stdlib.h>
#include <string.h>

bool getOTAValue(char* pszOTABuf, const char* pszName, char* pszValue )
{
  char pszKey[100];
  char* pszStart = 0;

  strcpy( pszKey, pszName );

  //printf("Key: %s\n", pszKey );

  char *pszPos = strchr( pszKey, '.' );
  if( pszPos != NULL )
  {
    *pszPos = '\0';
    int iLen = strlen( pszKey );

    pszStart = pszOTABuf;
    while( pszStart = strchr( pszStart, '[' ) )
    {
      pszStart++; // Skip past '['
      if( strncmp( pszStart, pszKey, iLen ) == 0 && *(pszStart+iLen) == ']' )
      {
        pszStart += iLen + 1;
        pszStart = strchr( pszStart, '{' );
        if( pszStart )
          return getOTAValue( pszStart + 1, pszPos + 1, pszValue );
      }
    }
  }
  else
  {
    pszStart = strstr( pszOTABuf, pszKey );
    pszPos = strchr( pszOTABuf, '}' );
    if( pszPos && pszStart && pszStart < pszPos )
    {
      pszStart += strlen( pszKey );
      if( *pszStart++ == '=' )
      {
        pszPos = strchr( pszStart, ';' );
        int iLen = pszPos - pszStart;
        if( pszPos )
        {
          strncpy( pszValue, pszStart, iLen );
          pszValue[iLen] = '\0';
          return true;
        }
      }
    }
  }
  *pszValue = '\0';
  return false;
}