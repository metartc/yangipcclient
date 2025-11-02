//
// Copyright (c) 2019-2023 yanggaofeng
//
#include "YangIosClient.h"


#include <dirent.h>
#include <string.h>

//extern "C"{
DIR *opendir$INODE64(const char * a)
 {
     return opendir(a);
 }
  
 struct dirent *readdir$INODE64(DIR *dir)
 {
     return readdir(dir);
 }


void g_yang_ios_setConfig(YangIpcClient8* client){
    if(client==nil)
        return;
    
   
    client->setLoglevel(client->session,5);
    client->setDecodeHw(client->session,yangfalse);
    client->setIceConfig(client->session,0, 2);
    client->setIceServer(client->session,(char*)"192.168.0.104", 3478, (char*)"metartc", (char*)"metartc");
    client->setMqttServer(client->session,yangfalse,(char*)"192.168.0.104", 1883, (char*)"", (char*)"");
    //client->setIceServer(client->session,(char*)"139.224.102.24", 3478, (char*)"metartc", (char*)"metartc");
   // client->setMqttServer(client->session,(char*)"139.129.17.54", 10082, (char*)"metartc_rtc", (char*)"metartc9644712");
}

@implementation YangIosClient

    -(id)init
    {
        if(self=[super init])
        {
            m_glView=nil;
            m_client=nil;
        }
        return self;
    }

    -(void)dealloc
    {
        yang_destroy_ipcClient8(m_client);
        if(m_client){
            free(m_client);
        }
        m_client=NULL;
    }

-(void)initClient:(void*) callback{
    YangPlayerMsgCallback *ipccallback=(YangPlayerMsgCallback*)callback;
  
    if(m_client==NULL) {
        m_client=(YangIpcClient8*)calloc(sizeof(YangIpcClient8),1);
        yang_create_ipcClient8(m_client,ipccallback,yangtrue);
        m_client->init(m_client->session);
        g_yang_ios_setConfig(m_client);
    }
}

-(void)setGLView:(YangGlView *)glView{
    m_glView=glView;
}
    
-(void)playVideo:(uint8_t *)data width:(uint32_t)width height:(uint32_t)height{
    if(m_glView){
        [m_glView playVideo:width height:height data:data];
    }
}

-(BOOL)mqttALive{
    if(m_client){
        return m_client->mqttALive(m_client->session)?YES:NO;
    }
    return NO;
}

-(int)startMqtt:(char *)serverTopic{
    if(m_client){
      //  NSLog(@">>>>>>>>>>>>>>>>>>>>start paly url");
        return m_client->startMqtt(m_client->session,serverTopic);
    }
    return 0;
}
-(int)startPlay{
    if(m_client){
      //  NSLog(@">>>>>>>>>>>>>>>>>>>>start paly url");
        return m_client->startPlay(m_client->session);
    }
    return 0;
}
-(void)stopPlay{
    if(m_client) m_client->stopPlay(m_client->session);
}

@end
