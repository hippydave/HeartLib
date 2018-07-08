#include "libheart.h"
extern gba_system __hrt_system;
u8* SRAM = (u8*)0x0E000000;

void hrt_SaveByte(int offset, u8 value)
{
	if (__hrt_system.hrt_start == 1) {
		SRAM[offset] = value;
	}
}

u8 hrt_LoadByte(int offset)
{
	if (__hrt_system.hrt_start == 1) {
		return SRAM[offset];
	}
	return 0;
}

void hrt_SaveByteEEP(u32 offset, u8 value)
{
	if (__hrt_system.hrt_start == 1) {
		EEPROM[offset] = value;
	}
}

u8 hrt_LoadByteEEP(u32 offset)
{
	if (__hrt_system.hrt_start == 1) {
		return EEPROM[offset];
	}
	return 0;
}