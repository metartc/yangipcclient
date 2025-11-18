#import "YangViewManager.h"
#import "YangOpenGLView.h"
#import <React/RCTUIManager.h>

@implementation YangViewManager

RCT_EXPORT_MODULE(YangOpenGLView)

- (UIView *)view {
    return [[YangOpenGLView alloc] init];
}

+ (BOOL)requiresMainQueueSetup{
  return YES;
}

RCT_EXPORT_METHOD(setLoglevel:(nonnull NSNumber *)reactTag
                  logLevel:(nonnull NSNumber *)logLevel)
{
  [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager,
                                      NSDictionary<NSNumber *,UIView *> *viewRegistry) {

    YangOpenGLView *view = (YangOpenGLView *)viewRegistry[reactTag];
    if (!view) return;

    NSLog(@"setLoglevel: logLevel=%d", [logLevel intValue]);
    [view setLoglevel:[logLevel intValue]];
  }];
}

RCT_EXPORT_METHOD(setDecodeHw:(nonnull NSNumber *)reactTag
                  isHw:(nonnull NSNumber *)isHw)
{
  [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager,
                                      NSDictionary<NSNumber *,UIView *> *viewRegistry) {

    YangOpenGLView *view = (YangOpenGLView *)viewRegistry[reactTag];
    if (!view) return;

    NSLog(@"setDecodeHw: isHw=%d", [isHw intValue]);
    [view setDecodeHw:[isHw intValue]];
  }];
}

RCT_EXPORT_METHOD(setIceConfig:(nonnull NSNumber *)reactTag
                  iceTransportPolicy:(nonnull NSNumber *)iceTransportPolicy iceCandidateType:(nonnull NSNumber *)iceCandidateType)
{
  [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager,
                                      NSDictionary<NSNumber *,UIView *> *viewRegistry) {

    YangOpenGLView *view = (YangOpenGLView *)viewRegistry[reactTag];
    if (!view) return;

    NSLog(@"setIceConfig: iceTransportPolicy=%d iceCandidateType=%d", [iceTransportPolicy intValue], [iceCandidateType intValue]);
    [view setIceConfig:[iceTransportPolicy intValue] iceCandidateType:[iceCandidateType intValue]];
  }];
}



RCT_EXPORT_METHOD(play:(nonnull NSNumber *)reactTag
                  playState:(nonnull NSNumber *)state
                  topic:(NSString *)topic)
{
  [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager,
                                      NSDictionary<NSNumber *,UIView *> *viewRegistry) {

    YangOpenGLView *view = (YangOpenGLView *)viewRegistry[reactTag];
    if (!view) return;

    NSLog(@"play: state=%@ topic=%@", state, topic);
    if([state intValue] == 0)
      [view play:topic];
    else
      [view unplay];
  }];
}

RCT_EXPORT_METHOD(setMqttServer:(nonnull NSNumber *)reactTag
                  ip:(NSString *)ip
                  port:(nonnull NSNumber *)port
                  username:(NSString *)username
                  password:(NSString *)password)
{
  [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager,
                                      NSDictionary<NSNumber *,UIView *> *viewRegistry) {

    YangOpenGLView *view = (YangOpenGLView *)viewRegistry[reactTag];
    if (!view) return;
    NSLog(@"setMqttServer: ip=%@ port=%d,username=%@,password=%@",
    ip, [port intValue],username,password);
    [view setMqttServer:ip port:[port intValue]
               username:username password:password];
  }];
}

RCT_EXPORT_METHOD(setIceServer:(nonnull NSNumber *)reactTag
                  ip:(NSString *)ip
                  port:(nonnull NSNumber *)port
                  username:(NSString *)username
                  password:(NSString *)password)
{
  [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager,
                                      NSDictionary<NSNumber *,UIView *> *viewRegistry) {

    YangOpenGLView *view = (YangOpenGLView *)viewRegistry[reactTag];
    if (!view) return;
  NSLog(@"setIceServer: ip=%@ port=%d,username=%@,password=%@", 
    ip, [port intValue],username,password);
    [view setIceServer:ip port:[port intValue]
               username:username password:password];
  }];
}

@end
