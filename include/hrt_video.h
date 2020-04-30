#ifndef HRT_VIDEO
#define HRT_VIDEO

//Includes
#include "hrt_types.h"
#include "hrt_memmap.h"

//Structs

//Macros
#define DSP_MODE(mode)	mode
#define OBJ_MAP_1D		0x40
#define OBJ_MAP_2D		0x0
#define H_BLANK_OAM		0x20
#define FORCE_BLANK		0x80
#define	ENABLE_BG(bg)	1UL << (8+bg)
#define WIN1_ENABLE		0x2000
#define WIN2_ENABLE		0x4000
#define OBJWIN_ENABLE	0x8000
#define OBJ_ENABLE		0x1000

#define	CHAR_BASE(m)		((m) << 2)
#define BG_TILE_BASE(m)		((m) << 2)
#define CHAR_BASE_ADR(m)	((m) << 14)
#define MAP_BASE_ADR(m)		((m) << 11)
#define BG_MAP_BASE(m)		((m) << 8)
#define OBJ_TILE_BASE(m)	(((m)*0x20)+0x10000)

#define hrt_SetPaletteEntry(entry, color) PALETTE[entry] = color

//Functions
HEART_API void hrt_PlotPixelInMode4(u32 x, u32 y, u32 color);
HEART_API void hrt_LoadDataIntoVRAM(u16* data, u32 offset, u32 length);
HEART_API void hrt_DSPSetBGMode(u8 mode);
HEART_API void hrt_DSPConfigureBG(u8 bg, u16 mode);
HEART_API u16  hrt_GenerateColorFromRGB(u8 red, u8 green, u8 blue);
HEART_API void hrt_DSPEnableBG(u8 bg);
HEART_API void hrt_DSPDisableBG(u8 bg);
HEART_API void hrt_DSPEnableOBJ(void);
HEART_API void hrt_DSPDisableOBJ(void);
HEART_API void hrt_DSPConfigBG(u8 bg, u8 priority, u8 tilebase, u8 mosaic, u8 color, u8 mapbase, u8 wraparound, u8 dimensions);
HEART_API void hrt_SetBGXY(u8 bg, int x, int y);
HEART_API void hrt_SetBGX(u8 bg, int x);
HEART_API void hrt_SetBGY(u8 bg, int y);
HEART_API void hrt_InvertPalette(u16 start, u16 amount);
HEART_API void hrt_PlotPixelInMode3(u8 x, u8 y, u16 color);
HEART_API void hrt_DrawLine3(int x1, int y1, int x2, int y2, unsigned short color);
HEART_API void hrt_DSPEnableForceBlank(void);
HEART_API void hrt_DSPDisableForceBlank(void);
HEART_API void hrt_LoadDataIntoPalette(u16* data, u32 offset, u32 length);
HEART_API void hrt_PlotPixelInMode5(u8 x, u8 y, u16 color);
HEART_API void hrt_EnableGreenSwap(void); //This makes the screen look fuzzy, only works on hardware.
HEART_API void hrt_DisableGreenSwap(void);
HEART_API u16  hrt_GetPixelInMode3(int x, int y);
HEART_API void hrt_DestroyBG(u8 bg);
HEART_API void hrt_DSPEnableLinearOBJ(void);
HEART_API void hrt_DSPDisableLinearOBJ(void);
HEART_API void hrt_DSPEnableLinearOBJ(void);
HEART_API void hrt_DSPDisableLinearOBJ(void);
HEART_API void hrt_BGSet16Color(u8 layer);
HEART_API void hrt_BGSet256Color(u8 layer);
HEART_API void hrt_BGEnableMosaic(u8 layer);
HEART_API void hrt_BGDisableMosaic(u8 layer);
HEART_API void hrt_BGSetSize(u8 layer, u8 size);
HEART_API void hrt_BGSetMapBase(u8 layer, u8 no);
HEART_API void hrt_BGSetTileBase(u8 layer, u8 no);
HEART_API void hrt_BGSetPriority(u8 layer, u8 no);
HEART_API void hrt_FlipBGBuffer(void);

//Inlines


#endif