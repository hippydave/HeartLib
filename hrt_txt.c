#include "libheart.h"
extern gba_system __hrt_system;
extern unsigned char font_matrixBitmap[6080];
u16* tram = (u16*)0x06000800;
char __outstr2[32];

u16 _____colors[3] = {
	0x0000, 0x0421, 0x7FFF
};

void hrt_SetPaletteOfTiledText(u8 pal)
{
	register int i;
	if(__hrt_system.hrt_start == 1) {
		__hrt_system.__hrt_tiledtext_palno = pal;
		for(i=0; i < 1024; i++)
		{
			VRAM[i] |= (pal << 12);
		}
	}
}

void hrt_SetBitmapTextColors(u16 outside, u16 inside)
{
	if(__hrt_system.hrt_start == 1) {
		_____colors[1] = outside;
		_____colors[2] = inside;
	}
}

void hrt_DrawChar(int mode, int left, int top, char letter) {
    if (__hrt_system.hrt_start == 1) {
        register int x, y;
		register u8 temp;
        for (y = 0; y < 8; y++)
            for (x = 0; x < 8; x++) {
				temp = font_matrixBitmap[(letter - 32) * 64 + y * 8 + x];
				if (!(temp == 0))
				{
					hrt_DrawPixel(mode, left + x, top + y, _____colors[temp]);
				}
            }
    }
}

void hrt_PrintOnBitmap(int left, int top, char *str, ...) {
    if (__hrt_system.hrt_start == 1) {
		va_list args;
		char *string = __outstr2;
		va_start(args, str);
		vsprintf(__outstr2, str, args);
		va_end(args);
        register int pos = 0;
        while (*string) {
            hrt_DrawChar(3, left + pos, top, *string++);
            pos += 8;
        }
    }
}

void hrt_InitTiledText(u8 bg)
{
	BUP temp;
	register u16 i;
    if (__hrt_system.hrt_start == 1) {
		temp.SrcNum = 6080;
		temp.SrcBitNum = 8;
		temp.DestBitNum = 4;
		temp.DestOffset = 0;
		temp.DestOffset0_On = 0;
		hrt_BitUnPack((void*)font_matrixBitmap, (u16*)0x06000800, &temp);
		hrt_SetBGPalEntry(0, 0x0000);
		hrt_SetBGPalEntry(1, 0x0421);
		hrt_SetBGPalEntry(2, 0x7FFF);
		REG_BGxCNT(bg) = 0x0000;
		for(i=0; i < 1024; i++)
		{
			VRAM[i] = 64;
		}
	}
}

void hrt_PrintOnTilemap(u8 tx, u8 ty, char* str, ...)
{
	if (__hrt_system.hrt_start == 1) {
		va_list args;
		char *string = __outstr2;
		va_start(args, str);
		vsprintf(__outstr2, str, args);
		va_end(args);
		register int pos = 0;
        while (*string) {
            VRAM[(ty*32+tx+pos)%1024] = *string++;
			VRAM[(ty*32+tx+pos)%1024] += 32;
            pos += 1;
        }
		hrt_SetPaletteOfTiledText(__hrt_system.__hrt_tiledtext_palno);
	}
}

void hrt_ClearTiledText(void)
{
	register u16 i;
	if(__hrt_system.hrt_start == 1) {
		for(i=0; i<1024; i++)
		{
			VRAM[i] = 64;
		}
	}
}