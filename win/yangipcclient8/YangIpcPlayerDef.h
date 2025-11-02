/*
 * YangIosClientDef.h
 *
 *  Created on: 2025年9月25日
 *      Author: yang
 */

#ifndef INCLUDE_YANGAPP_YANGIPCPlayerTDEF_H_
#define INCLUDE_YANGAPP_YANGIPCPlayerTDEF_H_

#include <stdint.h>

#if _WIN32
#define YANG_EXPORT_API __declspec(dllexport)
#elif TARGET_OS_IPHONE
#define YANG_EXPORT_API __attribute__((visibility("default")))
#else
#define YANG_EXPORT_API
#endif

typedef struct{
	void* session;
	void (*success)(void* session);
	void (*failure)(void* session,int32_t  errcode);
}YangPlayerMsgCallback;

typedef struct{
	uint32_t width;
	uint32_t height;
	uint8_t* payload;
}YangRenderImage;


#endif /* INCLUDE_YANGAPP_YANGIOS_YANGIOSCLIENTDEF_H_ */
