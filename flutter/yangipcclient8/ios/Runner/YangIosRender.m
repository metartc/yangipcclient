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
    YangOpenGLView* m_view;
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
            m_view=NULL;
            m_client=NULL;
            m_img=NULL;
       
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
    
-(void)setOpengl:(YangOpenGLView*)view{
  m_view=view;
}
      
-(void)setClient:(YangIpcClient8*) iosClient{
  m_client=iosClient;
   
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
    
    if(m_isRender&&m_img&&m_view){
      [m_view playVideo:m_img->width height:m_img->height data:m_img->payload];
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
