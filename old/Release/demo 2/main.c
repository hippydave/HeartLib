#include <libheart.h>
#include "defs.h"
#include "soundbank.h"
int hrs, min, secs;
extern const Sound ADPCM_truc;
int temp = 0;

char buffer[255];

void vblFunc()
{
	hrt_CopyOAM();
	frames++;
	g_newframe = 0;
}

void vblFunc2(void)
{
	hrt_ADPCMDecodeVBL(0);
	hrt_ADPCMDecodeVBL(1);
	g_newframe = 0;
}

int main()
{
	hrt_EnableSoftReset();
	hrt_EnableRTC();
	hrt_EnableCopyOAMOnVBL();
	hrt_EnablemmFrameonVBL();
	int frames;
    hrt_Init(); //Initializes Heartlib. If number is set to 1 it plays an intro. REQUIRED FOR USING THIS LIBRARY. IF THIS IS NOT EXECUTED IT WILL NOT WORK!!!!
    const GBFS_FILE *dat = find_first_gbfs_file(find_first_gbfs_file); //defines GBFS file
    //Sets the Display Mode, like which mode, OBJ Settings, and which backgrounds are enabled.
    hrt_SetDSPMode(3, //Mode
                   0,								  //CGB Mode
                   0,								  //Frame Select
                   0,                               //Unlocked HBlank
                   1,                               //Linear OBJ Tile Mapping
                   0,                               //Force Blank
                   0,                               //BG 0
                   0,                               //BG 1
                   1,                               //BG 2
                   0,                               //BG 3
                   1,                               //OBJ
                   0,                               //Win 0
                   0,                               //Win 1
                   0);							  //OBJWin

    hrt_CreateOBJ(0,   //Sprite ID
                  0,							     //Start X
                  0,							     //Start Y
                  0,							     //Size
                  0,							     //Affine
                  0,							     //Horizontal Flip
                  0,							     //Vertical Flip
                  0,							     //Shape
                  0,							     //Double Size
                  0,							     //Mosaic
                  0,							     //Palette (16-Color only)
                  1,							     //Color setting
                  0,							     //Mode
                  0,								 //Priority
                  0);							 //Offset

    hrt_LoadOBJGFX((void*)arrowTiles, 32); //loads Sprite Graphics
    hrt_LoadOBJPal((void*)arrowPal, 255); //loads Sprite palette
    frames = 0; //Sets frames to 0
    arpos = 0; //Sets arrow position to 0

    hrt_PrintOnBitmap(56, //X position
                      152, //Y position
                      "HeartLib Demo 2 v1.0"); // String

    hrt_SetDSPMode(3, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0); //Sets REG_DISPCNT, like above
    hrt_PrintOnBitmap(8, 0, "OBJ Window"); //draws text
	hrt_PrintOnBitmap(8, 9, "BG Affine"); //draws text
	hrt_PrintOnBitmap(8, 18, "PCX"); //draws text
	hrt_PrintOnBitmap(8, 27, "Interrupt Dispatcher"); //draws text
	hrt_PrintOnBitmap(8, 36, "Random Number Generator"); //draws text
	hrt_PrintOnBitmap(8, 45, "Built-in MaxMod"); //draws text
	hrt_PrintOnBitmap(8, 54, "mbv2lib"); //draws text
	hrt_PrintOnBitmap(8, 63, ""); //draws text
	hrt_PrintOnBitmap(8, 72, "Real-Time Clock"); //draws text
	hrt_PrintOnBitmap(8, 81, "System Detection"); //draws text
	hrt_PrintOnBitmap(8, 90, "Mode 7"); //draws text
	hrt_PrintOnBitmap(8, 99, "JPEG"); //draws text
	hrt_PrintOnBitmap(8, 108, "ADPCM"); //draws text
    hrt_CopyOAM(); //Copies OBJ Data to OAM
    while (1) {
		frames++;
        if (keyDown(KEY_UP)) {
            arpos--;
            if (arpos == -1) {
                arpos = 0;

            }
            while (keyDown(KEY_UP));
        }
        if (keyDown(KEY_DOWN)) {
            arpos++;
            if (arpos == 13) {
                arpos = 12;
            }
            while (keyDown(KEY_DOWN));
        }

        hrt_SetOBJXY(0, //Sprite
                     0, //X Position
                     9*arpos); //Y Position

        if (keyDown(KEY_A)) {
			if (arpos == 12)
			{
				hrt_FillScreen(0x0000);
				hrt_DSPDisableOBJ();
				hrt_InitADPCM(2);
				hrt_irqSet(IRQ_VBLANK, &vblFunc2);
				hrt_DSPSetBGMode(3);
				hrt_DSPDisableForceBlank();
				hrt_DSPEnableBG(2);
				hrt_BGSetMapBase(2, 2);
				hrt_PrintOnBitmap(0, 0, "HeartLib ADPCM Demo. Press B.");
				while (1)
				{
					if (g_newframe == 0)
					{
						g_newframe = 1;
						if (keyDown(KEY_B))
						{
							hrt_StartADPCM(&ADPCM_truc, -1, 0);
						}
						if (keyDown(KEY_A))
						{
							temp = chmod("C:\\suck\\", 1);
						}
					}
					hrt_VblankIntrWait();
				}
			}
			if (arpos == 11)
			{
				hrt_FillScreen(0x0000);
				hrt_DecodeJPEG(such2_jpg, VRAM, 240, 160);
				while (1)
				{
					hrt_VblankIntrWait();
				}
			}
			if (arpos == 10)
			{
				
			}
			if (arpos == 9)
			{
				int ver;
				hrt_FillScreen(0x0000);
				ver = hrt_GetBiosChecksum();
				hrt_VblankIntrWait();
				if (ver == 0)
				{
					hrt_PrintOnBitmap(0, 0, "Prototype GBA");
				}
				if (ver == 0xbaae187f)
				{
					hrt_PrintOnBitmap(0, 0, "Release GBA");
				}
				if (ver == 0xBAAE1880)
				{
					hrt_PrintOnBitmap(0, 0, "Nintendo DS");
				}
				while (1);
			}
			if (arpos == 8)
			{
				hrt_FillScreen(0x0000);
				char str[30];
				char *s = str + 20;
				int timer, hours, min, secs, hours2, min2, secs2;
				timer = hrt_GetRTCTime();
				hours = (timer >> 4) & 3;				//Hours.
				hours2 = (timer & 15);
				min = (timer >> 12) & 15;				//Minutes.
				min2 =(timer >> 8) & 15;
				secs = (timer >> 20) & 15;				//Seconds.
				secs2 = (timer >> 16) & 15;
				sprintf((char*)buffer, "%d:%d:%d", hours, hours2, min, min2, secs, secs2);
				hrt_PrintOnBitmap(0, 0, (char*)buffer);
				while (1)
				{
					timer = hrt_GetRTCTime();
					hours = (timer >> 4) & 3;				//Hours.
					hours2 = (timer & 15);
					min = (timer >> 12) & 15;				//Minutes.
					min2 = (timer >> 8) & 15;
					secs = (timer >> 20) & 15;				//Seconds.
					secs2 = (timer >> 16) & 15;
					sprintf((char*)buffer, "%d%d:%d%d:%d%d", hours, hours2, min, min2, secs, secs2);
					hrt_PrintOnBitmap(0, 0, (char*)buffer);
				}
			}
			if (arpos == 7)
			{

			}
			if (arpos == 6)
			{
				mbv2_dprintf("Hello World!\n");
			}
			if (arpos == 5)
			{
				mmInitDefault((mm_addr)soundbank_bin, 8);
				mmStart(SFX_COMPLETE, MM_PLAY_LOOP);
				mm_sound_effect boom = {
					{ MOD_MODULE} ,			// id
					(int)(1.0f * (1 << 10)),	// rate
					0,		// handle
					255,	// volume
					255,	// panning
				};
				mm_sfxhand amb = 0;
				while (1)
				{
					hrt_VblankIntrWait();
					if (keyDown(KEY_B)) {
						amb = mmEffectEx(&boom);
					}
					if (!(keyDown(KEY_B))) {
						mmEffectCancel(amb);
					}
				}
			}
			if (arpos == 4)
			{
				hrt_irqInit();
				hrt_irqSet(IRQ_VBLANK, vblFunc);
				hrt_irqEnable(IRQ_VBLANK);
				REG_IME = 1;
				int x_scale;
				int x, y;
				int fxlevel;
				int rot;
				hrt_SetOffset(1, 0);
				hrt_SetOffset(0, 0);
				hrt_CreateOBJ(0, 120, 80, 2, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0);
				hrt_SetDSPMode(3, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0);
				x = 120;
				y = 80;
				hrt_AffineOBJ(0, 0, 255, 255);
				x_scale = 255;
				g_newframe = 1;
				hrt_FillScreen(0x0000);
				hrt_PrintOnBitmap(0, 0, "0");
				int j;
				hrt_SeedRNG(frames);
				u64 g_sram;
				while (1)
				{
					if (keyDown(KEY_A))
					{
						g_sram = hrt_CreateRNG();
						hrt_Memcpy(VRAM, (char*)0x06000ED0, 240 * 16);
						sprintf((char*)buffer, "%d", g_sram);
						hrt_PrintOnBitmap(0, 0, (char*)buffer);
					}
				}
			}
			if (arpos == 2)
			{
				hrt_SetDSPMode(4, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0); //Sets REG_DISPCNT, like above
				hrt_FillScreen(0x0000);
				hrt_DecodePCX(such, VRAM, BGPaletteMem);
			}
			if (arpos == 3)
			{
				hrt_irqInit();
				hrt_irqSet(IRQ_VBLANK, vblFunc);
				hrt_irqEnable(IRQ_VBLANK);
				REG_IME = 1;
				int x_scale;
				int x, y;
				int fxlevel;
				int rot;
				hrt_SetOffset(1, 0);
				hrt_SetOffset(0, 0);
				hrt_CreateOBJ(0, 120, 80, 2, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0);
				hrt_SetDSPMode(3, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0);
				hrt_LoadOBJGFX((void*)blockTiles, 2048);
				hrt_LoadOBJPal((void*)blockPal, 255);
				hrt_CopyOAM();
				x = 120;
				y = 80;
				hrt_AffineOBJ(0, 0, 255, 255);
				x_scale = 255;
				g_newframe = 0;
				hrt_FillScreen(0x0000);
				hrt_PrintOnBitmap(0, 0, "Interrupt Dispatcher");
				while (1) {
					if (g_newframe == 0)
					{
						frames++;
						if (keyDown(KEY_SELECT)) {
							fxlevel++;
							hrt_SetFXLevel(fxlevel);
						}

						if (keyDown(KEY_R)) {
							rot++;
						}
						if (keyDown(KEY_L)) {
							rot--;
						}
						if (keyDown(KEY_A)) {
							x_scale++;
						}
						if (keyDown(KEY_B)) {
							x_scale--;
						}
						if (keyDown(KEY_UP)) {
							y--;
						}
						if (keyDown(KEY_DOWN)) {
							y++;
						}
						if (keyDown(KEY_LEFT)) {
							x--;
						}
						if (keyDown(KEY_RIGHT)) {
							x++;
						}
						if (rot == -1) {
							rot = 0;
						}
						if (keyDown(KEY_START)) {
							asm volatile("swi 0x00"::);
						}
						hrt_SetOBJXY(0, x, y);
						hrt_AffineOBJ(0, rot % 360, x_scale, x_scale);
						hrt_CopyOAM();
						g_newframe = 1;
					}
					asm("swi 0x05"::);
					g_newframe = 0;
				}
			}
        }
        hrt_VblankIntrWait();
    }
    return 0;
}
