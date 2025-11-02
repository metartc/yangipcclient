//
//  ViewController.m
//  metaplayer7_ios
//
//  Created by apple on 2023/8/14.
//  Copyright © 2023 metaRTC. All rights reserved.
//

#import "ViewController.h"

#import <Network/Network.h>

static void yang_success(void* session){
    //ViewController* view=(__bridge ViewController*)session;
    //if(view->m_isStart)
       // return;
    
   // [view on_play];
}

static void yang_failure(void* session,int32_t  errcode){
    ViewController* view=(__bridge ViewController*)session;
    if(errcode==3){
        if(view->m_isStart){
            [view on_play];
        }
        return;
    }

}


@interface LocalNetworkManager : NSObject
@end

@implementation LocalNetworkManager

// 触发 Local Network 权限弹窗
+ (void)requestLocalNetworkPermission {
    
    nw_endpoint_t endpoint = nw_endpoint_create_host("192.168.0.104", "1883"); // mDNS 组播地址
    nw_parameters_t params = nw_parameters_create_secure_udp(NW_PARAMETERS_DEFAULT_CONFIGURATION, NW_PARAMETERS_DEFAULT_CONFIGURATION);
    
    nw_connection_t conn = nw_connection_create(endpoint, params);
    nw_connection_set_queue(conn, dispatch_get_main_queue());
    nw_connection_start(conn);
    
    // 系统会在这里触发权限弹窗
    NSLog(@"Local network permission requested.");
    
}

@end


@interface ViewController ()

@end

@implementation ViewController
{
    YangPlayerMsgCallback m_callback;
}
-(id)init
{
    if(self=[super init])
    {
        m_glview=NULL;
        m_client=NULL;
        m_render=NULL;
        m_isStart=false;
    }
    return self;
}

//-(void)dealloc{
   // if(m_player){
   //
   // };
//}

-(void)on_play{
    if(!m_isStart){
        if(m_client){
            if([m_client startMqtt:(char*)"test1001"]!=0){
                return;
            }
            
            if(![m_client mqttALive])
                return;
            
            if([m_client startPlay]!=0){
                return;
            }
            
            if(!m_render->m_isRender){
                m_render->m_isRender=true;
                [m_render start];
            }
        }
        [_m_b_play setTitle:@"stop" forState:UIControlStateNormal];
        m_isStart=true;
    }else{
        m_isStart=false;
        [_m_b_play setTitle:@"play" forState:UIControlStateNormal];
        [m_client stopPlay];
        m_render->m_isRender=false;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // _m_glview = [[YangGlView alloc] init];
    if(m_glview==NULL){
        m_glview = [[YangGlView alloc] initWithFrame:[_m_play_view bounds]];
          [_m_play_view addSubview:m_glview];
    }
    if(m_client==NULL){
        m_callback.session=(__bridge void*)self;
        m_callback.success=yang_success;
        m_callback.failure=yang_failure;
        m_client=[[YangIosClient alloc] init];
        [m_client initClient:&m_callback];
        [m_client setGLView:m_glview];
    }
    
    if(m_render==NULL){
        m_render=[[YangIosRender alloc] init];
        [m_render setClient:m_client];
       // m_render->m_iosClient=m_client;
    }
    
    [LocalNetworkManager requestLocalNetworkPermission];
   // [self addSubview:_m_glview];
}



- (IBAction)b_play_ondown:(id)sender {
    [self on_play];
    
}

- (IBAction)b_play_set:(id)sender {

}


@end
