//
// Copyright (c) 2019-2022 yanggaofeng
//
#include "yangrequest.h"
#import <AVFoundation/AVFoundation.h>
#import <Network/Network.h>

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


void yang_requestMicrophone(){
     [LocalNetworkManager requestLocalNetworkPermission];
[AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted) {
                        // 用户授权
                        NSLog(@"用户授权麦克风权限");
                     
                    } else {
                        // 用户拒绝
                        NSLog(@"用户拒绝麦克风权限");
                        
                    }
                });
            }];	
}
