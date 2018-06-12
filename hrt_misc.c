#include "libheart.h"
u8* ExtWRAM = (u8*)0x2000000;
extern int __gettime(void);
extern void sleep12();
extern void __hrt_exittoez4();
extern gba_system __hrt_system;

double hrt_Distance(int x1, int y1, int x2, int y2)
{
	if (__hrt_system.hrt_start == 1) {
		return sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2));
	}
	return 0;
}

double hrt_Slope(int x1, int y1, int x2, int y2)
{
	if (__hrt_system.hrt_start == 1) {
		return ((y2 - y1) / (x2 - x1));
	}
	return 0;
}

void *hrt_Memcpy(void *dest, const void *src, size_t len)
{
	if (__hrt_system.hrt_start == 1) {
		char *d = dest;
		const char *s = src;
		while (len--)
			*d++ = *s++;
		return dest;
	}
	return 0;
}

void hrt_SleepF(u32 frames) {
	if (__hrt_system.hrt_start == 1) {
		int i;
		i = frames;
		while (i--) {
			hrt_VblankIntrWait();
		}
	}
}

double hrt_VolumeCylinder(double r, double h)
{
	if (__hrt_system.hrt_start == 1)
	{
		return (PI)*(r * r)*h;
	}
	return 0;
}

double hrt_AreaTriangle(double a, double b)
{
	if (__hrt_system.hrt_start == 1)
	{
		return (1 / 2)*(a*b);
	}
	return 0;
}

double hrt_AreaCircle(double r)
{
	if (__hrt_system.hrt_start == 1)
	{
		return (PI)*(r * r);
	}
	return 0;
}

void hrt_EnableRTC(void)
{
	__hrt_system.__hrt_rtc = 1;
}

void hrt_EnableSoftReset(void)
{
	__hrt_system.__hrt_reset = 1;
}

void hrt_DisableSoftReset(void)
{
	__hrt_system.__hrt_reset = 0;
}

void hrt_DisableRTC(void)
{
	__hrt_system.__hrt_rtc = 0;
}

void hrt_EnablemmFrameonVBL(void)
{
	__hrt_system.__hrt_mmframeonvbl = 1;
}
void hrt_DisablemmFrameonVBL(void)
{
	__hrt_system.__hrt_mmframeonvbl = 0;
}
void hrt_EnableCopyOAMOnVBL(void)
{
	__hrt_system.__copyoamonvbl = 1;
}
void hrt_DisableCopyOAMOnVBL(void)
{
	__hrt_system.__copyoamonvbl = 0;
}

int hrt_GetRTCTime(void)
{
	if (__hrt_system.hrt_start == 1)
	{
		if (__hrt_system.__hrt_rtc == 1)
		{
			return __gettime();
		}
	}
	return 0;
}

int hrt_GetRTCHour_H(void)
{
	if (__hrt_system.hrt_start == 1)
	{
		if (__hrt_system.__hrt_rtc == 1)
		{
			int timer = hrt_GetRTCTime();
			return ((timer >> 4) & 3);
		}
	}
	return 0;
}
int hrt_GetRTCHour_L(void)
{
	if (__hrt_system.hrt_start == 1)
	{
		if (__hrt_system.__hrt_rtc == 1)
		{
			int timer = hrt_GetRTCTime();
			return (timer & 15);
		}
	}
	return 0;
}

int hrt_GetRTCMinute_H(void)
{
	if (__hrt_system.hrt_start == 1)
	{
		if (__hrt_system.__hrt_rtc == 1)
		{
			int timer = hrt_GetRTCTime();
			return ((timer >> 12) & 15);
		}
	}
	return 0;
}
int hrt_GetRTCMinute_L()
{
	if (__hrt_system.hrt_start == 1)
	{
		if (__hrt_system.__hrt_rtc == 1)
		{
			int timer = hrt_GetRTCTime();
			return ((timer >> 8) & 15);
		}
	}
	return 0;
}

int hrt_GetRTCSecond_H(void)
{
	if (__hrt_system.hrt_start == 1)
	{
		if (__hrt_system.__hrt_rtc == 1)
		{
			int timer = hrt_GetRTCTime();
			return ((timer >> 20) & 15);
		}
	}
	return 0;
}
int hrt_GetRTCSecond_L(void)
{
	if (__hrt_system.hrt_start == 1)
	{
		if (__hrt_system.__hrt_rtc == 1)
		{
			int timer = hrt_GetRTCTime();
			return ((timer >> 16) & 15);
		}
	}
	return 0;
}

void hrt_EZ4Exit(void)
{
	if (__hrt_system.hrt_start == 1)
	{
		hrt_DMA_Copy(3, (u8*)0x02000000, (u8*)&sprites, 0x3FF, 0x80800000);
		hrt_CopyOAM();
		__hrt_exittoez4();
	}
}
void hrt_Suspend(void)
{
	if (__hrt_system.hrt_start == 1)
	{
		sleep12();
	}
}