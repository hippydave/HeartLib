#ifdef __cplusplus
extern "C" {
#endif

#ifndef HRT_TEXT
#define HRT_TEXT

//Includes
#include <stdarg.h>
#include <stdio.h>
#include "hrt_types.h"

//Functions
HEART_API void hrt_ClearText();
HEART_API void hrt_InitTextEngine(u8 bg);
HEART_API void hrt_Print(u8 tx, u8 ty, char* str, ...);
HEART_API void hrt_SetTextColors(u16 out, u16 in);

#endif

#ifdef __cplusplus
}
#endif