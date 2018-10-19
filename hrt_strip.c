#include "libheart.h"
extern gba_system __hrt_system;
GameMap gGameMap;

void hrt_ConfigMapLayerDrawing(u8 numLayers, u16 *tileset, s16 dimensionsx, s16 dimensionsy, u16 *map, s32 x, s32 y)
{
	if (__hrt_system.hrt_start == 1)
	{
		gGameMap.numLayers = numLayers;
		gGameMap.layer->map = map;
		gGameMap.dimensions.x = dimensionsx;
		gGameMap.dimensions.y = dimensionsy;
		gGameMap.layer[1].scroll.y = y;
		gGameMap.layer[1].scroll.x = x;
		gGameMap.tileset = tileset;
	}
}

void hrt_DrawFullLargeScrollMap()
{
	if (__hrt_system.hrt_start == 1)
	{
		u32 j, i;
		for (i = 0; i < gGameMap.numLayers; i++)
			for (j = 0; j < 32; j++)
				hrt_DrawMapLayerStripH(i, fptochar(gGameMap.layer[i].scroll.y) + j);
	}
}

void hrt_SetLargeScrollMapX(s32 x, u8 i)
{
	if (__hrt_system.hrt_start == 1)
	{
		gGameMap.layer[i].scroll.x = x;
	}
}

void hrt_SetLargeScrollMapY(s32 y, u8 i)
{
	if (__hrt_system.hrt_start == 1)
	{
		gGameMap.layer[i].scroll.y = y;
	}
}

void hrt_DrawMapLayerStripH(int layerIdx, int srcY)   // srcY is in 8x8 tiles (even though source map tiles are 16x16) 
{
	if (__hrt_system.hrt_start == 1)
	{
		int i;
		const MapLayer *layer = &gGameMap.layer[layerIdx];
		const u16 *src = layer->map + (srcY >> 1) * gGameMap.dimensions.x;
		u16 *dest = BG_SCRN_VRAM(28 + layerIdx) + (srcY & 31) * 32;
		const int scrollXChar = fptochar(layer->scroll.x);
		const int yOffset = ((srcY & 1) << 1);
		for (i = 0; i < 32; i++)
		{
			const int xOffset = ((scrollXChar + i) & 1);
			const u16 tile = src[(scrollXChar + i) >> 1];
			dest[(scrollXChar + i) & 31] = gGameMap.tileset[(tile << 2) + xOffset + yOffset];
		}
	}
}

void hrt_DrawMapLayerStripV(int layerIdx, int srcX)
{
	if (__hrt_system.hrt_start == 1)
	{
		int i;
		const MapLayer *layer = &gGameMap.layer[layerIdx];
		const u16 *src = layer->map + (srcX >> 1);
		u16 *dest = BG_SCRN_VRAM(28 + layerIdx) + (srcX & 31);
		const int scrollYChar = fptochar(layer->scroll.y);
		const int xOffset = (srcX & 1);
		for (i = 0; i < 32; i++)
		{
			const int yOffset = ((scrollYChar + i) & 1) << 1;
			const u16 tile = src[((scrollYChar + i) >> 1) * gGameMap.dimensions.x];
			dest[((scrollYChar + i) & 31) * 32] = gGameMap.tileset[(tile << 2) + xOffset + yOffset];
		}
	}
}

void hrt_SetLargeMapXY(s32 x, s32 y)
{
	if (__hrt_system.hrt_start == 1)
	{
		gGameMap.layer[1].scroll.y = y;
		gGameMap.layer[1].scroll.x = x;
	}
}


s32 hrt_GetLargeMapX(u8 i)
{
	if (__hrt_system.hrt_start == 1)
	{
		return gGameMap.layer[i].scroll.x;
	}
	return 0;
}

s32 hrt_GetLargeMapY(u8 i)
{
	if (__hrt_system.hrt_start == 1)
	{
		return gGameMap.layer[i].scroll.y;
	}
	return 0;
}

u8 hrt_GetNumLayers()
{
	if (__hrt_system.hrt_start == 1)
	{
		return gGameMap.numLayers;
	}
	return 0;
}