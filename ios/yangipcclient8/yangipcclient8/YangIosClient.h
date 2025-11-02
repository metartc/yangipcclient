//
// Copyright (c) 2019-2023 yanggaofeng
//
#ifndef YangIosPlayer_H
#define YangIosPlayer_H
//import yangipc8
#import "YangGlView.h"
#import "yangclient8/yangclient8.h"
@interface YangIosClient:NSObject
{
@public
YangIpcClient8* m_client;
YangGlView* m_glView;
}
-(id)init;
-(void)dealloc;
-(void)initClient:(void*) callback;
-(void)setGLView:(YangGlView*)glView;
-(void)playVideo:(uint8_t*)data width:(uint32_t)width height:(uint32_t)height;
-(BOOL)mqttALive;
-(int)startMqtt:(char*)serverTopic;
-(int)startPlay;
-(void)stopPlay;
//-(void)startRender;
//-(void)stopRender;
@end





#endif
