//
//  YangNativePlugin.m
//  Runner
//
//  Created by yang on 2025/11/20.
//


#import "YangNativePlugin.h"
#import "YangOpenGLFactory.h"
#import "YangOpenGLView.h"

@implementation YangNativePlugin {
    FlutterMethodChannel *_channel;
    YangOpenGLFactory *_factory;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {

    YangNativePlugin* instance = [[YangNativePlugin alloc] init];

    instance->_channel = [FlutterMethodChannel methodChannelWithName:@"YangNativeChannel"
                                                     binaryMessenger:[registrar messenger]];
    
    instance->_factory = [[YangOpenGLFactory alloc] initWithMessenger:[registrar messenger]];

    [registrar registerViewFactory:instance->_factory withId:@"YangNativeView"];

    [registrar addMethodCallDelegate:instance channel:instance->_channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
   // NSLog(@">>>>>>>>>>>>>>>>>>>>call.method=%@", call.method);
    NSNumber *viewId = call.arguments[@"viewId"];
    YangOpenGLView *view = [_factory getViewById:viewId];
    if(view==NULL)
        return;
    
    //setLoglevel setDecodeHw setIceConfig setMqttServer setIceServer
    if ([call.method isEqualToString:@"play"]) {
        NSString *serverTopic = call.arguments[@"serverTopic"];
        //NSLog(@"play: serverTopic=%@", serverTopic);
        [view play:serverTopic];
        result(@(YES));
    }else if ([call.method isEqualToString:@"unplay"]) {
        //NSLog(@"unplay========");
        [view unplay];
        result(@(YES));
    }else if ([call.method isEqualToString:@"setLoglevel"]) {
        NSNumber *logLevel = call.arguments[@"logLevel"];
        NSLog(@"setLoglevel: logLevel=%d", [logLevel intValue]);
        [view setLoglevel:[logLevel intValue]];
        result(@(YES));
    }else if ([call.method isEqualToString:@"setDecodeHw"]) {
        NSNumber *isHw = call.arguments[@"isHw"];
        NSLog(@"setDecodeHw: isHw=%d", [isHw intValue]);
         [view setDecodeHw:[isHw intValue]];
        result(@(YES));
    }else if ([call.method isEqualToString:@"setIceConfig"]) {
        NSNumber *iceTransportPolicy = call.arguments[@"iceTransportPolicy"];
        NSNumber *iceCandidateType = call.arguments[@"iceCandidateType"];
        NSLog(@"setIceConfig: iceTransportPolicy=%d iceCandidateType=%d", [iceTransportPolicy intValue], [iceCandidateType intValue]);
        [view setIceConfig:[iceTransportPolicy intValue] iceCandidateType:[iceCandidateType intValue]];
        result(@(YES));
    }else if ([call.method isEqualToString:@"setMqttServer"]) {
        NSString *ip = call.arguments[@"ip"];
        NSNumber *port = call.arguments[@"port"];
        NSString *username = call.arguments[@"username"];
        NSString *password = call.arguments[@"password"];

        NSLog(@"setMqttServer: ip=%@ port=%d,username=%@,password=%@",
          ip, [port intValue],username,password);

        [view setMqttServer:ip port:[port intValue]
                   username:username password:password];
        result(@(YES));
    }else if ([call.method isEqualToString:@"setIceServer"]) {
        NSString *ip = call.arguments[@"ip"];
        NSNumber *port = call.arguments[@"port"];
        NSString *username = call.arguments[@"username"];
        NSString *password = call.arguments[@"password"];

        NSLog(@"setIceServer: ip=%@ port=%d,username=%@,password=%@",
          ip, [port intValue],username,password);

        [view setIceServer:ip port:[port intValue]
                  username:username password:password];
        result(@(YES));
    }else{
        result(FlutterMethodNotImplemented);
    }
}

@end
