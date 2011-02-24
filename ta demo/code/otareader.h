///////////////////////////////////////////////////////////////////////////////
// Params:
//  pszOTABuf  - buffer with OTA file
//  pszName    - name to read, e.g. "GlobalHeader.Schema0.specials.special2.XPos"
//  pszValue   - value is written here (out param), make sure buffer is big enough
// 
// Returns true if the value was found, otherwise false.
//
bool getOTAValue(char* pszOTABuf, const char* pszName, char* pszValue );
