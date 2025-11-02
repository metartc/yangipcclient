/*
 * YangIosRender.cpp
 *
 *  Created on: 2025年9月25日
 *      Author: yang
 */

#import "YangIosRender.h"

@implementation YangIosRender
{
    YangRenderImage* m_img;
    YangIosClient* m_iosClient;
    YangIpcClient8* m_client;
    NSThread *m_clientThread;
}
    -(id)init
    {
        if(self=[super init])
        {
            m_isStart = false;
            m_isLoop  = false;
            m_isRender = false;
            m_client=NULL;
            m_img=NULL;
            m_iosClient=NULL;
        }
        return self;
    }

    -(void)dealloc
    {
        [self stop];
        while(m_isStart){
            usleep(20*1000);
        }
    }
    
-(void)setClient:(YangIosClient*) iosClient{
    m_iosClient=iosClient;
    m_client=iosClient->m_client;
}

-(void)start{
    if (m_isStart)
        return;

    m_clientThread = [[NSThread alloc] initWithTarget:self
                                             selector:@selector(run)
                                               object:nil];
    [m_clientThread start];

}
-(void)stop{
    m_isLoop = false;
}

-(void)render{
    if(m_client)
        m_img=m_client->getRenderImage(m_client->session);
    
    if(m_isRender&&m_img&&m_iosClient){
        [m_iosClient playVideo:m_img->payload width:m_img->width height:m_img->height];
    }
}

-(void)run{
    @autoreleasepool {
        m_isStart = true;
        [self startLoop];
        m_isStart = false;
    }
}

-(void)startLoop {
    m_isLoop = true;
   
    while(m_isLoop){
        usleep(1000*10);
        [self render];
    }
    
}

@end
