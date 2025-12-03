
//
// Copyright (c) 2019-2025 yanggaofeng
//

#ifndef INCLUDE_YANGIPC8_H_
#define INCLUDE_YANGIPC8_H_
#include <stdint.h>
#define yangbool uint8_t
#define yangtrue 1
#define yangfalse 0

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


typedef struct{
    void* session;
    void (*init)(void* session);

    yangbool (*mqttALive)(void* session);
    int32_t (*startMqtt)(void* session,char* serverTopic);
    
    int32_t (*stopPlay)(void* session);
    int32_t (*startPlay)(void* session);


    void (*initRender)(void* session);
    YangRenderImage* (*getRenderImage)(void* session);

    void (*setDecodeHw)(void* session,yangbool isHw);
    void (*setLoglevel)(void* session,int32_t logLevel);
    void (*setIceConfig)(void* session,int32_t iceTransportPolicy,int32_t iceCandidateType);
    void (*setIceServer)(void* session,char* ip,int32_t port,char* username,char* passwork);
    void (*setMqttServer)(void* session,yangbool isTls,char* ip,int32_t port,char* username,char* passwork);
}YangIpcClient8;



int32_t yang_create_ipcClient8(YangIpcClient8* client,YangPlayerMsgCallback* callback,yangbool isHd);
void yang_destroy_ipcClient8(YangIpcClient8* client);


#endif /* SRC_YANGIOS_YANGPLAYERIOS_H_ */

// In this header, you should import all the public headers of your framework using statements like #import <yangclient8/PublicHeader.h>
