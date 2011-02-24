#ifndef tamemH
#define tamemH

#pragma pack(1)

struct PlayerStruct;
struct PlayerInfoStruct;
struct UnitStruct;
struct UnitOrdersStruct;
struct WeaponStruct;
struct MapFileStruct;
struct UnitDefStruct;
struct GafAnimStruct;
struct Object3doStruct;
struct PrimitiveStruct;
struct PrimitiveInfoStruct;
struct ProjectileStruct;
struct FeatureDefStruct;
struct FXGafStruct;
struct FeatureStruct;
struct WreckageInfoStruct;
struct DebrisStruct;
struct Unk1Struct;
struct Point3;
struct SmokeListNode;
struct ParticleSystemStruct;
struct SmokeListNode;
struct ParticleBase;
struct SmokeGraphics;
struct RadarPicStruct;

struct Point3{
	int x;
	int y;
	int z;
};
struct WreckageInfoStruct{
	int unk1;
	LPVOID unk2;
	int XPos;
	int ZPos;
	int YPos;
	char data1[0xC];
	short ZTurn;
	short XTurn;
	short YTurn;
	char data2[0xA];
};

struct FeatureStruct{
	char data1[8];
	short FeatureDefIndex;
	short WreckageInfoIndex;
	char data2[1];
}; //0xD

struct FeatureDefStruct {
	char Name[0x20];
	char data1[0x60];
	char Description[20];
	char Data2[108];
}; //0x100
#pragma pack()

#endif
